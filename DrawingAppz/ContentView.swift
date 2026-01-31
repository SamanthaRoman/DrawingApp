





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
        canvasView.becomeFirstResponder()
    }
}


// Bridge between SwiftUI and UIKit
struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    
    func makeUIView(context: Context) -> PKCanvasView {
        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        } else {
            canvasView.allowsFingerDrawing = true
        }
        canvasView.delegate = context.coordinator
        return canvasView
    }
    
    // Update SwiftUI from the UIKit changes
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, PKCanvasViewDelegate {
            var parent: CanvasView
            
            init(_ parent: CanvasView) {
                self.parent = parent
            }
            
            func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
                print("drawing is working on every stroke")
            }
        }
    }
    

