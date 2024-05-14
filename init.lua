-- local dark_colorscheme = "nightly"
-- local dark_colorscheme = { "monokai-pro-spectrum", "dark" }
-- local dark_colorscheme = { "rose-pine", "dark" }
local dark_colorscheme = { "gruvbox-baby", "dark" }
-- local dark_colorscheme = { "carbonfox", "dark" }
-- local dark_colorscheme = { "biscuit", "dark" }
local light_colorscheme = { "dayfox", "light" }
-- local colorscheme = light_colorscheme
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
vim.o.backspace = "indent,eol,start"
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.autoindent = true
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
vim.o.termguicolors = false
vim.o.wildmenu = true
vim.o.wrap = false
vim.o.clipboard = "unnamedplus"
-- vim.o.signcolumn="number"
vim.o.cmdheight = 1
vim.o.autoread = true
---}}}

function TelescopeConfig()
    require("telescope").setup({
        defaults = require("telescope.themes").get_ivy()
    })
    -- require('telescope').load_extension('coc')

    local menu = require("nui.menu")

    local telescope_actions = {
        -- { text = "Jump to definition",      cmd = "coc declarations" },
        { text = "Show calls to this",      cmd = "lsp_incoming_calls" },
        { text = "Show references to this", cmd = "lsp_references" },
        { text = "Show workspace issues",   cmd = "diagnostics" },
        { text = "Live grep",               cmd = "live_grep" },
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

    vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])

    require("vstask").setup {
        config_dir = ".tasks"
    }
end

---{{{ Plugins
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
        event = "VeryLazy",
        -- lazy = false,
        dependencies = { "folke/which-key.nvim" },
        config = function()
            TelescopeConfig()
        end,

        keys = {
            { "<leader>==", ":Telescope<CR>",                  desc = "Telescope" },

            { "<F2>",       ":lua Telescope_Menu:mount()<CR>", desc = "LSP actions" },
            { "<leader>e",  "<cmd>Telescope diagnostics<CR>",  desc = "Diagnostics" },
            { "<F12>",      "<cmd>Telescope resume<CR>",       desc = "Resume last telescope" },
            { "<leader>f",  "<cmd>Telescope find_files<CR>",   desc = "Find files", },
            { "<leader>/",  "<cmd>Telescope live_grep<CR>",    "Grep in files", }
        }
    },

    {
        'nvim-telescope/telescope-ui-select.nvim',
        dependencies = { "nvim-telescope/telescope.nvim" },
        event = "VeryLazy",
        -- lazy = false,
        config = function()
            require("telescope").load_extension("ui-select")
        end
    },

    -- {
    --     'fannheyward/telescope-coc.nvim'
    -- },

    {
        "EthanJWright/vs-tasks.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            {
                "<f5>",
                function()
                    require("telescope").extensions.vstask.tasks()
                end,
                desc = "Launch tasks"
            }
        }
    },

    {
        'mhinz/vim-startify'
    },

    -- {
    --     "nvim-neorg/neorg",
    --     build = ":Neorg sync-parsers",
    --     dependencies = { "nvim-lua/plenary.nvim" },
    --     config = function()
    --         require("neorg").setup {
    --             load = {
    --                 ["core.defaults"] = {},
    --                 ["core.concealer"] = {},
    --                 ["core.export"] = {},
    --                 ["core.dirman"] = {
    --                     config = {
    --                         workspaces = {
    --                             notes = "~/docs/notes",
    --                         },
    --                         default_workspace = "notes",
    --                     },
    --                 },
    --             },
    --         }
    --
    --         vim.wo.foldlevel = 99
    --         vim.wo.conceallevel = 2
    --     end,
    -- },


    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- operators = { ";" }
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

    'MunifTanjim/nui.nvim',

    -- Colorschemes
    { 'AhmedAbdulrahman/aylin.vim' },

    {
        'EdenEast/nightfox.nvim',
        event = "VeryLazy",
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
        'rose-pine/neovim',
        name = 'rose-pine',
        event = "VeryLazy",
    },

    {
        'kartikp10/noctis.nvim',
        event = "VeryLazy",
        name = 'noctis',
        dependencies = {
            'rktjmp/lush.nvim'
        }
    },

    {
        'Biscuit-Colorscheme/nvim',
        event = "VeryLazy",
        name = 'biscuit',
        -- lazy = false,
        priority = 1000,
    },


    {
        "Shatur/neovim-ayu",
        event = "VeryLazy",
        config = function()
            require('ayu').setup {
                mirage = false
            }
        end
    },

    {
        "projekt0n/github-nvim-theme",
        -- lazy = false,
        config = function()
            require("github-theme").setup {}
        end
    },

    {
        'luisiacc/gruvbox-baby',
        event = "VeryLazy",
        config = function()
            -- vim.g.gruvbox_baby_function_style = "NONE"
            vim.g.gruvbox_baby_keyword_style = "italic"
            vim.g.gruvbox_baby_background_color = "dark"

            -- Each highlight group must follow the structure:
            -- ColorGroup = {fg = "foreground color", bg = "background_color", style = "some_style(:h attr-list)"}
            -- See also :h highlight-guifg
            -- Example:
            -- vim.g.gruvbox_baby_highlights = {Normal = {fg = "#123123", bg = "NONE", style="underline"}}

            -- Enable telescope theme
            vim.g.gruvbox_baby_telescope_theme = 1

            -- Enable transparent mode
            -- vim.g.gruvbox_baby_transparent_mode = 1
        end
    },

    {
        "loctvl842/monokai-pro.nvim",
        event = "VeryLazy",
        config = function()
            require("monokai-pro").setup()
        end
    },

    {
        "Alexis12119/nightly.nvim",
        event = "VeryLazy",
        config = function()
            require("nightly").setup {}
        end
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
        event = "VeryLazy",
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        config = function()
            require("nvim-tree").setup {
                view = {
                    adaptive_size = false,
                    width = 25
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

                -- filters = {
                --     dotfiles = true, -- don't show dotfiles
                -- },
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = true
                },
            }

            -- Nmap('<leader>d', ':ProjectRootExe NvimTreeToggle<CR>', {silent = true})
        end,

        keys = {
            { "<leader>d", "<cmd>NvimTreeToggle<CR>", desc = 'Nvim-tree toggle' }
        }
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

                ft_ignore = { "NvimTree", "lazy", "startup" },

                segments = {
                    { text = { "%C" }, click = "v:lua.ScFa" },
                    { text = { "%s" }, click = "v:lua.ScSa" },
                    {
                        text = { " ", builtin.lnumfunc, " ▐ ", }, --builtin.lnumfunc, " ┃ " }, -- ·" },
                        condition = { true, builtin.not_empty },
                        click = "v:lua.ScLa",
                    }
                }
            }
        end,
    },


    {
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup()
        end
    },

    {
        'romgrk/barbar.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        lazy = false,
        config = function()
            require "bufferline".setup {
                auto_hide = false,
                insert_at_end = true,
                icons = {
                    button = '',
                }
            }
        end,

        keys = (function()
            local keys = {
                { "<M->>", "<Cmd>BufferMoveNext<CR>",     desc = "Buffer move to next" },
                { "<M-<>", "<Cmd>BufferMovePrevious<CR>", desc = "Buffer move to previous" },
                { "<C-q>", '<Cmd>BufferClose<CR>',        desc = "Close buffer" }
            }

            for i = 1, 10 do
                table.insert(keys,
                    { '<M-' .. i .. '>', '<Cmd>BufferGoto ' .. i .. '<CR>', "Change tabs", mode = { "t", "n" } }
                )
            end

            return keys
        end)()
    }, --barbar

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        lazy = false,
        config = function()
            require("lualine").setup {
                options = {
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    theme = (function()
                        if colorscheme == "gruvbox-baby" then
                            return "gruvbox-baby"
                        else
                            return nil
                        end
                    end)(),
                    disabled_filetypes = {
                        statusline = { 'lazy', 'NvimTree' },
                        winbar = { 'lazy', 'NvimTree' }
                    }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = { 'filename' }, --, require('lsp-progress').progress },
                    lualine_x = { 'encoding', 'fileformat', { 'diagnostics', sources = { 'nvim_lsp' } }, 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },

            }
        end
    }, -- lualine


    -- {
    --     "andweeb/presence.nvim",
    --     config = function()
    --         require("presence").setup {}
    --     end
    -- },


    {
        'numToStr/Comment.nvim',
        config = function()
            print("Hello")
            require('Comment').setup {
                mappings = {
                    basic = true,
                    extra = false
                }
            }
        end,

        keys = {
            { ";", "<Plug>(comment_toggle_linewise_current)j", desc = "Comment line",  noremap = false },
            { ";", "<Plug>(comment_toggle_linewise_visual)",   desc = "Comment block", mode = "v",     noremap = false },
        }
    },


    -- LSP
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    {
        'neovim/nvim-lspconfig',
        init_options = {
            userLanguages = {
                rust = "html"
            }
        }
    },

    {
        "prettier/vim-prettier"
    },

    -- { 'fatih/vim-go' },


    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/nvim-cmp' },
    {
        'L3MON4D3/LuaSnip',
        version = "v2.*"
    },

    -- {
    --     'stevearc/aerial.nvim',
    --     opts = {},
    --     -- Optional dependencies
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --         "nvim-tree/nvim-web-devicons"
    --     },
    -- },

    {
        'tamago324/nlsp-settings.nvim',
        config = function()
            require("nlspsettings").setup {
                config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
                local_settings_dir = ".nlsp",
                local_settings_root_markers_fallback = { '.git' },
                append_default_schemas = true,
                loader = 'json'
            }
        end
    },

    -- {
    --     'linrongbin16/lsp-progress.nvim',
    --     dependencies = { 'nvim-tree/nvim-web-devicons' },
    --     config = function()
    --         require('lsp-progress').setup()
    --     end
    -- },

    -- {
    --     "ray-x/lsp_signature.nvim",
    --     event = "VeryLazy",
    --     opts = {},
    --     config = function(_, opts) require'lsp_signature'.setup(opts) end
    -- },

    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end
    },

    -- {
    --     'lvimuser/lsp-inlayhints.nvim',
    --     config = function ()
    --         require("lsp-inlayhints").setup()
    --     end
    -- },

    -- {
    --     'vigoux/ltex-ls.nvim',
    --     event = "VeryLazy",
    -- },

    {
        'simrat39/rust-tools.nvim',
        event = "VeryLazy",
    },

    {
        "iamcco/markdown-preview.nvim",
        event = "VeryLazy",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },


    {
        'lervag/vimtex',
        config = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_ignore_filters = { 'Underfull', 'Overfull', 'Token not allowed', 'Size', 'Draft',
                'Font shape' }
            -- vim.g.vimtex_view_method = "general"
            vim.g.Tex_IgnoreLevel = 8
            vim.g.vimtex_compiler_latexmk = {
                continuous = 1,
                options = { "-shell-escape" }
            }
        end
    },

    {
        "micangl/cmp-vimtex",
    }
}
---}}}

require("lazy").setup(plugins, {})
vim.cmd("colorscheme " .. colorscheme[1])
vim.o.background = colorscheme[2]

local wk = require("which-key")
local highlight = vim.api.nvim_set_hl

function FileTypesConfig()
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.wgsl",
        callback = function()
            vim.bo.filetype = "wgsl"
        end,
    })
end

---{{{ Generic Keybinds
function GenericKeybindsConfig()
    wk.register({
        ["ec"] = { ":e ~/.config/nvim/init.lua<cr>", "Open config" }
    }, {
        prefix = "<leader>",
        mode = "n",
    })

    wk.register({
        ["<C-n><C-n>"] = { ":noh<cr>", "No highlights" },
        ["<C-s>"] = { ":w<cr>", "Save" }
    }, {
        mode = 'n'
    })

    wk.register({
        ["<C-s>"] = { "<esc>:w<cr>i", "Save" }
    }, {
        mode = { 'i' },
    })

    wk.register({
        ["'x"] = { [["_x]], "Cut without saving" }
    }, {
        mode = "v",
        noremap = true
    })

    wk.register({
        ["'dd"] = { [["_dd]], "Cut without saving" }
    }, {
        mode = "n",
        noremap = true
    })
end

---}}}

--- {{{ Vimtex

function VimtexConfig()
    wk.register({
        t = { '<cmd>:VimtexCompile<CR>', "Vimtex Compile" },
        v = { '<cmd>:VimtexView<CR>', "Vimtex View" }
    }, {
        prefix = "<leader>t"
    })

    vim.g.vimtex_view_method = 'zathura_simple'

    -- vim.cmd [[
    -- function! Synctex()
    --         " remove 'silent' for debugging
    --         execute "silent !zathura --synctex-forward " . line('.') . ":" . col('.') . ":" . bufname('%') . " " . g:syncpdf
    -- endfunction
    -- ]]
end

---}}}

---{{{ TextWidthConfig
function TextWidthConfig()
    function SetupTextWidth()
        local api = vim.api
        local length = api.nvim_buf_line_count(0)
        if length <= 0 then
            return
        end

        local line = api.nvim_buf_get_lines(0, length - 1, length, true)[1]
        local data = string.match(line, "%%tw=([0-9]+)")
        local tw = nil

        if data ~= nil then
            tw = tonumber(data)
        end

        if tw ~= nil then
            vim.cmd([[setlocal textwidth=]] .. tw .. [[ formatoptions+=t ]])
        end
    end

    wk.register({ ["'f"] = { "ms{gq}'s", "Format paragraph" } }, {})
    wk.register({ ["'f"] = { "gq", "Format paragraph" } }, { mode = "v" })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*.tex" },
        callback = SetupTextWidth
    })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*.md" },
        callback = function()
            vim.cmd([[setlocal textwidth=120]])
        end
    })
end

--- }}}

--- {{{ LspConfig
function LspConfig()
    local lsp_zero = require('lsp-zero')

    lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })
        -- vim.lsp.inlay_hint.enable(bufnr, true)
        -- require("lsp-inlayhints").on_attach(client, bufnr)
    end)

    lsp_zero.set_server_config({
        on_init = function(client)
            client.server_capabilities.semanticTokensProvider = nil
        end,
    })

    local rust_lsp = lsp_zero.build_options('rust_analyzer', {})

    local border = "rounded"

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = border
        opts.max_width = 60
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    require("mason").setup()
    require("mason-lspconfig").setup({
        handlers = {
            lsp_zero.default_setup,
        }
    })

    local lspconfig = require("lspconfig")

    -- lspconfig.ltex.setup {
    --     filetypes = { "latex", "tex", "bib", "markdown", "text" },
    -- }

    lspconfig.denols.setup {
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    }

    lspconfig.tsserver.setup {
        root_dir = lspconfig.util.root_pattern("package.json"),
        single_file_support = false
    }

    lspconfig.pylsp.setup {
        cmd = { "rye", "run", "pylsp" }
    }

    lspconfig.ruff_lsp.setup {
        cmd = { "rye", "run", "ruff-lsp" }
    }

    -- require("lspcV
    --     cmd = { "bunx", "tsserver"},
    --     init_options = {
    --         hostInfo = "neovim"
    --     },
    --     single_file_support = true
    -- }
    --
    lsp_zero.setup_servers({
        "lua_ls",
        "omnisharp",
        -- "tsserver",
        -- "pyright",
        -- "ruff_lsp",
        "jsonls",
        -- "svelte",
        "gopls",
        "tailwindcss",
        "gdscript"
        -- "wgsl_analyzer",
        -- "hls",
        -- "elixirls",
        -- "zls"
    })

    -- setup rust separately with rust tools
    require("rust-tools").setup({ server = rust_lsp })

    vim.api.nvim_set_hl(0, "CmpNormal", { link = "Normal" })

    local MAX_LABEL_WIDTH = 60
    local ELLIPSIS_CHAR = "…"

    local function fixed_width(content)
        local result = ""
        if #content > MAX_LABEL_WIDTH then
            result = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
        else
            result = content
        end
        return result
    end

    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load()

    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
        preselect = cmp.PreselectMode.None,
        sources = {
            { name = 'nvim_lsp_signature_help' },
            { name = "luasnip" },
            { name = "path" },
            { name = "nvim_lsp" },
            { name = "vimtex" },
            { name = "buffer" }
        },

        formatting = {
            fields = { 'menu', 'abbr', 'kind' },
            format = function(entry, item)
                local menu_icon = {
                    nvim_lsp = 'λ ',
                    vimtex = 'ξ ',
                    luasnip = '⋗ ',
                    buffer = 'Ω ',
                    path = '🖫 ',
                }

                item.abbr = fixed_width(item.abbr)

                item.menu = menu_icon[entry.source.name]
                item.kind_hl_group = "TSString"

                if entry.source.name == "vimtex" then
                    item.kind = "VimTeX"
                end

                return item
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<Enter>'] = cmp.mapping.confirm(),
        }),
        window = {
            completion = {
                border = "rounded",
                -- winhighlight = "NormalFloat:Normal"
                winhighlight = "Normal:CmpNormal"
            },

            documentation = {
                border = "rounded",
                max_width = 60,
                -- max_height = 20,
            }
        }
    })

    -- require("aerial").setup {
    --     layout = {
    --         max_width = { 0.25 },
    --         min_width = 30
    --     },
    --     on_attach = function(bufnr)
    --     end
    -- }

    -- wk.register({
    --     ["s"] = { "<cmd>AerialToggle<CR>", "Open aerial" }
    -- }, {
    --     prefix = "<leader>"
    -- })
end

---}}}

function Configuration()
    FileTypesConfig()
    -- TelescopeConfig()
    VimtexConfig()
    LspConfig()
    GenericKeybindsConfig()
    TextWidthConfig()

    highlight(0, 'FloatBorder', { link = 'Normal' })
    highlight(0, 'NormalFloat', { link = 'Normal' })
    -- highlight(0, 'LspInlayHint', { link = 'Comment' })
end

Configuration()

-------------------------------{{{ Neovide

-- vim.o.guifont = "Iosevka NFP Medium:h11"
vim.o.guifont = "CaskaydiaCove Nerd Font Mono:h14"
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
