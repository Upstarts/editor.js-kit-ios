//
//  ImageBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
open class ImageBlockContent: EJAbstractBlockContent {
    open var items: [ImageBlockContentItem]
    open var numberOfItems: Int { return items.count }
    
    required public init(from decoder: Decoder) throws {
        items = [ try ImageBlockContentItem(from: decoder)]
    }
    
    open func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
    
}

///
public class ImageBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey { case file, caption, withBorder,stretched, withBackground }
    public let file: ImageFile
    public let caption: String
    public let withBorder: Bool
    public let stretched: Bool
    public let withBackground: Bool
    public var attributedString: NSAttributedString?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        file = try container.decode(ImageFile.self, forKey: .file)
        caption = try container.decode(String.self, forKey: .caption)
        withBorder = try container.decode(Bool.self, forKey: .withBorder)
        stretched = try container.decode(Bool.self, forKey: .stretched)
        withBackground = try container.decode(Bool.self, forKey: .withBackground)
        
        if let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.image) as? EJImageBlockStyle {
            attributedString = caption.convertHTML(font: style.font)
        }
    }
}

///
public class ImageFile: Decodable {
    enum CodingKeys: String, CodingKey { case url }
    
    public let url: URL
    public var imageData: Data?
    public var callback: (() -> Void)?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
        DataDownloaderService.downloadFile(at: url) { data in
            self.imageData = data
            self.callback?()
        }
    }
}
