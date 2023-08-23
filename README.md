_WARNING_ - this repository is work in progress and subjet to significant change
as we generalize the structure in order to support multiple target boards,
as of today (8/21/2023) the only board supported by this repository is the
mitysom5cse-l2-3y8 (single ARM core, 512MBy DDR), however we are actively
working to support additional module types. If you need a specific module
to be supported, you may add an issue, or (if you are able to do so) feel
free to modify this repo and submit a Pull Request.

**Recomended Template Project**
Go (here)[] for an example project which
is fully configured to build valid boot images for the supported module(s).

**Dependencies**
This layer depends on the following Yocto layers
* meta-intel-fpga
    * URL:  https://github.com/altera-opensource/meta-intel-fpga 
    * branch: kirkstone
* Yocto Poky
    * URL:  https://git.yoctoproject.org/poky
    * branch: kirkstone
* Meta-openembedded
    * URL:  https://git.openembedded.org/meta-openembedded
    * branch: kirkstone

**Structure**
This repo builds a Linux runtime that uses a ramdisk+overlayfs structure in order
to permit atomic updating of the root filesystem of the target device. The top level
build target is "sdimage-mitysom5cs". This target generates the required U-Boot
bootloader, Linux kernel, initramfs, and squashfs root filesystem. A default empty
FPGA bitstream file is also provided for example, and should be replaced with your
application specific file.

**FPGA Support**
As the CycloneV SoC contains both fixed ARM processor components _and_ configurable
FPGA gates, full use of this project requires generation of configuration files from
Intel Quartus software. Free (limited functionality) versions of this software are
available from the IntelFPGA project pages. Instructions on how to program an FPAG
are outside the scope of this project, but are available from Exact Assembly as a 
service, and you can also look at how-to guides and find complete documentation of
the IntelFPGA structure at the following:
* (Intel CycloneV SoC FPGA)[https://www.intel.com/content/www/us/en/products/details/fpga/cyclone/v.html]
* (RocketBoards CycloneV SoC Golden Reference Design)[https://www.rocketboards.org/foswiki/Documentation/CycloneVSoCGSRD]
