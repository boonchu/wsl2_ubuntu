#### wsl2_ubuntu
* setup `WSL2`
```
-- Run cmd.exe
-- Run OptionalFeatures.exe
    - check 'Windows Subsystem for linux'
    - check 'Windows Hypervisor Platform'
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
