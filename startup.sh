#!/bin/zsh

# Function to kill background processes upon exit
cleanup() {
    echo "Killing background processes..."
    for pid in $ovos_media_pid $ovos_audio_pid $ovos_core_pid $ovos_phal_pid $ovos_phal_admin_pid $ovos_dinkum_listener_pid; do
        if [[ -n $pid ]]; then
            kill $pid 2>/dev/null
        fi
    done
}

# Start processes in the background and save their PIDs
echo "Please be sure to start the ovos-messagebus before starting the other services"
./ovos_PHAL &
ovos_phal_pid=$!
ovos-dinkum-listener &
ovos_dinkum_listener_pid=$!
ovos-audio &
ovos_audio_pid=$!
ovos-core &
ovos_core_pid=$!
sudo ./ovos_PHAL_admin &
ovos_phal_admin_pid=$!
# ovos-media &
# ovos_media_pid=$!

# Trap exit, interrupt, and termination signals and call cleanup function
trap cleanup EXIT SIGINT SIGTERM

# Wait for all background processes to exit (optional, remove if you want the script to exit immediately)
wait
