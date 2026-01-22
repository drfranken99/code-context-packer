//
//  ContentView.swift
//  CodeContextPacker
//
//  Created by drfranken on 1/22/26.
//

import SwiftUI
import AppKit

struct ContentView: View {

    // Temporary single-project state (will support multiple tabs later)
    @StateObject private var project: Project = Project()
    @State private var focusedNodeIDs: Set<String> = []

    var body: some View {
        NavigationSplitView {
            // Sidebar: file tree
            if let root = project.fileTree {
                VStack(alignment: .leading) {
                    Text(project.displayName)
                            .font(.headline)
                            .padding(.horizontal)
                    List(selection: $focusedNodeIDs) {
                        OutlineGroup(root.children ?? [], children: \.children) { node in
                            if node.isDirectory {
                                // Folder row (keep default disclosure behavior)
                                HStack {
                                    Text(node.name)
                                }
                                .tag(node.id)
                            } else {
                                // File row with check toggle button
                                HStack {
                                    Button {
                                        project.toggleSelection(for: node)
                                    } label: {
                                        Image(systemName: project.isSelected(node)
                                              ? "checkmark.circle.fill"
                                              : "circle")
                                            .foregroundStyle(project.isSelected(node) ? .green : .secondary)
                                    }
                                    .buttonStyle(.plain)

                                    Text(node.name)
                                        .fontWeight(project.isSelected(node) ? .semibold : .regular)
                                }
                                .tag(node.id)
                            }
                        }
                    }
                    .onKeyPress { event in
                        guard event.key == .space else {
                            return .ignored
                        }

                        handleSpaceKeyToggle()
                        return .handled
                    }
                }
            } else {
                Text("No project loaded")
            }
        } detail: {
            // Packed context preview
            VStack(alignment: .leading) {
                Text("Packed Context Preview")
                    .font(.headline)
                    .padding(.bottom, 8)

                TextEditor(text: .constant(project.packedText))
                    .font(.system(.body, design: .monospaced))
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {

                Button {
                    openProject()
                } label: {
                    Label("Open Project", systemImage: "folder")
                }

                Button {
                    refreshProject()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
        }
    }
    
    private func openProject() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Open Project"

        if panel.runModal() == .OK, let url = panel.url {
            project.rootURL = url
            project.loadFileTree()
        }
    }
    
    private func refreshProject() {
        project.loadFileTree()
    }
    
    private func handleSpaceKeyToggle() {
        guard let root = project.fileTree else { return }

        // 1) Collect selected file nodes (ignore folders)
        func collect(from node: FileNode) -> [FileNode] {
            var result: [FileNode] = []

            if focusedNodeIDs.contains(node.id), !node.isDirectory {
                result.append(node)
            }

            if let children = node.children {
                for child in children {
                    result.append(contentsOf: collect(from: child))
                }
            }
            return result
        }

        let selectedFiles = collect(from: root)
        guard !selectedFiles.isEmpty else { return }

        // 2) Determine bulk toggle policy
        let hasUnchecked = selectedFiles.contains {
            !project.isSelected($0)
        }

        // 3) Apply toggle
        if hasUnchecked {
            for file in selectedFiles where !project.isSelected(file) {
                DispatchQueue.main.async {
                    project.toggleSelection(for: file)
                }
            }
        } else {
            for file in selectedFiles where project.isSelected(file) {
                DispatchQueue.main.async {
                    project.toggleSelection(for: file)
                }
            }
        }
    }
}
