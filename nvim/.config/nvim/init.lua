-- lazy.nvim reads the leader when it sets up plugin key mappings.
vim.g.mapleader = ','

-- Bootstrap lazy.nvim. Plugins live in stdpath('data'), outside this
-- repository; their revisions are pinned in lazy-lock.json next to this file.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
    }, true, {})
  end
end
vim.opt.rtp:prepend(lazypath)

-- Options
vim.opt.shell = 'bash'
vim.opt.textwidth = 0
vim.opt.clipboard = 'unnamedplus'
vim.opt.guicursor = ''
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.background = 'dark'
vim.g.python_highlight_all = 1

-- Mappings
vim.keymap.set('', 'q', '<Nop>')
vim.keymap.set('', 'Q', '<Nop>')
vim.keymap.set('', ',c', '<Cmd>lclose | pclose | cclose<CR>')

-- Plugins
local function executable(name)
  return vim.fn.executable(name) == 1
end

require('lazy').setup({
  spec = {
    { 'justinmk/vim-sneak' },
    { 'vim-scripts/indentpython.vim', ft = 'python' },
    { 'mattn/emmet-vim' },
    {
      'junegunn/goyo.vim',
      cmd = 'Goyo',
      keys = { { ';g', '<Cmd>Goyo<CR>' } },
      init = function()
        vim.g.goyo_width = '80%'
        vim.g.goyo_height = '80%'
      end,
    },
    {
      'shime/vim-livedown',
      ft = 'markdown',
      init = function()
        -- Livedown also needs `npm install -g livedown`. Without qutebrowser
        -- it opens the system default browser.
        if executable('qutebrowser') then
          vim.g.livedown_browser = 'qutebrowser'
        end
        vim.g.livedown_autorun = 0
        vim.g.livedown_open = 1
        vim.g.livedown_port = 4242
      end,
    },
    {
      -- VimTeX's documentation asks not to lazy-load it.
      'lervag/vimtex',
      lazy = false,
      init = function()
        -- Without latexmk VimTeX warns on every TeX buffer.
        vim.g.vimtex_compiler_enabled = executable('latexmk') and 1 or 0
        if executable('okular') then
          vim.g.vimtex_view_general_viewer = 'okular'
        end
      end,
    },
    {
      -- python-mode needs Neovim's Python provider (the pynvim package). It
      -- detects that itself on load and sets g:pymode_python to 'disable';
      -- `config` runs before its ftplugin, so switching it off there avoids
      -- an error on every Python buffer without a startup check.
      'python-mode/python-mode',
      ft = 'python',
      config = function()
        if vim.g.pymode_python == 'disable' then
          vim.g.pymode = 0
        end
      end,
      init = function()
        vim.g.pymode_rope = 1
        vim.g.pymode_rope_completion = 1
        vim.g.pymode_rope_lookup_project = 0
        vim.g.pymode_rope_completion_bind = '<C-Space>'
        vim.g.pymode_rope_complete_on_dot = 1
      end,
    },
  },
  -- Updates go through :Lazy update so lazy-lock.json changes deliberately.
  checker = { enabled = false },
  change_detection = { notify = false },
  -- No plugin here is a luarock; this avoids health warnings about luarocks.
  rocks = { enabled = false },
})

vim.cmd.colorscheme('default')
vim.cmd('hi StatusLine ctermbg=none cterm=bold gui=bold')

-- Autocommands
local group = vim.api.nvim_create_augroup('dotfiles', { clear = true })

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = group,
  pattern = '*.md',
  callback = function()
    -- Goyo is missing until lazy.nvim has installed it, e.g. offline.
    if vim.fn.exists(':Goyo') == 2 then
      vim.cmd('Goyo')
    end
    vim.cmd('hi StatusLineNC ctermfg=white')
    vim.opt_local.number = false
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = group,
  pattern = '*.py',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.textwidth = 79
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.fileformat = 'unix'
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = group,
  pattern = { '*.js', '*.html', '*.css' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- pdflatex, then biber for the bibliography, then pdflatex again so the
-- citations resolve. pdflatex writes into the working directory, so run all
-- three beside the file for biber to find its output.
vim.api.nvim_create_user_command('Compile', function()
  local dir = vim.fn.shellescape(vim.fn.expand('%:p:h'))
  local tex = vim.fn.shellescape(vim.fn.expand('%:t'))
  local base = vim.fn.shellescape(vim.fn.expand('%:t:r'))
  vim.cmd('!cd ' .. dir .. ' && pdflatex ' .. tex .. ' && biber ' .. base .. ' && pdflatex ' .. tex)
end, {})
