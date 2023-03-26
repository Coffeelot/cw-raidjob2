local Translations = {
    error = {
        ["canceled"]                    = "Canceled",
        ["no_key"]                    = "You don't have the key",
        ["no_case"]                    = "You don't have the case",
        ["someone_recently_did_this"]   = "Someone recently did this, try again later..",
        ["you_failed"]                  = "You failed!",
        ["you_dont_have_enough_money"]  = "You Dont Have Enough Money",
    },
    success = {
        ["you_removed_first_security_case"]     = "You removed the the first layer of security on the case",
        ["you_got_paid"]                        = "You got paid",
        ["payment_success"]                 = "We got the payment. Sending you and email with the details",
        ["caseAquired"]                           = "There something beeping in the case",
        ["contentAquired"]                           = "The beeping stopped.",
    },
    info = {
        ["talking_to_boss"]             = "Talking to boss..",
        ["unlocking_case"]              = "Unlocking case..",
        ["turn_in_goods"]                   = "Turn in goods.",
        ["unlock_first"]                = "Unlock first lock",
        ["search_key"]                  = "Search for key",
        ["picked_up_key"]                  = "You picked up the key"
    },
    mailstart = {
        ["sender"]                      = "Unknown",
        ["subject"]                     = "?",
        ["message"]                     = "Updated your gps with the location to the case.",
    },
    mailSecond = {
        ["sender"]                      = "Unknown",
        ["subject"]                     = "Car Collection",
        ["message"]                     = "Looks like you got the Car. There might be a tracker. I'll send you the dropoff location when it's safe.",
    },
    mailEnd = {
        ["sender"]                      = "Unknown",
        ["subject"]                     = "Goods Delivered",
        ["message"]                     = "Good job. Take the slip to someone who knows what to do",
    },
    police = {
        ["alert"]                       = " Car Theft In Progress (Tracker active): "
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
