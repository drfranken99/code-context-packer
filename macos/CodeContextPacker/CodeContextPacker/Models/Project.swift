//
//  Project.swift
//  CodeContextPacker
//
//  Created by drfranken on 1/22/26.
//

import Foundation
import Combine

final class Project: ObservableObject, Identifiable {
    let id = UUID()

    @Published var rootURL: URL
    @Published var fileTree: FileNode?
    @Published var selectedFileIDs: Set<UUID> = []

    init(rootURL: URL) {
        self.rootURL = rootURL
    }
}

// MARK: - Selection
extension Project {
    func toggleSelection(for node: FileNode) {
        if selectedFileIDs.contains(node.id) {
            selectedFileIDs.remove(node.id)
        } else {
            selectedFileIDs.insert(node.id)
        }
    }

    func isSelected(_ node: FileNode) -> Bool {
        selectedFileIDs.contains(node.id)
    }
}

// MARK: - Packing
extension Project {
    var packedText: String {
        let files = selectedFiles()
        guard !files.isEmpty else { return "" }

        return files.map { node in
            let relativePath = node.url.path
                .replacingOccurrences(of: rootURL.path, with: "")

            let content = (try? String(contentsOf: node.url)) ?? ""

            return """
            ---- file: \(relativePath) ----
            \(content)
            """
        }
        .joined(separator: "\n\n")
    }

    private func selectedFiles() -> [FileNode] {
        guard let root = fileTree else { return [] }
        return collectSelected(from: root)
    }

    private func collectSelected(from node: FileNode) -> [FileNode] {
        var result: [FileNode] = []

        if !node.isDirectory && selectedFileIDs.contains(node.id) {
            result.append(node)
        }

        for child in node.children {
            result.append(contentsOf: collectSelected(from: child))
        }

        return result
    }
}
