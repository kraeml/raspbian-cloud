#!/bin/bash -e

echo "Checking git submodules ..."
git submodule init
git submodule update

# Insert imagetool.sh as link
[ ! -h ./imagetool.sh ] && ln -s pi-gen/imagetool.sh ./imagetool.sh
pushd pi-gen
git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
git branch
popd

echo "Building traditional RPI image ..."
./raspbian-cloud-build.sh

echo "All done! Have a look in deploy folder:"
ls -l deploy
