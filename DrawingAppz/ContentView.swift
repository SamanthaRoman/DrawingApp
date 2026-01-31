





import SwiftUI
import PencilKit

struct ContentView: View {
    
    @State private var canvasView = PKCanvasView() // paper
    @State private var toolPicker = PKToolPicker() // floating toolbox with all the elements
    var body: some View {

        NavigationView {
            VStack(spacing: 0) {
                CanvasView(canvasView: $canvasView, toolPicker: $toolPicker)
                    .navigationBarTitle("Drawing App", displayMode: .inline)
                    .navigationBarItems(
                        leading: HStack {
                            Button(action: cleanCanvas) {
                                Label("Clear", systemImage: "trash")
                            }
                            .keyboardShortcut("k", modifiers: .command)
                        },
                        trailing: HStack(spacing: 20) {
                            Button(action: undo) {
                                Label("Undo", systemImage: "arrow.uturn.backward")
                            }
                            .keyboardShortcut("z", modifiers: .command)
                            
                            Button(action: redo) {
                                Label("Redo", systemImage: "arrow.uturn.forward")
                            }
                            .keyboardShortcut("r", modifiers: .command)
                        }
                    )
                    .onAppear(perform: setupToolPicker)
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func cleanCanvas() {
        canvasView.drawing = PKDrawing()
    }
    
    private func undo() {
        canvasView.undoManager?.undo()
    }
    private func redo() {
        canvasView.undoManager?.redo()
    }
    
    private func setupToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        toolPicker.becomeFirstResponder()
    }
}

