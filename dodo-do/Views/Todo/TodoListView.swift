import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var showingAddSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HeaderView(onAdd: { showingAddSheet = true })

            // Search Bar
            SearchBar(text: $viewModel.searchText)

            // Filter Tabs
            FilterTabs(selection: $viewModel.filter)

            // Task List
            ScrollView {
                VStack(alignment: .leading) {
                    if viewModel.filter == .completed {
                        TaskListSection(title: "Completed", tasks: viewModel.completedTasks, viewModel: viewModel)
                    } else {
                        if !viewModel.todayTasks.isEmpty {
                            TaskListSection(title: "Today", tasks: viewModel.todayTasks, viewModel: viewModel)
                        }
                        if !viewModel.upcomingTasks.isEmpty {
                            TaskListSection(title: "Upcoming", tasks: viewModel.upcomingTasks, viewModel: viewModel)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(width: 450, height: 600)
        .sheet(isPresented: $showingAddSheet) {
            AddTodoView(viewModel: viewModel)
        }
    }
}

// MARK: - Subviews

private struct HeaderView: View {
    var onAdd: () -> Void
    
    var body: some View {
        HStack {
            Text("接下来不能闲着了啊")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Button("忙起来(新todo)", action: onAdd)
                .buttonStyle(.borderedProminent)
                .tint(.primary)
        }
    }
}

private struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search tasks", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(8)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

private struct FilterTabs: View {
    @Binding var selection: FilterType
    @Namespace private var namespace // Added for animation

    var body: some View {
        HStack(spacing: 20) {
            ForEach(FilterType.allCases, id: \.self) { filter in
                VStack {
                    Text(filter.rawValue)
                        .fontWeight(selection == filter ? .bold : .regular)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selection = filter
                            }
                        }
                    if selection == filter {
                        Rectangle()
                            .frame(height: 2)
                            .matchedGeometryEffect(id: "underline", in: namespace)
                    }
                }
            }
        }
        .padding(.top, 5)
    }
}

private struct TaskListSection: View {
    let title: String
    let tasks: [TodoItem]
    @ObservedObject var viewModel: TodoListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            
            ForEach(tasks) { todo in
                TodoRowView(viewModel: viewModel, todo: todo)
                Divider()
            }
        }
        .padding(.top)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
