-- ==========================================
-- Caelestia: Custom Special Workspaces
-- ==========================================

-- Special workspace toggles
-- Existing defaults SUPER + M and SUPER + D
-- are preserved.

-- Notes
hl.bind("SUPER + ALT + N", hl.dsp.exec_cmd("caelestia toggle notes"))

-- Files
hl.bind("SUPER + ALT + E", hl.dsp.exec_cmd("caelestia toggle files"))

-- Music (existing Caelestia binding)
-- SUPER + M -> caelestia toggle music

-- Communication (existing Caelestia binding)
-- SUPER + D -> caelestia toggle communication

-- ==========================================
-- Window rules
-- ==========================================

-- Music players
hl.window_rule({
	match = { class = "^(strawberry)$" },
	workspace = "special:music",
})

hl.window_rule({
	match = { class = "^(tauonmb)$" },
	workspace = "special:music",
})

-- Notes
hl.window_rule({
	match = { class = "^(obsidian)$" },
	workspace = "special:notes",
})
hl.window_rule({
	match = { class = "^(simplenote)$" },
	workspace = "special:notes",
})

-- Communication
hl.window_rule({
	match = { class = "^(com.rtosta.zapzap)$" },
	workspace = "special:communication",
})

-- File manager
hl.window_rule({
	match = { class = "^(thunar)$" },
	workspace = "special:files",
})
