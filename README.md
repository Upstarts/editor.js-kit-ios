
<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://static.upstarts.work/ejkit/logo-dark.png?">
  <img src="https://static.upstarts.work/ejkit/logo-light.png?">
</picture>
</p>

<!--<p align="center">-->
<!--  <img src="https://static.upstarts.work/ejkit/logo-dark.png?#gh-dark-mode-only" width=400 />-->
<!--  <img src="https://static.upstarts.work/ejkit/logo-light.png?#gh-light-mode-only" width=400 />-->
<!--</p>-->

[![Version](https://img.shields.io/cocoapods/v/EditorJSKit.svg?style=flat)](https://cocoapods.org/pods/EditorJSKit)
[![License](https://img.shields.io/cocoapods/l/EditorJSKit.svg?style=flat)](https://cocoapods.org/pods/EditorJSKit)
[![Platform](https://img.shields.io/cocoapods/p/EditorJSKit.svg?style=flat)](https://cocoapods.org/pods/EditorJSKit)

## About

A non-official iOS Framework for [Editor.js](https://editorjs.io) - block styled editor. It's purpose to make easy use of rendering and parsing of blocks.

Converts clean json blocks data like [this](Example/EditorJSKit/EditorJSMock.json) into native views like that 👇

<p align="center">
  <img src="https://static.upstarts.work/ejkit/editorjs.kit-ios-scr.png?" width=420 />
</p>

#### Supported blocks
* 🎩 Header
* 🥑 Raw HTML
* 📷 Image
* 🖌 Delimiter
* 💌 Paragraph
* 🕸 Link
* 🌿 List

#### TODO's
* 📋 Table block support
* `UITableView` rendering
* Documentation on how to apply custom styles
* Documentation on how to create custom blocks
* Documentation on how to create custom renderers

## Developers note
Essentially the Kit is built on multiple levels of abstractions. It is pretty handy since it provides an ability to customize the behavior of rendering clean json data and adding custom blocks.

Note that the framework has a built-in protocol-oriented tools to implement your own adapters, renderers and custom blocks. These features are not documented yet, we're working on it. 

## Usage
For now we only support blocks rendering within a `UICollectionView` out of the box. If your collection view contains only EJ blocks, use `EJCollectionViewAdapter`, it encapsulates collection's dataSource and delegate and is super easy to use. 

Here's the example of `EJCollectionViewAdapter` usage: 

1. Decode your data (array of json blocks) with `EJBLockList` type (which is `Codable`). 

2. Store decoded blocks somewhere like `var blockList: EJBlockList`

3. Inside of your ViewController create a `collectionView`:
``` swift
lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
```

4. Create an adapter:
``` swift
lazy var adapter = EJCollectionViewAdapter(collectionView: collectionView)
```

5. Confirm to `EJCollectionDataSource` and return your parsed blocks in the `data` variable.
``` swift
extension ViewController: EJCollectionDataSource {
    var data: EJBlocksList? { blockList }
}
```

6. Assign your `ViewController` to `adapter`'s `dataSource`
``` swift
override func viewDidLoad() {
    super.viewDidLoad()
    adapter.dataSource = self
}
```

In case if you'd like to mix EJ blocks with some other cells, use `EJCollectionRenderer`. It provides you with more flexibility, here's how to use it:

1. Repeat steps 1-3 from the guide above.

2. Create a renderer:
``` swift
lazy var renderer = EJCollectionRenderer(collectionView: collectionView)
```

3. Implement and assign collection's data source and delegate methods.
``` swift
///
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return blockList.blocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockList.blocks[section].data.numberOfItems
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        do {
            return try renderer.render(block: blockList.blocks[indexPath.section], itemIndexPath: indexPath)
        }
        catch {
            // Ensure you won't ever get here
            return UICollectionViewCell()
        }
    }
}

///
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        do {
            return try renderer.size(forBlock: blockList.blocks[indexPath.section], itemIndexPath: indexPath, style: nil, superviewSize: collectionView.frame.size)
        } catch {
            return .zero
        }
    }
}
``` 


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

EditorJSKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EditorJSKit'
```

## Author

[Upstarts team](https://upstarts.work)

[Vadim Popov](https://t.me/popovvadim) - Architecture, implementation, code review

[Ivan Glushko](https://github.com/ivanglushko) - Implementation

