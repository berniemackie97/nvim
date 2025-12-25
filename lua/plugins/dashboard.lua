local function pad_center(center)
  for _, button in ipairs(center) do
    if type(button.desc) == "string" then
      button.desc = button.desc .. string.rep(" ", math.max(0, 43 - #button.desc))
    end
    button.key_format = "  %s"
  end
end

return {
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local logo = [[
██████╗ ███████╗██████╗ ███╗   ██╗██╗███████╗██╗   ██╗██╗███╗   ███╗
██╔══██╗██╔════╝██╔══██╗████╗  ██║██║██╔════╝██║   ██║██║████╗ ████║
██████╔╝█████╗  ██████╔╝██╔██╗ ██║██║█████╗  ██║   ██║██║██╔████╔██║
██╔══██╗██╔══╝  ██╔══██╗██║╚██╗██║██║██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
██████╔╝███████╗██║  ██║██║ ╚████║██║███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝

           ⚡ SHIP FAST · LINT CLEAN · CODE LIKE A PRO ⚡
]]
      logo = string.rep("\n", 4) .. logo .. "\n"

      opts.config = opts.config or {}
      opts.config.header = vim.split(logo, "\n")

      opts.config.center = opts.config.center or {}
      table.insert(opts.config.center, 1, {
        action = "Mason",
        desc = "Tool Manager",
        icon = "[M] ",
        key = "m",
      })
      pad_center(opts.config.center)

      local footer = opts.config.footer
      opts.config.footer = function()
        local lines = {}
        if type(footer) == "function" then
          lines = footer()
        elseif type(footer) == "table" then
          lines = vim.deepcopy(footer)
        elseif type(footer) == "string" then
          lines = { footer }
        end
        return lines
      end

      return opts
    end,
  },
}
