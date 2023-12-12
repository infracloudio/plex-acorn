# Acorn for a Plex App 

Plex Media Server (usually just called Plex) is a digital media player and organizational tool that allows you to your entire digital library from any compatible computer, smartphone, or streaming device, without the need to transfer files manually. Using Acorn, you can host your own Plex Media Server and use a Wasabi S3 storage to store the media.

## Running Plex Acorn

The Plex Acorn is designed as a fully-functional application with the ability to organise your Media stored remotedly on Wasabi S3. The stored media on Wasabi S3 is synced as per the specified cron schedule, currently it is daily by default using Rclone. There are multiple benefits of switching to Wasabi S3 instead of the AWS S3, such as it costs 80% less than Amazon S3 and there are no egress fees.

You can create your own Wasabi S3 bucket by signing up on Wasabi and access it using their AWS credentials. 

## Arguments for Running Plex

plexserver_claim: Plex Claim to add the server ( https://www.plex.tv/claim/ ). Note : The claim expires after every 10mins
storage: Plex Media storage Size 
access_key: Wasabi S3 Access Key 
secret_key: Wasabi S3 Secret Key 
bucket_name: Wasabi S3 Bucket Name 
rclone_schedule: Rclone Job schedule to periodically sync the Wasabi S3 bucket with Plex Media Volume