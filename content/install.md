# mod_swift Installation

mod_swift should install fine on pretty much any Unix system that can run
Swift and Apache 2.4. Including exotic setups like Raspberry Pi systems.

We also provide a macOS Homebrew tap which makes it really easy to install
mod_swift and its dependencies on macOS. We highly recommend that over a
custom install.

On the Linux side we test w/ Ubuntu Trusty and Xenial, though it should work
pretty much anywhere.

## Install on macOS using Homebrew

Got no Homebrew? [Get it!](https://brew.sh)

Before you install mod_swift, we highly recommend that you install or reinstall
the Homebrew Apache w/ HTTP/2 and the MPM event module:

    brew reinstall httpd --with-mpm-event --with-http2

You can also add `--with-privileged-ports` if you want to use such.

Then add the mod_swift tap and install mod_swift:

    brew tap modswift/mod_swift
    brew install mod_swift

*(yes, the account is just modswift w/o underscore due to GitHub limitations)*

## Install on Linux (or macOS w/o Homebrew)

On macOS: We strongly advise that you rather use Homebrew, more importantly
          the Apache provided by Homebrew.

Ubuntu packages required (assuming you have Swift 3 installed already), this includes
the PostgreSQL and SQLite3 database adaptors, add additional ones as desired:

    sudo apt-get update
    sudo apt-get install \
       curl pkg-config libapr1-dev libaprutil1-dev \
       libxml2 apache2 apache2-dev \
       libnghttp2-dev \
       libaprutil1-dbd-sqlite3 \
       libaprutil1-dbd-pgsql

Install mod_swift:

    curl -L -o mod_swift.tgz \
         https://github.com/modswift/mod_swift/archive/0.8.5.tar.gz
    tar zxf mod_swift.tgz && cd mod_swift-0.8.5
    make
    sudo make install

That puts mod_swift into `/usr/local`. If you want to have it in `/usr`, do:

    sudo make prefix=/usr install

## Check whether the installation is OK

You can call `swift apache validate` to make sure the installation is OK:

    $ swift apache validate
    The Swift Apache build environment looks sound.
    
    srcroot:   /Users/helge/dev/Swift/Apex3
    module:    mods_Apex3
    config:    debug
    product:   /Users/helge/dev/Swift/Apex3/.build/mods_Apex3.so
    apxs:      /usr/local/bin/apxs
    mod_swift: /usr/local
    swift:     3.1.0
    cert:      self-signed-mod_swift-localhost-server.crt
    http/2:    yes

## Troubleshooting

If something isn't working in a Homebrew setup, check whether:

    brew doctor

outputs anything unusual.

If you need any help, feel free to ask on the
[Mailing List](https://groups.google.com/d/forum/mod_swift)
or our
[Slack channel](http://slack.noze.io).


