local M = {}

function M.setup(opts)
    local set = vim.cmd
    local config = require "anysphere.config"
    local themes = require "anysphere.themes"

    if vim.g.colors_name then
        set.hi "clear"
    end

    if vim.fn.exists "syntax_on" then
        set.syntax "reset"
    end

    vim.o.background = "dark"
    vim.o.termguicolors = true
    vim.g.colors_name = "anysphere"

    config:extend(opts)
    themes.load()

    if opts then
        set.colorscheme "anysphere"
    end
end

return M
