[한국어로 보기](./README.ko.md)

# CodeContextPacker

**Curate and pack your code context for conversational AI.**

CodeContextPacker is a cross-platform developer tool that helps you selectively curate files from a project directory and pack them into a single, human-readable code context optimized for conversational AI tools such as ChatGPT, Claude, or Gemini.

Instead of sending entire repositories or struggling with CLI-based workflows, CodeContextPacker lets you visually select exactly which files matter and turns them into a clean, structured context you can immediately copy and paste.

⸻

## Why CodeContextPacker?

When working with conversational AI for coding tasks, context quality matters more than context size.
- Sending an entire repository is inefficient and noisy
- CLI-based tools introduce friction for selective context control
- Manually copying files breaks flow and consistency

CodeContextPacker solves this by acting as a visual context curator.

⸻

## Key Features
- **Project Tree Sidebar**
  - Browse files in an Xcode-like hierarchical view
  - Toggle files on/off with clear visual feedback
  - Selected files are highlighted and marked with a green check indicator
- **Context Packing**
  - Only selected files are included
  - Each file is represented by:
    - Its relative path from the project root
    - Its full file content
  - Files are separated by clear, human-readable dividers
- **Unified Context Preview**
  - View the packed result as a single continuous text
  - Fully selectable (Cmd + A) and copyable
  - Ready to paste directly into conversational AI tools
- **Force Refresh**
  - Re-scan the directory and regenerate context on demand

⸻

## Context Format Example
```
–– file: Sources/App/MainView.swift ––
<file content>

–– file: Sources/Model/FileNode.swift ––
<file content>
```
The format is intentionally simple, explicit, and readable by both humans and AI models.

⸻

## Platform Support
- macOS: SwiftUI (in progress)
- Windows: Planned

The packed context format is designed to be consistent across all platforms.

⸻

## Project Structure (Planned)
```
code-context-packer/
├─ macos/        # macOS SwiftUI application
├─ windows/      # Windows implementation (planned)
├─ shared/       # Shared context format & rules
└─ docs/         # Vision, roadmap, and architecture
```
⸻

## Roadmap
- [ ] macOS MVP (file selection + context packing)
- [ ] Context format stabilization
- [ ] Large file handling
- [ ] Export packed context as .txt
- [ ] Windows version

⸻

## License

This project is licensed under the MIT License.

⸻

## Contributing

Contributions, ideas, and discussions are welcome.

If you are interested in improving developer workflows around conversational AI, feel free to open an issue or submit a pull request.
