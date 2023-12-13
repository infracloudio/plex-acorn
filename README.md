# Acorn for a Plex App 

[Plex Media Server](https://www.plex.tv/media-server-downloads/) (usually just called Plex) is a digital media player and organizational tool that allows you to your entire digital library from any compatible computer, smartphone, or streaming device, without the need to transfer files manually. Using Acorn, you can host your own Plex Media Server and use a Wasabi S3 storage to store the media.

## Wasabi
[Wasabi](https://wasabi.com/hot-cloud-storage/) is one of the most affordable online storage options available. You can store all of your media on it with as little as $6.99 TB/Month, with no egress charges.

## Running Plex Acorn

The Plex Acorn is designed as a fully-functional application with the ability to organise your Media stored remotedly on Wasabi S3. The stored media on Wasabi S3 is synced as per the specified cron schedule, currently it is daily by default using Rclone. There are multiple benefits of switching to Wasabi S3 instead of the AWS S3, such as it costs 80% less than Amazon S3 and there are no egress fees.

You can create your own Wasabi S3 bucket by signing up on Wasabi and access it using their AWS credentials. 

## Arguments for Running Plex

| Argument | required? | Description | Default Value |
|---|---|---|---|
| plexserver_claim | Y | Plex Claim to add the server ( https://www.plex.tv/claim/ ). Note : The claim expires after every 10mins | NA |
| storage | N | Plex Media storage Size | 2G |
| region | Y | Wasabi S3 bucket region | us-east-1 |
| endpoint_url | Y | Wasabi S3 bucket url | s3.wasabisys.com |
| access_key | Y | Wasabi S3 Access Key | NA |
| secret_key | Y | Wasabi S3 Secret Key | NA |
| bucket_name | Y | Wasabi S3 Bucket Name  | NA |
| rclone_schedule | N | Rclone Job schedule to periodically sync the Wasabi S3 bucket with Plex Media Volume | `0 */6 * * *` i.e. Every 6 hours |