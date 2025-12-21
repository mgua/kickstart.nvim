# neovim mgua 21.12.2025
lazyvim based setup

# from powershell
winget install neovim.neovim
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim
Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force

# you may see https://www.dmsussman.org/resources/neovimsetup/ 


# choco components
choco install far grep gzip wget curl unzip ripgrep make mingw less 

# windows components

winget install Microsoft.WindowsTerminal
winget install Python.Python.3.12 Python.Python.3.14 Python.Launcher 
winget install git.git JesseDuffield.lazygit 7zip.7zip OpenJS.NodeJS.LTS JanDeDobbeleer.OhMyPosh
winget install ImageMagick.Q16-HDRI Notepad++.Notepad++
winget install GnuWin32.Tar GnuWin32.FindUtils junegunn.fzf
edit env variables to add C:\Program Files\7-Zip to path (7z.exe)

# npm node neovim plugin
npm install -g neovim

# ast.grep aka sg
npm install --global @ast-grep/cli

# luarocks (lua package manager)
donwnload luarocks.exe from its windows package here
https://luarocks.github.io/luarocks/releases/
then put luarocks.exe in the path
i put it in C:\tools\neovim\nvim-win64\bin 
