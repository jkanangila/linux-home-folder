return {
  "Kaiser-Yang/blink-cmp-dictionary",

  specs = {
    {
      "saghen/blink.cmp",
      optional = true,

      opts = {
        sources = {
          default = {
            "dictionary",
          },

          providers = {
            dictionary = {
              name = "Dict",
              module = "blink-cmp-dictionary",
              min_keyword_length = 1,

              opts = {
                dictionary_directories = {
                  vim.fn.expand "~/.config/nvim/dictionary",
                },
              },
            },
          },
        },
      },
    },
  },
}
