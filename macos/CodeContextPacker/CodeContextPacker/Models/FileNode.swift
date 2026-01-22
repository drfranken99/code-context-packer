//
//  FileNode.swift
//  CodeContextPacker
//
//  Created by drfranken on 1/22/26.
//

import Foundation

struct FileNode: Identifiable, Hashable {

    // MARK: - Identity
    let id: String
    let relativePath: String

    // MARK: - File info
    let url: URL
    let name: String
    let isDirectory: Bool
    let isSelectable: Bool

    // MARK: - Tree
    var children: [FileNode]?

    init(
        url: URL,
        relativePath: String,
        isDirectory: Bool,
        children: [FileNode]? = nil
    ) {
        self.url = url
        self.relativePath = relativePath
        self.id = relativePath
        self.name = url.lastPathComponent
        self.isDirectory = isDirectory
        self.isSelectable = !isDirectory
        self.children = children
    }
}
