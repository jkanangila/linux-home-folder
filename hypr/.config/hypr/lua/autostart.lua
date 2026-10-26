-- Applications started with Hyprland.

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("mako")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")

	-- Polkit authentication agent.
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

	-- Clipboard history.
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")

	-- set random wallpaper at startup
	hl.exec_cmd("~/.config/hypr/random_wallpaper.sh")
end)
