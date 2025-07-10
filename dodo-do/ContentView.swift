import SwiftUI

struct ContentView: View {
    init() {
        // 设置 TabView 的外观，避免色偏
        let appearance = NSAppearance(named: .aqua)
        NSApp.appearance = appearance
    }
    
    var body: some View {
        TabView {
            TodoListView()
                .tabItem {
                    Label("Todo List", systemImage: "list.bullet")
                }
            
            CountdownListView()
                .tabItem {
                    Label("Countdown", systemImage: "timer")
                }
        }
        .padding(.top)
        .preferredColorScheme(.light) // 强制使用浅色模式，避免色偏
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}