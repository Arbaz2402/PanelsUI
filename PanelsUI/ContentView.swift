import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isSidebarOpen = false
    @State private var openTabs: [String] = []
    @State private var selectedTab: String? = nil
    @State private var isCompilerDrawerOpen = false
    @State private var drawerHeight: CGFloat = 200
    @State private var sidebarWidth: CGFloat = 250

    var body: some View {
        ZStack(alignment: .leading) {
            NavigationView {
                VStack(spacing: 0) {
                    if !openTabs.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(openTabs, id: \.self) { tab in
                                    TabItemView(tab: tab, openTabs: $openTabs, selectedTab: $selectedTab)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 55)
                    }

                    if let selectedTab = selectedTab {
                        CodeEditorView(fileName: selectedTab)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(colorScheme == .dark ? Color.black : Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Text("Select a file from the sidebar.")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(colorScheme == .dark ? Color.black : Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding()
                    }
                }
                .navigationTitle("IDE")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                isSidebarOpen.toggle()
                            }
                        }) {
                            Image(systemName: "sidebar.left")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                }
            }

            if isSidebarOpen {
                HStack(spacing: 0) {
                    SidebarView(isSidebarOpen: $isSidebarOpen,
                                openTabs: $openTabs,
                                selectedTab: $selectedTab,
                                width: $sidebarWidth)
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 4)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newWidth = sidebarWidth + value.translation.width
                                    sidebarWidth = max(150, min(400, newWidth))
                                }
                        )
                }
                .frame(width: sidebarWidth)
                .transition(.move(edge: .leading))
                .zIndex(2)
            }

            GeometryReader { geometry in
                if !isCompilerDrawerOpen {
                    Button(action: {
                        withAnimation(.spring()) {
                            isCompilerDrawerOpen.toggle()
                            if isCompilerDrawerOpen {
                                drawerHeight = 200
                            }
                        }
                    }) {
                        Image(systemName: "terminal.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding()
                            .background(colorScheme == .dark ? Color.blue.opacity(0.7) : Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .position(
                        x: geometry.size.width - 50,
                        y: geometry.size.height - 50
                    )
                }
            }

            if isCompilerDrawerOpen {
                VStack {
                    Spacer()
                    ResizableDrawer(isOpen: $isCompilerDrawerOpen, height: $drawerHeight)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .shadow(radius: 5)
                }
                .transition(.move(edge: .bottom))
                .zIndex(3)
            }
        }
    }
}

struct SidebarView: View {
    @Binding var isSidebarOpen: Bool
    @Binding var openTabs: [String]
    @Binding var selectedTab: String?
    @Binding var width: CGFloat

    @State private var expandedFolders: [String: Bool] = [:]

    let fileHierarchy: [FileItem] = [
        .folder(name: "src", contents: [
            .file(name: "main.swift"),
            .file(name: "AppDelegate.swift"),
            .folder(name: "views", contents: [
                .file(name: "LoginView.swift"),
                .file(name: "DashboardView.swift")
            ])
        ]),
        .folder(name: "models", contents: [
            .file(name: "User.swift"),
            .file(name: "Session.swift")
        ]),
        .folder(name: "services", contents: [
            .file(name: "APIService.swift"),
            .file(name: "AuthService.swift")
        ]),
        .file(name: "README.md")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Explorer")
                    .font(.headline)
                    .padding(.leading, 4)

                Spacer()

                Button(action: {
                    withAnimation {
                        isSidebarOpen = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 18))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(fileHierarchy, id: \.name) { item in
                        FileRowView(
                            item: item,
                            expandedFolders: $expandedFolders,
                            openTabs: $openTabs,
                            selectedTab: $selectedTab,
                            dismissSidebar: dismissSidebar
                        )
                    }
                }
                .padding(.horizontal, 8)
            }
            Spacer()
        }
        .frame(width: width)
        .background(Color(UIColor.systemBackground))
        .shadow(radius: 5)
    }

    private func dismissSidebar() {
        withAnimation {
            isSidebarOpen = false
        }
    }
}


struct ResizableDrawer: View {
    @Binding var isOpen: Bool
    @Binding var height: CGFloat
    @State private var logs: [String] = ["Build Succeeded", "Error: Missing File", "Warning: Deprecated API"]
    private let minHeight: CGFloat = 50
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Capsule()
                    .frame(width: 50, height: 5)
                    .foregroundColor(.gray)
                    .padding(.vertical, 10)
                Spacer()
                Button(action: {
                    withAnimation {
                        isOpen = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .padding(.trailing, 10)
                }
            }
            .background(Color(UIColor.systemBackground))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newHeight = height - value.translation.height
                        height = max(minHeight, newHeight)
                    }
            )
            
            HStack {
                Text("Compiler Output")
                    .font(.headline)
                    .padding(.leading, 10)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    logs.removeAll()
                }) {
                    Text("Clear")
                        .font(.subheadline)
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing, 10)
            }
            .padding(.vertical, 5)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    if logs.isEmpty {
                        Text("Console is empty.")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding()
                    } else {
                        ForEach(logs, id: \.self) { log in
                            Text(log)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .frame(height: height)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct FileRowView: View {
    let item: FileItem
    @Binding var expandedFolders: [String: Bool]
    @Binding var openTabs: [String]
    @Binding var selectedTab: String?
    let dismissSidebar: () -> Void

    var body: some View {
        switch item {
        case .folder(let name, let contents):
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation {
                        expandedFolders[name]?.toggle()
                        if expandedFolders[name] == nil {
                            expandedFolders[name] = true
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "folder")
                            .foregroundColor(.blue)
                        Text(name)
                        Spacer()
                        Image(systemName: expandedFolders[name] ?? false ? "chevron.down" : "chevron.right")
                    }
                }

                if expandedFolders[name] ?? false {
                    VStack(alignment: .leading) {
                        ForEach(contents, id: \.name) { subItem in
                            FileRowView(
                                item: subItem,
                                expandedFolders: $expandedFolders,
                                openTabs: $openTabs,
                                selectedTab: $selectedTab,
                                dismissSidebar: dismissSidebar
                            )
                            .padding(.leading, 20)
                        }
                    }
                }
            }
        case .file(let name):
            Button(action: {
                if !openTabs.contains(name) {
                    openTabs.append(name)
                }
                selectedTab = name
                dismissSidebar()
            }) {
                Text(name)
            }
        }
    }
}

enum FileItem: Identifiable {
    case folder(name: String, contents: [FileItem])
    case file(name: String)

    var id: String { name }

    var name: String {
        switch self {
        case .folder(let name, _): return name
        case .file(let name): return name
        }
    }
}

struct TabItemView: View {
    var tab: String
    @Binding var openTabs: [String]
    @Binding var selectedTab: String?

    var body: some View {
        HStack(spacing: 5) {
            Text(tab)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .foregroundColor(.primary)
                .onTapGesture {
                    selectedTab = tab
                }

            Button(action: {
                openTabs.removeAll { $0 == tab }
                if selectedTab == tab {
                    selectedTab = openTabs.last
                }
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.red)
            }
            .padding(.trailing, 5)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .background(selectedTab == tab ? Color.gray.opacity(0.3) : Color(UIColor.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 3)
    }
}

struct CodeEditorView: View {
    let fileName: String

    var body: some View {
        ScrollView {
            Text("""
                import SwiftUI

                // Dummy code for \(fileName)

                struct \(fileName.prefix(fileName.count - 6))View: View {
                    var body: some View {
                        Text("Hello, \(fileName)!")
                    }
                }
                """)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
                .padding()
                .background(Color(UIColor.systemBackground))
        }
    }
}
