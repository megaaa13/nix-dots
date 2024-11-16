FILE=$1
scp "$FILE" oracle:/home/ubuntu/services/website/files
wl-copy "https://megaaa.ovh/files/$(echo $FILE | rev | cut -d/ -f1 | rev)"
if [ $? -eq 0 ];then
    notify-send "Note sent & URL copied"
fi
exit
