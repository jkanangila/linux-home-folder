return {
  "echasnovski/mini.icons",
  opts = {
    directory = {
      -- General / source
      ["."] = { glyph = "", hl = "MiniIconsYellow" },
      ["src"] = { glyph = "", hl = "MiniIconsBlue" },
      ["dist"] = { glyph = "", hl = "MiniIconsRed" },
      ["build"] = { glyph = "", hl = "MiniIconsRed" },
      ["out"] = { glyph = "", hl = "MiniIconsRed" },
      ["lib"] = { glyph = "", hl = "MiniIconsYellow" },
      ["core"] = { glyph = "", hl = "MiniIconsBlue" },

      -- Testing
      ["tests"] = { glyph = "", hl = "MiniIconsYellow" },
      ["test"] = { glyph = "", hl = "MiniIconsYellow" },
      ["spec"] = { glyph = "", hl = "MiniIconsYellow" },
      ["specs"] = { glyph = "", hl = "MiniIconsYellow" },
      ["e2e"] = { glyph = "", hl = "MiniIconsOrange" },
      ["coverage"] = { glyph = "", hl = "MiniIconsGreen" },

      -- Documentation and assets
      ["docs"] = { glyph = "", hl = "MiniIconsCyan" },
      ["doc"] = { glyph = "", hl = "MiniIconsCyan" },
      ["assets"] = { glyph = "", hl = "MiniIconsGreen" },
      ["static"] = { glyph = "", hl = "MiniIconsGreen" },
      ["public"] = { glyph = "", hl = "MiniIconsGreen" },
      ["media"] = { glyph = "", hl = "MiniIconsPurple" },
      ["images"] = { glyph = "", hl = "MiniIconsPurple" },
      ["fonts"] = { glyph = "", hl = "MiniIconsYellow" },

      -- Environments and dependencies
      ["venv"] = { glyph = "", hl = "MiniIconsGreen" },
      [".venv"] = { glyph = "", hl = "MiniIconsGreen" },
      ["env"] = { glyph = "", hl = "MiniIconsGreen" },
      ["node_modules"] = { glyph = "", hl = "MiniIconsRed" },
      ["vendor"] = { glyph = "", hl = "MiniIconsGrey" },

      -- Configuration and hidden folders
      ["config"] = { glyph = "", hl = "MiniIconsAzure" },
      [".config"] = { glyph = "", hl = "MiniIconsAzure" },
      [".github"] = { glyph = "", hl = "MiniIconsPurple" },
      [".vscode"] = { glyph = "", hl = "MiniIconsBlue" },
      [".idea"] = { glyph = "", hl = "MiniIconsOrange" },
      ["docker"] = { glyph = "", hl = "MiniIconsBlue" },

      -- Data, databases and storage
      ["data"] = { glyph = "", hl = "MiniIconsOrange" },
      ["database"] = { glyph = "", hl = "MiniIconsBlue" },
      ["db"] = { glyph = "", hl = "MiniIconsBlue" },
      ["migrations"] = { glyph = "", hl = "MiniIconsYellow" },
      ["logs"] = { glyph = "", hl = "MiniIconsGrey" },
      ["cache"] = { glyph = "", hl = "MiniIconsYellow" },
      [".cache"] = { glyph = "", hl = "MiniIconsYellow" },

      -- Scripts and tooling
      ["scripts"] = { glyph = "", hl = "MiniIconsPurple" },
      ["bin"] = { glyph = "", hl = "MiniIconsOrange" },
      ["tools"] = { glyph = "", hl = "MiniIconsAzure" },

      -- Clean architecture
      ["domain"] = { glyph = "", hl = "MiniIconsRed" },
      ["entities"] = { glyph = "", hl = "MiniIconsRed" },
      ["use_cases"] = { glyph = "", hl = "MiniIconsOrange" },
      ["application"] = { glyph = "", hl = "MiniIconsOrange" },
      ["infrastructure"] = { glyph = "", hl = "MiniIconsBlue" },
      ["adapters"] = { glyph = "", hl = "MiniIconsPurple" },
      ["presentation"] = { glyph = "", hl = "MiniIconsCyan" },
      ["interfaces"] = { glyph = "", hl = "MiniIconsCyan" },

      -- Hexagonal architecture / data access
      ["ports"] = { glyph = "", hl = "MiniIconsCyan" },
      ["repositories"] = { glyph = "", hl = "MiniIconsGreen" },
      ["services"] = { glyph = "", hl = "MiniIconsYellow" },
      ["providers"] = { glyph = "", hl = "MiniIconsPurple" },

      -- UI / frontend / state management
      ["view"] = { glyph = "", hl = "MiniIconsCyan" },
      ["views"] = { glyph = "", hl = "MiniIconsCyan" },
      ["viewmodel"] = { glyph = "", hl = "MiniIconsPurple" },
      ["viewmodels"] = { glyph = "", hl = "MiniIconsPurple" },
      ["components"] = { glyph = "", hl = "MiniIconsOrange" },
      ["layouts"] = { glyph = "", hl = "MiniIconsBlue" },
      ["pages"] = { glyph = "", hl = "MiniIconsGreen" },
      ["screens"] = { glyph = "", hl = "MiniIconsCyan" },
      ["templates"] = { glyph = "", hl = "MiniIconsBlue" },
      ["store"] = { glyph = "", hl = "MiniIconsYellow" },
      ["states"] = { glyph = "", hl = "MiniIconsYellow" },
      ["reducers"] = { glyph = "", hl = "MiniIconsRed" },
      ["actions"] = { glyph = "", hl = "MiniIconsGreen" },

      -- CI/CD and workflows
      ["pipelines"] = { glyph = "", hl = "MiniIconsAzure" },
      ["pipeline"] = { glyph = "", hl = "MiniIconsAzure" },
      ["workflows"] = { glyph = "", hl = "MiniIconsPurple" },

      -- Web / API / application logic
      ["models"] = { glyph = "", hl = "MiniIconsRed" },
      ["controllers"] = { glyph = "", hl = "MiniIconsPurple" },
      ["api"] = { glyph = "", hl = "MiniIconsCyan" },
      ["routers"] = { glyph = "", hl = "MiniIconsAzure" },
      ["routes"] = { glyph = "", hl = "MiniIconsAzure" },
      ["middleware"] = { glyph = "", hl = "MiniIconsOrange" },
      ["schemas"] = { glyph = "", hl = "MiniIconsYellow" },
      ["utils"] = { glyph = "", hl = "MiniIconsGrey" },
      ["helpers"] = { glyph = "", hl = "MiniIconsGrey" },
      ["hooks"] = { glyph = "", hl = "MiniIconsYellow" },
      ["constants"] = { glyph = "", hl = "MiniIconsAzure" },
      ["types"] = { glyph = "", hl = "MiniIconsCyan" },
      ["interfaces_ts"] = { glyph = "", hl = "MiniIconsCyan" },
      ["locales"] = { glyph = "", hl = "MiniIconsGreen" },
      ["i18n"] = { glyph = "", hl = "MiniIconsGreen" },
    },
  },
}
