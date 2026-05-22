local M = {}

M.print_clients = function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print 'no clients attached'
  end

  for _, client in ipairs(clients) do
    print('Client Name: ' .. client.name)
    print('Client ID: ' .. client.id)
    print('Root Directory: ' .. (client.config.root_dir or 'N/A'))
    print '---'
  end
end

vim.api.nvim_create_user_command('LspPrintClients', function()
  M.print_clients()
end, {})

return M
