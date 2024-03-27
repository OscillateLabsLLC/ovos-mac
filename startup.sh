#!/bin/zsh

# Function to kill background processes upon exit
cleanup() {
    echo "Killing background processes..."
    # kill -9 $ovos_dinkum_listener_pid
    # for pid in $ovos_audio_pid $ovos_core_pid $ovos_phal_pid $ovos_phal_admin_pid $ovos_messagebus_pid; do
    for pid in $ovos_audio_pid $ovos_core_pid $ovos_phal_pid $ovos_phal_admin_pid; do
        kill $pid
    done
}

# Start processes in the background and save their PIDs
echo "Please be sure to start the ovos-messagebus before starting the other services"
# ovos-messagebus &
# ovos_messagebus_pid=$!
./ovos_PHAL &
ovos_phal_pid=$!
./ovos_PHAL_admin &
ovos_phal_admin_pid=$!
# ovos-dinkum-listener &
# ovos_dinkum_listener_pid=$!
ovos-audio &
ovos_audio_pid=$!
ovos-core &
ovos_core_pid=$!

# Trap shell exit signal and call cleanup function
trap cleanup EXIT

# Wait for all background processes to exit (optional, remove if you want the script to exit immediately)
wait
