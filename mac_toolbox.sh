echo "Loading mac_toolbox..."

# power user mode
alias mac_pu="open 'jamfselfservice://content?entity=policy&id=810&action=execute'"

# reset pki card reader
alias mac_rpki="open 'jamfselfservice://content?entity=policy&id=2135&action=execute'"
alias mac_rpki_reset="sudo killall ctkd"

# reset airid card reader
alias mac_airid_reset="sudo killall ctkd; sudo pkill -9 com.apple.ifdreader"

# Source: https://apple.stackexchange.com/questions/52064/how-to-find-out-the-start-time-of-last-sleep
alias mac_osx_sleepWakeUp='pmset -g log|grep -e " Sleep  " -e " Wake  " -e " DarkWake  "'
# Source: https://osxdaily.com/2011/07/14/get-exact-boot-sleep-and-wake-times-from-the-command-line/
alias mac_osx_bootTime='sysctl -a |grep kern.boottime'
alias mac_osx_sleepTime='sysctl -a |grep sleeptime'
alias mac_osx_WakeTime='sysctl -a |grep waketime'