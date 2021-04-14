# Persistent-Swift

This repo is a Swift port of the original PersistentJXA projects by D00MFist (https://github.com/D00MFist/PersistentJXA). 

For my repos, the code that executes the persistence is Swift and I kept the payloads themselves as JXA payloads. 

------------------
## Steps

1. Ensure you have Xcode installed (which will also install Swift)
2. If you want to make any changes to the code, open the .xcodeproj file of the desired persistence project (ex: AtomPersist) in XCode and edit the code in main.swift
3. Once done with any edits or if you don't want to make any edits at all, you can **cd** into the project directory and then run ***swift build***
4. This will build the macho binary in the following directory structure of the project directory: **.build/debug**
5. You can then cd into that directory and run the macho binary (or copy the macho elsewhere and run it)
6. Alternatively, you can also build from XCode by clicking **Product** -> **Build**. This method will drop the macho at a directory structure similar to: **~/Library/Developer/Xcode/DerivedData/[ProjectName]-[random]/Build/Products/Debug/**.

Additional details are below:

---------------------------
## Details

|Project	|          Description                      |	Usage	|Artifacts Created|	Commandline Commands Executed|
|---------|-------------------------------------------|--------|-----------------|-----------------------------|
|AtomPersist | Persistence using the Atom init script. Appends the Atom init script to execute our command. Persistence executes upon Atom opening.| ./AtomPersist [path_to_jxa_payload] | Modification to end of: /System/Volumes/Data/Users/{User}/.atom/init.coffee | Atom will run "osascript [payload] &" upon open|
|ZshProfilePersistence |Modifies user's zsh profile to execute the specified jxa js payload. Persistence executes on zsh terminal open. | ./ZshProfilePersistence [path_to_jxa_payload] [yes/no] | $HOME/.zshenv If you select "yes" for hidden file creation then: $HOME/.security/apple.sh and $HOME/.security/update.sh | If "no"  for hidden file creation, then the on disk jxa js payload is run directly from .zshenv; If "yes" for hidden file creation then: $HOME/.security/apple.sh and sh $HOME/.security/update.sh are dropped and run; both options use "osascript [payload] &" during payload execution|
|CronJobPersistence | Persistence using CronJobs. This script will create a hidden file (share.sh) inside of .security in the user’s home directory. You can modify the default cron job time interval 15 mins by editing the main.swift code. | ./CronJobPersistence [path_to_jxa_payload] | $HOME/.security/.share.sh, crontab entry| sh -c echo "$(echo '*/15 * * * * cd $HOME/.security && ./.share.sh' ; crontab -l)" | osascript [payload' &, crontab -, sh -c |
|iTermPersistence | Persistence using the iTerm2 application startup script. Adds to the end of the application script for iTerm2 to execute our command. If the folder does not exist then one will be created. Persistence executes upon iTerm2 opening. See https://theevilbit.github.io/beyond/beyond_0002/ for more details. | ./iTermAppScriptPersistence [path_to_js_jxa_payload] | creates a new file at /Library/Application Support/iTerm2/Scripts/AutoLaunch/iTerm.sh | osascript [path_to_app] &|
|LoginItemPersistence | Persistence by adding an app as a Login Item | ./LoginItemPersistence [app path] [true/false] | Will generate a pop-up if XPC access has not yet been granted from Terminal to System Events, since this implementation leverages System Events via NSAppleScript | N/A, as this uses the NSAppleScript API|
