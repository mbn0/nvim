return {
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                stages = "fade_in_slide_out", -- Use the "fade_in_slide_out" animation.
                timeout = 2000,  -- Notification duration in milliseconds.
                max_width = 50,  -- Max width for the notifications.
                max_height = 10, -- Max height for the notifications.
                background_colour = "#282828", -- Background color.
                render = "compact", -- Render style.
                top_down = false -- Position the notifications at the bottom.
            })
        end
    }
}
