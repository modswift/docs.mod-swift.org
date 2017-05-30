# ApacheExpress

[ApacheExpress](http://apacheexpress.io/) is a framework layering on top of 
mod_swift.
It makes it very easy to quickly build reliable and feature rich Swift server
applications from within Xcode or using the Swift Package Manager.
It supports convenient database access using Apache mod_dbd.
And well, can be used together with all the other regular Apache modules.

Example:

```swift
public func ApacheMain(_ cmd: OpaquePointer) {
  let app = ApacheExpress.express(cmd)
  
  app.use(cookieParser())
  
  app.get("/cookies.json") { req, res, next in
    try res.json(req.cookies)
  }
  
  app.get("/") { req, res, next in
    let values : [ String : Any ] = [
      "cowOfTheDay" : cows.vaca()
    ]
    try res.render("index", values)
  }
}
```


  - [ApacheExpress Homepage](http://apacheexpress.io/)
  - [ApacheExpress Documentation](http://docs.apacheexpress.io/)
