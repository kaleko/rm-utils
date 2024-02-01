The Remarkable tablet auto syncs to the Remarkable cloud, but this is NOT a source of long term backups.
For example, a file deleted from either the desktop app or from the tablet will instantly delete in the other place too.

Requirements for this backup routine are:
0) Remarkable is on and awake (not sleeping, not light sleeping)
1) ~/.ssh/id_rsa_remarkable[.pub] exists
2) ~/.ssh/config contains a `host remarkable` block, so "ssh root@remarkable" works
3) Your laptop is on and connected to the same wifi as your Remarkable
4) Local directory ~/Data/remarkable-backups exists

The backup procedure consists of two steps:
1) Rsync files from the Remarkable to the local ~/Data/remarkable-backups/ directory.
2) Tar this directory (with date/time tag), and copy to WorkDocs Drive, where it syncs automatically to secure cloud storage.

The two steps are combined into a shell script which can be executed with:

>> bash /Users/kaleko/github/rm-utils/remarkable-backup/run-remarkable-backup.sh

For convenience you can add the following to your shell startup script (e.g. ~/.bash_profile):

echo
echo "Reminder: periodically back up your remarkable notes with backup-remarkable !"
echo

backup-remarkable(){ 
    /bin/bash /YOUR/PATH/TO/remarkable-backup/run-remarkable-backup.sh 
}

Then simply

>> backup-remarkable

will perform the full backup.