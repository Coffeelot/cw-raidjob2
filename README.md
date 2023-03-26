# Raidjob 2
Better desc coming soon. Currently in beta release.


Biggest differences:
- The missions are now tiered (low, mid and high by default. You can create whatever tiers you want in the config)
- Each tier has a set of locations, when the mission is started it randomizes between these.
- Each tier has one mission giver
- The location of the case is always random
- The key is not given when starting no more, you have to find the enemy that was holding it and loot them (using Target)
- Attempts at making this a group job, using renewed phone, has been done (not tested yet)
This means the script lets all members of the group trigger stuff, not just the mission taker. Anyone can turn in the goods, but the payout only goes to the one that turns it it, and the buy in is paid by the one that starts it. There will be NO added auto-split  deal with it.
- Intergration with mz-skills for rep
- Enemies are spawned serverside, so should sync better... hopefully

The best way to describe 2 compared to 1 is that it's a lot less Wallmart Heist and a lot more in the style of just a job. The focus being to be able to have multiple locations and have access to them controlled in an easy way. So low Tier might be easy to start, just a chunk of pocket change and you're good to go, while you might lock medium tier behind a Rep or a token.
If you used BoostJob, the way the missions are given is more like that, but each tier will have a different NPC 
This also means raidjob(1) will be fully unsupported, and have reached it's End Of Life. No more patches, fixes or support will come to the current script.

[Raidjob 1](https://github.com/Coffeelot/cw-raidjob)

# Preview 📽
<!-- [![YOUTUBE VIDEO](http://img.youtube.com/vi/3BmZ8fIAXpg/0.jpg)](https://youtu.be/3BmZ8fIAXpg) -->

# Developed by Coffeelot and Wuggie
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈\
[Support, updates and script previews](https://discord.gg/FJY4mtjaKr) 👈

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
## Making the names show up in to the Inventory 📦
If you want to make the vehicle name show up in QB-Inventory:
Open `app.js` in `qb-inventory`. In the function `FormatItemInfo` you will find several if statements. Head to the bottom of these and add this before the second to last `else` statement (after the `else if` that has `itemData.name == "labkey"`). Then add this between them:
```
else if (itemData.name == "swap_slip") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>Vehicle: " + itemData.info.vehicle + "</p>");
        }
``` 

Also make sure the images are in qb-inventory>html>images

# Dependencies

* qb-target - https://github.com/BerkieBb/qb-target


## Developed by Coffeelot#1586 and Wuggie#1683
