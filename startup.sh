#!/bin/zsh

# Function to kill background processes upon exit
cleanup() {
    echo "Killing background processes..."
    for pid in $ovos_messagebus_pid $ovos_dinkum_listener_pid $ovos_audio_pid $ovos_core_pid; do
        kill $pid
    done
}

# Start processes in the background and save their PIDs
ovos-messagebus &
ovos_messagebus_pid=$!
ovos-dinkum-listener &
ovos_dinkum_listener_pid=$!
ovos-audio &
ovos_audio_pid=$!
ovos-core &
ovos_core_pid=$!

# Trap shell exit signal and call cleanup function
trap cleanup EXIT

# Wait for all background processes to exit (optional, remove if you want the script to exit immediately)
wait
