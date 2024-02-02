require("Comment").setup {
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    ---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
    sticky = true,

    ---Lines to be ignored while comment/uncomment.
    ---Could be a regex string or a function that returns a regex string.
    ---Example: Use '^$' to ignore empty lines
    ignore = "^$",
    toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
    },
    opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
    },

    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },

    ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
    ---NOTE: If `mappings = false` then the plugin won't create any mappings
    ---@type boolean|table
    mappings = {
        ---Operator-pending mapping
        ---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
        ---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
        basic = true,
        ---Extra mapping
        ---Includes `gco`, `gcO`, `gcA`
        extra = true,
        ---Extended mapping
        ---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
        extended = false,
    },
    pre_hook = nil,
    post_hook = nil,
}
