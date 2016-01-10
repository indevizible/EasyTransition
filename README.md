# EasyTransition
[![Build Status](https://travis-ci.org/indevizible/EasyTransition.svg)](https://travis-ci.org/indevizible/EasyTransition)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/EasyTransition.svg)](https://img.shields.io/cocoapods/v/EasyTransition.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/indevizible/EasyTransition/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/EasyTransition.svg?style=flat)](http://cocoadocs.org/docsets/EasyTransition)
[![Twitter](https://img.shields.io/badge/twitter-@indevizible-blue.svg?style=flat)](http://twitter.com/indevizible)

EasyTransition is a simple library for make a transition in iOS.

![example](https://raw.githubusercontent.com/indevizible/EasyTransition/master/EasyTransition.gif)

Live preview : https://appetize.io/app/r9whewdb992hymjtznbdn2gbvr

## Features
- [x] Transition from corners
- [x] Interactive dismissal transition

## Requirements
Swift 2 or later
iOS 8.0+

##  Installation
You can install this library in 2 ways

### Manually

Copy this [file](EasyTransition/EasyTransition.swift) to your project and give me some beer.

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

pod 'EasyTransition', '~> 1.0'
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
github "indevizible/EasyTransition" ~> 1.0
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
transition?.direction = .Right
transition?.margins = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
presentViewController(vc, animated: true, completion: nil)
```
You can also make a direction from a corner:
```swift
transition?.direction = [.Top,.Right]
```
And more on EasyTransitionExample.xcodeproj

## Sources Used
Background Images: www.subtlepatterns.com

[Alamofire](https://github.com/Alamofire/Alamofire) for Cocoapods and Carthage description

## The MIT License (MIT)

Copyright (c) 2016 Nattawut Singhchai

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
