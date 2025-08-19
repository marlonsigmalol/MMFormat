//
//  MMModel.swift
//  MMFormat
//
//  Created by Marlon Mawby on 19/8/2025.
//

import SwiftUI

// MARK: - MM Document Root

/// A parsed MM document consisting of blocks
public struct MMDocument: Identifiable {
    public let id = UUID()
    public var blocks: [MMBlock]
    
    public init(blocks: [MMBlock]) {
        self.blocks = blocks
    }
}

// MARK: - Block Level Elements

/// Block-level MM elements (big structural units)
public enum MMBlock: Identifiable {
    case title([MMInline])                        // Large title text
    case subtitle([MMInline])                     // Smaller title
    case text([MMInline])                         // Body paragraph
    case list(items: [[MMInline]], ordered: Bool) // Bullet or numbered list
    case quote([MMInline])                        // Quoted block
    case codeBlock(String)                        // Monospaced block
    case link(label: String, action: String)      // Action link
    case divider                                 // Horizontal line
    case image(name: String, alt: String?)        // Embedded image or asset
    case meta([String: String])                   // Metadata like version, author
    case style([String: String])                  // Style hints (font, spacing, etc.)
    
    public var id: UUID { UUID() }
}

// MARK: - Inline Level Elements

/// Inline MM elements (live inside titles/text/quotes/etc.)
public enum MMInline {
    case text(String)                             // Plain text
    case sfSymbol(String)                         // Inline SF Symbol
    case bold([MMInline])                         // Bold inline span
    case italic([MMInline])                       // Italic inline span
    case underline([MMInline])                    // Underlined inline span
    case color(Color, [MMInline])                 // Colored text span
    case code(String)                             // Inline monospaced code
    case link(label: String, action: String)      // Inline tappable link
    case image(name: String, alt: String?)        // Inline image/asset
}

// MARK: - Helpers

extension MMBlock {
    /// Convenience method: return a short preview text for debugging
    public var summary: String {
        switch self {
        case .title(let inlines): return "TITLE: \(inlines.map(\.plainText).joined())"
        case .subtitle(let inlines): return "SUBTITLE: \(inlines.map(\.plainText).joined())"
        case .text(let inlines): return "TEXT: \(inlines.map(\.plainText).joined())"
        case .list(let items, let ordered):
            let prefix = ordered ? "Ordered List" : "Unordered List"
            return "\(prefix) (\(items.count) items)"
        case .quote(let inlines): return "QUOTE: \(inlines.map(\.plainText).joined())"
        case .codeBlock(let str): return "CODEBLOCK: \(str.prefix(20))..."
        case .link(let label, _): return "LINK: \(label)"
        case .divider: return "DIVIDER"
        case .image(let name, _): return "IMAGE: \(name)"
        case .meta(let dict): return "META: \(dict)"
        case .style(let dict): return "STYLE: \(dict)"
        }
    }
}

extension MMInline {
    /// Convert inline to plain text (ignores styling/symbols/images)
    public var plainText: String {
        switch self {
        case .text(let str): return str
        case .sfSymbol(let name): return "[\(name)]"
        case .bold(let children): return children.map(\.plainText).joined()
        case .italic(let children): return children.map(\.plainText).joined()
        case .underline(let children): return children.map(\.plainText).joined()
        case .color(_, let children): return children.map(\.plainText).joined()
        case .code(let str): return str
        case .link(let label, _): return label
        case .image(_, let alt): return alt ?? ""
        }
    }
}
