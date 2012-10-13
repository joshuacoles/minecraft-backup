#!/bin/bash
# Set these values to match your server's settings.

# This script should be located in the craftbukkit folder

# Make sure you change this to the name of your world folder! 
# Add additional worlds by separating them with a space. 

# We want to have directories which have a level.dat file in
# This gets all the world
# find -maxdepth 2 -name level.dat -print | gawk -F/ '{print $2 }' | uniq | tr \\n " "
#declare -a worlds=(Farm Farm_nether Farm_the_end)
declare -a worlds=(`find -maxdepth 2 -name level.dat -print | gawk -F/ '{print $2 }' | uniq | tr \\n " "`)

backupdir=/backups/from-minecraft-script/
ext=.zip

hdateformat=$(date '+%Y-%m-%d-%H-%M-%S')H$ext
ddateformat=$(date '+%Y-%m-%d')D$ext

echo "Starting multiworld backup..."
 
if [ -d $backupdir ] ; then
    sleep 0
else
    mkdir -p $backupdir
fi

zip -q $backupdir$hdateformat -r plugins

for i in `find -maxdepth 2 -name level.dat -print | gawk -F/ '{print $2 }'`; do
    echo "Saving '$i' to '$backupdir$hdateformat'."
    zip -q $backupdir$hdateformat -r $i
done

# Copy the most recent hourly to be the last daily
cp $backupdir$hdateformat $backupdir$ddateformat
echo "Updated daily backup."

# Remove any old Hourly ones
find $backupdir/ -name *H$ext -mmin +1440 -exec rm {} \;

# Remove any old Daily ones
find $backupdir/ -name *D$ext -mtime +14 -exec rm {} \;
echo "Removed old backups." 
 
echo "Backup complete."

exit 0
