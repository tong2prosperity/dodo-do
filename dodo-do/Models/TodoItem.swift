import Foundation

// Enum for task priority
enum Priority: String, CaseIterable, Codable, Equatable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

// The main data structure for a single todo item
struct TodoItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var content: String
    var isCompleted: Bool
    let createdAt: Date
    
    // New properties from the design
    var dueDate: Date?
    var priority: Priority
    var category: String?

    // Default initializer
    init(id: UUID = UUID(), 
         title: String, 
         content: String = "", 
         isCompleted: Bool = false, 
         createdAt: Date = Date(), 
         dueDate: Date? = nil, 
         priority: Priority = .medium, 
         category: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.priority = priority
        self.category = category
    }
}
