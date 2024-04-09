# neon-mac

Run Neon natively on Mac OS. No containers, no PulseAudio - just pure Python.

Very much a work in progress! This is intended a proof-of-concept, not as comprehensive instructions. For support, please open an issue on this repo.

Tested on an M1 Macbook Air and an M2 Macbook Pro.

## Prerequisites

- Homebrew
- Python 3.10 or 3.11
- Poetry
- fann2 (optional, Padatious intent engine only)

## Considerations

- Padatious does not install very easily on an Apple Silicon Mac. Padacioso will be the default, but note it is quite a bit slower than Padatious. To install Padatious anyway, [see the below section](#installing-padatious).

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
- Vosk does not install on an Apple Silicon Mac - TODO: This isn't true anymore, so come up with instructions
- pocketsphinx does not install on an Apple Silicon Mac - TODO: This isn't true but you need 5.0+, which isn't compatible with OVOS/Neon packages
- ovos-microphone-plugin-sounddevice sometimes creates very clipped recordings, so we instead use the PyAudio plugin for the listener
- ovos-microphone-plugin-pyaudio has microphone buffer overflow issues periodically, which can be alleviated by making the `chunk_size` property obnoxiously large (16000 seems to work consistently for me when I have problems, but it means the listening sound takes forever. Just state your request right after the wakeword and it's fine)

<!-- 2024-04-07 09:11:36.425 - skills - ovos_core.skill_manager:_load_plugin_skill:461 - ERROR - Load of skill skill-fallback_llm.neongeckocom failed!
Traceback (most recent call last):
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_workshop/skill_launcher.py", line 459, in _create_skill_instance
    return False
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_workshop/decorators/compat.py", line 40, in func_wrapper
    return func(*args, **kwargs)
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_workshop/skills/fallback.py", line 81, in __new__
    return super().__new__(cls)
TypeError: object.__new__() takes exactly one argument (the type to instantiate)

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_core/skill_manager.py", line 459, in _load_plugin_skill
    load_status = skill_loader.load(skill_plugin)
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_workshop/skill_launcher.py", line 519, in load
    def load(self, skill_class: Optional[callable] = None) -> bool:
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_workshop/skill_launcher.py", line 531, in _load
    def _load(self):
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_workshop/skill_launcher.py", line 464, in _create_skill_instance
    # if the signature supports skill_id and bus pass them
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/skill_fallback_llm/__init__.py", line 58, in __init__
    self.register_entity_file("llm.entity")
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_workshop/skills/ovos.py", line 1303, in register_entity_file
    self.intent_service.register_padatious_entity(name, filename, lang)
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_workshop/intents.py", line 449, in register_padatious_entity
    self.bus.emit(msg.forward('padatious:register_entity',
  File "/Users/Mike/Library/Caches/pypoetry/virtualenvs/neon-mac-sv8wqWXe-py3.10/lib/python3.10/site-packages/ovos_workshop/intents.py", line 259, in bus
    raise RuntimeError("bus not set. call `set_bus()` before trying to"
RuntimeError: bus not set. call `set_bus()` before trying tointeract with the Messagebus -->

<!-- py2app: Supports creating macOS .app bundles from a Python project. -->
<!-- Briefcase: Part of the BeeWare Project; a cross-platform packaging tool that supports creation of .app bundles on macOS, as well as managing signing and notarization. -->
