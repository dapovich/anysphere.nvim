local themes = {}

---Set highlight groups
---@param groups groups
local function set_highlight(groups)
    local logs = require "anysphere.logs"
    local set_hl = vim.api.nvim_set_hl

    for name, attrs in pairs(groups) do
        local status_ok, err = pcall(set_hl, 0, name, attrs)

        if not status_ok then
            logs.error.notify("themes(%s): %s", name, err)
        end
    end
end

function themes.load()
    local config = require "anysphere.config"
    local colors = require "anysphere.colors"
    local default = require "anysphere.themes.groups"

    set_highlight(default)
    set_highlight(config.themes(colors))
end

return themes
