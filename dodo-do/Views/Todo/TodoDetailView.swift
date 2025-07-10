import SwiftUI

struct TodoDetailView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State var todo: TodoItem
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Form {
                TextField("Title", text: $todo.title)
                
                Text("Content:")
                TextEditor(text: $todo.content)
                    .frame(minHeight: 100)
            }
            .padding()

            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Save") {
                    viewModel.updateTodo(todo)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
        .frame(width: 300, height: 250)
    }
}
