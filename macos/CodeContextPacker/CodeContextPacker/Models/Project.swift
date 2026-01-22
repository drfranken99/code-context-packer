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

    @Published var rootURL: URL? {
        didSet {
            loadFileTree()
        }
    }
    @Published var fileTree: FileNode?
    @Published var selectedFileIDs: Set<String> = []

    

    func loadFileTree() {
        guard let rootURL else {
            fileTree = nil
            selectedFileIDs.removeAll()
            return
        }

        let newTree = buildTree(at: rootURL, rootURL: rootURL)

        // Collect all valid file IDs from new tree
        var validIDs = Set<String>()
        collectAllFileIDs(from: newTree, into: &validIDs)

        // Normalize selection (remove deleted files)
        selectedFileIDs = selectedFileIDs.intersection(validIDs)

        fileTree = newTree
    }

    private func buildTree(at url: URL, rootURL: URL) -> FileNode {
        let resourceValues = try? url.resourceValues(forKeys: [.isDirectoryKey])
        let isDirectory = resourceValues?.isDirectory ?? false

        let relativePath = url.path
            .replacingOccurrences(of: rootURL.path + "/", with: "")

        var children: [FileNode]? = nil

        if isDirectory {
            let contents = (try? FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )) ?? []

            let childNodes = contents
                .map { buildTree(at: $0, rootURL: rootURL) }
                .sorted {
                    if $0.isDirectory != $1.isDirectory {
                        return $0.isDirectory && !$1.isDirectory
                    }
                    return $0.name.localizedStandardCompare($1.name) == .orderedAscending
                }

            children = childNodes.isEmpty ? nil : childNodes
        }

        return FileNode(
            url: url,
            relativePath: relativePath,
            isDirectory: isDirectory,
            children: children
        )
    }

    private func collectAllFileIDs(from node: FileNode, into set: inout Set<String>) {
        if node.isSelectable {
            set.insert(node.id)
        }

        if let children = node.children {
            for child in children {
                collectAllFileIDs(from: child, into: &set)
            }
        }
    }
}

// MARK: - Selection
extension Project {

    func toggleSelection(for node: FileNode) {
        guard node.isSelectable else { return }

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
        guard let url = rootURL else { return ""}
        
        let files = selectedFiles()
        guard !files.isEmpty else { return "" }

        return files.map { node in
            let relativePath = node.relativePath

            let content = (try? String(contentsOf: node.url)) ?? ""

            return """
            📝---- file: \(relativePath) ----📝
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

        if let children = node.children {
            for child in children {
                result.append(contentsOf: collectSelected(from: child))
            }
        }

        return result
    }
}
