# Blockchain Configuration

Here are the steps to create the blockchain network and deploy the business network.

## Prerequisites

The blockchain network is not recommended for use in Windows environment. These scripts have been tested in the Linux environment. In the MAC environment it has not been tested, but this should work successfully.

However, if you want to use Windows, you can either use a VM with the Linux image or use a Windows Subsystem Linux (WSL). For WSL, you can see how to configure the following links below:

[Configuring WSL in Windows](https://medium.com/cochain/hyperledger-fabric-on-windows-10-26723116c636)
[Enabling Docker in WSL](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly)

It is recommended to use Ubuntu 16.04. For Ubuntu you need to install the following:
- git
- nvm (to install the node)
- node (version 8.**)
- CA certificates
- curl
- Docker
- Docker Compose
- Hyperledger Compose Tools
--composer-cli 0.19.2
--generator-hyperledger-composer 0.19.12
--composer-rest-server 0.19.12
--yo
--composer-playground@0.19.12

Go to the **blockchain** folder and give permission for .sh files.
```sh
sudo chmod +x *.sh
```

```sh
sudo chmod +x scripts/*.sh
```

You must run the **00-prereqs_ubuntu.sh** file.
```sh
./scripts/00-prereqs_ubuntu.sh
```
You can see the file **00-prereqs_ubuntu.sh** and run the commands to install manually.

You need to do the download of the docker images and fabric tools. Execute the command below:
```sh
./01_build_fabric_docker_images.sh
```

## Creating the blockchain network
Execute the all scripts in numerical order