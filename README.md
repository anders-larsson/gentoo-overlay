**Current build status:** [![Build Status](https://travis-ci.org/anders-larsson/gentoo-overlay.svg)](https://travis-ci.org/anders-larsson/gentoo-overlay)

gentoo-overlay
==============

Overlay for Gentoo/Linux packages

The following packages are available in this overlay:

* acquisition - https://github.com/xyzz/acquisition
* dwarf-therapist - https://github.com/splintermind/Dwarf-Therapist
* simplescreenrecorder - http://www.maartenbaert.be/simplescreenrecorder


## Warning

This overlay is not official and not available in layman (as an official source).

**Use ebuilds supplied in this repository on your own risk**. They've been tested on my own system setup (~amd64) and (most likely) tested on virtual systems (amd64 and x86).

## Installing

Please read https://wiki.gentoo.org/wiki/Layman for more information regarding layman.

### Add it using layman:

    layman -f -o http://anders-larsson.github.io/gentoo-overlay/repositories.xml -a anders-larsson

### Add it manually:

Edit /etc/layman/layman.cfg and include the following line for "overlays".

    http://anders-larsson.github.io/gentoo-overlay/repositories.xml

Should look something similar to the lines below if you don't use any other layman overlays.

    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
                http://anders-larsson.github.io/gentoo-overlay/repositories.xml

Finally add the layman overlay using the command below.

    layman -a anders-larsson
