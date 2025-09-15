import SwiftUI

public struct MMRenderer: View {
    let document: MMDocument
    
    public init(document: MMDocument) {
        self.document = document
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(document.blocks) { block in
                renderBlock(block)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func renderBlock(_ block: MMBlock) -> some View {
        switch block {
        case .title(let inlines):
            renderInlinesAsText(inlines)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 4)
                
        case .subtitle(let inlines):
            renderInlinesAsText(inlines)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 2)
                
        case .text(let inlines):
            renderInlinesAsText(inlines)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                
        case .list(let items, let ordered):
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                    HStack(alignment: .top, spacing: 8) {
                        Text(ordered ? "\(idx + 1)." : "•")
                            .font(.body)
                            .foregroundColor(.primary)
                            .frame(minWidth: ordered ? 20 : 8, alignment: .leading)
                        
                        renderInlinesAsText(item)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.leading, 8)
            
        case .quote(let inlines):
            HStack(alignment: .top, spacing: 12) {
                Rectangle()
                    .fill(Color.secondary)
                    .frame(width: 4)
                    .cornerRadius(2)
                
                renderInlinesAsText(inlines)
                    .font(.body)
                    .italic()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 8)
            .padding(.leading, 4)
            
        case .codeBlock(let text):
            ScrollView(.horizontal, showsIndicators: false) {
                Text(text)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                    )
            )
            
        case .link(let label, let action):
            Button(action: {
                print("Link tapped: \(action)")
                // Add proper URL handling here if needed
            }) {
                Text(label)
                    .font(.body)
                    .foregroundColor(.blue)
                    .underline()
            }
            .buttonStyle(PlainButtonStyle())
            
        case .divider:
            Divider()
                .background(Color.secondary)
                .padding(.vertical, 8)
                
        case .image(let name, let alt):
            if let uiImage = UIImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(8)
                    .accessibilityLabel(alt ?? "")
            } else {
                HStack {
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                    Text("Image not found: \(name)")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(6)
            }
            
        case .meta, .style:
            EmptyView()
        }
    }
    
    // New method to properly render inlines as flowing text
    private func renderInlinesAsText(_ inlines: [MMInline]) -> Text {
        var result = Text("")
        
        for inline in inlines {
            result = result + renderSingleInline(inline)
        }
        
        return result
    }
    
    private func renderSingleInline(_ inline: MMInline) -> Text {
        switch inline {
        case .text(let str):
            return Text(str)
            
        case .sfSymbol(let name):
            return Text(Image(systemName: name))
            
        case .bold(let inner):
            return renderInlinesAsText(inner)
                .bold()
            
        case .italic(let inner):
            return renderInlinesAsText(inner)
                .italic()
            
        case .underline(let inner):
            return renderInlinesAsText(inner)
                .underline()
            
        case .color(let color, let inner):
            return renderInlinesAsText(inner)
                .foregroundColor(color)
            
        case .code(let str):
            return Text(str)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
            
        case .link(let label, _):
            return Text(label)
                .foregroundColor(.blue)
                .underline()
            
        case .image(let name, let alt):
            // For inline images, we'll use a text representation
            // since Text can't contain arbitrary Views
            if UIImage(named: name) != nil {
                return Text("[📷 \(alt ?? name)]")
                    .foregroundColor(.blue)
            } else {
                return Text("[❌ \(alt ?? name)]")
                    .foregroundColor(.red)
            }
            
        case .condensed(let inner):
            return renderInlinesAsText(inner)
                .fontWidth(.condensed)
            
        case .expanded(let inner):
            return renderInlinesAsText(inner)
                .fontWidth(.expanded)
        }
    }
}

// MARK: - Preview Example
#if DEBUG
struct MMRenderer_Previews: PreviewProvider {
    static var previews: some View {
        let mmText = """
# Main Title with 📱 SF Symbol
## Subtitle Here with ⭐ Icons

This is regular **bold text** and *italic text* and `inline code` all flowing together properly with 🎯 symbols.

- First list item with **bold** content and 📝 icon
- Second item with *italic* and `code` plus ⚡ symbol
- Third item that should wrap nicely when the text gets longer 🚀

1. Numbered first item with 📊 chart icon
2. Second numbered item with 🔥 fire
3. Third item with ✅ checkmark

> This is a blockquote with **bold text** and *italic text* that should flow properly and wrap to multiple lines when needed. Contains 💡 lightbulb.

```
def hello_world():
    print("Hello, World!")
    return "success"
```

:star.fill:

---

Final paragraph with [a link](https://example.com) and more text with 🌟 star symbol.
"""
        let document = MMConverter.parse(mmText)
        MMRenderer(document: document)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
