//
//  LinkBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public class LinkBlockContent: EJAbstractBlockContentSingleItem {
    public private(set) var item: EJAbstractBlockContentItem
    public let link: URL
    
    enum CodingKeys: String, CodingKey { case link, meta }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        link = try container.decode(URL.self, forKey: .link)
        let item = try container.decode(LinkBlockContentItem.self, forKey: .meta)
        item.link = link
        item.formattedLink = LinkFormatterService.format(link: link)
        self.item = item
    }
}

///
public class LinkBlockContentItem: EJAbstractBlockContentItem {
    public var link: URL?
    
    private let title: String
    private let siteName: String?
    private let description: String?
    
    public let image: ImageFile?
    public var formattedLink: String?
    
    var cachedTitleAttributedString: NSAttributedString?
    var cachedSiteNameAttributedString: NSAttributedString?
    var cachedDescriptionAttributedString: NSAttributedString?
    
    enum CodingKeys: String, CodingKey {
        case title, site_name, description, image
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        siteName = try container.decodeIfPresent(String.self, forKey: .site_name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        image = try container.decodeIfPresent(ImageFile.self, forKey: .image)
    }
    
    func prepareCachedStrings(withStyle style: EJLinkBlockStyle) {
        if cachedTitleAttributedString == nil {
            cachedTitleAttributedString = title.convertHTML(font: style.titleFont)
        }
        
        if cachedSiteNameAttributedString == nil {
            cachedSiteNameAttributedString = siteName?.convertHTML(font: style.titleFont)
        }
        
        if cachedDescriptionAttributedString == nil {
            cachedDescriptionAttributedString = description?.convertHTML(font: style.descriptionFont)
        }
    }
}
