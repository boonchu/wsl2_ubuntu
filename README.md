#### wsl2_ubuntu
* setup `WSL2`
```
-- Run cmd.exe
-- Run OptionalFeatures.exe
    - check 'Virtual Machine Platform'
    - check 'Windows Subsystem for linux'
    - check 'Windows Hypervisor Platform'
-- set the virtual disk to "sparse" mode
    - `wsl --manage <DistroName> --set-sparse true`
-- Edit c:\Users\<USERNAME>\.wslconfig
[wsl2]
memory=8GB
swap=0
MaxCrashDumpCount = 1
```
* `Zellij`
```
-- Install Zellij
    - `cargo install --locked zellij`
-- set PATH
    - `export PATH=/home/bigchoo/.cargo/bin:$PATH`
```
* `starship`
```
-- Install Starship
    - `curl -sS https://starship.rs/install.sh | sh`
-- Install to .bashrc
    - `eval "$(starship init bash)"`
-- copy file `configs/starship.toml` to ~/.config/
```
* `wezterm`
    * Gist https://gist.github.com/johnlindquist/346e18fd6875ae4207a9b69c62071e9a
    * Remap key https://github.com/boonchu/wsl2_ubuntu/blob/master/configs/wezterm.lua#L72-L94
```
-- Install windows version, https://wezterm.org/install/windows.html
-- rundll32.exe sysdm.cpl,EditEnvironmentVariables
    - Set path to C:\Program Files\wezterm
-- Adjust wezterm.lua to switch
    - Font styles
    - Background picture for terminal
-- copy file `configs/wezterm.lua` from project to C:\Users\<USERNAME>\.config\wezterm\
```

* `Free disk space`
  
-- Run PowerShell to find file larger than 2GB in CURRENT USER FOLDER\AppData\Local
```
Get-ChildItem "$env:USERPROFILE\AppData\Local" -Recurse -File -Force -ErrorAction SilentlyContinue |
Where-Object { $_.Length -gt 2GB } |
 ForEach-Object {
     [PSCustomObject]@{
         FileName   = $_.Name
         Path       = $_.FullName
         SizeGB     = [math]::Round($_.Length / 1GB, 2)
         LastAccess = $_.LastAccessTime
     }
 } |
 Sort-Object SizeGB -Descending
```
-- example output
```
FileName                                                       Path                                                                                                         Size
ext4.vhdx                                                      C:\Users\XXXXX\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx        15
wsl-crash-1785013471-19152-_usr_lib_code-server_lib_node-6.dmp C:\Users\XXXXX\AppData\Local\Temp\wsl-crashes\wsl-crash-1785013471-19152-_usr_lib_code-server_lib_node-6.dmp 46
wsl-crash-1785017797-35372-_usr_lib_code-server_lib_node-6.dmp C:\Users\XXXXX\AppData\Local\Temp\wsl-crashes\wsl-crash-1785017797-35372-_usr_lib_code-server_lib_node-6.dmp 39
wsl-crash-1785089664-649-_usr_lib_code-server_lib_node-6.dmp   C:\Users\XXXXX\AppData\Local\Temp\wsl-crashes\wsl-crash-1785089664-649-_usr_lib_code-server_lib_node-6.dmp   34
wsl-crash-1785086604-3194-_usr_lib_code-server_lib_node-6.dmp  C:\Users\XXXXX\AppData\Local\Temp\wsl-crashes\wsl-crash-1785086604-3194-_usr_lib_code-server_lib_node-6.dmp  33
wsl-crash-1785085516-75-_usr_lib_code-server_lib_node-6.dmp    C:\Users\XXXXX\AppData\Local\Temp\wsl-crashes\wsl-crash-1785085516-75-_usr_lib_code-server_lib_node-6.dmp    33
wsl-crash-1785014429-30748-_usr_lib_code-server_lib_node-6.dmp C:\Users\XXXXX\AppData\Local\Temp\wsl-crashes\wsl-crash-1785014429-30748-_usr_lib_code-server_lib_node-6.dmp 32
wsl-crash-1785088110-86-_usr_lib_code-server_lib_node-6.dmp    C:\Users\XXXXX\AppData\Local\Temp\wsl-crashes\wsl-crash-1785088110-86-_usr_lib_code-server_lib_node-6.dmp    32
swap.vhdx                                                      C:\Users\XXXXX\AppData\Local\Temp\C08CA811-4A81-48A0-BCBB-EAE1B38D8E1B\swap.vhdx     
```

-- Clean up files in `wsl-crash`

-- Start WSL Linux distribution

-- Cleanup docker images and unused Linux packages
```
# Docker cleanup (if used)
docker container prune -f
docker image prune -a -f
docker volume prune -f
docker system prune -a --volumes -f

# System cleanup
sudo apt-get clean
sudo apt-get autoremove -y
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/

# nix cleanup
nix-collect-garbage -d

# brew cleanup
brew cleanup --prune=all
```
-- Run `wsl --shutdown`

-- Use `diskpart` to shrink size of Ubuntu vdisk in WSL2. Take output from PowerShell scanning script.
  - Run Windows Powershell
  - Run `diskpart`
  - Run `select vdisk file="C:\Users\XXXXX\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx"`
  - Run `compact vdisk`

-- Run `wsl --update`

-- Ref: https://netdevops.it/blog/fixing-wsl-crash---complete-recovery-guide-for-e_unexpected-errors/#step-2-create-data-backups
