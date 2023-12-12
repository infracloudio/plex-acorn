env >> /etc/environment
val=$AWS_S3_BUCKET

echo "bucket name is new $val"

mkdir -p /config/rclone

cat <<EOF >> /config/rclone/rclone.conf

[wasabi]
type = s3
provider = Wasabi
access_key_id = $AWS_ACCESS_KEY_ID
secret_access_key = $AWS_SECRET_ACCESS_KEY
region = us-east-1
endpoint = s3.wasabisys.com

EOF

rclone sync wasabi:$AWS_S3_BUCKET /plexmedia 

ls -la /plexmedia
rm -rf /plexmedia/lost+found
echo "crobjob applied"
