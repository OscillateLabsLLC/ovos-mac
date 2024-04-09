#!/bin/zsh

# Function to kill background processes upon exit
cleanup() {
    echo "Killing background processes..."
    for pid in $neon_enclosure_pid $neon_speech_pid $neon_audio_pid $neon_core_pid $neon_gui_pid $neon_messagebus_pid; do
        if [[ -n $pid ]]; then
            kill $pid 2>/dev/null
        fi
    done
}

# Start processes in the background and save their PIDs
# neon-messagebus run &
# neon_messagebus_pid=$!
neon-enclosure run &
neon_enclosure_pid=$!
neon-speech run &
neon_speech_pid=$!
neon-audio run &
neon_audio_pid=$!
neon run-skills &
neon_core_pid=$!
neon-gui run &
neon_gui_pid=$!

# sudo neon-enclosure run &
# neon_enclosure_admin_pid=$!

# Trap exit, interrupt, and termination signals and call cleanup function
trap cleanup EXIT SIGINT SIGTERM

# Wait for all background processes to exit (optional, remove if you want the script to exit immediately)
wait
