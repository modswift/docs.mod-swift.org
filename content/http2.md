# HTTP/2

If your server provides the `mod_http2` module, `swift apache` will
automatically pick it up, configure a development SSL certificate and
the HTTP/2 module.

## Check whether HTTP/2 is available

To check whether mod_swift did detect the HTTP/2 module successfully, you can
run:

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

Look for the last line and check whether it says `yes`.

## Install the Homebrew Apache w/ HTTP/2

Before you install mod_swift, we highly recommend that you install or reinstall
the Homebrew Apache w/ HTTP/2 and the MPM event module:

    brew reinstall httpd --with-mpm-event --with-http2

You can also add `--with-privileged-ports` if you want to use such.

## Useful tools

### Chrome Developer Tools

You can use the `Network` tab in the Chrome Developer Tools to check whether
requests are done using HTTP/2. Right click the table view and select
'Protocol'.

### curl w/ HTTP/2 support

On Homebrew you can easily install `curl` with HTTP/2 support:

    brew reinstall curl --with-nghttp2 --with-openssl

*IMPORTANT*: curl is Cellar only w/ Homebrew. To invoke it either adjust your
`PATH` to include `/use/local/opt/curl/bin` or invoke curl with the full path:

```shell
/usr/local/opt/curl/bin/curl -v --insecure --http2 https://localhost:8442/hello
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
