# Database Access using mod_dbd

A feature of Apache 2 known to few is
[mod_dbd](https://httpd.apache.org/docs/2.4/mod/mod_dbd.html).
Using that you can configure a SQL database connection within the 
[Apache.conf](https://github.com/AlwaysRightInstitute/mod_swift/blob/master/apache.conf#L79)
and use that within all your Apache modules/handlers.

**Note**: Shown below is pretty raw access to mod_dbd as provided by the
          mod_swift [Apache](https://github.com/modswift/Apache) wrapper
          module.
          You can use [ApacheExpress](http://apacheeexpress.io) to access
          databases using the [ZeeQL](http://zeeql.io/) library,
          which is way more convenient.

This will setup a directory as a barebones Swift Apache module (try ApacheExpress for a higher level API!)

Though you can also write your own, Apache 2 comes with drivers for 
[SQLite3](https://www.sqlite.org), 
[PostgreSQL](http://postgresql.org),
MySQL and Oracle.
The macOS system Apache and the one than can be tapped in Homebrew
includes SQLite3.
On Linux you can easily install the ones you want:

    sudo apt-get install libaprutil1-dbd-sqlite3 libaprutil1-dbd-pgsql

Your Swift Apache module doesn't need to concern itself with the database type
or connection, it can just ask Apache for a connection and it'll happily
return one from its pool.
The code looks like this:

    guard let con = req.dbdAcquire()                 else { return ... }
    guard let res = con.select("SELECT * FROM pets") else { return ... }
    
    while let row = res.next() {
      req.puts("<li>\(row[0])</li>")
    }

So how does Apache know how to connect and all that? As everything in Apache,
the admin can configure that in the apache.conf:

    <IfModule dbd_module>
      DBDriver  sqlite3
      DBDParams "/var/data/testdb.sqlite3"
    </IfModule>

Or to access your favorite OpenGroupware.org database using PostgreSQL:

    <IfModule dbd_module>
      DBDriver pgsql
      DBDParams "host=127.0.0.1 port=5432 dbname=OGo user=OGo password=OGo"

      # Connection Pool Management
      DBDMin      1
      DBDKeep     2
      DBDMax     10
      DBDExptime 60
    </IfModule>

You get the idea. We provide a simple wrapper for the select query shown as
part of our [Apache](https://github.com/modswift/Apache) module.


2019-08-14: Homebrew has removed support for apr-util DBD drivers except
SQLite:
[PR #31799](https://github.com/Homebrew/homebrew-core/pull/31799/commits/584a9faa5c2decf32f25bb9d5f028395bb93ab5f).
To fix that, you can manually install `apr-util` with the `--with-pgsql`
option (or any other driver you want to build).
Then just hack-link the driver you want into the Homebrew install, e.g.:
```
pushd /usr/local//opt/apr-util/libexec/lib/apr-util-1/
ln -s /usr/local/apr/lib/apr-util-1/apr_dbd_pgsql*.so .
```