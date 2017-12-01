# meta-intel-iot-middleware

This is the middleware layer for the Intel IoT developer kit. Here are
middleware parts useful for the iot-devkit but not shipped as part of meta-oe
or backports from newer versions of meta-oe which are not appropriate for
meta-oe itself. Software in here is likely to follow a more agressive upgrade
schedule (FT - this is Intel's original text, and it's true if more agressive == less slow).

This layer depends on:

  URI: git://git.openembedded.org/meta-openembedded
  branch: daisy

You will find more details in the README file in this directory

# What is here

This is a fork of http://git.yoctoproject.org/cgit/cgit.cgi/meta-intel-iot-middleware

Currently I am tracking origin but I have created two patched branches: dizzy-uptodate and dizzy-latest.

  * **dizzy-uptodate** tracks origin/dizzy. This is the branch that should be pulled by http://git.yoctoproject.org/cgit/cgit.cgi/meta-intel-edison/setup.sh. Currently (20-4-2017) the original meta-intel-edison checks out commit c6d681475e76107e6c04c5f7a06034dc9e772d1e (12-06-2015) which gives you upm 0.3.1 and mraa 0.7.2. Unfortunately, this will not build anymore as paho-mqtt moved to another location and iotkit-comm-js are no longer supported (and were used  only to acces Intel's cloud service that has now shutdown). This branch will give you the same c6d6814..., with the relocated paho-mqtt minus the unsupported stuff.
  * **dizzy-latest** tries to track origin/master. However, that adds java support for mraa and upm after a certain point (0da7afac...) which requires the meta-java layer. This layer is on krogoth, not on dizzy, so needs to be patched. In the sources of the Edison 3.5 image this has been done, but it no longer builds. And as these sources are not a git repository, the patches can not be easily applied to another fork and then finally fixed up. Long story short, it is not worth the effort to me. Currently I branched of 7c54122... (24-03-2016), which gives you mraa 0.9.0, upm 0.4.1 and mosquitto 1.4. Not to bad. The next commit (updating nodejs to 4.2.4) FTB unfortunately, otherwise I would have moved up to mraa 0.9.6.

*I would accept pull requests that allow to go HEAD of master of course. But I would prefer to build master with the java requirement patched out of mraa and upm. I fail to see why anybody would want to run java on the Edison.*

# How to use this

You normally would not want to clone this directly as cloning is handled by the setup script in my cloned  meta-intel-edison layer.