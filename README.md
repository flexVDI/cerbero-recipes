# Custom set of cerbero recipes

## Download

Clone this repo and update the cerbero submodule:

    $ git clone https://github.com/flexVDI/cerbero-recipes
    $ cd cerbero-recipes
    $ git submodule init && git submodule update

## Use

1. Configure `~/.cerbero/cerbero.cbc`. Add home_dir, at least. E.g. `home_dir = '/home/you/cerbero'`
2. Use `cerbero.sh` script in the root dir of the project. It includes the flexvdi.cbc file and runs from the cerbero config directory so that a) custom recipe paths and toolchains are set, and b) other configuration files are referenced without path.

_NOTE_: When cross-compiling on Linux to Windows, glib recipe seems no need more than 1024 open files.
Increase the limit where needed.

### Examples:

1. Bootstrap the Android build tools and NDK:
   
       ./cerbero.sh -c cross-android-universal.cbc bootstrap

2. Build the flexVDI Desktop Client on Windows 32-bit:

       ./cerbero.sh -c cross-win32.cbc build flexvdi-client

### Building portable Linux binaries

In order to build Linux binaries that can be run in many other Linux distributions, use the `linux-container.sh` script.
It launches a docker container based on Debian Jessie.
Linux binaries built there will be compatible with many Linux distributions of the last ~5 years.

For 64-bit environment:

    $ ./linux-container.sh

For 32-bit environment:

    $ ./linux-container.sh i686

The script will discover the Cerbero home_dir you configured in cerbero.cbc and mount it as a volume.
So, you only have to run `cerbero bootstrap` once, even if you destroy the container.
Inside the container, the cerbero binary is in the $PATH, and the cerbero user is created with the same uid and gid of the user running docker.
