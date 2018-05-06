# glomex/content-sdk
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/glomex/content-sdk-ios.svg?style=flat)](https://travis-ci.org/glomex/content-sdk-ios)
[![Version](https://img.shields.io/cocoapods/v/glomex.svg?style=flat)](http://cocoapods.org/pods/glomex)
[![License](https://img.shields.io/cocoapods/l/glomex.svg?style=flat)](http://cocoapods.org/pods/glomex)
[![Platform](https://img.shields.io/cocoapods/p/glomex.svg?style=flat)](http://cocoapods.org/pods/glomex)

## Demo

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation
### Cocoapods
Content SDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'glomex/content-sdk'
```

### Carthage
Add `content-sdk` in your Cartfile.
```
github "glomex/content-sdk"
```
Run carthage to build the framework and drag the built content-sdk.framework into your Xcode project.

### Integration
`ContentSdk.load()` is used to load content. `Content` is passed to `callback` if content loaded successfully or `error` will be return to handle negative result

```swift
import glomex

var video: Content?
var errorDescription: String?

let config = ContentConfig(content_id: contentId, integration_id: integrationId, page_url: pageUrl)
player.playWithURL(URL(string: url)!)

ContentSdk.load(config: config) { [weak self] (content, error) in
    if let error = error {
        switch error {
        case ContentSdkError.configError:
            self?.errorDescription = "configError"
        case ContentSdkError.newrorkError:
            self?.errorDescription = "newrorkError"
        case ContentSdkError.serverError(let reason):
            self?.errorDescription = "serverError: \(reason)"
        default:
            break
        }
        return
    }
    self?.video = content
}
```
`Content` is used to get sources by `content.getSources()`

Track content events:
- `content.trackContentBegin()` to track content beginning event
- `content.trackAdBegin(adRollName: AdRollName.preroll)` to track ad beginning event by type

## Author

mrgerych@gmail.com,

## License

GlomexContentSdk is available under the MIT license. See the LICENSE file for more info.
