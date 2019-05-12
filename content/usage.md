# Hello World

Note: mod_swift only provides a very low level raw API. If you want something
more convenient, checkout [ApacheExpress](http://apacheexpress.io/).

But lets do a simple `mods_helloworld` module for demonstration purposes.

## Setup Module

Setup a new directory and initialize it as an Apache Swift module:

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

This creates a Swift Package Manager module and places an example Apache entry
point into it:

```
$ tree
.
├── Package.swift
└── Sources
    └── mods_helloworld
        └── mods_helloworld.swift

2 directory, 2 files
```

The `Package.swift` just loads the Apache wrapper module we provide:

```swift
import PackageDescription

let package = Package(
    name: "mods_helloworld",

    dependencies: [
      .package(url: "https://github.com/modswift/Apache.git", from: "0.5.0")
    ],
    
    targets: [
      .target(name: "mods_helloworld", dependencies: [ "Apache" ])
    ]    
)
```

The `mods_helloworld.swift` source file contains a demo Apache module. The
file can be named anything (but main.swift, which would produce a tool instead
of a library ;-)

```swift
import CApache
import Apache

var module = CApache.module(name: "mods_helloworld")

func mods_helloworldHandler(p: UnsafeMutablePointer<request_rec>?) -> Int32 {
  // example content handler, modify to your liking
  var req = ApacheRequest(raw: p!)
  
  req.contentType = "text/html; charset=ascii"
  req.puts("<html><head><title>Hello mod_swift</title>\(semanticUI)</head>")
  req.puts("<body><div class='ui main container' style='margin-top: 1em;'>")
  req.puts("<h3>Welcome to mods_helloworld</h3>")
  defer { req.puts("</div></body></html>") }
  
  req.puts("<h4>Links of Interest</h4>")
  req.puts("<ul>")
  req.puts("  <li><a href='http://mod-swift.org/'>mod-swift.org</a></li>")
  req.puts("  <li><a href='http://apacheexpress.io/'>ApacheExpress</a></li>")
  req.puts("  <li><a href='https://httpd.apache.org/'>Apache</a></li>")
  
  req.puts("</ul>")
  return OK
}

fileprivate func register_hooks(pool: OpaquePointer?) {
  // hookup the handlers you want
  ap_hook_handler(mods_helloworldHandler, nil, nil, APR_HOOK_MIDDLE)
}

@_cdecl("ApacheMain")
public func ApacheMain(cmd: UnsafeMutablePointer<cmd_parms>) {
  module.register_hooks = register_hooks
  
  let rc = apz_register_swift_module(cmd, &module)
  assert(rc == APR_SUCCESS, "Could not add Swift module!")
}
```

### Explanation of the Source

#### Module Structure

At the top this prepares the Apache module structure. The structure identifies
our module within Apache. It contains the name, links to our callbacks, and
optionally configuration data (yes, you can also add your own configuration
directives to the Apache config).

```swift
var module = CApache.module(name: "mods_helloworld")
```

Which is registered at the bottom, in the `ApacheMain` function:

#### ApacheMain()

`ApacheMain` is the primary entry point which is called by mod_swift when it
executes the `LoadSwiftModule` directive in the Apache configuration.
The `@_cdecl` isn't actually required in this case, but can be necessary in more
complex setups. It tells Apache where to find the entry
function (Apache being written in C, needs to have a C name, which often, but
not always can be derived - the cdecl makes it explicit).

```swift
@_cdecl("ApacheMain")
public func ApacheMain(cmd: UnsafeMutablePointer<cmd_parms>) {
  module.register_hooks = register_hooks

  let rc = apz_register_swift_module(cmd, &module)
}
```

Within the ApacheMain function, we attach the `register_hooks` callback to
the module. And after that, register our Swift module as a regular Apache
module.
When Apache starts up, it runs its configuration process (actually twice,
checkout the module devguide for more info).
A part of that is registering the module hooks, in our example:


#### register_hooks

```swift
fileprivate func register_hooks(pool: OpaquePointer?) {
  // hookup the handlers you want
  ap_hook_handler(mods_helloworldHandler, nil, nil, APR_HOOK_MIDDLE)
}
```

There are hooks which allow you to add callbacks to pretty much any part of
Apache (configuration, process handling, path translation, authorization, etc.).
In our simple case we just register a so called 'handler'.
Handlers are pretty similar to what one may know as Middleware from other
frameworks. And just like Middleware, they can decline to handle a request
(return DECLINED), or process it (return OK or an error code).
Lets look at our handler:

#### mods_helloworldHandler

Again, you can use any name. This is just a generated one. Also, you can have as
many handlers as you want!

```swift
func mods_helloworldHandler(p: UnsafeMutablePointer<request_rec>?) -> Int32 {
  var req = ApacheRequest(raw: p!)
  req.contentType = "text/html; charset=ascii"
...
  req.puts("<h3>Welcome to mods_helloworld</h3>")
...  
  return OK
}
```

The argument this function receives is the raw Apache C structure representing
the current HTTP request. First thing we do is wrap it in a `ApacheRequest`
Swift object, to make the API nicer (you can still call all Apache C API on the
raw pointer!).

Next we assign a content-type to the response (Apache uses a single object
to represent both, Request and Response) and write out some content using
`req.puts`.

Then we return `OK` to tell Apache that our handler processed the request and
no other content handler needs to run.


## Build Module

Now that we looked at the source, lets build the module:
`swift apache build` first invokes `swift build` and subsequently converts the
build results into an Apache module shared library (`mods_helloworld.so`).

```
$ swift apache build
Fetching https://github.com/modswift/Apache.git
Fetching https://github.com/modswift/CApache.git
Completed resolution in 3.65s
Cloning https://github.com/modswift/CApache.git
Resolving https://github.com/modswift/CApache.git at 2.0.1
Cloning https://github.com/modswift/Apache.git
Resolving https://github.com/modswift/Apache.git at 0.5.0
[2/2] Compiling Swift Module 'mods_helloworld' (1 sources)

$ ls -hl .build/mods_helloworld.so
-rwxr-xr-x  1 helge  staff   173K 12 Mai 15:29 .build/mods_helloworld.so
```

## Run Module

The `swift apache serve` command will generate an Apache configuration and
start Apache with it.
You can then access your module in the browser using either

  - HTTP: [http://localhost:8042/helloworld](http://localhost:8042/helloworld)
  - HTTPS / HTTP/2: [https://localhost:8442/helloworld](https://localhost:8442/helloworld)

```
$ swift apache serve
Note: DocRoot /usr/local/var/www/htdocs
Starting Apache on port 8042/8442:
GET /helloworld/ 200 715 - 0ms
```

Note of interest: `0ms`, the duration of the request. Yes, it is *that* fast ;-)

In case you wonder, the generated Apache configuration can be found in 
`.build/debug/apache.conf `.
