import Foundation

class PersistenceService {
    static let shared = PersistenceService()

    private let todoURL: URL
    private let countdownURL: URL

    private init() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportURL = urls[0].appendingPathComponent("dodo-do")

        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: appSupportURL.path) {
            try? fileManager.createDirectory(at: appSupportURL, withIntermediateDirectories: true, attributes: nil)
        }

        self.todoURL = appSupportURL.appendingPathComponent("todos.json")
        self.countdownURL = appSupportURL.appendingPathComponent("countdowns.json")
    }

    func loadTodos() -> [TodoItem] {
        guard let data = try? Data(contentsOf: todoURL) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([TodoItem].self, from: data)) ?? []
    }

    func saveTodos(_ todos: [TodoItem]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(todos) {
            try? data.write(to: todoURL, options: [.atomicWrite])
        }
    }

    func loadCountdowns() -> [CountdownItem] {
        guard let data = try? Data(contentsOf: countdownURL) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([CountdownItem].self, from: data)) ?? []
    }

    func saveCountdowns(_ countdowns: [CountdownItem]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(countdowns) {
            try? data.write(to: countdownURL, options: [.atomicWrite])
        }
    }
}
