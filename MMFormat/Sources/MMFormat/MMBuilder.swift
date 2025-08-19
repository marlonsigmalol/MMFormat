//
//  MMBuilder.swift
//  MMFormat
//
//  Created by Marlon Mawby on 19/8/2025.
//

import SwiftUI

public class MMBuilder {
    private var blocks: [MMBlock] = []
    
    public init() {}
    
    // MARK: - Blocks
    
    @discardableResult
    public func addTitle(_ inlines: [MMInline]) -> MMBuilder {
        blocks.append(.title(inlines))
        return self
    }
    
    @discardableResult
    public func addSubtitle(_ inlines: [MMInline]) -> MMBuilder {
        blocks.append(.subtitle(inlines))
        return self
    }
    
    @discardableResult
    public func addText(_ inlines: [MMInline]) -> MMBuilder {
        blocks.append(.text(inlines))
        return self
    }
    
    @discardableResult
    public func addList(_ items: [[MMInline]], ordered: Bool = false) -> MMBuilder {
        blocks.append(.list(items: items, ordered: ordered))
        return self
    }
    
    @discardableResult
    public func addQuote(_ inlines: [MMInline]) -> MMBuilder {
        blocks.append(.quote(inlines))
        return self
    }
    
    @discardableResult
    public func addCodeBlock(_ code: String) -> MMBuilder {
        blocks.append(.codeBlock(code))
        return self
    }
    
    @discardableResult
    public func addLink(label: String, action: String) -> MMBuilder {
        blocks.append(.link(label: label, action: action))
        return self
    }
    
    @discardableResult
    public func addDivider() -> MMBuilder {
        blocks.append(.divider)
        return self
    }
    
    @discardableResult
    public func addImage(name: String, alt: String? = nil) -> MMBuilder {
        blocks.append(.image(name: name, alt: alt))
        return self
    }
    
    // MARK: - Inline Helpers
    
    public func text(_ str: String) -> MMInline {
        return .text(str)
    }
    
    public func bold(_ inlines: [MMInline]) -> MMInline {
        return .bold(inlines)
    }
    
    public func italic(_ inlines: [MMInline]) -> MMInline {
        return .italic(inlines)
    }
    
    public func underline(_ inlines: [MMInline]) -> MMInline {
        return .underline(inlines)
    }
    
    public func color(_ color: Color, _ inlines: [MMInline]) -> MMInline {
        return .color(color, inlines)
    }
    
    public func code(_ str: String) -> MMInline {
        return .code(str)
    }
    
    public func link(_ label: String, _ action: String) -> MMInline {
        return .link(label: label, action: action)
    }
    
    public func sfSymbol(_ name: String) -> MMInline {
        return .sfSymbol(name)
    }
    
    public func image(_ name: String, alt: String? = nil) -> MMInline {
        return .image(name: name, alt: alt)
    }
    
    // MARK: - Build
    
    public func build() -> MMDocument {
        return MMDocument(blocks: blocks)
    }
}
