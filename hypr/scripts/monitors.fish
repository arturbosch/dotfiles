#!/usr/bin/env fish

set logFile ~/.local/state/dots_hypr_monitors.log
set laptopMonitor "eDP-1,preferred,auto,1"
set laptopDisable "eDP-1,disable"

function setMonitor --argument monitorConfig
    hyprctl keyword monitor "$monitorConfig"
end

function log --argument message
    echo $message >>$logFile
end

function handle --argument line
    switch $line
        case "monitoraddedv2*"
            log $line
            set args (string split "," -- (string split ">>" -- $line))
            set command $args[1]
            set id $args[2]
            if test $id = -1 # activate laptop monitor on fallback
                log "activate eDP-1"
                setMonitor $laptopMonitor
                return
            end

            if test $id = 0
                log "already eDP-1"
                return
            end

            set name $args[3]
            set desc $args[4]
            log activate $name
            switch $desc
                case "*DELL U2518*"
                    setMonitor "desc:Dell Inc. DELL U2518D 3C4YP89TA5PL,preferred,auto,1"
                case "*DELL U2725QE*"
                    setMonitor "desc:Dell Inc. DELL U2725QE 5VRC734,3840x2160@120,auto,1.5"
            end
            setMonitor $laptopDisable
    end
end

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -l line
    handle "$line"
end
