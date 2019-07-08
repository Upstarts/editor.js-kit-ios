//
//  LinkBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public class LinkBlockContent: EJAbstractBlockContent {
    public let link: URL
    public var items: [LinkBlockContentItem]
    public var numberOfItems: Int { return items.count }
    
    public func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard index == 0 else { return nil }
        return items.first
    }
    
    enum CodingKeys: String, CodingKey { case link, meta }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        link = try container.decode(URL.self, forKey: .link)
        items = [ try container.decode(LinkBlockContentItem.self, forKey: .meta) ]
        items.forEach { $0.formattedLink = LinkFormatterService.format(link: link)}
    }
    
}

///
public class LinkBlockContentItem: EJAbstractBlockContentItem {
    private let title: String
    private let siteName: String?
    private let description: String?
    
    public let image: ImageFile?
    public var formattedLink: String?
    public var titleAttributedString: NSAttributedString?
    public var siteNameAttributedString: NSAttributedString?
    public var descriptionAttributedString: NSAttributedString?
    
    enum CodingKeys: String, CodingKey {
        case title, site_name, description, image
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        siteName = try container.decodeIfPresent(String.self, forKey: .site_name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        image = try container.decodeIfPresent(ImageFile.self, forKey: .image)
        if let style = EJKit.shared.style.getStyle(forBlockType: EJNativeBlockType.linkTool) as? LinkNativeStyle {
            titleAttributedString = title.convertHTML(font: style.titleFont)
            siteNameAttributedString = siteName?.convertHTML(font: style.titleFont)
            descriptionAttributedString = description?.convertHTML(font: style.descriptionFont)
        } else {
            titleAttributedString = nil
            siteNameAttributedString = nil
            descriptionAttributedString = nil
        }
    }
}


