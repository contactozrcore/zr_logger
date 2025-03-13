# FiveM Event and StateBag Logger

## Overview
This script provides logging and monitoring capabilities for events and StateBags in a FiveM server. It helps detect potential exploits or suspicious activity by tracking event payload sizes and monitoring StateBag changes. Additionally, it includes an artifact version checker to ensure the FXServer version is up-to-date and secure.

## Features
- Logs changes to StateBags with size limits.
- Detects and warns about oversized event payloads.
- Ignores specific predefined events to reduce unnecessary logging.
- Checks the current FXServer artifact version for known issues (Node 22 - Javascript).
- **New documentation on how to use the script in the /shared/config.lua**

## Installation
1. Download the script and place it inside your `resources` folder.
2. Add the following line to your `server.cfg` file to ensure the script starts properly:

   ```plaintext
   ensure zr_logger
   ```

3. Restart your server or use the `refresh` and `ensure zr_logger` command in the server console.

4. Now the use of ox_lib will be mandatory as a dependency, make sure to have it installed. [ox_lib](https://github.com/overextended/ox_lib)

## Configuration
Modify the `Config` table in the script to adjust logging behavior:
- `EnableLogger`: Enable or disable logging.
- `maxStateBagPayload`: Maximum allowed size for StateBag changes.
- `maxEventPayload`: Maximum allowed size for events.
- `maxLogStateBagPayload`: Maximum size before logging StateBag changes.
- `ignoreEvents`: List of event names to be ignored.

## How It Works
### StateBag Monitoring
- Tracks and logs StateBag changes.
- Detects and warns about excessively large keys, values, or bag names.
- Logs StateBag changes exceeding a defined threshold.

### Event Monitoring
- Logs client-to-server (`C->S`) and server-to-client (`S->C`) events.
- Detects and warns about events exceeding `maxEventPayload`.
- Differentiates between normal events and latent events (bandwidth-limited events).

### FXServer Version Check
- Retrieves the current FXServer artifact version.
- Checks against a known database of broken artifacts.
- Issues warnings if the artifact version is known to have issues.

## Logs & Alerts
- **Warnings**: Shown when a suspicious activity is detected.
- **Info Logs**: Logged for StateBag changes and event activity.
- **Artifact Version Logs**: Informs about FXServer version status.

## Example Logs
```plaintext
[WARNING] Suspicious StateBag Detected: player_data
[INFO] Logging StateBag | BagName: vehicle_data | Key: engine_status | Val: true
[WARNING] [C->S] Event Sniper: resource_x | Name: large_event | Src: player_12 | Size: 5000B
[INFO] [S->C] Latent Event Sniper: resource_y | Name: delayed_event | Src: player_8 | Size: 3000B | Bps: 50
[INFO] The FXServer version you are currently using is correct.
```

## License
This script is provided 'as is' without any warranty. You are free to modify and distribute it as needed.

## Credits
Developed by Zeeroo.

Credits for the API Key of Artifacts to: [Artifacts by JGScripts](https://artifacts.jgscripts.com/)

## Support
For any issues or feature requests, please open an issue on this repository.