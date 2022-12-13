echo "Loading mac_toolbox..."

# power user mode
alias mac_pu="open 'jamfselfservice://content?entity=policy&id=810&action=execute'"

# reset pki card reader
alias mac_rpki="open 'jamfselfservice://content?entity=policy&id=2135&action=execute'"

alias mac_osx_lidOpenUser='pmset -g log|grep -e "LidOpen/UserActivity"'
alias mac_osx_lidOpen='pmset -g log | grep LidOpen'
alias mac_osx_sleepWakeUp='pmset -g log|grep -e " Sleep  " -e " Wake  " -e " DarkWake  "'