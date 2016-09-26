# EasyTransition
[![Build Status](https://travis-ci.org/indevizible/EasyTransition.svg?branch=master)](https://travis-ci.org/indevizible/EasyTransition.svg?branch=master)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EasyTransition.svg)](https://img.shields.io/cocoapods/v/EasyTransition.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/indevizible/EasyTransition/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/EasyTransition.svg?style=flat)](http://cocoadocs.org/docsets/EasyTransition)
[![Twitter](https://img.shields.io/badge/twitter-@indevizible-blue.svg?style=flat)](http://twitter.com/indevizible)

EasyTransition is a simple library for make a transition in iOS.

![example](https://raw.githubusercontent.com/indevizible/EasyTransition/master/EasyTransition.gif)

[Live preview](https://appetize.io/app/jc8dgwd8rfhzxtna06e1b4bz9w)

## Features
- [x] Transition from corners
- [x] Interactive dismissal transition
- [x] Scalable to background view controller
- [x] Blur Effect
- [ ] In-Out transition direction

## Limitation

- This library can be compile with iOS 8.0+ but transition work on iOS 8.3+

## Requirements
- Swift 2+ (use v.1.2)
- Swift 3 (2.0)
- iOS 8.3+

##  Installation
You can install this library in 2 ways

### Manually

Copy [EasyTransition.swift](EasyTransition/EasyTransition.swift) and [UIView+Constraints.swift](EasyTransition/UIView+Constraints.swift) to your project and give me some beer.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate EasyTransition into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'EasyTransition', '~> 2.0'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate EasyTransition into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "indevizible/EasyTransition" ~> 2.0
```

Run `carthage update` to build the framework and drag the built `EasyTransition.framework` into your Xcode project.

## Usage
Import and declare EasyTransition:
```swift
import EasyTransition

class ViewController: UIViewController {
  var transition: EasyTransition?
}
```
Customise transition and present normally:

```swift
let vc = TargetViewController()
transition = EasyTransition(attachedViewController: vc)
transition?.transitionDuration = 0.4
transition?.direction = .right
transition?.margins = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
present(vc, animated: true, completion: nil)
```
You can also make a direction from a corner:
```swift
transition?.direction = [.top,.right]
```
And more on EasyTransitionExample.xcodeproj

## Sources Used
- www.subtlepatterns.com
- www.unsplash.com
- [Alamofire/Alamofire](https://github.com/Alamofire/Alamofire) for CocoaPods and Carthage description
- [prolificinteractive/NavigationControllerBlurTransition](https://github.com/prolificinteractive/NavigationControllerBlurTransition) for [UIView+Constraints.swift](https://github.com/prolificinteractive/NavigationControllerBlurTransition/blob/master/Pod/Classes/UIView%2BConstraints.swift)

## Author

Nattawut Singhchai, wut@indevizible.com

## License

EasyTransition is available under the MIT license. See the [LICENSE file](LICENSE).

