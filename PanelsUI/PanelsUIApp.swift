//
//  PanelsUIApp.swift
//  PanelsUI
//
//  Created by Arbaz Kaladiya on 08/12/24.
//

import SwiftUI

@main
struct PanelsUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.clear) // Ensure no blue background in the main app
        }
    }
}

//import SwiftUI
//
//struct ContentView: View {
//    @State private var isSidebarOpen = false
//    @State private var openTabs: [String] = []
//    @State private var selectedTab: String? = nil
//    @State private var isCompilerDrawerOpen = false
//    @State private var drawerHeight: CGFloat = 200
//
//    var body: some View {
//        ZStack {
//            NavigationView {
//                VStack(spacing: 0) {
//                    // Tab Bar
//                    if !openTabs.isEmpty {
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 10) {
//                                ForEach(openTabs, id: \.self) { tab in
//                                    TabItemView(tab: tab, openTabs: $openTabs, selectedTab: $selectedTab)
//                                }
//                            }
//                            .padding(.horizontal)
//                            .background(Color.opacity(0.1))
//                        }
//                        .frame(height: 50)
//                    }
//
//                    // Main content
//                    if let selectedTab = selectedTab {
//                        Text("Content for \(selectedTab)")
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(10)
//                            .padding()
//                    } else {
//                        Text("Select a file from the sidebar.")
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(10)
//                            .padding()
//                    }
//
//                    // Compiler drawer toggle button
//                    Button(action: {
//                        withAnimation {
//                            isCompilerDrawerOpen.toggle()
//                        }
//                    }) {
//                        Text("Toggle Compiler Drawer")
//                            .padding()
//                            .background(Color)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding(.bottom)
//                }
//                .navigationTitle("IDE")
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: {
//                            withAnimation {
//                                isSidebarOpen.toggle()
//                            }
//                        }) {
//                            Image(systemName: "sidebar.left")
//                        }
//                    }
//                }
//            }
//
//            // Sidebar
//            if isSidebarOpen {
//                SidebarView(isSidebarOpen: $isSidebarOpen, openTabs: $openTabs, selectedTab: $selectedTab)
//                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
//                    .transition(.move(edge: .leading))
//                    .zIndex(1)
//            }
//
//            // Compiler Drawer
//            if isCompilerDrawerOpen {
//                VStack {
//                    Spacer()
//                    ResizableDrawer(isOpen: $isCompilerDrawerOpen, height: $drawerHeight)
//                }
//                .zIndex(2)
//            }
//        }
//    }
//}
//
//struct SidebarView: View {
//    @Binding var isSidebarOpen: Bool
//    @Binding var openTabs: [String]
//    @Binding var selectedTab: String?
//
//    let dummyFiles = ["File1.swift", "File2.swift", "File3.swift", "File4.swift", "File5.swift"]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text("Explorer")
//                    .font(.headline)
//                    .padding(.leading)
//                Spacer()
//                Button(action: {
//                    withAnimation {
//                        isSidebarOpen.toggle()
//                    }
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                }
//                .padding(.trailing)
//            }
//            .padding(.vertical)
//
//            List(dummyFiles, id: \.self) { file in
//                Button(action: {
//                    if !openTabs.contains(file) {
//                        openTabs.append(file)
//                    }
//                    selectedTab = file
//                    withAnimation {
//                        isSidebarOpen.toggle()
//                    }
//                }) {
//                    Text(file)
//                }
//            }
//        }
//        .frame(maxHeight: .infinity)
//        .background(Color.white.shadow(radius: 5))
//        .cornerRadius(10)
//    }
//}
//
//struct TabItemView: View {
//    var tab: String
//    @Binding var openTabs: [String]
//    @Binding var selectedTab: String?
//
//    var body: some View {
//        HStack(spacing: 5) {
//            Text(tab)
//                .padding(.horizontal, 10)
//                .padding(.vertical, 5)
//                .background(selectedTab == tab ? Color.gray.opacity(0.3) : Color.clear)
//                .cornerRadius(5)
//                .onTapGesture {
//                    selectedTab = tab
//                }
//
//            Button(action: {
//                openTabs.removeAll { $0 == tab }
//                if selectedTab == tab {
//                    selectedTab = openTabs.last
//                }
//            }) {
//                Image(systemName: "xmark")
//                    .foregroundColor(.red)
//                    .padding(.trailing, 5)
//            }
//        }
//        .padding(.vertical, 5)
//        .background(Color.white)
//        .cornerRadius(8)
//        .shadow(radius: 3)
//    }
//}
//
//struct ResizableDrawer: View {
//    @Binding var isOpen: Bool
//    @Binding var height: CGFloat
//
//    var body: some View {
//        VStack(spacing: 0) {
//            HStack {
//                Spacer()
//                Capsule()
//                    .frame(width: 50, height: 5)
//                    .foregroundColor(.gray)
//                    .onTapGesture {
//                        withAnimation {
//                            isOpen = false
//                        }
//                    }
//                Spacer()
//            }
//            .padding(.top, 10)
//
//            Text("Compiler Output")
//                .font(.headline)
//                .padding()
//
//            Spacer()
//        }
//        .frame(height: height)
//        .background(Color.white.shadow(radius: 5))
//        .cornerRadius(15)
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//                    let newHeight = height - value.translation.height
//                    if newHeight > 150 && newHeight < UIScreen.main.bounds.height * 0.5 {
//                        height = newHeight
//                    }
//                }
//        )
//    }
//}
