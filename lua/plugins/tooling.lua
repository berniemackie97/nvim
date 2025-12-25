local function add_unique(list, items)
  local seen = {}
  for _, item in ipairs(list) do
    seen[item] = true
  end
  for _, item in ipairs(items) do
    if not seen[item] then
      table.insert(list, item)
      seen[item] = true
    end
  end
end

local function extend_by_ft(map, ft, items)
  map[ft] = map[ft] or {}
  add_unique(map[ft], items)
end

local function ensure_linter_condition(opts, name, condition)
  opts.linters = opts.linters or {}
  local linter = opts.linters[name]
  if linter == nil then
    opts.linters[name] = { condition = condition }
  elseif type(linter) == "table" then
    linter.condition = linter.condition or condition
  end
end

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      extend_by_ft(opts.formatters_by_ft, "c", { "clang-format" })
      extend_by_ft(opts.formatters_by_ft, "cpp", { "clang-format" })
      extend_by_ft(opts.formatters_by_ft, "objc", { "clang-format" })
      extend_by_ft(opts.formatters_by_ft, "objcpp", { "clang-format" })
      extend_by_ft(opts.formatters_by_ft, "cuda", { "clang-format" })
      extend_by_ft(opts.formatters_by_ft, "proto", { "clang-format" })
      extend_by_ft(opts.formatters_by_ft, "go", { "goimports", "gofumpt" })
      extend_by_ft(opts.formatters_by_ft, "rust", { "rustfmt" })
      extend_by_ft(opts.formatters_by_ft, "java", { "google-java-format" })
      extend_by_ft(opts.formatters_by_ft, "cs", { "csharpier" })
      extend_by_ft(opts.formatters_by_ft, "python", { "ruff_format" })
      return opts
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      extend_by_ft(opts.linters_by_ft, "go", { "golangcilint" })
      extend_by_ft(opts.linters_by_ft, "markdown", { "markdownlint-cli2" })
      extend_by_ft(opts.linters_by_ft, "python", { "ruff" })
      ensure_linter_condition(opts, "golangcilint", function()
        return vim.fn.executable("golangci-lint") == 1
      end)
      ensure_linter_condition(opts, "markdownlint-cli2", function()
        return vim.fn.executable("markdownlint-cli2") == 1
      end)
      ensure_linter_condition(opts, "ruff", function()
        return vim.fn.executable("ruff") == 1
      end)
      return opts
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      add_unique(opts.ensure_installed, {
        "clang-format",
        "csharpier",
        "eslint_d",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "google-java-format",
        "markdownlint-cli2",
        "prettier",
        "ruff",
        "rustfmt",
      })
      return opts
    end,
  },
}
