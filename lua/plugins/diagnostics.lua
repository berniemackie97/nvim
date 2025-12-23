return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.virtual_text = vim.tbl_deep_extend("force", opts.diagnostics.virtual_text or {}, {
        spacing = 2,
        source = "if_many",
        prefix = ">",
        severity = { min = vim.diagnostic.severity.WARN },
      })
      opts.diagnostics.float = vim.tbl_deep_extend("force", opts.diagnostics.float or {}, {
        border = "rounded",
        source = "if_many",
      })
      opts.diagnostics.severity_sort = true
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function(_, opts)
      local M = {}
      local lint = require("lint")
      opts.linters = opts.linters or {}
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.events = opts.events or { "BufWritePost", "BufReadPost", "InsertLeave" }

      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
          if type(linter.prepend_args) == "table" then
            lint.linters[name].args = lint.linters[name].args or {}
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          end
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      local function lint_enabled(buf)
        if vim.g.lint_enabled == false then
          return false
        end
        local value = vim.b[buf].lint_enabled
        if value ~= nil then
          return value
        end
        return true
      end

      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        local buf = vim.api.nvim_get_current_buf()
        if not lint_enabled(buf) then
          return
        end
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        names = vim.list_extend({}, names)

        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end

        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            LazyVim.warn("Linter not found: " .. name, { title = "nvim-lint" })
          end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)

        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
  },
}
