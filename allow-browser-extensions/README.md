# Helper scripts to enable browser extensions

## Mac and Edge

TL;DR:
- copy the `allow.edge.ext.plist` file to `/Library/LaunchDaemons/` (replace `<USER>` with the actual user name)
- set the correct permissions with `sudo chown root:wheel /Library/LaunchDaemons/allow.edge.ext.plist` and `sudo chmod 400 /Library/LaunchDaemons/allow.edge.ext.plist`
- load the agent with `sudo launchctl load /Library/LaunchDaemons/allow.edge.ext.plist`

### Introduction

The configuration for Microsoft Edge on Mac is located in `/Library/Managed Preferences/<USER>/com.microsoft.Edge.plist`. This "Propert List" file is a binary file, so you can't just edit it with a text editor. You can convert it to XML format with the `plutil` command, modify it with a text editor, and then convert it back to binary format.

The way how all browser extensions are blocked is by setting the `ExtensionInstallBlocklist` key to an item containing a wildcard `*` in the `com.microsoft.Edge.plist` file. To allow all extensions, it  is necessary to remove this key from the file.

Converting the file, modifying it and converting it back is a bit cumbersome. Instead, we can leverage the tool `PlistBuddy` to modify the file directly without the need for convertion. To get the current values, we can issue the following command (**Attention: `PlistBuddy` is not in the PATH, so you need to use the full path to the binary.**)

```bash
# -c means command and "Print" is the command to print the content of the file
# see man PlistBuddy for more information
/usr/libexec/PlistBuddy -c "Print" /Library/Managed\ Preferences/<USER>/com.microsoft.Edge.plist
```

Since we are interested in the `ExtensionInstallBlocklist` key, we can issue the following command to get the value of the key:

```bash
/usr/libexec/PlistBuddy -c "Print :ExtensionInstallBlocklist" /Library/Managed\ Preferences/<USER>/com.microsoft.Edge.plist
```

which will return something like:

```
Array {
  *
}
```

To remove the key, we can issue the following command, which translates to "Set the first item of the `ExtensionInstallBlocklist` key to an empty string":

```bash
/usr/libexec/PlistBuddy -c "Set :ExtensionInstallBlocklist:0 ''" /Library/Managed\ Preferences/<USER>/com.microsoft.Edge.plist
```

For convenience, we can define an alias in the shell configuration file (e.g. `~/.bashrc` or `~/.zshrc`):

```bash
# requires root privileges
alias edge-allow-extensions="/usr/libexec/PlistBuddy -c 'Set :ExtensionInstallBlocklist:0 \"\"' /Library/Managed\ Preferences/<USER>/com.microsoft.Edge.plist"
```

### Automating the process

Mac uses the launchd daemon to run tasks at specific times or when certain conditions are met. We can use a launchd agent to run the command to allow browser extensions. The "system" daemons (that are executed as root) are stored in `/Library/LaunchDaemons` and defined in XML files. We can create a new file, e.g. `allow.edge.ext.plist` (just an example) with the following content (or use the [provided file](allow.edge.ext.plist) in this repository):

```xml
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>allow.edge.ext</string>

	<key>KeepAlive</key>
	<false/>

	<key>RunAtLoad</key>
	<true/>

	<key>ProgramArguments</key>
	<array>
		<string>/usr/libexec/PlistBuddy</string>
		<string>-c</string>
		<string>Set :ExtensionInstallBlocklist:0 ''</string>
		<string>/Library/Managed Preferences/<USER>/com.microsoft.Edge.plist</string>
	</array>

	<key>StandardErrorPath</key>
	<string>/dev/null</string>
	<key>StandardOutPath</key>
	<string>/dev/null</string>

	<key>StartInterval</key>
	<integer>30</integer>
</dict>
</plist>
```

This file will run the command every 30 seconds. This is necessary, because the configuration of Microsoft Edge is overwritten some time **after** the reboot through some scripts and we don't have a real trigger / event to react on that change. (If you know a better way, please let me know!)
Property List files for LaunchDaemons must be owned by root and have permissions set to 600 or 400 according to Apple's [documentation](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html). We can issue the following commands to set the correct permissions:

```bash
sudo chown root:wheel /Library/LaunchDaemons/allow.edge.ext.plist
sudo chmod 400 /Library/LaunchDaemons/allow.edge.ext.plist
```

To load the daemon, we can issue the following command:

```bash
sudo launchctl load /Library/LaunchDaemons/allow.edge.ext.plist
```

Next time the Mac is restarted, the agent will be loaded automatically.
To unload the agent, we can issue the following command:

```bash
sudo launchctl unload /Library/LaunchDaemons/allow.edge.ext.plist
```