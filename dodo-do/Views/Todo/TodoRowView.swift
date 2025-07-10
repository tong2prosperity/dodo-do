import SwiftUI

struct TodoRowView: View {
    @ObservedObject var viewModel: TodoListViewModel
    let todo: TodoItem

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.headline)
                    .strikethrough(todo.isCompleted, color: .secondary)

                HStack(spacing: 10) {
                    if let dueDate = todo.dueDate {
                        Text(formatDate(dueDate))
                    }
                    Text("Priority: \(todo.priority.rawValue)")
                    if let category = todo.category {
                        Text("Category: \(category)")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                viewModel.toggleCompletion(for: todo)
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM, h:mm a"
        return formatter.string(from: date)
    }
}


