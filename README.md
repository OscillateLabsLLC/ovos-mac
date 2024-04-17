# ovos-mac

Run OVOS natively on Mac OS. No containers, no PulseAudio - just pure Python.

Very much a work in progress! This is intended a proof-of-concept, not as comprehensive instructions. For support, please visit [Matrix chat](https://matrix.to/#/#OpenVoiceOS-Support:matrix.org) or open an issue on this repo.

Tested on an M1 Macbook Air and an M2 Macbook Pro.

## Prerequisites

- Homebrew
- Python 3.10 or 3.11
- Poetry
- fann2 (optional, Padatious intent engine only)

## Considerations

- Padatious does not install very easily on an M1-3 Mac. Padacioso will be the default, but note it is quite a bit slower than Padatious. To install Padatious anyway, [see the below section](#installing-padatious).

## Steps

Set up a few minimal requirements in `~/.config/mycroft/mycroft.conf`:

```json
{
  "play_wav_cmdline": "afplay %1",
  "play_mp3_cmdline": "afplay %1",
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
  }
}
```

Then clone this repo, cd into the directory, and run:

```zsh
# brew install poetry # If you don't have it
poetry install --without padatious # Or just poetry install if you want Padatious
poetry shell
ovos-messagebus & # Keep the message bus running in the background, no need to shut it down and spin it up each time
ovos-dinkum-listener & # There's a known issue with the pyaudio mic plugin on Mac, so we start this manually.
# If ovos-dinkum-listener fails, start it again until it succeeds.
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
- Sometimes afplay will clip on Macbook default speakers
- Vosk does not install on an Apple Silicon Mac
- pocketsphinx does not install on an Apple Silicon Mac
- ovos-microphone-plugin-sounddevice sometimes creates very clipped recordings, so we instead use the PyAudio plugin for the listener
- ovos-microphone-plugin-pyaudio has microphone buffer overflow issues periodically, which can be alleviated by making the `chunk_size` property obnoxiously large (16000 seems to work consistently for me when I have problems, but it means the listening sound takes forever. Just state your request right after the wakeword and it's fine)
- The buffer overflows are sometimes caused by an iPhone connecting as a microphone. Disconnecting the iPhone usually fixes the issue.
