import SwiftUI

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = true
    @State private var priority: Priority = .medium
    @State private var category: String = "Personal"

    var body: some View {
        VStack {
            Text("忙起来 (New Todo)")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()

            Form {
                TextField("Title", text: $title)
                
                TextEditor(text: $content)
                    .frame(minHeight: 80)
                    .border(Color.gray.opacity(0.2), width: 1)
                
                Toggle(isOn: $hasDueDate) {
                    Text("Has Due Date")
                }
                
                if hasDueDate {
                    DatePicker("Due Date", selection: $dueDate)
                }
                
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
                
                TextField("Category", text: $category)
            }
            .padding()

            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Add Task") {
                    viewModel.addTodo(
                        title: title,
                        content: content,
                        dueDate: hasDueDate ? dueDate : nil,
                        priority: priority,
                        category: category.isEmpty ? nil : category
                    )
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(title.isEmpty)
            }
            .padding()
        }
        .frame(width: 400, height: 450)
        .padding()
    }
}
