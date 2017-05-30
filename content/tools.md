# mod_swift Tools

mod_swift comes with a set of CLI tools that integrate with the 
Swift Package Manager.
The tools enhance the Swift Package Manager to be able to build native
Apache modules, configure them and run them.
All of them are invoked like:

    swift apache <subcommand>

If the toolname is omitted, you get a small help:

```
$ swift apache
usage: swift apache <subcommand>

Available subcommands are:
   init      Setup directory as a Swift Apache module Package.
   build     Build Swift Package as a Swift module.
   serve     Start Apache and load Swift Apache module.
   validate  Check Apache build environment.

Try 'swift apache <subcommand> help' for details.
```

*Note*: [ApacheExpress](http://apacheexpress.io) comes with its own set of
        tools.

## swift apache init

Prepare a directory as a Swift Apache module. This will setup a directory
as a *barebones* Swift Apache module
(try [ApacheExpress](http://apacheexpress.io) for a higher level API!)

```
$ mkdir mods_helloworld && cd mods_helloworld
$ swift apache init
The Swift Apache build environment looks sound.

  module:    mods_helloworld
  config:    debug
  product:   /Users/helge/tmp/tests/mods_helloworld/.build/mods_helloworld.so
  apxs:      /usr/local/bin/apxs
  mod_swift: /usr/local/opt/mod_swift
```

## swift apache build

`swift apache build` first invokes `swift build` and subsequently converts the
build results into an Apache module shared library.

```
$ swift apache build
Cloning https://github.com/modswift/Apache.git
HEAD is now at 37f3038 Travis: use `swift build`
Resolved version: 0.2.0
Cloning https://github.com/modswift/CApache.git
HEAD is now at aa7d5b5 Tabs to spaces
Resolved version: 1.0.0
Compile Swift Module 'Apache' (8 sources)
Compile Swift Module 'mods_helloworld' (1 sources)

$ ls -hl .build/mods_helloworld.so
-rwxr-xr-x  1 helge  staff   240K May 30 16:05 .build/mods_helloworld.so
```

## swift apache serve

The `swift apache serve` command will generate an Apache configuration and
start Apache with it.
You can then access your module in the browser using either

  - HTTP: [http://localhost:8042/](http://localhost:8042/)
  - HTTPS/HTTP2: [https://localhost:8442/](https://localhost:8442/)

```
$ swift apache serve
Note: DocRoot /usr/local/var/www/htdocs
Starting Apache on port 8042/8442:
GET /helloworld/ 200 715 - 0ms
```

You can modify the configuration which is created using
[mod_swift config templates](configtemplates.md).

## swift apache validate

`swift apache validate` just checks whether a build is likely to be successful
and prints out the configuration assumptions it has.

```
$ swift apache validate
The Swift Apache build environment looks sound.

  srcroot:   /Users/helge/tmp/tests/mods_helloworld
  module:    mods_helloworld
  config:    debug
  product:   /Users/helge/tmp/tests/mods_helloworld/.build/mods_helloworld.so
  apxs:      /usr/local/bin/apxs
  mod_swift: /usr/local/opt/mod_swift
  swift:     3.0.2
  cert:      self-signed-mod_swift-localhost-server.crt
  http/2:    yes
```
