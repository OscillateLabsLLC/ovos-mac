# ovos-mac

Run OVOS natively on Mac OS. No containers, no PulseAudio - just pure Python.

Very much a work in progress! This is intended a proof-of-concept, not as comprehensive instructions. For support, please visit [Matrix chat](https://matrix.to/#/#OpenVoiceOS-Support:matrix.org) or open an issue on this repo.

Tested on an M1 Macbook Air and an M2 Macbook Pro.

## Prerequisites

- Homebrew
- Python 3.10-3.11
- Poetry
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
  "listener": {
    "silence_end": 0.5,
    "recording_timeout": 7,
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
  },
  "Audio": {
    "default_backend": "vlc",
    "backends": {
      "OCP": {
        "classifier_threshold": 0.4,
        "min_score": 50,
        "filter_media": true,
        "filter_SEI": true,
        "search_fallback": true,
        "legacy_cps": false,
        "playback_mode": 40,
        "preferred_audio_services": ["vlc"],
        "legacy": false,
        "autoplay": true,
        "disable_mpris": true,
        "manage_external_players": true
      },
      "vlc": {
        "type": "ovos_vlc",
        "active": true
      }
    }
  }
}
```

Then clone this repo, cd into the directory, and run:

```zsh
# brew install poetry # If you don't have it
poetry install --without padatious # Or just poetry install if you want Padatious
poetry shell
ovos-messagebus & # Keep the message bus running in the background, no need to shut it down and spin it up each time
./startup.sh
```

## Installing Padatious

First, build fann from source following the [instructions on their repo](https://github.com/libfann/fann). Then run:

```zsh
brew install portaudio swig
poetry shell
LIBRARY_PATH=/usr/local/lib poetry install --with padatious
ln -s /usr/local/lib/libdoublefann.2.dylib .
```

`fann` is also available on Homebrew but I haven't tested using it. If you want to try it, run `brew install fann` instead of building it from source. Feel free to PR any changes you need to make to the above instructions.

## Adding skills

OVOS skills are just Python packages, so you can simply run `poetry add my-skill` to add a skill to your environment. You can also clone a skill repo and add it to your environment with `poetry add /path/to/my-skill`. Finally, you can also add a skill from a git repo with `poetry add git+https://my-skill/repo.git`.

Once the skill is installed, stop your `startup.sh` script and start it again. Sometimes the skill will load without even restarting!

## Known issues

- Padatious does not install easily on M1-3 Macs
- Sometimes afplay will clip on Macbook default speakers if using pyaudio. Use sounddevice instead to avoid this.
- The OVOS-supported version of pocketsphinx does not install on an Apple Silicon Mac
- ovos-microphone-plugin-pyaudio has microphone buffer overflow issues periodically, which can be alleviated by disconnecting any extra microphones from your Mac (iPhone, webcam mic, external mic, etc.). Once ovos-dinkum-listener loads, you can reconnect the microphones and use them as normal.
