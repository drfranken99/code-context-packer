//
//  FileNode.swift
//  CodeContextPacker
//
//  Created by drfranken on 1/22/26.
//

import Foundation

struct FileNode: Identifiable, Hashable {

    enum Kind {
        case directory
        case file
    }

    // MARK: - Identity
    let id: String
    let relativePath: String

    // MARK: - File info
    let url: URL
    let name: String
    let kind: Kind

    // MARK: - Tree
    var children: [FileNode]?

    var isDirectory: Bool {
        kind == .directory
    }

    var isSelectable: Bool {
        kind == .file
    }

    init(
        url: URL,
        relativePath: String,
        kind: Kind,
        children: [FileNode]? = nil
    ) {
        self.url = url
        self.relativePath = relativePath
        self.id = relativePath
        self.name = url.lastPathComponent
        self.kind = kind
        self.children = children
    }
}
