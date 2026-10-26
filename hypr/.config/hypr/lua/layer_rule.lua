-- Waybar blur rules
-- Hyprland 0.56.2

hl.layer_rule({
	name = "waybar-blur",
	match = {
		namespace = "waybar",
	},
	blur = true,
})

hl.layer_rule({
	name = "waybar-ignore-alpha",
	match = {
		namespace = "waybar",
	},
	ignore_alpha = 0.2,
})
