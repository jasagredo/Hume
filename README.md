# Hume

This project implements the [Hungarian method](https://en.wikipedia.org/wiki/Hungarian_algorithm) solver.

It can handle not balanced cost matrix and is prepared for minimization although maybe in the future it could be extended to support maximization.

## Installation

This doesn't work yet (but it will).

You can use the Swift Package Manager to install HungarianSolver by adding the proper description to your Package.swift file:

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/Jasagredo/Hume.git", from: "1.0.2"),
    ]
)
```

## Usage

Once the Hume class is imported, just declare a solver and ask for a solution. The algorithm runs in O(n^3).

```swift
var h = HunSolver(matriz: mat)
print(h.resuelve())
```

## Future work

- [ ] Actually convert this into a library
- [ ] Allow minimization problems
- [ ] Check NaN and Inf costs
- [ ] Translate methods and variables to English

## License

HungarianSolver is under MIT license. Check LICENSE for more details.
