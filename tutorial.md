# Deploying Plex on Acorn

Upgrade your entertainment with Plex! Easily organize, stream, and enjoy your media collection from anywhere, at any time. Plex offers a sleek interface, works on different devices, and allows remote access, changing the way you enjoy movies, TV shows, music, and photos. Thinking about creating your own Plex Media Library? It's a great idea! With features like server-side transcoding and offline access, you can host your own Media Library using Plex for the best streaming and management experience. Just keep in mind that setting up the server and network might be a bit tricky if you're not familiar with it.

With modern cloud-native services and technologies, the challenges of setting up your infrastructure shouldn't hold you back. Meet [Acorn](http://www.acorn.io) - Unleash the power of effortless deployment, scalability, and top-notch security. Acorn simplifies the intricate process of building, running, and scaling your applications by offering a comprehensive way to describe your application and dependencies in a single file known as an [Acornfile](https://docs.acorn.io/reference/acornfile). What's more, you can explore the [Acorn Platform](https://acorn.io/auth), which provides free cloud-based computing environments for anyone with a GitHub account to run, test, and develop Acorns.

Let's get started with the tutorial to deploy Plex.

Plex is a digital media player and organizational tool that allows you to your entire digital library. We will be deploying Plex in conjuction with [Wasabi](https://wasabi.com/hot-cloud-storage/),one of the most affordable online storage options available. You can store all of your media on it with as little as $6.99 TB/Month, with no egress charges. 

To start using the application, you need to create your own Wasabi S3 bucket by registering to Wasabi. Once signed in, populate the Wasabi S3 bucket with your favourite Photos, Movies or Videos and generate Access Credentials. We will be using these credentials to connect to Plex to download the Media using [Rclone](https://rclone.org/). We have two Rclone Jobs : rclone-init: to perform one-time initial sync of Plex with Wasabi S3 and rclone-cronjob: runs as a scheduled cronjob for periodic Data Sync from the Wasabi S3 bucket and Plex Media volume with default cron schedule of every 6hrs.

## Set up your Wasabi S3 Bucket:

- Sign in to Wasabi - https://console.wasabisys.com/login
- Go to Buckets and select Create Bucket. Add the required details such as name and region. 
Please Note: Be sure to provide the corresponding "endpoint URL" in the "args" while deploying Plex. Current Defaults- region:"us-east-1" and endpoint_url:"s3.wasabisys.com".

![Select Region](./assets/select-region.png)

- Click on Next and choose the required Bucket Settings.

![Create Bucket](./assets/create-bucket-preview.png)

- Select Create Bucket.
- Once the bucket is create, you can now upload your artifacts.
- Now, to access the bucket need to create Access Keys. Go to Access Keys and select Create Access Key for Root or Sub-User as per requirement.
- Save the Access Keys safely. 

We will be using the above Bucket and Access Details to sync the Wasabi S3 bucket and Plex. 

Before, we dive deep into creating your own Acorns, you can give Plex a shot by clicking the below link to launch the app immediately in a free sandbox environment. All you need is a GitHub ID to create an account and provide Wasabi S3 configs in Advanced Configurations.

[![Run in Acorn](https://acorn.io/v1-ui/run/badge?image=ghcr.io+infracloudio+plex-acorn:v1.32.8-0&ref=aashimodi14)](https://acorn.io/run/ghcr.io/infracloudio/plex-acorn:v1.32.8-0?ref=aashimodi14&name=plex-app)

Now, we will deep dive into developing your own Plex Acorn. So, follow along!

> _Note: Everything shown in this tutorial can be found in [this repository](https://github.com/infracloudio/plex-acorn)_.
## Pre-requisites

- Acorn CLI: The CLI allows you to interact with the Acorn Runtime as well as Acorn to deploy and manage your applications. Refer to the [Installation documentation](https://docs.acorn.io/installation/installing) to install Acorn CLI for your environment.
- A GitHub account is required to sign up and use the Acorn Platform.
- Access to your Wasabi S3 bucket

## Acorn Login

Log in to the [Acorn Platform](https://acorn.io) using the GitHub Sign-In option with your GitHub user.

![Login Page](./assets/acorn-login-page.png)

After the installation of Acorn CLI for your OS, you can login to the Acorn platform.

```sh
$ acorn login
```

## Deploying the Plex Media Server App

There are two ways to deploy Plex server on Acorn Platform.

1. Using Acorn platform dashboard.
2. Using CLI

The Acorn Dashboard way is the easiest one where, in just a few clicks you can deploy the Plex on the platform and start using it. However, if you want to customize the application use the CLI option.

## Deploying Using Acorn Dashboard

In this option you use the published Acorn application image to deploy the Plex in just a few clicks. It allows you to deploy your applications faster without any additional configurations. Let us see below how you can deploy Plex to the Acorn platform dashboard.

1. Login to the [Acorn Platform](https://acorn.io/auth/login) using the Github Sign-In option with your Github user.
2. Select the "Already have an Acorn? Deploy" option.
3. Choose the source for deploying your Acorns
   3.1. Select “From Acorn Image” to deploy the sample Application.

   ![Select from image](./assets/deploy-from-image.png)

   3.2. Provide a name "plex-app”, use the default Region and provide the URL for the Acorn image and select Advanced Options on bottom left corner and click Next.

   ```sh
   ghcr.io/infracloudio/plex-acorn:v#.#.#-#
   ```
   ![Plex Deploy Preview](./assets/plex-deploy-preview.png)

   Provide Advanced Configurations to deploy Plex: 

   **Plexserver Claim**: Add the Plex Claim Token (To create the Plex Claim Token, login to https://www.plex.tv and copy the generated token from the link - https://www.plex.tv/claim/.)
   **Bucket Name**: Wasabi S3 Bucket Name
   **Access Key**: Wasabi S3 Access Key
   **Secret Key**: Wasabi S3 Secret Key
   **Rclone Schedule**: Rclone Cron Job Schedule to periodically sync the Wasabi S3 bucket with Plex Media Volume. Current default Value is `0 */6 * * *` i.e. Every 6 hours

  ![Advanced Plex Config Preview](./assets/plex-adv-config-preview.png)

> _Note: The App will be deployed in the Acorn Sandbox Environment. As the App is provisioned on AcornPlatform in the sandbox environment it will only be available for 2 hrs and after that it will be shutdown. Upgrade to a pro account to keep it running longer_.
4. Once the Acorn is running, you can access it by clicking the redirect link icon.

   4.1. Running Application on Acorn

   ![Plex Platform Dashboard](./assets/plex-platform-dashboard.png)

   4.2. Running Plex

   ![Plex Homepage](./assets/plex-home.png)

## Deploying Using Acorn CLI

As mentioned previously, running the Acorn application using CLI lets you understand the Acornfile. With the CLI option, you can customize the Plex to your requirement or use your Acorn knowledge to run your own application.

To run the application using CLI you first need to clone the source code repository on your machine.

```sh
$ git clone https://github.com/infracloudio/plex-acorn.git
```

Once cloned here’s how the directory structure will look.

```sh

.
├── Acornfile
├── LICENSE
├── plex-icon.png
├── rclone-config-script.sh
└── README.md

```

### Understanding the Acornfile

To run the application we need an Acornfile which describes the whole application without all of the boilerplate of Kubernetes YAML files. 

Before we dive into the intricacies of writing your own Acornfiles, available [Acorn elements](https://docs.acorn.io/reference/acornfile), usage of [Acorn Services](https://docs.acorn.io/authoring/services) and [Acorn Jobs](https://docs.acorn.io/authoring/jobs) might be worth exploring.

```sh

args: {
  scale: 1
  // required: Plex Claim Token
  plexserver_claim: ""
	// Optional: Plex media volume size
	storage:          "2G"
	// Required: Wasabi bucket name
	bucket_name:      ""
	// Required: Wasabi bucket region. Default: us-east-1
	region:           "us-east-1"
	// Required: Wasabi bucket url. Default: s3.wasabisys.com
	endpoint_url:     "s3.wasabisys.com"
	// Required: Wasabi access key
	access_key:       ""
	// Required: Wasabi secret key
	secret_key:       ""
	// Optional: Bucket sync job cron schedule. Default: every 6 hours.
  rclone_schedule:  "0 */6 * * *"
}

containers: {
  plexserver: {
    scale: args.scale
    env: {
      "PLEX_CLAIM": args.plexserver_claim
      "PGID": "1000"
      "PUID": "1000"
      "VERSION": "latest"
      "TZ": "Asia/Kolkata"

    }
    image: "ghcr.io/linuxserver/plex:1.32.8"
    ports: {
      publish: [
        "32400:32400/http",
        "32469/tcp",
        "3005/tcp",
        "8324/tcp",
        "1900/udp",
        "5354:5353/udp",
        "32410/udp",
        "32412/udp",
        "32413/udp",
        "32414/udp"
      ]
    }
    dirs: {
      "/config": "volume://plex-config"
      "/plexmedia": "volume://plexmedia"
    }
  }
}

jobs: {
  "rclone-init": {
      image: "rclone/rclone:latest"
      env: {
        RCLONE_CONFIG_MYS3_TYPE: "s3"
        AWS_ACCESS_KEY_ID:     args.access_key
        AWS_SECRET_ACCESS_KEY: args.secret_key
        AWS_S3_BUCKET:         args.bucket_name
				REGION:                args.region
				ENDPOINT_URL: 				 args.endpoint_url
      }
      dirs: {
        "./rclone-config-script.sh": "./rclone-config-script.sh"
        "/plexmedia": "volume://plexmedia"
      }
      entrypoint: ["/bin/sh", "-c", "./rclone-config-script.sh"]
  }
  "rclone-cronjob": {
      image: "rclone/rclone:latest"
      env: {
        RCLONE_CONFIG_MYS3_TYPE: "s3"
        AWS_ACCESS_KEY_ID:     args.access_key
        AWS_SECRET_ACCESS_KEY: args.secret_key
        AWS_S3_BUCKET:         args.bucket_name
				REGION:                args.region
				ENDPOINT_URL: 				 args.endpoint_url
      }
      dirs: {
        "./rclone-config-script.sh": "./rclone-config-script.sh"
        "/plexmedia": "volume://plexmedia"
      }
      entrypoint: ["/bin/sh", "-c", "./rclone-config-script.sh"]
      schedule: args.rclone_schedule
  }
}

volumes: {
  "plex-config": {
    size: 100M
  }
  "plexmedia": {
    size: args.storage
  }
}

```

There are various components for running the Plex

- plex application
- rclone jobs : init-job and periodic-job

The above Acornfile has the following elements:

- **Args**: Required and Optional User Arguments for running Plex 
  - **plexserver_claim**: required: Plex Claim Token. To create the Plex Claim Token, login to https://www.plex.tv and copy the generated token from the link - https://www.plex.tv/claim/.
  - **storage**: Optional: Plex media volume size. Default Value : 2G
  - **bucket_name**: Required: Wasabi bucket name
  - **region**: Required: Wasabi bucket region. Default: us-east-1
  - **endpoint_url**: Required: Wasabi bucket url. Default: s3.wasabisys.com
  - **access_key**: Required: Wasabi access key
  - **secret_key**: Required: Wasabi secret key
  - **rclone_schedule**: Optional: Rclone Cron Job schedule to periodically sync the Wasabi S3 bucket with Plex Media Volume. Default: every 6 hours.
- **Containers**: We define the plexserver container with following configurations:
  - **plexserver**:
    - **scale**: Plexserver Replicas
    - **image**: It defines Plex image
    - **env**: Environment variables for running the plex server.
    - **ports**: ports required by the application.
    - **dirs**: Config and Plex Media Volume mounts for the app.
- **Jobs**: 
  - **rclone-init**: Rclone Job for initial Data Sync from the Wasabi S3 bucket and Plex Media volume.
    - **image**: Rclone image
    - **env**: Environment variables for running the Plex.
    - **dirs**: Rclone script to create rclone configs for wasabi s3 sync and Plex Media Volume mount.
    - **entrypoint**: Run the config script on container start.
  - **rclone-cronjob**: Rclone Cron Job for periodic Data Sync from the Wasabi S3 bucket and Plex Media volume with default cron schedule of every 6hrs. 
- **Volumes**: Volumes to store persistent data in your applications

### Running the Application

Once you've logged using Acorn CLI you can directly deploy applications on the Acorn platform Sandbox plan. Run the following command from the root of the directory.

```sh
$ acorn run -n plex-app . --plexserver_claim <> --bucket_name <> --access_key <> --secret_key <>
```

Below is what the output looks like.

![Acorn CLI output](./assets/plex-cli-running.png)

## Using Plex

The Acornfile is configured with defaults and is available to run the Plex as is once your own Wasabi S3 credentials are configured.

![Plex Homepage](./assets/plex-home.png)

### Plex Media Library Setup

First time setup of Plex includes setting up your own Media Library like Movies, TV Shows, Music, Photos or Other Videos for Plex.

![Plex Media Setup](./assets/plex-media-setup-1.png)
![Plex Media Server Setup](./assets/plex-media-setup-2.png)
![Plex Select Media](./assets/plex-select-media.png)
![Plex Browse Media](./assets/plex-browse-media.png)
![Plex Add Folder](./assets/plex-add-folder.png)
![Plex Add Media Preview](./assets/add-media-preview.png)
![Plex Media Preview](./assets/plex-media-preview.png)
![Photo Media Preview](./assets/photo-media-preview.png)


## What's Next?

1. Plex provisioned on Acorn Platform is available for two hours, you should upgrade to Pro account to keep it running for longer duration.
2. After deploying you can edit the Acorn Application or remove it if no longer needed. Click the `Edit` option to edit your Acorn's Image. Toggle the `Advanced Options` switch for additional edit options.
3. Remove the Acorn by selecting the `Remove` option from your Acorn dashboard.

## Conclusion

In this tutorial we explored how to host your own Plex Media Server and use Acorn to seemlessly not only deploy the application but also extend it to perform automated scheduled job for your app. Also, different ways to deploy the app using CLI and Dashboard approach.
