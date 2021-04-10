### Container based builder for vscodium

This work was inspired by my desire to compile my own IDE from source, as I like to build and customize my software frequently, and/or contribute back upstream. I did not want to rely on github workflows, preferring instead to build locally within a container. Leveraging the work from vscodium, I've modified the scripts to exclude anything github or non-rpm-linux related.  The resulting container build pulls the requested version from source, builds it, and outputs your build RPM of vscodium.

#### Example usage

##### Requirements:
Requires buildah and podman to be installed. Tested on Fedora 33.

The output directory is created and mounted for the resulting RPM that is produced.

```
mkdir output

export CONTAINERNAME="vscode_builder"
export VERSION="0.1.6"

# Build our container first with our toolchain.
buildah bud -f vscode_builder -t $CONTAINERNAME:$VERSION
# Run the toolchain container and build script to build from source. Mount /home/ to move the resulting binary onto your local fs.
podman run -v ./output/:/home/:Z $CONTAINERNAME:$VERSION

# Clean up vars.
unset CONTAINERNAME
unset VERSION

# For example, your output folder will have an RPM similar to this:
# ls output/
# codium-x.xx.x-xxxxxxxxxx.el8.x86_64.rpm
```

#### ENV vars
The default ENV vars that are set for the build that can be changed at run time:

* ENV repo="https://github.com/timhansendev/vscodium.git"
* ENV tag="1551"
* ENV VSCODE_ARCH=x64

#### TODO
* Test past three tags (versions) of vscodium automatically.
* Allow more customization of build.
* Build out source container build for .deb based package managers.
* Build out source container build for flatpak.

