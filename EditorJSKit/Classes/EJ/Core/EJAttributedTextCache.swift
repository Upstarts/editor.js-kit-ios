//
//  EJAttributedTextCache.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 26.08.2026.
//

import UIKit

///
/// Caches the NSAttributedString produced by parsing a block's HTML, keyed by the font it was
/// parsed with, so that a style change re-parses the text instead of showing a stale string.
///
/// Parsing HTML spins a nested run loop (NSHTMLReader runs on WebKit). Doing that while the
/// collection view has a dequeued cell outstanding crashes UIKit, so the renderer prepares these
/// caches before dequeuing a cell — see issues #31 and #33. A failed parse is recorded as well,
/// so it is not retried on every dequeue.
final class EJAttributedTextCache {
    private(set) var attributedString: NSAttributedString?
    private var parsedFontKey: String?

    /// Stores an externally provided value. It carries no font key, so `prepare` trusts it as-is.
    func store(_ attributedString: NSAttributedString?) {
        self.attributedString = attributedString
        parsedFontKey = nil
    }

    /// Parses `html` with `font` unless the cache is already up to date for that font.
    func prepare(html: String, font: UIFont, forceFontFace: Bool = false) {
        let fontKey = "\(font.fontName)/\(font.pointSize)"
        guard parsedFontKey != fontKey else { return }
        // A value without a font key was stored externally — keep it.
        guard parsedFontKey != nil || attributedString == nil else { return }
        attributedString = html.convertHTML(font: font, forceFontFace: forceFontFace)
        parsedFontKey = fontKey
    }
}
