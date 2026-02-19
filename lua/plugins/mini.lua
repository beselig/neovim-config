return {
  'echasnovski/mini.nvim',
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  version = false,
  config = function()
    require('mini.comment').setup {
      n_lines = 500,
      custom_commentstring = function()
        local plug = require('ts_context_commentstring').setup {
          languages = {
            javascript = {
              __default = '// %s',
              jsx_element = '{/* %s */}',
              jsx_fragment = '{/* %s */}',
              jsx_attribute = '// %s',
              comment = '// %s',
            },
            typescript = {
              __default = '// %s',
              jsx_element = '{/* %s */}',
              jsx_fragment = '{/* %s */}',
              jsx_attribute = '// %s',
              comment = '// %s',
            },
          },
        }

        print 'foo'

        return plug.calculate_commentstring() or vim.bo.commentstring
      end,
    }

    require('mini.ai').setup { n_lines = 500 }

    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = true }

    require('mini.surround').setup()

    local notify = require 'mini.notify'
    notify.setup()
    vim.notify = notify.make_notify {
      ERROR = { duration = 15000 },
      WARN = { duration = 15000 },
      INFO = { duration = 5000 },
    }

    -- not sure about this one:
    -- require 'mini.jump'jump.setup()

    require('mini.pairs').setup()

    require('mini.misc').setup {
      make_global = { 'put', 'put_text' },
    }

    require('mini.move').setup()

    -- require('mini.icons').setup()

    -- you can configure sections in the statusline by overriding their
    -- default behavior. for example, here we set the section for
    -- cursor location to line:column
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
