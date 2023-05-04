local QBCore = exports['qb-core']:GetCoreObject()
local useDebug = Config.Debug

-- Constants
local PlayerPopGroup = 'RaidPlayerGroup'
local GuardPopGroup = 'RaidGuardGroup'
local CivPopGroup = 'RaidCivGroup'

-- Globals
local Cooldown = false
local ActiveJobs = {}
--[[
    ActiveJobs = {
        JobId = {
            diff = jobDiff,
            location = jobLocation,
            leader = src
            Group = {
                src = 1
            }
            spawnTriggered = false
        }
    }
--]]
local Npcs = {
    ['RaidGuardGroup'] = {},
    ['RaidCivGroup'] = {}
}

-- == Start == --
local function verifyIsLeader(src)
    if Config.UseRenewedPhoneGroups and exports['qb-phone']:GetGroupByMembers(src) then
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local leader = exports['qb-phone']:GetGroupLeader(group)
        return leader == src
    else
        return true
    end
end

local function verifyGroupSize(src)
    if Config.UseRenewedPhoneGroups and exports['qb-phone']:GetGroupByMembers(src) then
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local size = exports['qb-phone']:getGroupSize(group)
        return size <= Config.MaxGroupSize
    else
        return true
    end
end

local function generateJobId()
    local jobId = "RJ-" .. math.random(1111, 9999)
    while ActiveJobs[jobId] ~= nil do
        jobId = "RJ-" .. math.random(1111, 9999)
    end
    return jobId
end

local function activateRun(src, jobDiff, jobLocation)
    TriggerClientEvent('QBCore:Notify', src, Lang:t("success.payment_success"), 'success')
    local jobId = generateJobId()

    ActiveJobs[jobId] = {
        diff = jobDiff,
        location = jobLocation,
        leader = src,
        spawnTriggered = false,
        Group = {}
    }
    TriggerEvent('cw-raidjob2:server:coolout', src)

    if Config.UseRenewedPhoneGroups and exports['qb-phone']:GetGroupByMembers(src) then
        local group = exports['qb-phone']:GetGroupByMembers(src)
        local members = exports['qb-phone']:getGroupMembers(group)

        local memberTable = {}
        for i, v in pairs(members) do
            if useDebug then
               print('member', i,v)
            end
            memberTable[#memberTable+1]= { [i] = 1}
            TriggerClientEvent('cw-raidjob2:client:runactivate', i, jobId, jobDiff, jobLocation)
        end
        ActiveJobs[jobId].Group = memberTable
    else
        ActiveJobs[jobId].Group = {
            [src] = 1
        }
        TriggerClientEvent('cw-raidjob2:client:runactivate', src, jobId, jobDiff, jobLocation)
    end
end

RegisterServerEvent('cw-raidjob2:server:start', function(jobDiff, jobLocation)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    if useDebug then
       print(jobDiff, jobLocation)
    end
    if verifyIsLeader and verifyGroupSize then
        if Config.UseTokens then
            TriggerEvent('cw-tokens:server:TakeToken', src, Config.Jobs[jobDiff].token)
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.payment_success"), 'success')
            activateRun(src, jobDiff, jobLocation)
        else
            local paymentType = Config.Jobs[jobDiff].paymentType
            local runCost = Config.Jobs[jobDiff].runCost
            if useDebug then
                print('payout', paymentType, runCost)
            end
            if paymentType == 'cash' then
                if Player.PlayerData.money['cash'] >= runCost then
                    Player.Functions.RemoveMoney('cash', runCost)
                    activateRun(src, jobDiff, jobLocation)
                else
                    TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
                end
            elseif paymentType == 'bank' then
                if Player.PlayerData.money['bank'] >= runCost then
                    Player.Functions.RemoveMoney('bank', runCost)
                    activateRun(src, jobDiff, jobLocation)
                else
                    TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
                end
            elseif paymentType == 'crypto' then
                if Config.UseRenewedCrypto then
                    if exports['qb-phone']:hasEnough(src, Config.CryptoType, runCost) then
                        exports['qb-phone']:RemoveCrypto(src, Config.CryptoType, runCost)
                        activateRun(src, jobDiff, jobLocation)
                    else
                        TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
                    end
                else
                    if Player.PlayerData.money['crypto'] >= runCost then
                        Player.Functions.RemoveMoney('crypto', tonumber(runCost))
                        activateRun(src, jobDiff, jobLocation)
                    else
                        TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
                    end
                end
            end


        end
    end
end)

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

local npcVehicles = {}
-- Spawning
local function spawnVehicles(jobId, jobDiff, jobLocation)
    -- Bad Guys cars
    local CurrentJobLocation = Config.Locations[jobDiff][jobLocation]
    local vehicles = CurrentJobLocation.GuardCars
    if vehicles then
        local vehicleList = {}
        for i,vehicle in pairs(vehicles) do
            local GuardVehicleCoords = vehicle.coords
            local transport = CreateVehicle(vehicle.model, GuardVehicleCoords.x, GuardVehicleCoords.y, GuardVehicleCoords.z, GuardVehicleCoords.w, true, true)

            while not DoesEntityExist(transport) do
                if useDebug then
                   print('vehicle dont exist', transport)
                end
                Wait(100)
            end
            local networkID = 'SOMETHINGSWRONG'
            if DoesEntityExist(transport) then
                networkID = NetworkGetNetworkIdFromEntity(transport)
            end

            if useDebug then
               print('vehicle', transport, networkID)
            end
            vehicleList[networkID] = transport
        end
        npcVehicles[jobId] = vehicleList
    end
end

local GuardStats = {}

local function spawnGuards(jobId, jobDiff, jobLocation)
    local CurrentJobLocation = Config.Locations[jobDiff][jobLocation]
    local listOfGuardPositions = nil

    if CurrentJobLocation.GuardPositions ~= nil then
        listOfGuardPositions = shallowCopy(CurrentJobLocation.GuardPositions) -- these are used if random positions
    end

    for k, v in pairs(CurrentJobLocation.Guards) do
        local guardPosition = v.coords
        local animation = nil
        if guardPosition == nil then
            if listOfGuardPositions == nil then
                print('Someone made an oopsie when making guard positions!')
            else
                local random = math.random(1,#listOfGuardPositions)
                guardPosition = listOfGuardPositions[random]
                table.remove(listOfGuardPositions,random)
            end
        end
        local accuracy = Config.DefaultValues.accuracy
        if v.accuracy then
            accuracy = v.accuracy
        end
        local armor =  Config.DefaultValues.armor
        if v.armor then
            armor = v.armor
        end
        -- print('Guard location: ', guardPosition)
        local ped = CreatePed(26, GetHashKey(v.model), guardPosition, true, true)

        local weapon = 'WEAPON_PISTOL'
        if v.weapon then
            weapon = v.weapon
        end
        GiveWeaponToPed(ped, v.weapon, 255, false, false)

        local networkID = NetworkGetNetworkIdFromEntity(ped)
        SetPedRandomComponentVariation(ped, 0)
        SetPedRandomProps(ped)
        SetPedArmour(ped, armor)

        Npcs[GuardPopGroup][networkID] = ped
        GuardStats[networkID] = {
            accuracy = accuracy,
            hasKey = false
        }
        if k == 1 then
            if useDebug then
               print('giving key to', networkID)
            end
            GuardStats[networkID].hasKey = true
        end
    end
    for i,v in pairs(ActiveJobs[jobId].Group) do
        if useDebug then
           print('updating npcs for', i, v)
        end
        TriggerClientEvent('cw-raidjob2:client:setRelationsAndStats', i, Npcs, GuardStats)
    end
end

local function spawnCivilians(jobId, jobDiff, jobLocation)
    local CurrentJobLocation = Config.Locations[jobDiff][jobLocation]
    if CurrentJobLocation.Civilians then
        local listOfCivilianPositions = nil

        if CurrentJobLocation.CivilianPositions ~= nil then
            listOfCivilianPositions = shallowCopy(CurrentJobLocation.CivilianPositions) -- these are used if random positions
        end

        for k, v in pairs(CurrentJobLocation.Civilians) do
            local civPosition = v.coords
            local animation = nil
            if civPosition == nil then
                if listOfCivilianPositions == nil then
                    print('Someone made an oopsie when making civilian positions!')
                else
                    local random = math.random(1,#listOfCivilianPositions)
                    civPosition = listOfCivilianPositions[random]
                    table.remove(listOfCivilianPositions,random)
                end
            end
            local accuracy = Config.DefaultValues.accuracy
            local ped = CreatePed(26, GetHashKey(v.model), civPosition, true, true)

            local networkID = NetworkGetNetworkIdFromEntity(ped)
            SetPedRandomComponentVariation(ped, 0)
            SetPedRandomProps(ped)

            Npcs[CivPopGroup][networkID] = ped
        end
    end
end

local function spawnCase(jobId, jobDiff, jobLocation)
    local CasePositions = Config.Locations[jobDiff][jobLocation].CasePositions

    local prop = Config.Items.caseProp

    local caseLocation = CasePositions[math.random(1,#CasePositions)]
    local case = CreateObject(prop, caseLocation.x, caseLocation.y, caseLocation.z, true,  true, true)
    if useDebug then
       print(caseLocation.x,caseLocation.y,caseLocation.z)
       print('case:', case)
    end
    SetEntityHeading(case, math.random(180)*1.0)
    FreezeEntityPosition(case, true)
    while not DoesEntityExist(case) do
        print('case dont exist')
        Wait(100)
    end
    local networkID = 'SOMETHINGSWRONG'
    if DoesEntityExist(case) then
        networkID = NetworkGetNetworkIdFromEntity(case)
    end
    for i,v in pairs(ActiveJobs[jobId].Group) do
        if useDebug then
           print('pinging player about case', i, v)
        end
        TriggerClientEvent('cw-raidjob2:client:spawnCase', i, networkID)
    end
end

RegisterNetEvent('cw-raidjob2:server:spawn', function(jobId, jobDiff, jobLocation)
    if useDebug then
       print('spawning for', jobId, jobDiff, jobLocation)
    end
    if ActiveJobs[jobId].spawnTriggered == false then
        ActiveJobs[jobId].spawnTriggered = true
        for i,v in pairs(ActiveJobs[jobId].Group) do
            if useDebug then
               print('notifying that enemies are spawning', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:updateSpawned', i)
        end
        spawnGuards(jobId, jobDiff, jobLocation)
        spawnCivilians(jobId, jobDiff, jobLocation)
        spawnVehicles(jobId, jobDiff, jobLocation)
        spawnCase(jobId, jobDiff, jobLocation)
        for i,v in pairs(ActiveJobs[jobId].Group) do
            if useDebug then
               print('updating vehicles for', i, v)
            end
            TriggerClientEvent('cw-raidjob2:client:setVehicleEntities', i, npcVehicles[jobId])
        end
    end
end)

local function addItem(item, amount, info, src)
    if Config.Inventory == 'qb' then
    	local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddItem(item, amount, nil, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    elseif Config.Inventory == 'ox' then
        exports.ox_inventory:AddItem(src, item, amount, info)
        TriggerClientEvent('inventory:client:ItemBox', src, exports.ox_inventory:Items()[item], "add")
    end
end

local function removeItem(item, slot, src)
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.Inventory == 'qb' then
        Player.Functions.RemoveItem(item.name, 1, slot)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
    elseif Config.Inventory == 'ox' then
        exports.ox_inventory:RemoveItem(src, item, 1, nil, slot)
        TriggerClientEvent('inventory:client:ItemBox', src, exports.ox_inventory:Items()[item], "remove")
    end
end

local function removeItemBySlot(item, diff, src)
    if Config.Inventory == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        local items = Player.Functions.GetItemsByName(item)
        local slot = nil
        if items then
            for _, item in ipairs(items) do
                if useDebug then
                   print(item.info.diff)
                end
                if item.info.diff == diff then
                    QBCore.Debug(item)
                    removeItem(item, item.slot, src)
                    return true
                end
            end
        else
            return false
        end
    elseif Config.Inventory == 'ox' then
        local result = exports.ox_inventory:Search(src, 'slots', item, { diff = diff })
        if useDebug then
           print('fetched slot:', result[1].slot)
        end
        if #result > 0 then
            removeItem(item, result[1].slot, src)
            return true
        else
            return false
        end
    end
end

local function hasItem(item, diff, src)
    if Config.Inventory == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        local items = Player.Functions.GetItemsByName(item)
        local slot = nil
        if items then
            for _, item in ipairs(items) do
                if useDebug then
                   print(item.info.diff)
                end
                if item.info.diff == diff then
                    return true
                end
            end
        else
            return false
        end
    elseif Config.Inventory == 'ox' then
        local result = exports.ox_inventory:Search(src, 'slots', item, { diff = diff })
        if #result > 0 then
            return true
        else
            return false
        end
    end
end

RegisterNetEvent('cw-raidjob2:server:hasKeys', function(jobId)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    if useDebug then
       print(src, 'found the keys')
    end
    local item = Config.Items.key
    addItem(item, 1, { diff = ActiveJobs[jobId].diff }, src)

    for i,v in pairs(ActiveJobs[jobId].Group) do
        if useDebug then
           print('notifying player about key', i, v)
        end
        TriggerClientEvent('cw-raidjob2:client:setKeyTaken', i)
    end
end)

RegisterNetEvent('cw-raidjob2:server:setCaseIsInUse', function(jobId, bool)
    local src = source

    if useDebug then
       print(src, 'interacting with case')
    end

    for i,v in pairs(ActiveJobs[jobId].Group) do
        if useDebug then
           print('notifying player about case interaction', i, v)
        end
        TriggerClientEvent('cw-raidjob2:client:setCaseIsInUse', i, bool)
    end
end)

RegisterServerEvent('cw-raidjob2:server:grabCase', function (jobId)
    local src = source
    if useDebug then
        print(src, 'Grabbed case', jobId)
    end
    for i,v in pairs(ActiveJobs[jobId].Group) do
        if useDebug then
           print('notifying player about case grabbed', i, v)
        end
        TriggerClientEvent('cw-raidjob2:client:caseGrabbed', i)
    end

	local Player = QBCore.Functions.GetPlayer(src)
    local caseItem = Config.Items.caseItem

    addItem(caseItem, 1, { diff = ActiveJobs[jobId].diff }, src)
end)

RegisterServerEvent('cw-raidjob2:server:unlock', function (jobId)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local caseContent = Config.Items.caseContent
    local caseItem = Config.Items.caseItem
    local caseKey = Config.Items.key
    if hasItem(caseKey, ActiveJobs[jobId].diff, src) then
        if hasItem(caseItem, ActiveJobs[jobId].diff, src) then
            if removeItemBySlot(caseItem, ActiveJobs[jobId].diff, src) then
                if removeItemBySlot(caseKey, ActiveJobs[jobId].diff, src) then
                    if useDebug then
                        print(src, 'Unlocked case', jobId)
                    end
                    for i,v in pairs(ActiveJobs[jobId].Group) do
                        if useDebug then
                           print('notifying player about case unlocked', i, v)
                        end
                        TriggerClientEvent('cw-raidjob2:client:caseUnlocked', i)
                    end
                    addItem(caseContent, 1, { diff = ActiveJobs[jobId].diff }, src)
                end
            end
            ActiveJobs[jobId] = nil
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_case"), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_key"), 'error')
    end
end)

RegisterServerEvent('cw-raidjob2:server:givePayout', function(diff)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    local caseContent = Config.Items.caseContent
    if removeItemBySlot(caseContent, diff, src) then
        for k, v in pairs(Config.Jobs[diff].Rewards) do
            local chance = math.random(0,100)
            if useDebug then
               print('chance for '..v.item..': '..chance)
            end
            if chance < v.chance then
                Player.Functions.AddItem(v.item, v.amount)
                if Config.Inventory == 'qb' then
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.item], "add")
                elseif Config.Inventory == 'ox' then
                    TriggerClientEvent('inventory:client:ItemBox', src, exports.ox_inventory:Items()[v.item], "add")
                end
            end
        end
        local payoutType = Config.Jobs[diff].payoutType
        local payoutAmount = Config.Jobs[diff].payout
        if useDebug then
            print('payout', payoutType, payoutAmount)
        end
        if payoutType == 'cash' then
            Player.Functions.AddMoney('cash', payoutAmount)
        elseif payoutType == 'bank' then
            Player.Functions.AddMoney('bank', payoutAmount)
        elseif payoutType == 'crypto' then
            if Config.UseRenewedCrypto then
                exports['qb-phone']:AddCrypto(src, Config.CryptoType, payoutAmount)
            else
                Player.Functions.AddMoney('crypto', tonumber(payoutAmount))
            end
        end
    else
        print('Why u tryin 🙄')
    end
end)

QBCore.Functions.CreateUseableItem(Config.Items.caseItem, function(source, item)
    if Config.Inventory == 'ox' then
      TriggerClientEvent('cw-raidjob2:client:attemtpToUnlockCase', source, item.metadata.diff)
    else
      TriggerClientEvent('cw-raidjob2:client:attemtpToUnlockCase', source, item.info.diff)
    end
end)

-- cool down for job
RegisterServerEvent('cw-raidjob2:server:coolout', function()
    if useDebug then
       print('STARTING COOLDOWN')
    end
    Cooldown = true
    local timer = Config.Cooldown * 1000
    SetTimeout(timer, function()
        Cooldown = false
    end)
end)

QBCore.Functions.CreateCallback("cw-raidjob2:server:isInCooldown",function(source, cb)
     cb(Cooldown)
end)
