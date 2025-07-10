import SwiftUI

struct WheelPickerView: View {
    @Binding var selection: Int
    let range: Range<Int>
    let label: String

    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0

    private let itemHeight: CGFloat = 40
    private let visibleItems: Int = 5 // Should be an odd number

    var body: some View {
        GeometryReader { geometry in
            let halfWay = geometry.size.height / 2 - itemHeight / 2
            
            VStack(spacing: 0) {
                ForEach(range, id: \.self) { index in
                    Text(String(format: "%02d", index))
                        .font(.title)
                        .frame(width: geometry.size.width, height: itemHeight)
                        .opacity(opacity(for: index))
                        .scaleEffect(scale(for: index))
                }
            }
            .offset(y: halfWay + dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.dragOffset = lastDragOffset + value.translation.height
                    }
                    .onEnded { value in
                        let predictedEndOffset = lastDragOffset + value.predictedEndTranslation.height
                        let targetIndex = -Int(round(predictedEndOffset / itemHeight))
                        let clampedIndex = max(range.lowerBound, min(range.upperBound - 1, targetIndex))
                        
                        if self.selection != clampedIndex {
                           NSSound(named: "Pop")?.play()
                        }
                        self.selection = clampedIndex
                        
                        withAnimation(.spring()) {
                            self.dragOffset = -CGFloat(clampedIndex) * itemHeight
                        }
                        self.lastDragOffset = self.dragOffset
                    }
            )
            .onAppear {
                // Set initial offset
                self.dragOffset = -CGFloat(selection) * itemHeight
                self.lastDragOffset = self.dragOffset
            }
            .onChange(of: selection) { newSelection in
                 // Update offset if selection changes externally
                withAnimation(.spring()) {
                    self.dragOffset = -CGFloat(newSelection) * itemHeight
                }
                self.lastDragOffset = self.dragOffset
            }
        }
        .frame(height: itemHeight * CGFloat(visibleItems))
        .clipped()
        .overlay(
            VStack(spacing: 0) {
                Rectangle().fill(LinearGradient(colors: [.black.opacity(0.8), .black.opacity(0)], startPoint: .top, endPoint: .bottom)).frame(height: itemHeight * 2)
                Spacer()
                Rectangle().fill(LinearGradient(colors: [.black.opacity(0), .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)).frame(height: itemHeight * 2)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                .frame(height: itemHeight)
        )
    }
    
    private func opacity(for index: Int) -> Double {
        let selectedY = -dragOffset
        let itemY = CGFloat(index) * itemHeight
        let distance = abs(selectedY - itemY) / itemHeight
        return max(0, 1 - distance * 0.5)
    }

    private func scale(for index: Int) -> CGFloat {
        let selectedY = -dragOffset
        let itemY = CGFloat(index) * itemHeight
        let distance = abs(selectedY - itemY) / itemHeight
        return max(0.5, 1 - distance * 0.2)
    }
}
