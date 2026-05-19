-- empty setup using defaults
require('nvim-tree').setup {
  view = {
    width = 25,
  },
}

vim.api.nvim_set_keymap('n', '<Leader>s', '<cmd>lua require("custom.switch_case").switch_case()<CR>', { noremap = true, silent = true })

-- Off logs (turn on "debug" when needed)
-- vim.lsp.set_log_level 'off'

vim.cmd [[set colorcolumn=120]] -- show line on {=line} column

vim.api.nvim_create_user_command('ReplaceSelected', function(opts)
  -- Get args - the new text to replace with
  local new_text = table.concat(opts.fargs, ' ')

  -- Check if we have a new text argument
  if new_text == '' then
    print 'Usage: :Replace <new_text>'
    return
  end

  -- Save the current selection to register z
  vim.cmd 'normal! gv"zy'

  -- Get the selected text from register z
  local selected_text = vim.fn.getreg 'z'

  -- Escape special characters in the selected text for search
  local escaped_text = vim.fn.escape(selected_text, [[/\.*$^~[]])

  -- Replace selected text with new text throughout the file (with confirmation)
  vim.cmd(string.format('%%s/%s/%s/gc', escaped_text, vim.fn.escape(new_text, '/')))
end, {
  nargs = '*',
  range = true,
  desc = 'Replace selected text with new text across the file',
})

vim.api.nvim_create_user_command('Cla', 'LspClangdSwitchSourceHeader', {})

-- Copy Current File Path
function GetCopiedText()
  local config = {}
  config.config = {
    register = 'unnamedplus',
  }
  local api = require 'socks-copypath.api'
  local path = api.copy_absolute_path(config)
  require('osc52').copy(path)
end

vim.api.nvim_create_user_command('Copy', GetCopiedText, {})

function GetPossibleArcadiaLink()
  local config = {}
  config.config = {
    register = 'unnamedplus',
  }
  local api = require 'socks-copypath.api'
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local path = api.copy_absolute_path(config)
  path = path .. '#L' .. line_number
  local start = string.find(path, 'arcadia')
  path = string.sub(path, start)
  start = string.find(path, '/')
  path = string.sub(path, start)
  path = 'https://a.yandex-team.ru/arcadia' .. path
  print(path)
end

vim.api.nvim_create_user_command('ArcadiaLink', GetPossibleArcadiaLink, {})

-- copy plugin keys
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true })
vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)

-- show errors inline
vim.diagnostic.config {
  virtual_text = {},
}

return {}
