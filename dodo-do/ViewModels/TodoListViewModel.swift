import Foundation
import Combine

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var filter: FilterType = .all
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()

    // Grouped tasks for the view
    var todayTasks: [TodoItem] {
        let filtered = filteredAndSearchedTodos
        return filtered.filter {
            guard let dueDate = $0.dueDate else { return false }
            return Calendar.current.isDateInToday(dueDate)
        }.sorted(by: { $0.dueDate ?? Date() < $1.dueDate ?? Date() })
    }

    var upcomingTasks: [TodoItem] {
        let filtered = filteredAndSearchedTodos
        return filtered.filter {
            guard let dueDate = $0.dueDate else { return true } // Show items without due date in upcoming
            return !Calendar.current.isDateInToday(dueDate)
        }.sorted(by: { $0.dueDate ?? Date.distantFuture < $1.dueDate ?? Date.distantFuture })
    }

    var completedTasks: [TodoItem] {
        let filtered = filteredAndSearchedTodos
        return filtered.filter { $0.isCompleted }.sorted(by: { $0.dueDate ?? Date.distantFuture < $1.dueDate ?? Date.distantFuture })
    }

    private var filteredAndSearchedTodos: [TodoItem] {
        let baseList: [TodoItem]
        switch filter {
        case .all, .incomplete:
            baseList = todos.filter { !$0.isCompleted }
        case .completed:
            baseList = todos.filter { $0.isCompleted }
        }

        if searchText.isEmpty {
            return baseList
        } else {
            return baseList.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    init() {
        loadInitialData()
        
        $todos
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] updatedTodos in
                // In a real app, you'd save here.
                // PersistenceService.shared.saveTodos(updatedTodos)
                print("Data would be saved here.")
            }
            .store(in: &cancellables)
    }

    func addTodo(title: String, content: String, dueDate: Date?, priority: Priority, category: String?) {
        let newTodo = TodoItem(title: title, content: content, dueDate: dueDate, priority: priority, category: category)
        todos.append(newTodo)
    }

    func updateTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        todos.removeAll { $0.id == todo.id }
    }

    func toggleCompletion(for todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }
    
    private func loadInitialData() {
        // Sample data based on the design
        self.todos = [
            TodoItem(title: "Prepare presentation for client meeting", dueDate: Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()), priority: .high, category: "Work"),
            TodoItem(title: "Schedule doctor's appointment", dueDate: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()), priority: .medium, category: "Personal"),
            TodoItem(title: "Review project proposal", dueDate: Date().addingTimeInterval(86400), priority: .medium, category: "Work"),
            TodoItem(title: "Grocery shopping", dueDate: Date().addingTimeInterval(86400 * 2), priority: .low, category: "Personal"),
            TodoItem(title: "Finalize budget report", dueDate: Date().addingTimeInterval(86400 * 3), priority: .high, category: "Work"),
            TodoItem(title: "Plan weekend trip", dueDate: Date().addingTimeInterval(86400 * 4), priority: .medium, category: "Personal"),
            TodoItem(title: "Dentist Appointment", isCompleted: true, dueDate: Date().addingTimeInterval(-86400), priority: .high, category: "Personal")
        ]
    }
}

// Updated FilterType to match the design
enum FilterType: String, CaseIterable {
    case all = "All"
    case incomplete = "Incomplete"
    case completed = "Completed"
}
