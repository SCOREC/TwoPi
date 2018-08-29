Instructions for launching piscope and petram via a docker container.

- First install Docker for your platform. See http://docker.com

    For windows 10 professional and enterprise users, install the
    community addition. This will require admin access. After
    installation, add yourself to the docker-users group. The first 
    time DOcker mounts a local volume of opens a port (eg for VNC) you 
    will be asked to authorized as well.

    For windows 10 home, install Docker Toolbox which uses virtualbox
    (which is installed for you.) See

      https://docs.docker.com/toolbox/toolbox_install_windows/

    This installation will not require permissions for firewall ports 
    or local volumes as this is done through a lightweight virtualbox
    image. Otherwise, the commands are the same but you access through
    a dedicated MINGW64 prompt via the "Docker Quickstart" program/icon.
    Containers will also be accessed through the VirtualBox shared network
    rather than localhost, typically something like `http://192.168.99.100:6082/`

- Installing PetraM image. 

  > wget https://www-internal.psfc.mit.edu/~shiraiwa/petram_image/twopi_docker_image
  > docker load -i twopi_docker_image

- Run the image

  Set up a working directory in which to run piscope.
  This directory and its contents and subdirectories will be available 
  as the "work" directory in the container.

  To run the image, execute the `run_piscope.cmd` (WIN) or 
  `run_piscope.sh` (NIX) script depending on your platform. Then open
  a browser to indicated network. Note that the `run_base.sh` script
  uses `docker-machine` which is *only* for use on machines that do
  not support native virtualization. Currently linux, OSX and Windows 10
  Enterprise do support native virtualization. 

  These scripts cleanup previous images and deploy a new one. They
  essentially boil down to running this single command:

  > docker run -d --name test_instance -v $HOME/.ssh:/home/user/ssh_mount -v $PWD:/home/user/work -p 6080:6080 twopi/petram

  Note different mount point for users ssh directory. This is to permit permission checking
  for some platforms such as Windows 10 Home which use VirtualBox with docker.

- Miscellaneous
    The piscope image starts up using the openbox window manager. You
    can change this via the desktop menu through
    Debian->WindowManagers->ICEWm

    You can have multiple instances of piscope and/or petram running
    but make sure to select a different local port (the first 6080).


- Building from scratch
  This section is meant for a memo to make a docker image file for
  distribution. Since PetraM is continuously changing, we suggest
  to use the image distributed from the PSFC site

  Goto docker subdirectory,
  Make sure that local PetraM repositories are updated/cleaned when
  building from local,
  Run

  > docker build --no-cache -t twopi/base -f Dockerfile.base .
  > docker build --no-cache -t twopi/pymfem -f Dockerfile.pymfem .

  to build from local PetraM
  > docker build --no-cache -t twopi/petram -f Dockerfile.petram-local .

  to build from GitHUB
  > docker build --no-cache -t twopi/petram -f Dockerfile.petram .
  

  Note : `twopi/base` requires opencascade tar file to be present from
    https://www.opencascade.com/content/latest-release

    - Cleaning.

After bulding from scratch, you can remove intermediate docker
images with, but be aware this will remove cached steps from any
other docker images you may be working on:

    docker system prune

To check actual disk usage:

    docker system df




    docker run -d --name piscope-instance -v $HOME/.ssh:/home/user/ssh_mount -v $PWD:/home/user/work -p 6080:6080 jcwright/piscope

 PetraM may be invoked in the same way with:

    docker run -d --name petram-instance -v $HOME/.ssh:/home/user/ssh_mount -v $PWD:/home/user/work -p 6080:6080 jcwright/petram

 