dgn2200v3-network_monitor
=========================

Collection of scripts and instructions to set up rrdtool on Netgear DGN2200v3 router

Disclaimer
----------

The scripts supplied, as the build instructions, are not guaranteed to work, and may be full of bugs (and probably they are), but worked to me.
Your are the only responsible for your device, so use them at your own risk.

Requirements
------------

+ [Netgear toolchain](http://kb.netgear.com/app/answers/detail/a_id/2649/~/open-source-code-for-programmers-%28gpl%29) (tested with 1.1.00.21 version)
+ [rrdtool source](http://oss.oetiker.ch/rrdtool/pub/?M=D) (tested with 1.4.8 version)
+ make=3.81
+ texinfo<5

Optional dependencies
+ tar, wget, nano/vi compiled for MIPS. Will simplify the install process dramatically.

Setup
-----
+ Unpack and build toolchain (instructions in the `README` supplied), using `toolchain.config` as `.config` file.
+ Unpack, `make && make install` kernel and source, also in the toolchain package (if you are running linux>2.6 you'll need to edit `Kernel/bcm963xx/make.common`
  e.g. setting `KERNEL_VERSION := 2.6`)
+ Build rrdtool
```sh
  $ export version=4.4.2-1
  $ export PREFIX=/opt/toolchains/uclibc-crosstools-gcc-${version}
  $ export TARGET=mips-linux-uclibc
  $ export TOOLCHAIN=${PREFIX}/usr/bin/${TARGET}
  $ export CC=$PREFIX-gcc
  $ export LD=$PREFIX-ld   # export others, if needed
  $ export rrdtool_version=1.4.8
  $ wget http://oss.oetiker.ch/rrdtool/pub/rrdtool-${rrdtool_version}.tar.gz
  $ tar -xzf rrdtool-${rrdtool_version}
  $ cd rrdtool-${rrdtool_version}
  $ CPPFLAGS="-I/$PREFIX/usr/include/cairo -I/$PREFIX/usr/include/libpng12"  --sysroot=$PREFIX \
	./configure --prefix=/opt/rrdtool --host=$TARGET --disable-tcl --disable-python
  $ make
  # make install
```

Now you will need to connect to the router's shell via `telnet`.
You will need to unlock it visiting router's debug page ([192.168.0.1/setup.cgi?todo=debug](http://192.168.0.1/setup.cgi?todo=debug))
+ Remount target's / rw
```sh
  # mount -o remount,rw /
```
+ Optionally copy tar, wget, nano/vi on the router (aka the 'target')
+ Copy `/opt/rrdtool/{bin,lib}` to target (e.g. via usb drive or wget/ftp)
+ Copy additional libs from `$PREFIX/usr/lib` to `/opt/rrdtool/lib` (or `/lib`) on target (lib's list below).
  >libcairo.so.2.17.5
  >libexpat.so.1.5.2
  >libfontconfig.so.1.3.0
  >libfreetype.so.6.3.20
  >libglib-2.0.so.0.2000.5
  >libgmodule-2.0.so.0.2000.5
  >libgobject-2.0.so.0.2000.5
  >libiconv.so.2.4.0
  >libintl.so.8.0.1
  >libpango-1.0.so.0.2002.3
  >libpangocairo-1.0.so.0.2002.3
  >libpangoft2-1.0.so.0.2002.3
  >libpixman-1.so.0.10.0	
  >librrd.so.4.2.1
  >librrd_th.so.4.2.1
  >libxml2.so.2.7.3
+ Make symlinks for all the libraries, e.g.
```sh
  # ln -s libcairo.so.2.17.5 libcairo.so.2
```

+ Copy `pango-basic-fc.so` from `$PREFIX/usr/lib/pango/1.6.0/modules` to `/usr/lib/pango/1.6.0/modules` on target.
+ Copy `pango-querymodules` from `$PREFIX/usr/bin` and execute `pango-querymodules > '/etc/pango/pango.modules`.
+ Copy `DejaVuSansMono.ttf` (or any other TTF font you like) from your system to `/usr/share/fonts/TTF`.
+ Copy files from this repo to a directory of your liking on the target (e.g. `/opt/rrdtool/scripts`).
+ Make a directory for output graphs

```sh
  # mkdir /tmp/www/rrdtool
```

+ copy `rrdtool.htm` to `/tmp/www/` or `/www.eng/`

Usage
-----
+ Configure `nas1.conf` (you can rename if you like).
+ Run `./create_rrd.sh ./nas1.conf` to create rr database.
+ Run `./poll_graph.sh ./nas1.conf` every minute (or less) to poll the database.
+ Run `./poll_graph_*.sh ./nas1.conf` every now and then to create png's (default every 1, 5, 30, 120 minutes and 1 day, respectively).

To run scripts periodically you can use target's cron, or the `cronlike.sh` script supplied.

