-- This will run last in the setup process.

-- vim.lsp.buf.definition をラップして重複結果を排除する
-- (LspAttach keymap はAstroLSPに上書きされるため、関数自体をラップ)
local orig_definition = vim.lsp.buf.definition
vim.lsp.buf.definition = function(opts)
  opts = opts or {}
  if not opts.on_list then
    opts.on_list = function(options)
      local seen = {}
      local unique = {}
      for _, item in ipairs(options.items) do
        local key = (item.filename or "") .. ":" .. tostring(item.lnum) .. ":" .. tostring(item.col)
        if not seen[key] then
          seen[key] = true
          table.insert(unique, item)
        end
      end
      options.items = unique

      if #unique == 0 then return end
      vim.fn.setqflist({}, " ", options)
      if #unique == 1 then
        vim.cmd "cfirst"
      else
        vim.cmd "copen"
      end
    end
  end
  orig_definition(opts)
end
