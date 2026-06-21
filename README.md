#### wsl2_ubuntu

* setup `WSL2`
```
-- Run cmd.exe
-- Run OptionalFeatures.exe
    - check 'Windows Subsystem for linux'
    - check 'Windows Hypervisor Platform'
```

* `wezterm`
```
-- Install windows version, https://wezterm.org/install/windows.html
-- rundll32.exe sysdm.cpl,EditEnvironmentVariables
    - Set path to C:\Program Files\wezterm
-- Adjust wezterm.lua to switch
    - Font styles
    - Background picture for terminal
-- copy file `wezterm.lua` from project to C:\Users\<USERNAME>\.config\wezterm\
```
