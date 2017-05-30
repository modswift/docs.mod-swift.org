# Apache Configuration Templates

mod_swift **does not require** any configuration. Within your Apache module,
you can just run

    swift apache serve

and it'll derive a configuration from the module setup (i.e. issue proper
LoadModule directives, configure a document root, HTTP/2 and so on).

However, if you desire, you can tweak that process using mod_swift
configuration templates.

## Configuration Templates

### System Templates

The global Apache configuration is derived from the templates installed in
`{install-prefix}/lib/mod_swift/apache-config-templates/`.
It contains debug/release versions as well as versions for macOS Homebrew
and Ubuntu.

### Full Override: `apache.conf`

If you don't want **any** auto-configuration by `swift apache serve`,
you can place a file called `apache.conf` into your module directory.
If that exists, no configuration templating will happen, it is all
up to you.

### Custom Templates

If the module directory contains a `apache-template.conf`, that is going to
be used instead of the System Templates mentioned above.

Either that or a system template is used as the basis. If it doesn't contain
a `LoadModule swift_module`, that will get attached next.

In the next step the configuration will check for `{modulename}.conf`
and `{modulename}-template.conf` within your Swift Apache module directory.
For example `mods_helloworld-template.conf`.

One of the two is a good place to do additional configuration.

### Example Template

A config template is a great way to configure 
[Apache mod_dbd](https://httpd.apache.org/docs/2.4/mod/mod_dbd.html)
for the module.

If the module is called `mods_testdb`, create a new file called 
`mods_testdb-template.conf` with the necessary database configuration.
For example to configure Apache to access a SQLite3 database living within the
`data` directory of your module source:

```
LoadModule dbd_module %APACHE_MODULE_DIR%/mod_dbd.so

<IfModule dbd_module>
  DBDriver  sqlite3
  DBDParams "%SRCROOT%/data/MyDatabase.sqlite3"
</IfModule>
```

Note how the `%APACHE_MODULE_DIR%` variable is used to refer to the module
location.
Also note how `%SRCROOT%` is used to refer to the SQLite3 database file. This
is necessary, because mod_dbd requires an *absolute* path to the database file
(i.e. a relative path like `"data/MyDatabase.sqlite3"` doesn't work).


## Template Variables

  - %SRCROOT%
  - %APACHE_PREFIX%
  - %APACHE_PORT%
  - %APACHE_SSL_PORT%
  - %APACHE_PIDFILE%
  - %APACHE_DOCROOT%
  - %APACHE_MODULE_RELDIR%
  - %APACHE_MODULE_DIR%
  - %APACHE_SERVER_CERT_DIR%
  - %APACHE_SERVER_CERT%
  - %APACHE_SERVER_KEY%
  - %APACHE_HTTP2_LOAD_COMMAND%
  - %CONFIGURATION_BUILD_DIR%

## Document Root Lookup

mod_swift will look into the SRCROOT of the package and check for the
availability of those directories:

  - htdocs/
  - www/
  - public/
  
So within modules, you can just create a `public` directory, and Apache
will be configured to serve static files from there.

If none of those directories are available, it'll use whatever 
`apxs -q htdocsdir` has as the document root.
