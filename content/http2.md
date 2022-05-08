# HTTP/2

If your server provides the `mod_http2` module, `swift apache` will
automatically pick it up, configure a development SSL certificate and
the HTTP/2 module.

## Check whether HTTP/2 is available

To check whether mod_swift did detect the HTTP/2 module successfully, you can
run:

```
$ swift apache validate
swift-driver version: 1.45.2 The Swift Apache build environment looks sound.

  srcroot:   /Users/helge/tmp/mods_helloworld
  module:    mods_helloworld
  config:    debug
  product:   /Users/helge/tmp/mods_helloworld/.build/mods_helloworld.so
  apxs:      /opt/homebrew/bin/apxs
  moddir:    /opt/homebrew/lib/httpd/modules
  relmoddir: /
  mod_swift: /opt/homebrew/opt/mod_swift
  swift:     5.6.0
  cert:      self-signed-mod_swift-localhost-server.crt
  http/2:    yes
```

Look for the last line and check whether it says `yes`.

## Useful tools

### Chrome Developer Tools

You can use the `Network` tab in the Chrome Developer Tools to check whether
requests are done using HTTP/2. Right click the table view and select
'Protocol'.

### curl w/ HTTP/2 support

The system `curl` now comes with HTTP/2 support by default on macOS 12.

```shell
curl -v --insecure --http2 https://localhost:8442/hello
```
(--insecure is needed if you use it w/ the self-signed certificate coming w/
 mod_swift)

You can scan the output of curl to see whether it is actually using HTTP/2:

```
...
* ALPN, offering h2
* ALPN, offering http/1.1
...
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
...
> GET /hello HTTP/2
...
< HTTP/2 200
...
```


## Links

  - [how to h2 in apache](https://icing.github.io/mod_h2/howto.html)
