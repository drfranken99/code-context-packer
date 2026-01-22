//
//  FileNode.swift
//  CodeContextPacker
//
//  Created by drfranken on 1/22/26.
//

import Foundation

struct FileNode: Identifiable, Hashable {
    let id: UUID
    let url: URL
    let name: String
    let isDirectory: Bool
    var children: [FileNode]

    init(url: URL, isDirectory: Bool, children: [FileNode] = []) {
        self.id = UUID()
        self.url = url
        self.name = url.lastPathComponent
        self.isDirectory = isDirectory
        self.children = children
    }
}
