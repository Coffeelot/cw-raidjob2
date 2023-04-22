# Raidjob 2
A QB based script that is more of a system than a plug and play job script. To utilize this script to it's fullest you need to be able to at least do some Config devving, if that's to much then go find another script ✌ This script comes with several npcs and pre made locations and jobs to do, but the idea of it is for YOU to create your own jobs! The Config comes full off comments to guide you.

Raidjob 2, much like Raidjob 1, sets up PVE raids. This time it also makes use of [Renewed Phone groups](https://github.com/Renewed-Scripts/qb-phone) (optional toggle in Config) for better team interaction. The goal is simple:
1. Pay for the setup
2. Head to the location
3. Shoot the enemies
4. Grab the key
5. Grab the case
6. Wait for the timer on the case to go down (tracker is active for police during this time)
7. Open case from inventory
8. Return the content to the mission giver

The best way to describe Raidjob 2 compared to 1 is that it's a lot less Wallmart Heist and a lot more in the style of a job system. The focus in Raidjob 2 has been to be able to have multiple locations and have access to them controlled in an easy way. So low Tier might be easy to start, just a chunk of pocket change and you're good to go, while you might lock medium tier behind a Rep or a token.
If you used BoostJob, the way the missions are given is more like that, as compared to Raidjob 1, but each tier will have a different NPC.

Biggest differences:
- The missions are now tiered (low, mid and high by default. You can create whatever tiers you want in the config)
- Each tier has a set of locations, when the mission is started it randomizes between these.
- Each tier has one mission giver
- The location of the case is always random
- The key is not given when starting no more, you have to find the enemy that was holding it and loot them (using Target)
- Groups, using renewed phone.
This means the script lets all members of the group trigger stuff, not just the mission taker. Anyone can turn in the goods, but the payout only goes to the one that turns it it, and the buy in is paid by the one that starts it. There will be NO added auto-split  deal with it.
- Intergration with mz-skills for rep
- Enemies are spawned serverside, so should sync better... hopefully

Oh! And drop into the CW Discord and share your locations, and maybe pick up other players locations in the `#raidjob2-location-sharing` channel!

This also means raidjob(1) will be fully unsupported, and have reached it's End Of Life. No more patches, fixes or support will come to the current script.
[Raidjob 1](https://github.com/Coffeelot/cw-raidjob)

# Preview 📽
## Showcase
[![YOUTUBE VIDEO](http://img.youtube.com/vi/ZBJHE9NxEnY/0.jpg)](https://youtu.be/ZBJHE9NxEnY)
## Job Creation Showcase
[![YOUTUBE VIDEO](http://img.youtube.com/vi/tgw2OtYF9B0/0.jpg)](https://youtu.be/tgw2OtYF9B0)

# Developed by Coffeelot and Wuggie
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈

**Support, updates and script previews**:

[![Join The discord!](https://cdn.discordapp.com/attachments/977876510620909579/1013102122985857064/discordJoin.png)](https://discord.gg/FJY4mtjaKr )

**All our scripts are and will remain free** 

If you want to support what we do, you can buy us a coffee here:

[![Buy Us a Coffee](https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg)](https://www.buymeacoffee.com/cwscriptbois )

# SETUP ❗

## ADD ITEMS 📦
**QB:**
Items to add to qb-core>shared>items.lua 
```
	-- RAIDJOB2
	['cw_raidjob_key'] = {
		['name'] = 'cw_raidjob_key',
		['label'] = 'Case key',
		["type"] = "item",
		["image"] = "cw_raidjob_key.png",
		["unique"] = true,
		["useable"] = false,
		['shouldClose'] = false,
		["combinable"] = nil,
		['weight'] = 0,
		['description'] = "Probably used for a case"
	},
	['cw_raidjob_case'] = {
		['name'] = 'cw_raidjob_case',
		['label'] = 'Case',
		["type"] = "item",
		["image"] = "cw_raidjob_case.png",
		["unique"] = true,
		["useable"] = true,
		['shouldClose'] = false,
		["combinable"] = nil,
		['weight'] = 0,
		['description'] = "Probably contains things"
	},
	['cw_raidjob_content'] = {
		['name'] = 'cw_raidjob_content',
		['label'] = 'Documents',
		["type"] = "item",
		["image"] = "cw_raidjob_content.png",
		["unique"] = true,
		["useable"] = false,
		['shouldClose'] = false,
		["combinable"] = nil,
		['weight'] = 0,
		['description'] = "Well above your paygrade"
	},

```

**OX:**
Items to add to ox_inventory>data>items.lua 
```
	-- RAIDJOB2
	['cw_raidjob_key'] = {
		label = 'Case key',
		weight = 0,
		stack = true,
		close = true,
		allowArmed = true,
		description = "Probably used for a case"
	},
	['cw_raidjob_case'] = {
		label = 'Case',
		weight = 0,
		stack = true,
		close = true,
		allowArmed = true,
		description = "Probably contains things"
	},
	['cw_raidjob_content'] = {
		label = 'Documents',
		weight = 0,
		stack = true,
		close = true,
		allowArmed = true,
		description = "Well above your paygrade"
	},

```

Also make sure the images are in qb-inventory>html>images

# Dependencies

* qb-target - https://github.com/BerkieBb/qb-target
* PS-UI - https://github.com/Project-Sloth/ps-ui/


## Developed by Coffeelot#1586 and Wuggie#1683
