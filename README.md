gentoo-overlay
==============

Overlay for Gentoo/Linux packages

The following packages are available in this overlay:

* dwarf-therapist - https://github.com/splintermind/Dwarf-Therapist
* simplescreenrecorder - http://www.maartenbaert.be/simplescreenrecorder

## Installing
This overlay is not official and not available in layman.
To use this repository you can either add it using layman or add it manually to your layman configuration.

Please read https://wiki.gentoo.org/wiki/Layman for general instructs on how layman works.

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
