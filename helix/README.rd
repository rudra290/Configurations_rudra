# Helix Configuration

This directory contains my personal configuration files for the Helix editor. The goal of this setup is to provide a clean, fast, and customized editing environment.

## Directory Structure

- `config.toml` — Main Helix configuration file.
- `languages.toml` — Language-specific settings (if present).
- `theme.toml` or custom theme files — Optional custom themes.
- Additional configuration files as needed.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/rudra290/Configurations_rudra.git
   ```
2. Navigate to the Helix configuration folder:
   ```bash
   cd Configurations_rudra/helix
   ```
3. Copy the configuration into your local Helix config directory:
   ```bash
   mkdir -p ~/.config/helix
   cp -r * ~/.config/helix/
   ```

## What This Configuration Includes

- Custom keybindings.
- UI settings such as theme, cursor style, and statusline tweaks.
- Editor behavior adjustments (indentation, line numbers, rulers, etc.).
- Language server configurations if defined.
- Optional plugin-like behaviors via Helix features.

## Usage

After copying the files, launch Helix:
```bash
hx
```
Helix will automatically load your configuration.

## Notes

- If Helix updates introduce new configuration structures, you may need to adjust your files.



