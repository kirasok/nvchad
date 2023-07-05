---@type MappingsTable
local M = {}

M.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "" },
    ["<C-e>"] = { "" },

    -- navigate within insert mode
    ["<C-h>"] = { "" },
    ["<C-l>"] = { "<Esc>[s1z=`]a" },
    ["<C-j>"] = { "" },
    ["<C-k>"] = { "" },
  },

  n = {
    -- save
    ["<C-s>"] = { "" },

    -- line numbers
    ["<leader>n"] = { "" },
    ["<leader>rn"] = { "" },

    -- new buffer
    ["<leader>b"] = { "" },

    ["<leader>fm"] = { "" },
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>ch"] = { "" },
    ["<leader>ih"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
  },
}

M.lspconfig = {
  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
  n = {
    ["gD"] = { "" },
    ["fD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "LSP declaration",
    },

    ["gd"] = { "" },
    ["fd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "LSP definition",
    },

    ["K"] = { "" },
    ["fk"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "LSP hover",
    },

    ["gi"] = { "" },
    ["fi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "LSP implementation",
    },

    ["<leader>ls"] = { "" },
    ["fs"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "LSP signature help",
    },

    ["<leader>D"] = { "" },
    ["ft"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "LSP definition type",
    },

    ["<leader>ra"] = { "" },
    ["fr"] = {
      function()
        require("nvchad_ui.renamer").open()
      end,
      "LSP rename",
    },

    ["<leader>ca"] = { "" },
    ["fa"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },

    ["gr"] = { "" },
    ["fR"] = {
      function()
        vim.lsp.buf.references()
      end,
      "LSP references",
    },

    ["ff"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },
  },
}

M.nvimtree = {
  n = {
    -- focus
    ["<leader>e"] = { "" },
  },
}

M.telescope = {
  n = {
    -- git
    ["<leader>cm"] = { "" },
    ["<leader>gt"] = { "" },

    -- pick a hidden term
    ["<leader>pt"] = { "" },

    -- theme switcher
    ["<leader>th"] = { "" },

    ["<leader>ma"] = { "" },
    ["<leader>fm"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
  },
}

M.nvterm = {
  n = {
    -- new
    ["<leader>h"] = { "" },

    ["<leader>v"] = { "" },
  },
}

M.whichkey = {
  n = {
    ["<leader>wK"] = { "" },
    ["<leader>wk"] = { "" },
  },
}

M.blankline = {
  n = {
    ["gd"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd [[normal! _]]
        end
      end,

      "Jump to current context",
    },
    ["<leader>cc"] = { "" },
  },
}

M.gitsigns = {
  n = {
    -- Actions
    ["<leader>rh"] = { "" },

    ["<leader>ph"] = { "" },

    ["<leader>gb"] = { "" },

    ["<leader>td"] = { "" },
  },
}
-- more keybinds!

M.zk = {
  plugin = true,

  n = {
    ["zz"] = {
      function()
        require("zk").edit { sort = { "modified" } }
      end,
      "zk: open note",
    },
    ["zn"] = {
      function()
        require("zk").new { title = vim.fn.input "title: ", dir = "notsorted" }
      end,
      "zk: new note",
    },
    ["zp"] = {
      function()
        require("zk").new { title = vim.fn.input "title:", dir = "projects" }
      end,
      "zk: new project",
    },
    ["zb"] = {
      "<CMD>ZkBacklinks<CR>",
      "zk: backlinks",
    },
    ["zl"] = {
      "<CMD>ZkLinks<CR>",
      "zk: links",
    },
    ["zt"] = {
      "<CMD>ZkTags<CR>",
      "zk: tags",
    },
    ["zdd"] = {
      function()
        require("zk").new { dir = "projects/journal/daily" }
      end,
      "zk: new daily note",
    },
    ["zdw"] = {
      function()
        require("zk").new { dir = "projects/journal/weekly" }
      end,
      "zk: new weekly note",
    },
    ["zdm"] = {
      function()
        require("zk").new { dir = "projects/journal/monthly" }
      end,
      "zk: new monthly note",
    },
  },

  v = {
    ["zn"] = {
      "<CMD>'<,'>ZkNewFromTitleSelection{dir = 'notsorted'}<CR>",
      "zk: new note from title",
    },
    -- TODO: imporve
    ["zi"] = {
      "<CMD>'<,'>ZkInsertLinkAtSelection<CR>",
      "zk: insert link from visual",
    },
  },
}

require("core.utils").load_mappings "zk"

return M
