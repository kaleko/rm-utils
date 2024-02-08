# Directory on the Remarkable file system to back up -- don't change this
SOURCE_REMARKABLE_SYNC_DIR=/home/root/.local/share/remarkable/xochitl

# Where on your local machine you would like to sync the files to
# The first time the script is run, this will take a while (all files are copied)
# but subsequent times in the future, only changed files are copied over
# Note: deleting a file on the remarkable (and emptying trash) then running this
# script will delete it in your computer as well. However, if the file was previously
# synced, it will already have been stored in a zipped archive file.
DEST_REMARKABLE_SYNC_DIR=/Users/kaleko/Data/remarkable-backups/xochitl

# Where on your local machine you would like to save a tagged/zipped archive copy of the files
WORKDOCS_DRIVE_DIR=/System/Volumes/Data/Users/kaleko/Library/CloudStorage/WorkDocsDrive-Documents/kaleko-remarkable-backups

# Name of your tagged/zipped archive file
TAR_FILENAME=kaleko-remarkable-backup-$(date +%Y%m%d-%H%M%S).tar.bz2

# Check to make sure the remarkable is awake and ssh is working properly
# ("ssh root@remarkable" should work -- e.g. id_rsa and .ssh/config are set up)
echo "Testing the ssh connectivity ... "
if ! ssh -l "root" -o BatchMode=yes -o ConnectTimeout="5" "remarkable" true &>/dev/null
then
    echo "Cannot connect to the remarkable."
    echo "Make sure the remarkable is on, awake, connected to the same wifi as you (no VPN)."
else
    echo
    echo "  -- RUNNING RSYNC --"
    rsync -azH --stats --delete root@remarkable:${SOURCE_REMARKABLE_SYNC_DIR}/ ${DEST_REMARKABLE_SYNC_DIR}/
    echo
    echo "  -- TARRING AND TAGGING BACKUP --"
    tar -cjf ${WORKDOCS_DRIVE_DIR}/${TAR_FILENAME} --directory=${DEST_REMARKABLE_SYNC_DIR} .
    echo
    echo "  -- BACKUP COMPLETE --"
    FILESIZE=`du -hs "${WORKDOCS_DRIVE_DIR}/${TAR_FILENAME}" | cut -f1`
    echo
    echo " Tar file ${TAR_FILENAME} created, size =${FILESIZE}"
    N_BACKUPS=`ls $WORKDOCS_DRIVE_DIR | grep kaleko-remarkable-backup | wc -l`
    echo " Note there are ${N_BACKUPS} backups already existing. Consider clearing old ones from dir:"
    echo $WORKDOCS_DRIVE_DIR
    echo
fi
