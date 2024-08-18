# OVOS Mac Ansible Playbook

This Ansible playbook automates the setup of OpenVoiceOS (OVOS) on macOS, specifically for Apple Silicon Macs.

## Prerequisites

- macOS running on Apple Silicon (M1, M2, M3)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed on your Mac
- Sudo access (you'll be prompted for your password during installation)

## Quick Start

1. Clone this repository:

   ```sh
   git clone https://github.com/OscillateLabsLLC/ovos-mac-ansible.git
   cd ovos-mac-ansible
   ```

2. Run the playbook:

   ```sh
   ansible-playbook ovos_mac_setup.yml -K
   ```

   The `-K` flag will prompt for your sudo password.

3. After completion, restart your terminal or run:
   ```sh
   source ~/.zshrc
   ```

## What This Playbook Does

- Installs and configures necessary tools (Homebrew, Python, Poetry, etc.)
- Sets up OVOS and its dependencies
- Configures OVOS services to run on macOS
- Adds convenient command aliases for OVOS management

## Detailed Installation and Validation

To run the playbook step-by-step and validate each task:

1. Run with the `--step` flag:

   ```sh
   ansible-playbook ovos_mac_setup.yml --step
   ```

2. For detailed output, add `-v` (up to `-vvvv` for maximum verbosity):

   ```sh
   ansible-playbook ovos_mac_setup.yml --step -v
   ```

3. To start from a specific task:

   ```sh
   ansible-playbook ovos_mac_setup.yml --step --start-at-task="Task name"
   ```

4. To run specific tagged tasks:
   ```sh
   ansible-playbook ovos_mac_setup.yml --tags "tag_name"
   ```

## Post-Installation Verification

After running the playbook, verify the installation:

1. Check Homebrew: `brew --version`
2. Verify Python: `python3 --version`
3. Check Poetry: `poetry --version`
4. Verify OVOS:
   ```sh
   cd ~/ovos-mac
   poetry run ovos-messagebus --version
   ```
5. Check OVOS config: `cat ~/.config/mycroft/mycroft.conf`
6. Verify FANN: `ls /usr/local/lib/libdoublefann*`

## OVOS Service Management

The playbook sets up convenient commands for managing OVOS services:

- `ovos-start <service>`: Start a specific OVOS service
- `ovos-stop <service>`: Stop a specific OVOS service
- `ovos-restart <service>`: Restart a specific OVOS service
- `ovos-status`: Display the status of all OVOS services

Replace `<service>` with: messagebus, core, audio, speech, phal

## Troubleshooting

If you encounter issues:

1. Check Ansible output for error messages
2. Verify all prerequisites are met
3. Ensure you have necessary system permissions
4. For a failed task, use `--start-at-task` to resume from that point

For running assistant issues:

1. Check service status: `launchctl list | grep ovos`
2. View logs: `tail -f ~/.local/state/mycroft/logs/<service_name>.log`
3. Start a service manually: `~/ovos-mac/poetry run <service_command>`
4. Ensure proper microphone and speaker configuration
5. Try restarting your computer and OVOS services

## Installing Additional Skills

To add a skill:

1. Activate the Poetry environment:

   ```sh
   cd ~/ovos-mac
   poetry shell
   ```

2. Install the skill:

   ```sh
   poetry add <skill-name>
   ```

3. Restart the OVOS core service:
   ```sh
   ovos-restart core
   ```

Note: Manual skill updates will be overwritten when re-running this playbook.

## Support

For further assistance, please open an issue in this repository or consult the [OVOS documentation](https://openvoiceos.github.io/ovos-technical-manual/).
