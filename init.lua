-- local dark_colorscheme = "nightly"
-- local dark_colorscheme = { "monokai-pro-spectrum", "dark" }
 -- local dark_colorscheme = { "darkblue", "dark" }
-- local dark_colorscheme = { "noctis", "dark" }
local dark_colorscheme = { "biscuit", "dark" }
local light_colorscheme = { "dayfox", "light" }
local colorscheme = dark_colorscheme

_G.CurrentStatus = ""

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
    },

    {
        'nvim-telescope/telescope-ui-select.nvim',
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").load_extension("ui-select")
        end
    },

    {
        'fannheyward/telescope-coc.nvim'
    },


    {
        'mhinz/vim-startify'
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
        'kartikp10/noctis.nvim', name = 'noctis',
        dependencies = {
            'rktjmp/lush.nvim'
        }
    },

    {
        'Biscuit-Colorscheme/nvim',
        name = 'biscuit',
        lazy = false,
        priority = 1000,
    },


    {
        "Shatur/neovim-ayu",
        config = function()
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
        "loctvl842/monokai-pro.nvim",
        config = function()
            require("monokai-pro").setup()
        end
    },

    {
        "Alexis12119/nightly.nvim",
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
                d = { '<cmd>NvimTreeToggle<CR>', 'Nvim-Tree toggle' }
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

                ft_ignore = { "NvimTree", "lazy", "startup" },

                segments = {
                    { text = { "%C" }, click = "v:lua.ScFa" },
                    { text = { "%s" }, click = "v:lua.ScSa" },
                    {
                        text = { " ", builtin.lnumfunc, " ┃ " }, -- ·" },
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
        config = function()
            require "bufferline".setup {
                auto_hide = false,
                insert_at_end = true,
                icons = {
                    button = '❌'
                }
            }

            local wk = require("which-key")

            for i = 1, 10 do
                wk.register({
                        ['<M-' .. i .. '>'] =
                        { '<Cmd>BufferGoto ' .. i .. '<CR>', "Change tabs" }
                    },
                    { mode = { "t", "n" } })
            end

            wk.register({ ['<C-q>'] = { '<Cmd>BufferClose<CR>', "Close buffer" } })

            wk.register({
                ["<C->>"] = { "<Cmd>BufferMoveNext<CR>", "Buffer move to next" },
                ["<C-<>"] = { "<Cmd>BufferMovePrevious<CR>", "Buffer move to previous" }
            })
        end
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
                    disabled_filetypes = {
                        statusline = { 'lazy', 'NvimTree' },
                        winbar = { 'lazy', 'NvimTree' }
                    }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', '', 'filetype' },
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


    {
        "andweeb/presence.nvim",
        config = function()
            require("presence").setup {}
        end
    },


    {
        'numToStr/Comment.nvim',
        config = function()
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


    -- LSP


    {
        'neoclide/coc.nvim',
        branch = 'release'
    },

    {
        'puremourning/vimspector',
        config = function()
            local wk = require('which-key')
            wk.register({
                ["pp"] = { "<Plug>VimspectorBalloonEval", "Vimspector balloon eval" }
            }, {
                prefix = "<leader>",
                mode = "n",
            })
        end
    },

    {
        'mfussenegger/nvim-dap',
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" }
    },


    {
        'lervag/vimtex',
        config = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_ignore_filters = { 'Underfull', 'Overfull', 'Token not allowed' }
            vim.g.vimtex_view_method = "zathura"
            vim.g.Tex_IgnoreLevel = 8
            vim.g.vimtex_compiler_latexmk = {
                continuous = 1
            }
        end
    }

}
---}}}

require("lazy").setup(plugins, {})
vim.cmd("colorscheme " .. colorscheme[1])
vim.o.background = colorscheme[2]

local wk = require("which-key")
local highlight = vim.api.nvim_set_hl

--- {{{ Dap 
function DapConfig()
    local dap = require("dap")

    dap.adapters.coreclr = {
        type = 'executable',
        command = '/usr/bin/netcoredbg',
        args = { '--interpreter=vscode' }
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
        },
    }

    require("dapui").setup()
    wk.register({
        ["=?"] = { require("dapui").toggle, "Toggle dapui" },
        ["=/"] = { ":DapContinue<CR>", "Start Dap" }
    }, {
        prefix = "<leader>",
        mode = "n"
    })
end

---}}}

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

    wk.register({
        ["ls"] = { function() print(_G.CurrentStatus) end, "Show current status" }
    }, {
        prefix = "<leader>"
    })
end

---}}}

--- {{{ Telescope
function TelescopeConfig()
    require("telescope").setup({
        extensions = {
            coc = {
                theme = 'ivy',
                prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
            },
            builtin = {
                theme = 'ivy'
            },
        },
    })
    require('telescope').load_extension('coc')

    local menu = require("nui.menu")

    local telescope_actions = {
        { text = "Jump to definition",      cmd = "coc declarations" },
        -- { text = "Show calls to this", cmd = "lsp_incoming_calls" },
        { text = "Show references to this", cmd = "coc references" },
        { text = "Show workspace issues",   cmd = "coc workspace_diagnostics" },
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


    wk.register({
        ["=="] = { ":Telescope coc commands<CR>", "CoC commands" }
    }, {
        prefix = "<leader>",
        mode = "n"
    })

    wk.register({ ["<F2>"] = { ":lua Telescope_Menu:mount()<CR>", "LSP actions" } })
    wk.register({ ["<F3>"] = { "<cmd>Telescope coc document_symbols<CR>", "LSP symbols" } })
    wk.register({ ["<F12>"] = { "<cmd>Telescope resume<CR>", "Resume last telescope" } })
    wk.register({
        ["f"] = { "<cmd>Telescope find_files<CR>", "Find files" },
        ["/"] = { "<cmd>Telescope live_grep<CR>", "Grep in files" }
    }, {
        prefix = "<leader>"
    })

    vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])

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

    vim.cmd [[
    function! Synctex()
            " remove 'silent' for debugging
            execute "silent !zathura --synctex-forward " . line('.') . ":" . col('.') . ":" . bufname('%') . " " . g:syncpdf
    endfunction
    ]]
end

---}}}

--- {{{ CoC 
function CoCConfig()
    function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end

    function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
            vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
            vim.fn.CocActionAsync('doHover')
        else
            vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
    end

    local opts = { noremap = true, expr = true, replace_keycodes = false }
    vim.keymap.set("i", "<tab>", [[coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()]],
    opts)
    vim.keymap.set("i", "<s-tab>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
    -- vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
    vim.keymap.set("i", "<CR>",
        function()
            if vim.fn['coc#pum#visible']() == 1 then
                return vim.fn['coc#pum#confirm']()
            else
                return "\r"
            end
        end,
    opts)

    wk.register({
        ["<a-cr>"] = { [[<Plug>(coc-snippets-expand)]] , "Expand snippet" },
        {
            mode = 'i',
            silent = true
        }
    })

    wk.register({
        ["K"] = { '<cmd>lua _G.show_docs()<CR>', "Show docs" },
        ["gd"] = { '<Plug>(coc-definition)', "Goto definition" },
        ["QQ"] = { '<Plug>(coc-codeaction-cursor)', "Code actions" },
        ["QE"] = { ':Telescope coc diagnostics<CR>', "Errors" }
    }, {
        mode = 'n',
        silent = true
    })


    wk.register({
        ["oo"] = { [[:call CocAction('organizeImport')<cr>]], "Organize imports" }
    }, {
        prefix = "<leader>",
        mode = 'n',
        -- silent = true
    })

    wk.register({
        ["??"] = { '<Plug>(coc-format-selected)', "Format" },
    }, {
        mode = 'v',
        silent = true
    })
end
--- }}}

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
            vim.cmd([[setlocal textwidth=]]..tw..[[ formatoptions+=t ]])
        end
    end

    wk.register({["'f"] =  {"ms{gq}'s", "Format paragraph" }}, { })

    vim.api.nvim_create_autocmd({"BufEnter"}, {
        pattern = {"*.tex"},
        callback = SetupTextWidth
    })
end
--- }}}

function Configuration()
    DapConfig()
    TelescopeConfig()
    VimtexConfig()
    CoCConfig()
    GenericKeybindsConfig()
    TextWidthConfig()

    highlight(0, 'FloatBorder', { link = 'Normal' })
    highlight(0, 'NormalFloat', { link = 'Normal' })
    highlight(0, 'LspInlayHint', { link = 'Comment' })

    vim.api.nvim_create_autocmd("User", {
        pattern = "CocStatusChange",
        callback = function()
            local status = vim.call("coc#status")
            _G.CurrentStatus = status
            print(status)
        end
    })
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
