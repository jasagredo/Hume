# Hume  
[![Build Status](https://travis-ci.org/Jasagredo/Hume.svg?branch=master)](https://travis-ci.org/Jasagredo/Hume)

This project implements the [Hungarian method](https://en.wikipedia.org/wiki/Hungarian_algorithm) solver.

It can handle not balanced cost matrix and is prepared for minimization although maybe in the future it could be extended to support maximization.

## Installation

You can use the Swift Package Manager to install HungarianSolver by adding the proper description to your Package.swift file:

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/Jasagredo/Hume.git", from: "0.0.4"),
    ]
)
```

## Usage

Once the Hume class is imported, just declare a solver and ask for a solution. The algorithm runs in O(n^3).

```swift
var h = HunSolver(matrix: mat)
print(h.solve())
```

## Future work

- [x] Actually convert this into a library
- [x] Allow minimization problems
- [x] Check NaN and Inf costs
- [x] Translate methods and variables to English

## License

HungarianSolver is under MIT license. Check LICENSE for more details.
