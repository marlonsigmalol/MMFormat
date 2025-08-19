//
//  MMAsync.swift
//  MMFormat
//
//  Created by Marlon Mawby on 19/8/2025.
//


import SwiftUI

// MARK: - Async MM Document Loader
public class MMRemoteLoader {
    /// Downloads an MM document from the given URL asynchronously
    public static func loadDocument(from url: URL) async throws -> MMDocument {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let mmText = String(data: data, encoding: .utf8) else {
            throw URLError(.badServerResponse)
        }
        return MMConverter.parse(mmText)
    }
}

// MARK: - SwiftUI Convenience View
public struct MMRemoteDocumentView: View {
    let url: URL
    let placeholderCount: Int

    @State private var document: MMDocument? = nil

    public init(url: URL, placeholderCount: Int = 6) {
        self.url = url
        self.placeholderCount = placeholderCount
    }

    public var body: some View {
        Group {
            if let doc = document {
                ScrollView {
                    MMRenderer(document: doc)
                }
            } else {
                VStack(spacing: 12) {
                    ForEach(0..<placeholderCount, id: \.self) { _ in
                        MMSkeleton(height: 20)
                    }
                }
                .padding()
                .onAppear { loadDocument() }
            }
        }
    }

    private func loadDocument() {
        Task {
            do {
                document = try await MMRemoteLoader.loadDocument(from: url)
            } catch {
                print("Failed to load MM document: \(error)")
            }
        }
    }
}

struct MMAsync_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Skeleton placeholder preview
            MMRemoteDocumentView(url: URL(string: "https://mmhikingapp.pythonanywhere.com/api/ai/legaltext")!)
                .previewDisplayName("Skeleton Placeholder")

            
        }
    }
}
