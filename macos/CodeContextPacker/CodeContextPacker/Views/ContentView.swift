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
    
    @State private var triggerOpenAnimation = false
    @State private var triggerRefreshAnimation = false
    @State private var triggerCopyAnimation = false

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
                                    Image(systemName: "folder")
                                        .foregroundStyle(.secondary)
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

                                    Image(systemName: "doc.text")
                                        .foregroundStyle(.secondary)
                                    
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

                if project.fileTree != nil {
                    TextEditor(text: .constant(project.packedText))
                        .font(.system(.body, design: .monospaced))
                        .scrollContentBackground(.hidden)
                        .focusable(false)

                } else {
                    Text("Open a project to preview packed context.")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {

                Button {
                    openProject()
                    triggerOpenAnimation.toggle()
                } label: {
                    Image(systemName: "folder")
                        .symbolEffect(.bounce.up.byLayer, options: .speed(1.8), value: triggerOpenAnimation)
                }
                .keyboardShortcut("o", modifiers: [.command])

                Button {
                    refreshProject()
                    triggerRefreshAnimation.toggle()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .symbolEffect(.bounce.up.byLayer, options: .speed(1.8), value: triggerRefreshAnimation)
                }
                .keyboardShortcut("r", modifiers: [.command])
                
                Button {
                    copyPackedContext()
                    triggerCopyAnimation.toggle()
                } label: {
                    Image(systemName: "doc.on.doc")
                        .symbolEffect(.bounce.up.byLayer, options: .speed(1.8), value: triggerCopyAnimation)
                }
                .keyboardShortcut("c", modifiers: [.command, .shift])
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
            DispatchQueue.main.async {
                if let first = project.fileTree?.children?.first {
                    focusedNodeIDs = [first.id]
                }
            }
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
    
    private func copyPackedContext() {
        let text = project.packedText
        guard !text.isEmpty else { return }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}
