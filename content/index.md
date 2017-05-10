# mod_swift Documentation

**mod_swift** is a technology demo which shows how to write native modules
for the
[Apache Web Server](https://httpd.apache.org)
in the 
[Swift](http://swift.org/)
programming language.
The demo includes a 
[C module to load Swift modules](https://github.com/AlwaysRightInstitute/mod_swift/blob/master/mod_swift/README.md),
a [basic demo module](https://github.com/AlwaysRightInstitute/mod_swift/blob/master/mods_baredemo/README.md),
the [ApacheExpress](https://github.com/AlwaysRightInstitute/mod_swift/blob/master/ApacheExpress/README.md) framework which provides an Express 
like API for mod_swift,
a [demo for ApacheExpress](https://github.com/AlwaysRightInstitute/mod_swift/blob/master/mods_expressdemo/README.md),
a [Todo MVC](https://github.com/AlwaysRightInstitute/mod_swift/blob/master/mods_todomvc/README.md) backend,
and a few supporting libraries
(such as Freddy or Noze.io [Mustache](https://github.com/AlwaysRightInstitute/mod_swift/blob/master/ThirdParty/mustache/README.md)).

<center>*Server Side Swift the right way.*</center>

## What is an Apache module?

Apache is a highly modular and efficient server framework. The httpd
daemon itself is quite tiny and pretty much all webserver functionality is
actually implemented in the form of
[modules](https://httpd.apache.org/docs/2.4/mod/).
Be it thread handling, access control, mime detection or content negotation -
all of that is implemented as modules. And can be replaced by own modules!

The Apache core modules are written in portable C. Some modules are built
right into the server, but most are loaded as
[dynamic libraries](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/DynamicLibraries/000-Introduction/Introduction.html).
Which ones is specified by the user in the
[configuration file](https://httpd.apache.org/docs/2.4/configuring.html),
for example:

    LoadModule authz_core_module /usr/libexec/apache2/mod_authz_core.so
    LoadModule mime_module       /usr/libexec/apache2/mod_mime.so

Now with **mod_swift** you can write such modules using the
[Swift](http://swift.org/)
programming language. Enter:

    LoadSwiftModule ApacheMain /usr/libexec/apache2/mods_demo.so

This is a little different to something like `mod_php` which enables Apache
to directly interpret PHP scripts. `mod_php` itself is C software and a single
module.
Since Swift compiles down to regular executable binaries,
and because Swift has excellent 
[C integration](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithCAPIs.html#//apple_ref/doc/uid/TP40014216-CH8-ID17),
you can write arbitrary modules with **mod_swift** which behave just like the
regular C modules.

## Installation

Competently unleash value-added deliverables vis-a-vis error-free e-commerce. Objectively promote one-to-one e-business vis-a-vis standardized process improvements. Collaboratively visualize wireless leadership rather than market-driven mindshare. Seamlessly seize client-based models via pandemic channels. 

Intrinsicly customize backend partnerships whereas enabled materials. Collaboratively envisioneer B2C opportunities for quality experiences. Proactively predominate long-term high-impact users before value-added relationships.
