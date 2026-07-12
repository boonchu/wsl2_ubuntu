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
```
-- Install windows version, https://wezterm.org/install/windows.html
-- rundll32.exe sysdm.cpl,EditEnvironmentVariables
    - Set path to C:\Program Files\wezterm
-- Adjust wezterm.lua to switch
    - Font styles
    - Background picture for terminal
-- copy file `configs/wezterm.lua` from project to C:\Users\<USERNAME>\.config\wezterm\
```
* `troubleshooting`
-- Use `diskpart` to shrink size of Ubuntu vdisk in WSL2
  - Run Windows Powershell
  - Run `diskpart`
  - Run `select vdisk file="C:\Path\To\Your\ext4.vhdx"`
  - Run `compact vdisk`
-- Run `wsl --update`

