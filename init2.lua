-- local dark_colorscheme = "nightly"
local dark_colorscheme = {"monokai-pro-ristretto", "dark"}
local light_colorscheme = {"dayfox", "light"}
local colorscheme = dark_colorscheme

---{{{ Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
---}}}

---{{{ Options
vim.g.mapleader = " "
-- vim.o.omnifunc="syntaxcomplete#Complete
vim.o.ruler = true
vim.o.completeopt = "noinsert"
vim.o.compatible = false
vim.o.backspace="indent,eol,start"
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- vim.o.relativenumber = true
vim.wo.cursorline = true
vim.o.errorbells = false
vim.o.foldenable = true
vim.o.foldmethod = "marker"
vim.o.mouse = "a"
vim.o.number = true
vim.o.numberwidth = 5
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.wildmenu = true
vim.o.wrap = false
vim.o.clipboard = "unnamedplus"
-- vim.o.signcolumn="number"
vim.o.cmdheight = 1
vim.o.autoread = true
---}}}

---{{{ Lualine
LualinePlugins = {
    navic_component = function()
        local navic = require("nvim-navic")
        if navic.is_available() then
            return navic.get_location()
        else
            return " ## "
        end
    end,
    lsp_clients = function()
        local lsps = vim.lsp.get_active_clients({bufnr = vim.fn.bufnr()})
        if #lsps == 0 then
            return "##"
        end
        local str = ""
        for key, value in pairs(lsps) do
            str = str .. " " .. value.name
            if key < #lsps then
                str = str .. " /"
            end
        end
        return str
    end,
    current_time = function()
        return os.date("%H:%M")
    end
}
---}}}

---{{{ PLUGINS
local plugins = {
    -- Global utilities for neovim
    {
        "nvim-lua/plenary.nvim"
    },

    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            local treesitter = require("nvim-treesitter.configs")
            treesitter.setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = false
                },
                autotag = {
                    enable = true
                }
            }
        end
    },

    {
        "nvim-telescope/telescope.nvim",
        config = function()
            require("telescope").setup {
            }
        end
    },

    {
        'nvim-telescope/telescope-ui-select.nvim',
        dependencies = {"nvim-telescope/telescope.nvim"},
        config = function ()
            require("telescope").load_extension("ui-select")
        end
    },

    -- {
    --     "nvim-telescope/telescope-dap.nvim",
    --     dependencies = {"nvim-telescope/telescope.nvim"},
    --     config = function ()
    --         require("telescope").load_extension("dap")
    --     end
    -- },

    {
        "startup-nvim/startup.nvim",
        dependencies = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
        config = function()
            require"startup".setup()
        end
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

    'MunifTanjim/nui.nvim',

    -- Colorschemes
    {
        'EdenEast/nightfox.nvim',
        config = function()
            require("nightfox").setup {
                options = {
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                        strings = "italic"
                    }
                },
                groups = {
                    all = {
                        LspInlayHint = { fg = "palette.fg3", bg = "palette.bg2" }
                    }
                }
            }
        end
    }, -- nightfox

    {
        'rose-pine/neovim', name = 'rose-pine'
    },

    {
        "Shatur/neovim-ayu",
        config = function ()
            require('ayu').setup {
                mirage = false
            }
        end
    },

    {
        "projekt0n/github-nvim-theme",
        lazy = false,
        config = function()
            require("github-theme").setup {}
        end
    },

    {
        "ellisonleao/gruvbox.nvim"
    },

    {
        'uloco/bluloco.nvim',
        lazy = false,
        priority = 1000,
        dependencies = { 'rktjmp/lush.nvim' },
        config = function()
            require("bluloco").setup {
                italics = true
            }
        end,
    },

    {
        "loctvl842/monokai-pro.nvim",
        config = function()
            require("monokai-pro").setup()
        end
    },

    {
        "Alexis12119/nightly.nvim",
        config = function ()
            require("nightly").setup {}
        end
    },

    {
        "savq/melange-nvim",
    },

    -- Explorer
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },

    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        config = function()
            require("nvim-tree").setup {
                view = {
                    adaptive_size = true,
                },

                renderer = {
                    group_empty = true,
                    highlight_git = true,
                    icons = {
                        show = {
                            git = false
                        }
                    }
                },

                filters = {
                    dotfiles = true, -- don't show dotfiles
                },
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = true
                },
            }

            local wk = require("which-key")
            wk.register({
                d = {'<cmd>NvimTreeToggle<CR>', 'Nvim-Tree toggle'}
            }, {
                prefix = "<leader>"
            })
            -- Nmap('<leader>d', ':ProjectRootExe NvimTreeToggle<CR>', {silent = true})
        end
    },

    -- Appearance utils
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require("gitsigns").setup()
        end
    },

    {
        "luukvbaal/statuscol.nvim",
        lazy = false,
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup {
                setopt = true,

                ft_ignore = {"NvimTree", "lazy", "startup" },

                segments = {
                    { text = { "%C" }, click = "v:lua.ScFa" },
                    { text = { "%s" }, click = "v:lua.ScSa" },
                    {
                        text = { " ", builtin.lnumfunc, " ┃ "}, -- ·" },
                        condition = { true, builtin.not_empty },
                        click = "v:lua.ScLa",
                    }
                }
            }
        end,
    },

    -- {
    --     "folke/noice.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         -- add any options here
    --     },
    --     dependencies = {
    --         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --         "MunifTanjim/nui.nvim",
    --         -- OPTIONAL:
    --         --   `nvim-notify` is only needed, if you want to use the notification view.
    --         --   If not available, we use `mini` as the fallback
    --         "rcarriga/nvim-notify",
    --     }
    -- },

    {
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup()
        end
    },

    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end
    },

    {
        'romgrk/barbar.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require"bufferline".setup {
                auto_hide = false,
                insert_at_end = true,
                icons = {
                    button = '❌'
                }
            }

            local wk = require("which-key")

            for i = 1,10 do
                wk.register({ ['<M-' .. i .. '>'] =
                    { '<Cmd>BufferGoto ' .. i .. '<CR>', "Change tabs" } },
                    {mode = {"t", "n"}})
            end

            wk.register({ ['<C-q>'] = { '<Cmd>BufferClose<CR>', "Close buffer" }})

            wk.register({
                ["<C->>"] = { "<Cmd>BufferMoveNext<CR>", "Buffer move to next" },
                ["<C-<>"] = { "<Cmd>BufferMovePrevious<CR>", "Buffer move to previous" }
            })
        end
    }, --barbar

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'glepnir/lspsaga.nvim'},
        lazy = false,
        config = function()
            require("lualine").setup {
                options = {
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {'lazy', 'NvimTree'},
                        winbar = {'lazy', 'NvimTree'}
                    }
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff' },
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                },

                winbar = {
                    lualine_a = {},
                    lualine_b = { LualinePlugins.navic_component },
                    lualine_c = {},
                    lualine_x = { 'diagnostics' },
                    lualine_y = { LualinePlugins.lsp_clients },
                    lualine_z = { LualinePlugins.current_time }
                },
                inactive_winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                }
            }
        end
    }, -- lualine 

    {
        "andweeb/presence.nvim",
        config = function ()
            require("presence").setup {}
        end
    },

    -- General utils for coding
    -- {
    --     'tpope/vim-commentary',
    --     config = function()
    --         local wk = require("which-key")
    --         wk.register({
    --             [';'] = { "gccj", "Comment line" }
    --         }, {
    --             noremap = false
    --         })
    --         wk.register({
    --             [';'] = { "gc", "Comment block" }
    --         }, {
    --             mode = 'v',
    --             noremap = false
    --         })
    --         vim.cmd[[autocmd FileType glsl setlocal commentstring=\/\/\ %s]]
    --     end
    -- },
    {
        'numToStr/Comment.nvim',
        config = function ()
            require('Comment').setup({
                mappings = {
                    basic = true,
                    extra = false
                }
            })

            local wk = require("which-key")
            wk.register({
                [';'] = { "gccj", "Comment line" }
            }, {
                noremap = false
            })
            wk.register({
                [';'] = { "gc", "Comment block" }
            }, {
                mode = 'v',
                noremap = false
            })
        end
    },

    'jiangmiao/auto-pairs',

    -- LSP
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- null_ls.builtins.formatting.stylua,
                    -- null_ls.builtins.diagnostics.vale,
                    -- null_ls.builtins.diagnostics.eslint,
                    -- null_ls.builtins.diagnostics.misspell,
                    -- null_ls.builtins.diagnostics.proselint,
                    -- null_ls.builtins.completion.spell,
                },
            })
        end
    },

    "neovim/nvim-lspconfig",


     {
         "hrsh7th/nvim-cmp",
         dependencies = {
             "hrsh7th/cmp-nvim-lsp",
             "hrsh7th/cmp-path",
             "hrsh7th/cmp-buffer",
             "hrsh7th/cmp-cmdline",
         }
     },

     'saadparwaiz1/cmp_luasnip',
     {
         'uga-rosa/cmp-dictionary',
         config = function ()
             vim.opt_global.dictionary = "/home/subwave/.config/nvim/dicts/en.dict"
         end
     },

    {
        'L3MON4D3/LuaSnip',
        dependencies = {'hrsh7th/nvim-cmp'},
        config = function()
            require("luasnip.loaders.from_snipmate").lazy_load()
        end
    },

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            {'L3MON4D3/LuaSnip'},     -- Required
        },
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup {}

            local wk = require("which-key")

            wk.register({
                A = {"<cmd>TroubleToggle document_diagnostics<CR>", "Complete diagnostics via trouble"}
            }, {
                prefix = "Q"
            })
        end
    },
    --
    -- {
    --     "ray-x/lsp_signature.nvim",
    --     config = function()
    --         require("lsp_signature").setup({
    --             floating_window = false
    --         })
    --     end
    -- },


    {
        "SmiteshP/nvim-navic",
        dependencies = {  "neovim/nvim-lspconfig"  }
    },

    {
        'j-hui/fidget.nvim',
        tag = "legacy",
        config = function()
            require("fidget").setup {}
        end
    },

    {
        'lvimuser/lsp-inlayhints.nvim',
        config = function()
            require("lsp-inlayhints").setup()
        end
    },

    {
        'simrat39/rust-tools.nvim',
        config = function ()
            local rt = require("rust-tools")

            rt.setup({
                server = {
                    cmd = { "/home/subwave/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer" },
                    on_attach = function(_, bufnr)
                        local wk = require("which-key")
                        wk.register({
                            ["<F1>"] = { "<cmd>RustHoverActions<CR>", "Hover actions for Rust" }
                        }, {
                            buffer = bufnr
                        })
                    end,
                },
            })
        end
    },

    {
        "mfussenegger/nvim-jdtls",
    },

    {
        "tikhomirov/vim-glsl"
    },

    {
        'alexlafroscia/postcss-syntax.vim'
    },

    {
        'windwp/nvim-ts-autotag'
    },

    -- Debug
    -- {
    --     "mfussenegger/nvim-dap",
    --     config = function ()
    --         local dap = require("dap")
    --         local wk = require("which-key")

    --         wk.register({
    --             ["b"] = { dap.toggle_breakpoint, "Toggle breakpoint for DAP" },
    --             ["c"] = { dap.continue, "Continue in DAP" },
    --             ["s"] = { dap.step_over, "Step in DAP" } ,
    --             ["<F5>"] = { dap.repl_open, "Repl for DAP" }
    --         }, {
    --             prefix = "<leader>"
    --         })

    --     end
    -- },

    {
        'mrcjkb/haskell-tools.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim', -- optional
        },
        branch = '1.x.x', -- recommended
    },
    -- LaTeX

    {
        'lervag/vimtex',
        config = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_ignore_filters = {'Underfull', 'Overfull'}
            vim.g.vimtex_view_method = "zathura"
            vim.g.Tex_IgnoreLevel = 8
            vim.g.vimtex_compiler_latexmk = {
                continuous = 1
            }
        end
    }

}
---}}}

require('lazy').setup(plugins, {})
vim.cmd("colorscheme " .. colorscheme[1])
vim.o.background = colorscheme[2]

------------ Setup LSP ---------------------- {{{

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({
        buffer = bufnr,
    })

    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end
    -- nvim_tree_on_attach(bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    require("lsp-inlayhints").on_attach(client, bufnr)

    local wk = require("which-key")
    wk.register({
        ["<F1>"] = {vim.lsp.buf.hover, " LSP hover "}
    })
end)
lsp.skip_server_setup({'tsserver'})
lsp.skip_server_setup({'jedi_language_server'})
lsp.skip_server_setup({'rust_analyzer'})
lsp.skip_server_setup({'jdtls'})
lsp.skip_server_setup({'zls'})

require('lspconfig').lua_ls.setup({})

require('lspconfig').tsserver.setup({
    root_dir = require('lspconfig.util').root_pattern('.git')
})

require('lspconfig').jedi_language_server.setup({
    root_dir = require('lspconfig.util').root_pattern('.git')
})

require("lspconfig").ccls.setup {
    init_options = {
        compilationDatabaseDirectory = "build";
        index = {
            threads = 0;
        };
    }
}



lsp.setup()

---}}}

--- Setup CMP --------------------- {{{

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col > 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'luasnip' },
        {name = 'dictionary', keyword_length = 3},
        {
            name = 'buffer',
            keyword_length = 4,
            option = {
                keyword_pattern = [[\k\+]],
            }
        },
    },
    mapping = {
        -- `Tab` key to confirm completion
        -- ['<Tab>'] = cmp.mapping.confirm({select = false}),

        ['<Tab>'] = cmp.mapping(function(fallback)
            -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    cmp.confirm()
                end
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {"i", "s"}),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- -- Navigate between snippet placeholder
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    },

    window = {
        completion = cmp.config.window.bordered({
            border = "single"
        }),
        documentation = cmp.config.window.bordered({
            border = "single"
        })
    },
    formatting = {
        format = function(_entry, vim_item)
            vim_item.abbr = string.sub(vim_item.abbr, 1, 30)
            return vim_item
        end
    }
})

local dict = require("cmp_dictionary")
dict.switcher {
    spelllang = {en = "/home/subwave/.config/nvim/dicts/en.dict"}
}

--}}}

---{{{ Setup completion

-- require("mini.completion").setup({
--     window = {
--         info = { height = 25, width = 80, border = 'none' },
--         signature = { height = 25, width = 80, border = 'none' },
--     },
-- })

--}}}

---{{{ Lsp Appearance
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'single'
    opts.max_width= opts.max_width or 80
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local _border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
vim.lsp.handlers.hover, {
    border = _border
}
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
vim.lsp.handlers.signature_help, {
    border = _border
}
)

vim.diagnostic.config{
    float = { border = _border }
}
--
-- require("noice").setup({
--     lsp = {
--         -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
--         override = {
--             ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--             ["vim.lsp.util.stylize_markdown"] = true,
--             -- ["cmp.entry.get_documentation"] = true,
--         },
--     },
--     -- you can enable a preset for easier configuration
--     presets = {
--         bottom_search = true, -- use a classic bottom cmdline for search
--         command_palette = true, -- position the cmdline and popupmenu together
--         long_message_to_split = true, -- long messages will be sent to a split
--         inc_rename = false, -- enables an input dialog for inc-rename.nvim
--         lsp_doc_border = true, -- add a border to hover docs and signature help
--     },
--     -- views = {
--     --     hover = {
--     --         border = { style = "single" },
--     --         size = { max_width = 80 },
--     --     },
--     -- }
-- })
--
---}}}


------------ Keybindings ----------------{{{

local wk = require("which-key")
wk.register({
    ec = { ":e ~/.config/nvim/init.lua<CR>", "Open config" },
    ["/"] = { ":terminal<CR>", "Open terminal" }
}, {
    prefix = "<leader>",
    mode = "n"
})

wk.register({
    ["1"] = { ".", "Dot operator" }
}, {
    noremap = false,
    mode = "n"
})

wk.register({
    Q = { vim.lsp.buf.code_action, "Code action" },
    E = { vim.diagnostic.open_float, "Line diagnostics" },
    R = { vim.lsp.buf.rename, "Rename" },
    D = { vim.lsp.buf.definition, "Goto definition" },
    A = { require("telescope.builtin").diagnostics, "Show diagnostics" }
}, {
    prefix = "Q",
    mode = "n"
})

wk.register({
    ["<C-n>"] = { ":noh<CR>", "Remove highlights" },
    ["<C-s>"] = { ":w<CR>", "Save"},
    ["<F5>"] = {"<cmd>Telescope colorscheme<CR>", "Set colorscheme"},
    ["<F9>"] = {
        function()
            vim.o.background = "light"
            vim.cmd("colorscheme " .. light_colorscheme[1])
        end, "Set light colorscheme"
    },
    ["<F10>"] = {
        function()
            vim.o.background = "dark"
            vim.cmd("colorscheme " .. dark_colorscheme[1])
        end, "Set dark colorscheme"
    },
}, {
    mode = "n"
})
wk.register({
    ["<C-s>"] = { "<Esc>:w<CR>", "Save"},
}, {
    mode = 'i'
})
---}}}

------ Telescope ------------------{{{

local menu = require("nui.menu")

local telescope_actions = {
    { text = "Jump to definition", cmd = "lsp_definitions" },
    { text = "Show calls to this", cmd = "lsp_incoming_calls" },
    { text = "Show references to this", cmd = "lsp_references" },
    { text = "Show workspace issues", cmd = "diagnostics" },
    { text = "Live grep", cmd = "live_grep" },
}

Telescope_Menu = menu({
    position = "50%",
    border = {
        style = "single",
        text = {
            top = "Telescope actions",
            top_align = "center"
        },
    },
    win_options = {
        winhighlight = "Normal:Normal"
    },
}, {
    lines = (function()
        local lines = {}
        for k, v in ipairs(telescope_actions) do
            lines[#lines + 1] = menu.item("" .. k .. ". " .. v.text, v)
        end
        return lines
    end)(),
    min_width = 40,
    keymap = {
        focus_next = { "<Down>" },
        focus_prev = { "<Up>" },
        close = { "<Esc>", "q" },
        submit = { "<CR>" }
    },
    on_close = function()
    end,
    on_submit = function(item)
        print(item.cmd)
        vim.cmd(":Telescope " .. item.cmd)
    end
})

wk.register({ ["<F2>"] =  { ":lua Telescope_Menu:mount()<CR>", "LSP actions" }})
wk.register({ ["<F3>"] =  { "<cmd>Telescope lsp_document_symbols<CR>", "LSP symbols"} })
wk.register({ ["<F12>"] = { "<cmd>Telescope resume<CR>", "Resume last telescope" } })
wk.register({
    ["ff"] = { "<cmd>Telescope find_files<CR>", "Find files" }
}, {
    prefix = "<leader>"
})
--}}}

----- VimTeX settings -------------- {{{

wk.register({
    t = { '<cmd>:VimtexCompile<CR>', "Vimtex Compile" },
    v = { '<cmd>:VimtexView<CR>', "Vimtex View" }
}, {
    prefix = "<leader>t"
})

vim.cmd[[
function! SyncTexForward()
let execstr = "silent !zathura --synctex-forward ".line(".").":".col(".").":%:p %:p:r.pdf &"
exec execstr
endfunction
]]

-------------------------------------}}}

vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'LspInlayHint', { link = 'Comment' })

-------------------------------{{{ Neovide

-- vim.o.guifont = "Iosevka NFP Medium:h11"
vim.o.guifont = "Iosevka NFM:h9.5"
-- vim.o.guifont = "Hermit:h9"
-- vim.o.guifont = "League Mono:h11"
-- vim.o.guifont = "FiraCode Nerd Font Med:h9"

function NeovideFullscreen()
    if vim.g.neovide_fullscreen == true then
        vim.g.neovide_fullscreen = false
    else
        vim.g.neovide_fullscreen = true
    end
end
vim.g.neovide_scroll_animation_length = 0
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_vfx_mode = ""
vim.g.neovide_cursor_vfx_particle_density = 20.0

wk.register({
    ["<F11>"] = { NeovideFullscreen, "Toggle fullscreen in neovide" }
}, {
    mode = { "i", "n", "v", "t" }
})
---}}}
