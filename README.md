gentoo-overlay
==============

Overlay for Gentoo/Linux packages

The following packages are available in this overlay:

* simplescreenrecorder - http://www.maartenbaert.be/simplescreenrecorder

## Installing
This overlay is not official and not available in layman.
To use this repository you need to add it manually to your layman configuration.

Modify /etc/layman/layman.cfg and include the following line for "overlays".

    http://anders-larsson.github.io/gentoo-overlay/repositories.xml

Should look something similar to the lines below if you don't use any other layman overlays.

    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
                http://anders-larsson.github.io/gentoo-overlay/repositories.xml
