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



    var body: some View {
        NavigationSplitView {
            // Sidebar: file tree
            if let root = project.fileTree {
                List {
                    OutlineGroup(root, children: \.children) { node in
                        HStack {
                            if node.isSelectable {
                                Image(systemName: project.isSelected(node) ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(project.isSelected(node) ? .green : .secondary)
                            }

                            Text(node.name)
                                .fontWeight(project.isSelected(node) ? .semibold : .regular)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if !node.isDirectory {
                                project.toggleSelection(for: node)
                            }
                        }
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
            ToolbarItem(placement: .navigation) {
                Button("Open Project") {
                    openProject()
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
            // fileTree는 아직 만들지 않는다 (다음 단계)
        }
    }
}

//#Preview {
//    ContentView()
//}
