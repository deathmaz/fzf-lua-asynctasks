local fzf_lua_installed, fzf_lua = pcall(require, 'fzf-lua')
if not fzf_lua_installed then
  print('fzf lua is not installed')
  return
end

local M = {}

M.default_action = function(selected)
  local str = fzf_lua.utils.strsplit(selected[1], ' ')
  local command = 'AsyncTask ' .. vim.fn.fnameescape(str[1]);
  vim.api.nvim_exec(command, false)
end

local default_opts = {
  actions = {
    ['default'] = M.default_action
  },
  fzf_opts = {
    ["--no-multi"] = '',
    ["--nth"]      = '1',
  },
  winopts = {
    height = 0.6,
    width = 0.6,
  }
}

function M.setup(opts)
  fzf_lua.asynctasks = function()
    opts = fzf_lua.config.normalize_opts(opts, default_opts)
    local rows = vim.fn['asynctasks#source'](math.floor(vim.go.columns * 48 / 100))
    fzf_lua.fzf_exec(function(cb)
      for _, e in ipairs(rows) do
        local color = fzf_lua.utils.ansi_codes
        local line = color.green(e[1]) .. ' ' .. color.cyan(e[2]) .. ': ' .. color.yellow(e[3])
        cb(line)
      end
      cb()
    end, opts)
  end
end

return M
