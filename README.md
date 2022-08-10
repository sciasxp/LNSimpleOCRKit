# LNSimpleOCRKit

[![Version](https://img.shields.io/github/v/release/sciasxp/LNSimpleOCRKit?include_prereleases)](https://github.com/sciasxp/LNSimpleOCRKit/releases/tag/v1.1.0)


With this project I tried to simplify, as much em possible, the use of Apple's OCR.

## Minimum Requirements

This framework will be usable by iOS 13 and above or MacOS 10.15 and above.

## Installing

### SPM

**LNSimpleOCRKit is available via SwiftPackage.**

Add the following to you Package.swift file's dependencies:

```swift
.package(url: "https://github.com/sciasxp/LNSimpleOCRKit.git", from: "1.1.0"),
```

### CocoaPods

To integrate LNSimpleOCRKit into your project using CocoaPods, specify it in your Podfile:

```Ruby
pod 'LNSimpleOCRKit'
```

## How to Use

```swift
import LNSimpleOCRKit
```

```swift
let ocrKit = LNSimpleOCRKit()
ocrKit.detectText(for: <#Your UIImage Here#>) { result in
    switch result {
    case .success(let text):
        print(text)
        
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

Done!

That's it, simple as that.

## Advanced Usage

There are some callbacks and configurations you can apply if you choose so.

### Configuration

Basically you can configura three elements of your OCR:
1. Accuracy
2. Language
3. Language Correction

To keep it simple, here goes an exemple:
```swift
let ocrConfiguration = OCRConfiguration(language: .english, type: .accurate, languageCorrection: true)
let ocrKit = LNSimpleOCRKit(configuration: ocrConfiguration)
```

### Callbacks

You are able to preprocess your image via closure if you so want.

Here how you do it:
```swift
let ocrConfiguration = OCRConfiguration(language: .english, type: .accurate, languageCorrection: true)
let ocrKit = LNSimpleOCRKit(preprocessor: { image in
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }, 
    configuration: ocrConfiguration)
```

Also post-process a detected text and display detection progress.

```Swift
let ocrKit = LNSimpleOCRKit()
ocrKit.detectText(for: image) { progress in
    print("Detection progress: \(progress * 100)%")
} postprocessor: { text in
    var processed = text
    processed = processed.trimmingCharacters(in: .whitespacesAndNewlines)
    return processed
} result: { result in
    switch result {
    case .success(let text):
        print(text)
        
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

### Other Public API

There is a method to receive all the raw observations ([VNRecognizedTextObservation]).

```Swift
let ocrKit = LNSimpleOCRKit()
ocrKit.recognizedObservations(for: image) { result in
    switch result {
    case .success(let observations):
        return observations
        
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

## Future Work
1. Improve unit tests.
2. Improve documentation.

## Contributing

You are most welcome in contributing to this project with either new features (maybe one mentioned from the future work or anything else), refactoring and improving the code. Also, feel free to give suggestions and feedbacks. 

Created with ❤️ by Luciano Nunes.

Get in touch on [Email](mailto: sciasxp@gmail.com)
Visit:  [LinkdIn](https://www.linkedin.com/in/lucianonunesdev/)

