# Raidjob 2


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
