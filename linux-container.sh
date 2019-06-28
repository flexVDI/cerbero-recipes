#!/bin/sh
set -e

SRCDIR="$(readlink -e "$(dirname "$0")")"
if [ -f $HOME/.cerbero/cerbero.cbc ]; then
    BUILDDIR=$($SRCDIR/cerbero.sh show-config | grep home_dir | cut -d ':' -f 2 | sed -e 's/^[ \t]*//')
else
    BUILDDIR=$(readlink -e .)
    if [ "$BUILDDIR" == "$SRCDIR" ]; then
        BUILDDIR="$BUILDDIR"/build
    fi
    mkdir -p "$BUILDDIR"/sources/local
fi

arch=${1:-x86_64}
EXTRA_VOLUMES=$(
    IFS=:
    for d in $EXTRA_SOURCES; do
        IFS=, read dir mount <<< "$d"
        dir=$(readlink -e "$dir")
        if [ -z "$mount" ]; then mount=$(basename "$dir"); fi
        echo -n " -v $dir:/home/cerbero/build/sources/local/$mount:ro"
    done
)

DOCKERFILE="$SRCDIR"/linux-container/Dockerfile

case $arch in
    x86_64)
        ;;
    i686)
        DOCKERFILE="$DOCKERFILE".i686
        trap "rm $DOCKERFILE" EXIT
        sed -e "s/amd64/i386/" \
            -e "s/libc6-dev-i386/libc6-dev-amd64/" \
            -e "s/Architecture.X86_64/Architecture.X86/" \
            -e "s/x86_64-linux-gnu/i686-linux-gnu/" \
            -e "s/appimagetool-x86_64/appimagetool-i686/" \
            "$SRCDIR"/linux-container/Dockerfile > $DOCKERFILE
        ;;
    *)
        echo "WARNING: Unknown architecture $arch, using x86_64"
        arch=x86_64
        ;;
esac

if ! [ -f "$SRCDIR"/linux-container/appimagetool-${arch}.AppImage ]; then
    curl -L -o "$SRCDIR"/linux-container/appimagetool-${arch}.AppImage https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-${arch}.AppImage
fi

docker build -t linux-cerbero-$arch -f "$DOCKERFILE" "$SRCDIR"/linux-container

[ -S ~/.git-credential-cache/socket ] && GIT_CREDENTIAL_CACHE="-v $HOME/.git-credential-cache/socket:/home/cerbero/.git-credential-cache/socket"
docker run -it --rm \
    --privileged \
    -h cerbero-$arch \
    --name cerbero-$arch \
    -v "$SRCDIR":/home/cerbero/cerbero:ro \
    -v "$BUILDDIR":/home/cerbero/build \
    $GIT_CREDENTIAL_CACHE \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /etc/localtime:/etc/localtime:ro \
    $EXTRA_VOLUMES \
    -e TERM=$TERM \
    -e LOCAL_UID=`id -u` -e LOCAL_GID=`id -g` \
    linux-cerbero-$arch

