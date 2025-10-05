# `mentos1386/os`

My very special OS 🌸🌺! Based on [Bazzite](https://bazzite.gg/).

Currently supporting two versions:
 - Deck for Gaming focuesed devices.
    - `bootc switch ghcr.io/mentos1386/os-bazzite-deck-gnome:latest`
 - Gnome for everything else.
    - `bootc switch ghcr.io/mentos1386/os-bazzite-gnome:latest`

#### References:
 - https://github.com/DeterminateSystems/nix-installer/issues/1445#issuecomment-2816777981

# Installation

1. Install [Bazzite](https://bazzite.gg/).
2. Once installed, switch to this os using (matching flavor) `sudo bootc switch ghcr.io/mentos1386/os-bazzite-gnome:latest`.
3. Reboot 🐣

# Prerequisites

Working knowledge in the following topics:

- Containers
  - https://www.youtube.com/watch?v=SnSH8Ht3MIc
  - https://www.mankier.com/5/Containerfile
- bootc
  - https://bootc-dev.github.io/bootc/
- Fedora Silverblue (and other Fedora Atomic variants)
  - https://docs.fedoraproject.org/en-US/fedora-silverblue/
- Github Workflows
  - https://docs.github.com/en/actions/using-workflows

# How to Use

## Containerfile

This file defines the operations used to customize the selected image. It contains examples of possible modifications, including how to:
- change the upstream from which the custom image is derived
- add additional RPM packages
- add binaries as a layer from other images

## Building an ISO

This template provides an out of the box workflow for getting an ISO image for your custom OCI image which can be used to directly install onto your machines.

This template provides a way to upload the ISO that is generated from the workflow to a S3 bucket or it will be available as an artifact from the job. To upload to S3 we use a tool called [rclone](https://rclone.org/) which is able to use [many S3 providers](https://rclone.org/s3/). For more details on how to configure this see the details [below](#build-isoyml).

### Justfile Documentation

This `Justfile` contains various commands and configurations for building and managing container images and virtual machine images using Podman and other utilities.

#### Environment Variables

- `repo_organization`: The GitHub repository owner (default: "yourname").
- `image_name`: The name of the image (default: "yourimage").
- `centos_version`: The CentOS version (default: "stream10").
- `fedora_version`: The Fedora version (default: "41").
- `default_tag`: The default tag for the image (default: "latest").
- `bib_image`: The Bootc Image Builder (BIB) image (default: "quay.io/centos-bootc/bootc-image-builder:latest").

#### Aliases

- `build-vm`: Alias for `build-qcow2`.
- `rebuild-vm`: Alias for `rebuild-qcow2`.
- `run-vm`: Alias for `run-vm-qcow2`.


#### Commands

###### `check`

Checks the syntax of all `.just` files and the `Justfile`.

###### `fix`

Fixes the syntax of all `.just` files and the `Justfile`.

###### `clean`

Cleans the repository by removing build artifacts.

##### Build Commands

###### `build`

Builds a container image using Podman.

```bash
just build $target_image $tag $dx $hwe $gdx
```

Arguments:
- `$target_image`: The tag you want to apply to the image (default: aurora).
- `$tag`: The tag for the image (default: lts).
- `$dx`: Enable DX (default: "0").
- `$hwe`: Enable HWE (default: "0").
- `$gdx`: Enable GDX (default: "0").

##### Building Virtual Machines and ISOs

###### `build-qcow2`

Builds a QCOW2 virtual machine image.

```bash
just build-qcow2 $target_image $tag
```

###### `build-raw`

Builds a RAW virtual machine image.

```bash
just build-raw $target_image $tag
```

###### `build-iso`

Builds an ISO virtual machine image.

```bash
just build-iso $target_image $tag
```

###### `rebuild-qcow2`

Rebuilds a QCOW2 virtual machine image.

```bash
just rebuild-qcow2 $target_image $tag
```

###### `rebuild-raw`

Rebuilds a RAW virtual machine image.

```bash
just rebuild-raw $target_image $tag
```

###### `rebuild-iso`

Rebuilds an ISO virtual machine image.

```bash
just rebuild-iso $target_image $tag
```

##### Run Virtual Machines

###### `run-vm-qcow2`

Runs a virtual machine from a QCOW2 image.

```bash
just run-vm-qcow2 $target_image $tag
```

###### `run-vm-raw`

Runs a virtual machine from a RAW image.

```bash
just run-vm-raw $target_image $tag
```

###### `run-vm-iso`

Runs a virtual machine from an ISO.

```bash
just run-vm-iso $target_image $tag
```

###### `spawn-vm`

Runs a virtual machine using systemd-vmspawn.

```bash
just spawn-vm rebuild="0" type="qcow2" ram="6G"
```

##### Lint and Format

###### `lint`

Runs shell check on all Bash scripts.

###### `format`

Runs shfmt on all Bash scripts.

## Workflows

### build.yml

This workflow creates your custom OCI image and publishes it to the Github Container Registry (GHCR). By default, the image name will match the Github repository name.

### build-iso.yml

This workflow creates an ISO from your OCI image by utilizing the [bootc-image-builder](https://osbuild.org/docs/bootc/) to generate an ISO. In order to use this workflow you must complete the following steps:

- Modify `iso.toml` to point to your custom image before generating an ISO.
- If you changed your image name from the default in `build.yml` then in the `build-iso.yml` file edit the `IMAGE_REGISTRY` and `DEFAULT_TAG` environment variables with the correct values. If you did not make changes, skip this step.
- Finally, if you want to upload your ISOs to S3 then you will need to add your S3 configuration to the repository's Action secrets. This can be found by going to your repository settings, under `Secrets and Variables` -> `Actions`. You will need to add the following
  - `S3_PROVIDER` - Must match one of the values from the [supported list](https://rclone.org/s3/)
  - `S3_BUCKET_NAME` - Your unique bucket name
  - `S3_ACCESS_KEY_ID` - It is recommended that you make a separate key just for this workflow
  - `S3_SECRET_ACCESS_KEY` - See above.
  - `S3_REGION` - The region your bucket lives in. If you do not know then set this value to `auto`.
  - `S3_ENDPOINT` - This value will be specific to the bucket as well.

Once the workflow is done, you'll find it either in your S3 bucket or as part of the summary under `Artifacts` after the workflow is completed.

# Community

- [**bootc discussion forums**](https://github.com/bootc-dev/bootc/discussions) - Nothing in this template is ublue specific, the upstream bootc project has a discussions forum where custom image builders can hang out and ask questions.

## Artifacthub

This template comes with the necessary tooling to index your image on [artifacthub.io](https://artifacthub.io), use the `artifacthub-repo.yml` file at the root to verify yourself as the publisher. This is important to you for a few reasons:

- The value of artifacthub is it's one place for people to index their custom images, and since we depend on each other to learn, it helps grow the community.
- You get to see your pet project listed with the other cool projects in Cloud Native.
- Since the site puts your README front and center, it's a good way to learn how to write a good README, learn some marketing, finding your audience, etc.

[Discussion thread](https://universal-blue.discourse.group/t/listing-your-custom-image-on-artifacthub/6446)

## Community Examples

- [m2os](https://github.com/m2giles/m2os)
- [bos](https://github.com/bsherman/bos)
- [homer](https://github.com/bketelsen/homer/)
