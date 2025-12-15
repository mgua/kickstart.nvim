# Nvim setup with vscode colors

We are using the basedpyright plugin for python plus color settings for semantic tokens inside init.lua file. 
As visible on the bottom of these settings we can see that also html is added.

```lua

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
      
      -- VS Code-like colors (applied after colorscheme loads)
      vim.api.nvim_set_hl(0, '@type', { fg = '#4EC9B0' })
      vim.api.nvim_set_hl(0, '@type.builtin', { fg = '#4EC9B0' })
      vim.api.nvim_set_hl(0, '@constructor', { fg = '#4EC9B0' })
      vim.api.nvim_set_hl(0, '@module', { fg = '#4EC9B0' })
      vim.api.nvim_set_hl(0, '@function', { fg = '#DCDCAA' })
      vim.api.nvim_set_hl(0, '@function.call', { fg = '#DCDCAA' })
      vim.api.nvim_set_hl(0, '@function.builtin', { fg = '#DCDCAA' })
      vim.api.nvim_set_hl(0, '@method', { fg = '#DCDCAA' })
      vim.api.nvim_set_hl(0, '@method.call', { fg = '#DCDCAA' })
      vim.api.nvim_set_hl(0, '@variable', { fg = '#9CDCFE' })
      vim.api.nvim_set_hl(0, '@variable.parameter', { fg = '#9CDCFE' })
      vim.api.nvim_set_hl(0, '@parameter', { fg = '#9CDCFE' })
      vim.api.nvim_set_hl(0, '@keyword', { fg = '#569CD6' })
      vim.api.nvim_set_hl(0, '@keyword.function', { fg = '#569CD6' })
      vim.api.nvim_set_hl(0, '@keyword.return', { fg = '#C586C0' })
      vim.api.nvim_set_hl(0, '@keyword.import', { fg = '#C586C0' })
      vim.api.nvim_set_hl(0, '@include', { fg = '#C586C0' })
      vim.api.nvim_set_hl(0, '@string', { fg = '#CE9178' })
      vim.api.nvim_set_hl(0, '@number', { fg = '#B5CEA8' })
      vim.api.nvim_set_hl(0, '@comment', { fg = '#6A9955', italic = true })
      -- LSP semantic tokens (from Pyright)
      vim.api.nvim_set_hl(0, '@lsp.type.namespace', { fg = '#4EC9B0' })
      vim.api.nvim_set_hl(0, '@lsp.type.function', { fg = '#DCDCAA' })
      vim.api.nvim_set_hl(0, '@lsp.type.method', { fg = '#DCDCAA' })
      vim.api.nvim_set_hl(0, '@lsp.type.class', { fg = '#4EC9B0' })
      vim.api.nvim_set_hl(0, '@lsp.type.variable', { fg = '#9CDCFE' })
      vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg = '#9CDCFE' })
      -- HTML/Jinja template colors (VS Code style)
      vim.api.nvim_set_hl(0, '@tag', { fg = '#569CD6' })           -- HTML tags
      vim.api.nvim_set_hl(0, '@tag.builtin', { fg = '#569CD6' })
      vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#808080' }) -- < > /
      vim.api.nvim_set_hl(0, '@tag.attribute', { fg = '#9CDCFE' }) -- attributes like class=
      vim.api.nvim_set_hl(0, '@attribute', { fg = '#9CDCFE' })
      vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = '#D4D4D4' })
      vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg = '#D4D4D4' })
      vim.api.nvim_set_hl(0, '@punctuation.special', { fg = '#D4D4D4' })
      vim.api.nvim_set_hl(0, '@operator', { fg = '#D4D4D4' })
      vim.api.nvim_set_hl(0, '@constant', { fg = '#4FC1FF' })
      vim.api.nvim_set_hl(0, '@markup.heading', { fg = '#569CD6', bold = true })
      vim.api.nvim_set_hl(0, '@markup.link', { fg = '#CE9178' })
          
    end,
  },
```

To make these semantic tokens work with python, we need to install basedpyright plugin into nvim which is installed with python.
In the init.lua file, we need to add the local servers settings for python.
```lua
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  basedpyright = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}
```

and also set_venv to recognize environment



```lua

-- Auto-detect venv based on project structure
-- Looks for venv_<projectname> one level up from project root
-- If not found, prompts user to select from available venvs
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.py",
  callback = function()
    -- Skip if venv already set for this session
    if vim.g.venv_selected then return end
    
    local root = vim.fs.root(0, { ".git", "pyrightconfig.json", "pyproject.toml", "setup.py" })
    if not root then return end
    
    local project_name = vim.fn.fnamemodify(root, ":t")
    local parent_dir = vim.fn.fnamemodify(root, ":h")
    local venv_path = parent_dir .. "/venv_" .. project_name
    local venv_python = venv_path .. "/Scripts/python.exe"
    
local function set_venv(path)
      local python_exe = path .. "/Scripts/python.exe"
      if vim.fn.filereadable(python_exe) == 0 then
        vim.notify("Python not found in: " .. path, vim.log.levels.ERROR)
        return
      end
      
      vim.env.VIRTUAL_ENV = path
      vim.env.PATH = path .. "/Scripts;" .. vim.env.PATH
      vim.g.venv_selected = path
      
      -- Restart basedpyright with new python path
      local clients = vim.lsp.get_clients({ name = "basedpyright" })
      for _, client in ipairs(clients) do
        client.config.settings.python = { pythonPath = python_exe }
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end
      
      -- Force LSP restart to pick up new venv
      vim.defer_fn(function()
        vim.cmd("LspRestart basedpyright")
      end, 100)
      
      vim.notify("Activated venv: " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
    end
    
    -- Find all venv_* folders in parent directory
    local venvs = {}
    local handle = vim.loop.fs_scandir(parent_dir)
    if handle then
      while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end
        if type == "directory" and name:match("^venv_") then
          table.insert(venvs, parent_dir .. "/" .. name)
        end
      end
    end
    
    if #venvs == 0 then
      vim.notify("No venv_* folders found in: " .. parent_dir, vim.log.levels.WARN)
      return
    end
    
    -- Prompt user to select a venv
    vim.ui.select(venvs, {
      prompt = "Select venv for " .. project_name .. ":",
      format_item = function(item)
        return vim.fn.fnamemodify(item, ":t")
      end,
    }, function(choice)
      if choice then
        set_venv(choice)
      end
    end)
  end,
})


```
For the html we need to install those two plugins

```lua
:TSInstall html htmldjango

```

In 998_init.lua we need to comment the part that removes the background color:


```lua

	-- {
	-- -- Remove all background colors to make nvim transparent (e.g for terminal backgroud image).
	-- 	"xiyaowong/transparent.nvim"
	-- },
```