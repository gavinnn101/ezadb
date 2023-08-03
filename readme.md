# How to use

* Add `ezadb.bat` to an easy to find folder.
* Add that folder to your environment variables.
* * [Tutorial on how to do this](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Adding-folder-path-to-Windows-PATH-environment-variable.html)
* Open up terminal / powershell / command prompt
* * Run `ezadb` which should print the availble commands, etc.

# Commands

| Command                    | Flag             | Description                                                                                                        |
|----------------------------|------------------|--------------------------------------------------------------------------------------------------------------------|
| `ezadb connect`            | `[PORT]`         | Connects to the device at 127.0.0.1:$port and forwards tcp:61666 for local scripts.                                |
|                            |                  | **[PORT]**: The port number to connect to.                                                                         |
| `ezadb logs`               | `[PORT]`         | Prints logs for the device at $port.                                                                               |
|                            | `[OUTPUT_PATH]`  | (Optional) Path to save log files. Defaults to ~/Desktop/ezadb.log if omitted.                                      |
| `ezadb list`               | ` `              | Lists connected devices. (`adb devices` wrapper)                                                                   |


# Troubleshooting

* Did you get `ezadb is not recognized as an internal or external command`?
* * Something is wrong with how you setup your path to `ezadb` in your environment variables.