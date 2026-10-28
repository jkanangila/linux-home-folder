return {
	-- applications
	terminal = "kitty",
	browser = "brave",
	editor = "kitty -e nvim",
	fileExplorer = "kitty -e yazi",

	-- Keybindings
	kbTerminal = "SUPER + Return",

	-- Material You-inspired window styling
	blurEnabled = true,
	blurSpecialWs = false,
	blurPopups = true,
	blurSize = 6,
	blurPasses = 2,

	shadowEnabled = true,
	shadowRange = 12,
	shadowRenderPower = 3,

	-- Comfortable on a 1366x768 display
	workspaceGaps = 12,
	windowGapsIn = 4,
	windowGapsOut = 6,
	singleWindowGapsOut = 8,

	-- Rounded, subtly translucent windows
	windowOpacity = 1.0,
	windowRounding = 12,
	windowRoundingPower = 2,
	windowBorderSize = 2,

	-- Dynamic colors from Caelestia's current scheme
	activeWindowBorderColour = "rgba(" .. require("scheme.current").primary .. "e6)",
	inactiveWindowBorderColour = "rgba(" .. require("scheme.current").onSurfaceVariant .. "55)",
}
