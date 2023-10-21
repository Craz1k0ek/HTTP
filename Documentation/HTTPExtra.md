#  HTTPExtra

The HTTPExtra target provides some utility functionality to enhance your network stack creation experience. 

## Extensions

You are now able to create a URL from a `String` without having to unwrap the result. 
This is done by leveraging the `StaticString`. 
This means that you as a developer are responsible for providing the correct URL, 
or the app can still crash!

```swift
let url = URL("https://www.thinkerium.com/")
```

## Requests & responses

Some of the `URLSession` objects have been made available for use by the `HTTPSession` object. 
Both the `URL` object as well as the `URLRequest` object are now conform `HTTPRequestConvertible`.
This allows you to easily get started with the HTTP package, wihtout major changes.

For the responses we've made both `Data` and `String` conform to `HTTPResponseConvertible`. 
The latter one attempts to use the text encoding of the response during decoding.
If the encoding is missing, UTF-8 is assumed.

## URLSession

Finally, we've also made the `URLSession` conform to `HTTPSession`. This way, you can quickly
get started with the HTTP package!
