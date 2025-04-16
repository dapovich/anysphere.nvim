---@class colors
local colors = {}

---@type colors
local defaults = {
    fg = "#d6d6dd",
    bg = "#181818",
    white = "#eeeeee",
    gray = "#b3b3b3",
    darkblue = "#163761",
    yellow = "#ebc88d",
    magenta = "#e394dc",
    softblue = "#94c1fa",
    orange = "#efb080",
    cyan = "#83d6c5",
    purple = "#aaa0fa",
    red = "#f75f5f",
    pink = "#ffc0cb",
    darkpink = "#ff008c",
    softpink = "#ce95b8",
    peanut = "#f5d5a4",
    darkgray = "#4b5261",
    palevioletred2 = "#ee799f",
    lightgray = "#9ca3b2",
    dawnblue = "#26292f",
    green = "#98c379",
    aqua = "#61afef",
}

colors = vim.deepcopy(defaults)

---Convert hex value to rgb
---@param color string
local function hex2rgb(color)
    color = string.lower(color)

    return {
        tonumber(color:sub(2, 3), 16),
        tonumber(color:sub(4, 5), 16),
        tonumber(color:sub(6, 7), 16),
    }
end

---@param fg string #foreground color
---@param bg string #background color
---@param alpha number #number between 0 and 1.
---@source: https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/util.lua#L9-L37
local function blend(fg, bg, alpha)
    local bg_rgb = hex2rgb(bg)
    local fg_rgb = hex2rgb(fg)

    local blend_channel = function(i)
        local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))

        return math.floor(math.min(math.max(0, ret), 255) + 0.5)
    end

    return ("#%02x%02x%02x"):format(blend_channel(1), blend_channel(2), blend_channel(3))
end

---@param alpha number #number between 0 and 1
function string:darken(alpha)
    return blend(self, "#000000", alpha)
end

---@param alpha number #number between 0 and 1
function string:lighten(alpha)
    return blend(self, "#ffffff", alpha)
end

---Get the hex value of a color
---@param name string #name of the color
---@param value any #value of the color
---@return string? #hex string or `nil` if invalid
local function get_hex_value(name, value)
    local logs = require "greenlight.logs"

    local type_ok, err = pcall(vim.validate, {
        ["colors(" .. name .. ")"] = { value, "string" },
    })

    if not type_ok then
        logs.error.notify(err)

        return defaults[name]
    end

    if value:lower() == "none" then
        return value
    end

    local rgb = vim.api.nvim_get_color_by_name(value)

    if rgb == -1 then
        logs.error.notify("colors(%s): %q is not a valid color", name, value)

        return defaults[name]
    end

    return ("#%06x"):format(rgb)
end

local config = require "anysphere.config"

for name, value in pairs(config.colors) do
    colors[name] = get_hex_value(name, value)
end

return colors
