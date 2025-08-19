import SwiftUI

public struct MMRenderer: View {
    let document: MMDocument
    
    public init(document: MMDocument) {
        self.document = document
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(document.blocks) { block in
                renderBlock(block)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func renderBlock(_ block: MMBlock) -> some View {
        switch block {
        case .title(let inlines):
            renderInlines(inlines)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
        case .subtitle(let inlines):
            renderInlines(inlines)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
        case .text(let inlines):
            renderInlines(inlines)
                .font(.body)
                .foregroundColor(.primary)
        case .list(let items, let ordered):
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                    HStack(alignment: .top, spacing: 4) {
                        Text(ordered ? "\(idx + 1)." : "•")
                            .font(.body)
                        renderInlines(item)
                    }
                }
            }
        case .quote(let inlines):
            HStack(alignment: .top, spacing: 8) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 3)
                renderInlines(inlines)
                    .italic()
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        case .codeBlock(let text):
            ScrollView(.horizontal) {
                Text(text)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
            }
        case .link(let label, let action):
            Button(label) {
                print("Link tapped: \(action)")
            }
            .foregroundColor(.blue)
            .underline()
        case .divider:
            Divider()
        case .image(let name, let alt):
            if let uiImage = UIImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel(alt ?? "")
            } else {
                Text("[Image not found: \(name)]")
                    .foregroundColor(.red)
            }
        case .meta, .style:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func renderInlines(_ inlines: [MMInline]) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(inlines.enumerated()), id: \.offset) { _, inline in
                switch inline {
                case .text(let str):
                    Text(str)
                case .sfSymbol(let name):
                    Image(systemName: name)
                case .bold(let inner):
                    AnyView(renderInlines(inner).bold())
                case .italic(let inner):
                    AnyView(renderInlines(inner).italic())
                case .underline(let inner):
                    AnyView(renderInlines(inner).underline())
                case .color(let color, let inner):
                    AnyView(renderInlines(inner).foregroundColor(color))
                case .code(let str):
                    Text(str).font(.system(.body, design: .monospaced))
                case .link(let label, _):
                    Text(label).foregroundColor(.blue).underline()
                case .image(let name, let alt):
                    if let uiImage = UIImage(named: name) {
                        Image(uiImage: uiImage)
                    } else {
                        Text("[Image: \(alt ?? name)]").foregroundColor(.red)
                    }
                }
            }
        }
    }
}

// MARK: - Preview Example
#if DEBUG
struct MMRenderer_Previews: PreviewProvider {
    static var previews: some View {
        let mmText = """
        # Welcome [SFSYM:hand.wave]
        ## Subtitle Example
        This is a **bold** and *italic* text. _Underlined text_.
        - First bullet
        - Second bullet
        1. Ordered item one
        2. Ordered item two
        > This is a quote
        ```
        let x = 42
        print(x)
        ```
        [LINK: Learn More|openLearnMore]
        [IMAGE: example|Example Image]
        ---
        """
        let document = MMConverter.parse(mmText)
        MMRenderer(document: document)
            .previewLayout(.sizeThatFits)
    }
}
#endif
