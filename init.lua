local colorscheme = "github_dark_dimmed"

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
vim.o.foldenable = false
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

LualinePlugins = {
    navic_component = function()
        local navic = require("nvim-navic")
        if navic.is_available() then
            return navic.get_location()
        else
            return "  "
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
            }
        end
    },

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

    "rebelot/kanagawa.nvim",

    {
        "projekt0n/github-nvim-theme",
        lazy = false,
        config = function()
            require("github-theme").setup {}
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
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        config = function()
            require("nvim-tree").setup {
                view = {
                    adaptive_size = true,

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

                ft_ignore = {"NvimTree", "lazy", "startup", "mason"},

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
                auto_hide = true,
                insert_at_end = true,
                icons = {
                    button = '❌'
                }
            }

            local wk = require("which-key")

            for i = 1,10 do
                wk.register({ ['<M-' .. i .. '>'] = { '<Cmd>BufferGoto ' .. i .. '<CR>', "Change tabs" } })
            end

            wk.register({ ['<C-q>'] = { '<Cmd>BufferClose<CR>', "Close buffer" }})
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



    -- General utils for coding
    {
        'tpope/vim-commentary',
        config = function()
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
                    null_ls.builtins.diagnostics.proselint,
                    -- null_ls.builtins.completion.spell,
                },
            })
        end
    },

    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
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
    'uga-rosa/cmp-dictionary',

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

    {
        "doums/lswip.nvim",
        config = function()
            require("lswip").setup()
        end
    },

    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require("lsp_signature").setup()
        end
    },


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
                    on_attach = function(_, bufnr)
                        local wk = require("which-key")
                        wk.register({
                            K = { "<cmd>RustHoverActions<CR>", "Hover actions for Rust" }
                        }, {
                            buffer = bufnr
                        })
                    end,
                },
            })
        end
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

require('lazy').setup(plugins, {})
vim.cmd("colorscheme " .. colorscheme)


------------ Setup LSP ----------------------
require("mason").setup()
require("mason-lspconfig").setup({
    -- automatic_installation = true
})

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})

    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end
    -- nvim_tree_on_attach(bufnr)
    -- client.server_capabilities.semanticTokensProvider = nil
    require("lsp-inlayhints").on_attach(client, bufnr)
end)

lsp.skip_server_setup({'rust_analyzer'})
-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

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
})

local dict = require("cmp_dictionary")
dict.switcher {
    spelllang = {en = "/home/subwave/.config/nvim/dicts/en.dict"}
}


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

------------ Keybindings -------------------

local wk = require("which-key")
wk.register({
    ec = { ":e ~/.config/nvim/init.lua<CR>", "Open config" }
}, {
    prefix = "<leader>"
})

wk.register({
    Q = { vim.lsp.buf.code_action, "Code action" },
}, {
    prefix = "Q"
})

wk.register({
    ["<C-n>"] = { ":noh<CR>", "Remove highlights" },
    ["<C-s>"] = { ":w<CR>", "Save"},
    ["<F5>"] = {"<cmd>Telescope colorscheme<CR>", "Set colorscheme"},
    ["<F9>"] = {
        function()
            vim.o.background = "light"
            vim.cmd[[colorscheme github_light]]
        end, "Set light colorscheme"
    },
    ["<F10>"] = {
        function()
            vim.o.background = "dark"
            vim.cmd[[colorscheme github_dark_dimmed]]
        end, "Set dark colorscheme"
    },
})
------ Telescope ------------------

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

----- VimTeX settings --------------

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

-------------------------------------

vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
