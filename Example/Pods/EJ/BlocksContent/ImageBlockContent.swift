//
//  ImageBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
class ImageBlockContent: EJAbstractBlockContent {
    var items: [ImageBlockContentItem]
    var numberOfItems: Int { return items.count }
    
    required public init(from decoder: Decoder) throws {
        items = [ try ImageBlockContentItem(from: decoder)]
    }
    
    func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
    
}

///
public class ImageBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey { case file, caption, withBorder,stretched, withBackground }
    let file: ImageFile
    let caption: String
    let withBorder: Bool
    let stretched: Bool
    let withBackground: Bool
    public var attributedString: NSAttributedString?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        file = try container.decode(ImageFile.self, forKey: .file)
        caption = try container.decode(String.self, forKey: .caption)
        withBorder = try container.decode(Bool.self, forKey: .withBorder)
        stretched = try container.decode(Bool.self, forKey: .stretched)
        withBackground = try container.decode(Bool.self, forKey: .withBackground)
        
        if let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.image) as? ImageNativeStyle {
            attributedString = caption.convertHTML(font: style.font)
        }
    }
}

///
class ImageFile: Decodable {
    let url: URL
    var imageData: Data?
}
