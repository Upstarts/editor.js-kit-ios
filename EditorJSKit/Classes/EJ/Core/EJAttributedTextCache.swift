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
/// Assigning nil through the owning item's property invalidates the cache outright.
///
/// Parsing HTML spins a nested run loop (NSHTMLReader runs on WebKit). Doing that while the
/// collection view has a dequeued cell outstanding crashes UIKit, so the renderer prepares these
/// caches before dequeuing a cell — see issues #31 and #33. A failed parse is recorded as well,
/// so it is not retried on every dequeue.
///
/// A string assigned from outside takes precedence over the parsed one, but only for the style in
/// effect when it is first used: once the style changes, the assignment expires and the text is
/// parsed again. Otherwise a single assignment would silently freeze the item's appearance for
/// good — see issue #34.
final class EJAttributedTextCache {
    private var parsedString: NSAttributedString?
    private var parsedFontKey: String?

    private var assignedString: NSAttributedString?
    /// The font the assignment was first used with; nil while it has not been used yet.
    private var assignedFontKey: String?

    var attributedString: NSAttributedString? { assignedString ?? parsedString }

    /// Stores an externally provided string, which wins over parsing until the style changes.
    /// Assigning nil is the explicit invalidation gesture: it drops the parsed string as well, so
    /// the next `prepare` genuinely re-parses rather than returning the previous result.
    func store(_ attributedString: NSAttributedString?) {
        assignedString = attributedString
        assignedFontKey = nil
        if attributedString == nil {
            parsedString = nil
            parsedFontKey = nil
        }
    }

    /// Parses `html` with `font` unless the cache is already up to date for that font.
    func prepare(html: String, font: UIFont, forceFontFace: Bool = false) {
        let fontKey = "\(font.fontName)/\(font.pointSize)/\(forceFontFace)"

        if assignedString != nil {
            if assignedFontKey == nil {
                // First use: the assignment describes how things look right now.
                assignedFontKey = fontKey
            } else if assignedFontKey != fontKey {
                // The style moved on; correctness wins over the stale assignment.
                assignedString = nil
                assignedFontKey = nil
            }
        }

        guard parsedFontKey != fontKey else { return }
        parsedString = html.convertHTML(font: font, forceFontFace: forceFontFace)
        parsedFontKey = fontKey
    }
}
