# ovos-mac

Run OVOS natively on Mac OS. No containers, no PulseAudio - just pure Python.

Very much a work in progress! This is intended a proof-of-concept, not as comprehensive instructions. For support, please visit [Matrix chat](https://matrix.to/#/#OpenVoiceOS-Support:matrix.org) or open an issue on this repo.

Tested on an M1 Macbook Air and an M2 Macbook Pro.

## Prerequisites

- Homebrew
- Python 3.10-3.11
- UV
- fann2 (optional, Padatious intent engine only)

## Considerations

- Padatious does not install very easily on an M1-3 Mac. Padacioso will be the default, but note it is quite a bit slower than Padatious. To install Padatious anyway, [see the below section](#installing-padatious).

## Steps

Set up a few minimal requirements in `~/.config/mycroft/mycroft.conf`:

```json
{
  // For US users, uncomment the two lines below to get Fahrenheit and 12-hour time
  //   "system_unit": "imperial",
  //   "time_format": "half",
  "play_wav_cmdline": "afplay %1",
  "play_mp3_cmdline": "afplay %1",
  "enable_old_audioservice": true,
  "disable_ocp": false,
  "fake_barge_in": false,
  "stt": {
    "module": "ovos-stt-plugin-chromium",
    "fallback": { "module": "ovos-stt-plugin-server" }
  },
  "hotwords": {
    "hey_mycroft_vosk": { "active": false, "listen": false },
    "hey_mycroft_pocketsphinx": { "active": false, "listen": false }
  },
  "listener": {
    "silence_end": 0.5,
    "recording_timeout": 7,
    "fake_barge_in": false,
    "barge_in_volume": 60,
    "microphone": {
      "module": "ovos-microphone-plugin-pyaudio"
    },
    "VAD": {
      "module": "ovos-vad-plugin-silero",
      "ovos-vad-plugin-silero": {
        "threshold": 0.5
      }
    }
  },
  "padatious": {
    "regex_only": false
  }
}
```

Then clone this repo, cd into the directory, and run:

```zsh
# brew install uv # If you don't have it
uv venv
source .venv/bin/activate
uv sync
ovos-messagebus & # Keep the message bus running in the background, no need to shut it down and spin it up each time
./startup.sh
```

## Installing Padatious

First, build fann from source following the [instructions on their repo](https://github.com/libfann/fann). Then run:

```zsh
brew install portaudio swig
source .venv/bin/activate
LIBRARY_PATH=/usr/local/lib uv install --extra padatious
ln -s /usr/local/lib/libdoublefann.2.dylib .
```

`fann` is also available on Homebrew but I haven't tested using it. If you want to try it, run `brew install fann` instead of building it from source. Feel free to PR any changes you need to make to the above instructions.

## Viewing Logs

To view OVOS logs (excluding messagebus):

```sh
ologs
```

This will tail the log files located in `~/.local/state/mycroft/logs/`.

## Adding skills

OVOS skills are just Python packages, so you can simply run `uv add my-skill` to add a skill to your environment. You can also clone a skill repo and add it to your environment with `uv add /path/to/my-skill`. Finally, you can also add a skill from a git repo with `uv add git+https://my-skill/repo.git`.

Once the skill is installed, stop your `startup.sh` script and start it again. Sometimes the skill will load without even restarting!

## Known issues

- Padatious does not install easily on M1-3 Macs
- The OVOS-supported version of pocketsphinx does not install on an Apple Silicon Mac
- ovos-microphone-plugin-pyaudio has microphone buffer overflow issues periodically, which can be alleviated by disconnecting any extra microphones from your Mac (iPhone, webcam mic, external mic, etc.). Once ovos-dinkum-listener loads, you can reconnect the microphones and use them as normal.
