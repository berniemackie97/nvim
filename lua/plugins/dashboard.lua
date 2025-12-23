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
BBBBB  EEEEE  RRRR   N   N  III  EEEEE  V   V  III  M   M
B   B  E      R   R  NN  N   I   E      V   V   I   MM MM
BBBBB  EEEE   RRRR   N N N   I   EEEE   V   V   I   M M M
B   B  E      R  R   N  NN   I   E       V V    I   M   M
B   B  E      R   R  N   N   I   E        V     I   M   M
BBBBB  EEEEE  R   R  N   N  III  EEEEE    V    III  M   M
]]
      logo = string.rep("\n", 6) .. logo .. "\n"

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
        table.insert(lines, 1, "BERNIEVIM // ship fast, lint clean")
        return lines
      end

      return opts
    end,
  },
}
