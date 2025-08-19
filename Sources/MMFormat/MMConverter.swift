//
//  MMConverter.swift
//  MMFormat
//
//  Created by Marlon Mawby on 19/8/2025.
//

import SwiftUI

public struct MMConverter {
    
    // MARK: - Public API
    
    /// Parse raw MM string into a document
    public static func parse(_ input: String) -> MMDocument {
        let lines = input.split(separator: "\n", omittingEmptySubsequences: false)
        var blocks: [MMBlock] = []
        var currentCodeBlock: [String]? = nil
        
        for rawLine in lines {
            let line = rawLine.trimmingCharacters(in: .whitespaces)
            
            // Detect code block toggles
            if line.starts(with: "```") {
                if let active = currentCodeBlock {
                    // close block
                    blocks.append(.codeBlock(active.joined(separator: "\n")))
                    currentCodeBlock = nil
                } else {
                    // open block
                    currentCodeBlock = []
                }
                continue
            }
            
            if var code = currentCodeBlock {
                code.append(String(rawLine))
                currentCodeBlock = code
                continue
            }
            
            // Skip empty line -> paragraph spacing
            if line.isEmpty { continue }
            
            // Block detection
            if line.starts(with: "# ") {
                blocks.append(.title(parseInlines(String(line.dropFirst(2)))))
            } else if line.starts(with: "## ") {
                blocks.append(.subtitle(parseInlines(String(line.dropFirst(3)))))
            } else if line.starts(with: "- ") {
                let item = parseInlines(String(line.dropFirst(2)))
                if case .list(var items, let ordered) = blocks.last {
                    items.append(item)
                    blocks[blocks.count - 1] = .list(items: items, ordered: ordered)
                } else {
                    blocks.append(.list(items: [item], ordered: false))
                }
                let numPrefix = line.prefix(while: { $0.isNumber })
                if !numPrefix.isEmpty,
                   line.dropFirst(numPrefix.count).trimmingCharacters(in: .whitespaces).starts(with: ". ") {
                    let item = parseInlines(String(line.dropFirst(numPrefix.count + 2)))
                    if case .list(var items, let ordered) = blocks.last, ordered {
                        items.append(item)
                        blocks[blocks.count - 1] = .list(items: items, ordered: true)
                    } else {
                        blocks.append(.list(items: [item], ordered: true))
                    }
                }

            } else if line.starts(with: "> ") {
                blocks.append(.quote(parseInlines(String(line.dropFirst(2)))))
            } else if line == "---" {
                blocks.append(.divider)
            } else if line.starts(with: "[META:") {
                let content = line.dropFirst(6).dropLast()
                let pairs = content.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
                var dict: [String: String] = [:]
                for pair in pairs {
                    let comps = pair.split(separator: "=")
                    if comps.count == 2 {
                        dict[String(comps[0]).trimmingCharacters(in: .whitespaces)] =
                        String(comps[1]).trimmingCharacters(in: .whitespaces)
                    }
                }
                blocks.append(.meta(dict))
            } else if line.starts(with: "[STYLE:") {
                let content = line.dropFirst(7).dropLast()
                let pairs = content.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
                var dict: [String: String] = [:]
                for pair in pairs {
                    let comps = pair.split(separator: "=")
                    if comps.count == 2 {
                        dict[String(comps[0]).trimmingCharacters(in: .whitespaces)] =
                        String(comps[1]).trimmingCharacters(in: .whitespaces)
                    }
                }
                blocks.append(.style(dict))
            } else if line.starts(with: "[LINK:") {
                // [LINK: label|action]
                let content = line.dropFirst(6).dropLast()
                let comps = content.split(separator: "|")
                if comps.count == 2 {
                    blocks.append(.link(label: String(comps[0]), action: String(comps[1])))
                }
            } else if line.starts(with: "[IMAGE:") {
                // [IMAGE: name|alt]
                let content = line.dropFirst(7).dropLast()
                let comps = content.split(separator: "|")
                if comps.count == 2 {
                    blocks.append(.image(name: String(comps[0]), alt: String(comps[1])))
                } else if comps.count == 1 {
                    blocks.append(.image(name: String(comps[0]), alt: nil))
                }
            } else {
                // Default paragraph
                blocks.append(.text(parseInlines(line)))
            }
        }
        
        // Close stray code block if any
        if let code = currentCodeBlock {
            blocks.append(.codeBlock(code.joined(separator: "\n")))
        }
        
        return MMDocument(blocks: blocks)
    }
    
    // MARK: - Inline Parser
    
    private static func parseInlines(_ line: String) -> [MMInline] {
        var result: [MMInline] = []
        var buffer = ""
        var chars = Array(line)
        var i = 0
        
        func flushBuffer() {
            if !buffer.isEmpty {
                result.append(.text(buffer))
                buffer = ""
            }
        }
        
        while i < chars.count {
            let ch = chars[i]
            
            // Bold **text**
            if i + 1 < chars.count, ch == "*", chars[i+1] == "*" {
                flushBuffer()
                i += 2
                let (content, jump) = extract(until: "**", from: chars, start: i)
                result.append(.bold(parseInlines(content)))
                i = jump
                continue
            }
            
            // Italic *text*
            if ch == "*" {
                flushBuffer()
                i += 1
                let (content, jump) = extract(until: "*", from: chars, start: i)
                result.append(.italic(parseInlines(content)))
                i = jump
                continue
            }
            
            // Underline _text_
            if ch == "_" {
                flushBuffer()
                i += 1
                let (content, jump) = extract(until: "_", from: chars, start: i)
                result.append(.underline(parseInlines(content)))
                i = jump
                continue
            }
            
            // Inline code `code`
            if ch == "`" {
                flushBuffer()
                i += 1
                let (content, jump) = extract(until: "`", from: chars, start: i)
                result.append(.code(content))
                i = jump
                continue
            }
            
            // Inline link [label|action]
            if ch == "[", let closing = findClosingBracket(from: chars, start: i) {
                let inside = String(chars[(i+1)..<closing])
                if inside.starts(with: "LINK:") {
                    let content = inside.dropFirst(5)
                    let comps = content.split(separator: "|")
                    if comps.count == 2 {
                        result.append(.link(label: String(comps[0]), action: String(comps[1])))
                        i = closing + 1
                        continue
                    }
                } else if inside.starts(with: "IMAGE:") {
                    let content = inside.dropFirst(6)
                    let comps = content.split(separator: "|")
                    if comps.count == 2 {
                        result.append(.image(name: String(comps[0]), alt: String(comps[1])))
                        i = closing + 1
                        continue
                    } else if comps.count == 1 {
                        result.append(.image(name: String(comps[0]), alt: nil))
                        i = closing + 1
                        continue
                    }
                }
            }
            
            // Inline SF Symbol :symbol:
            if ch == ":", let closing = chars[(i+1)...].firstIndex(of: ":") {
                let symbolName = String(chars[(i+1)..<closing])
                flushBuffer()
                result.append(.sfSymbol(symbolName))
                i = closing + 1
                continue
            }
            
            // Inline SF Symbol [SFSYM:hand.wave]
            if ch == "[", let closing = findClosingBracket(from: chars, start: i) {
                let inside = String(chars[(i+1)..<closing])
                if inside.starts(with: "SFSYM:") {
                    let symbolName = String(inside.dropFirst(6))
                    flushBuffer()
                    result.append(.sfSymbol(symbolName))
                    i = closing + 1
                    continue
                }
            }
            
            buffer.append(ch)
            i += 1
        }
        
        flushBuffer()
        return result
    }
    
    // MARK: - Utility
    
    private static func extract(until delimiter: String, from chars: [Character], start: Int) -> (String, Int) {
        let contentStart = start
        var i = start
        while i + delimiter.count <= chars.count {
            if String(chars[i..<(i+delimiter.count)]) == delimiter {
                return (String(chars[contentStart..<i]), i + delimiter.count)
            }
            i += 1
        }
        return (String(chars[contentStart..<chars.count]), chars.count)
    }
    
    private static func findClosingBracket(from chars: [Character], start: Int) -> Int? {
        for j in (start+1)..<chars.count {
            if chars[j] == "]" { return j }
        }
        return nil
    }
}
