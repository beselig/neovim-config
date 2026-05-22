local M = {}

---@param bufnr integer Buffer handle, or 0 for current.
local function organize_imports(bufnr)
  local buf = bufnr or 0 -- 0 = current buffer
  local clients = vim.lsp.get_clients { bufnr = buf }
  for _, client in ipairs(clients) do
    if client.name == 'ts_ls' then
      -- local _, err = vim.lsp.buf_request_sync(buf, 'workspace/executeCommand', {
      --   command = 'typescript.organizeImports',
      --   arguments = { vim.api.nvim_buf_get_name(buf) },
      -- }, 1000)
      -- if err then
      --   print(err)
      -- end

      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { 'source.organizeImports' },
          diagnostics = {},
        },
      }
      vim.wait(500)
      return
    end
  end

  print "missing client 'ts_ls'. Could not organize imports"
end

M.organize_imports = organize_imports

return M
