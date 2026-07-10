# Ubuntu 24.04 Chroot Environment Deployment Guide

This guide details how to build your custom ARM64 development image on Ubuntu WSL, host it on Docker Hub, and set it up inside a rooted Termux environment on Android using `chroot-distro`.

---

## Part 1: Building and Deploying from WSL

Since your Android phone runs on an ARM64 processing unit, you must compile the Docker image for the `linux/arm64` platform. Windows Subsystem for Linux (WSL) running Docker Desktop or native Docker engines handles this using `buildx`.

### 1. Configure Docker Buildx
Open your WSL terminal and ensure `buildx` is ready for cross-platform builds:
```bash
docker buildx create --use
docker buildx inspect --bootstrap
```
### 2. Authenticate with Docker Hub
Login to your Docker Hub registry profile from WSL:

```bash
docker login
```

### 3. Compile and Push the Image
Navigate to the directory housing your Dockerfile and execute the build.
(Note: Compiling Neovim and Python from source for an alternate target architecture takes time. Let the pipeline process finish).

```bash
docker buildx build --platform linux/arm64 -t jkanangila/ubuntu-chroot:latest --push .
```

## Part 2: Setup and Deployment on Termux (Android)
With the image live on Docker Hub, switch entirely over to your rooted Android device running Termux.

### 1. Install chroot-distro Dependencies
First, prepare your Termux environment with native utility packages:

```bash
pkg update && pkg upgrade -y
pkg install git tsu root-repo -y

```
### 2. Clone and Setup chroot-distro
Clone the engine repository by sabamdarif into your Termux home space:

```bash
git clone [https://github.com/sabamdarif/chroot-distro.git](https://github.com/sabamdarif/chroot-distro.git) ~/chroot-distro
cd ~/chroot-distro

```
Make the script executable:

```bash
chmod +x chroot-distro
```

### 3. Deploy Your Custom Image
Using the framework's build parser, pull down your remote Docker image. It will strip the container layers, map out the environment permissions, and provision the rootfs tarball locally:

```bash
sudo ./chroot-distro install ubuntu-dev --image YOUR_DOCKERHUB_USERNAME/ubuntu-chroot:latest
```

## Part 3: Environment Lifecycle (Log In / Log Out)
**Logging Into the Chroot**
To activate the environment as your personalized user profile (jkanangila) while tracking interactive terminal shells:

```bash
sudo ./chroot-distro login ubuntu-dev --user jkanangila
```

**Logging Out**
When your work session is finished, you can cleanly sever the operational layer bindings and head back to standard Termux simply by typing:

```bash
exit
```
