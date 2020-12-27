local gl = require('galaxyline')
local vcs = require('galaxyline.provider_vcs')
local gls = gl.section
gl.short_line_list = {'LuaTree','vista','dbui'}

local lsp_status = require('lsp-status')
lsp_status.register_progress()

local colors = {
  bg = '#282c34',
  line_bg = '#353644',
  fg = '#8FBCBB',
  fg_green = '#65a380',

  yellow = '#fabd2f',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#afd700',
  orange = '#FF8800',
  purple = '#5d4d7a',
  magenta = '#c678dd',
  blue = '#51afef';
  red = '#ec5f67'
}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

gls.left[1] = {
  FirstElement = {
    provider = function() return '▊ ' end,
    highlight = {colors.blue,colors.line_bg}
  },
}
gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {n = colors.magenta, i = colors.green,v=colors.blue,[''] = colors.blue,V=colors.blue,
                          c = colors.red,no = colors.magenta,s = colors.orange,S=colors.orange,
                          [''] = colors.orange,ic = colors.yellow,R = colors.purple,Rv = colors.purple,
                          cv = colors.red,ce=colors.red, r = colors.cyan,rm = colors.cyan, ['r?'] = colors.cyan,
                          ['!']  = colors.red,t = colors.red}
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
      return '  '
    end,
    highlight = {colors.red,colors.line_bg,'bold'},
  },
}
gls.left[3] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.line_bg},
  },
}
gls.left[4] = {
  FileName = {
    provider = {'FileName','FileSize'},
    condition = buffer_not_empty,
    highlight = {colors.fg,colors.line_bg,'bold'}
  }
}

gls.left[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    highlight = {colors.orange,colors.line_bg},
  }
}
gls.left[6] = {
  GitBranch = {
    provider = function()
        local branch = vcs.get_git_branch()
        if branch then
            branch = branch .. ' | '
        end
        return branch
    end,
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    highlight = {'#8FBCBB',colors.line_bg,'bold'},
  }
}

local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

gls.left[7] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = '  ',
    highlight = {colors.green,colors.line_bg},
  }
}
gls.left[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = '  ',
    highlight = {colors.orange,colors.line_bg},
  }
}
gls.left[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = '  ',
    highlight = {colors.red,colors.line_bg},
  }
}
gls.left[10] = {
  LeftEnd = {
    provider = function() return '' end,
    separator = '',
    separator_highlight = {colors.bg,colors.line_bg},
    highlight = {colors.line_bg,colors.line_bg}
  }
}
gls.left[11] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.bg}
  }
}
gls.left[12] = {
  Space = {
    provider = function () return ' ' end
  }
}
gls.left[13] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '   ',
    highlight = {colors.blue,colors.bg},
  }
}

local lsp_messages = function()
    local buf_messages = lsp_status.messages()
    local msgs = {}
    local aliases = {
        pyls_ms = 'MPLS',
    }
    local config = {
        spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
    }
    for _, msg in ipairs(buf_messages) do
        local name = aliases[msg.name] or msg.name
        local client_name = '[' .. name .. ']'
        local contents = ''
        if msg.progress then
            contents = msg.title
            if msg.message then
                contents = contents .. ' ' .. msg.message
            end

            if msg.percentage then
                contents = contents .. ' (' .. msg.percentage .. ')'
            end

            if msg.spinner then
                contents = config.spinner_frames[(msg.spinner % #config.spinner_frames) + 1] .. ' ' .. contents
            end
        elseif msg.status then
            contents = msg.content
            if msg.uri then
                local filename = vim.uri_to_fname(msg.uri)
                filename = vim.fn.fnamemodify(filename, ':~:.')
                local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
                if #filename > space then
                    filename = vim.fn.pathshorten(filename)
                end
                contents = '(' .. filename .. ') ' .. contents
            end
        else
            contents = msg.content
        end

        table.insert(msgs, client_name .. ' ' .. contents)
    end
    return table.concat(msgs, ' ')
end

gls.left[14] = {
    LspStatus = {
        provider = function() return ' ' .. lsp_messages() end,
        condition = function() if checkwidth() and #vim.lsp.buf_get_clients() > 0 then return true end return false end,
        highlight= {colors.magenta,colors.bg}
    }
}


gls.right[1]= {
  LspFunc = {
      provider = function()
          local current_function = vim.b.lsp_current_function
          return '(' .. current_function .. ') '
      end,
    condition = function()
        local current_function = vim.b.lsp_current_function
        if checkwidth() and current_function and current_function ~= '' then
            return true
        end
        return false
    end,
    highlight = {colors.orange,colors.bg},
  }
}
gls.right[2]= {
  FileFormat = {
    provider = 'FileFormat',
    separator = ' ',
    separator_highlight = {colors.bg,colors.line_bg},
    highlight = {colors.fg,colors.line_bg,'bold'},
  }
}
gls.right[3] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = {colors.blue,colors.line_bg},
    highlight = {colors.fg,colors.line_bg},
  },
}
gls.right[4] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {colors.line_bg,colors.line_bg},
    highlight = {colors.cyan,colors.darkblue,'bold'},
  }
}
gls.right[5] = {
  ScrollBar = {
    provider = 'ScrollBar',
    highlight = {colors.blue,colors.purple},
  }
}

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = '',
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.fg,colors.purple}
  }
}


gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    separator = '',
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.fg,colors.purple}
  }
}
