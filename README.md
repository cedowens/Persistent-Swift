# Persistent-Swift

This repo is a Swift port of the original PersistentJXA projects by D00MFist (https://github.com/D00MFist/PersistentJXA). 

For my repos, the code that executes the persistence is Swift and I kept the payloads themselves as JXA payloads. Additional details are below:

---------------------------
## Details

|Project	|          Description                      |	Usage	|Artifacts Created|	Commandline Commands Executed|
|---------|-------------------------------------------|--------|-----------------|-----------------------------|
|AtomPersist | Persistence using the Atom init script. Appends the Atom init script to execute our command. Persistence executes upon Atom opening.| ./AtomPersist [path_to_jxa_payload] | Modification to end of: /System/Volumes/Data/Users/{User}/.atom/init.coffee | N/A|
|Bash_Profile_Persistence |Modifies user's zsh profile to execute script if the persistence process (current implementation assumes osascript) is not already running. Persistence executes on terminal open. | ./Bash_Profile_Persistence [path_to_jxa_payload] [yes/no] | $HOME/.bash_profile or $HOME/.zshenv If select "yes" for hidden file creation then: $HOME/.security/apple.sh and $HOME/.security/update.sh | N/A by default. "no" for hidden file creation; option If select "yes" for hidden file creation then: sh $HOME/.security/apple.sh and sh $HOME/.security/update.sh|
|CronJobPersistence | Persistence using CronJobs. This script will create a hidden file (share.sh) inside of .security in the user’s home directory. You can modify the default value of 15 mins by editing the main.swift code. (Note: This command generates a user prompt for Catalina. | ./CronJobPersistence [path_to_jxa_payload] | $HOME/.security/.share.sh, crontab entry| sh -c echo "$(echo '15 * * * * cd $HOME/.security && ./.share.sh' ; crontab -l)" | crontab -, sh -c (Persistence Action)|
