/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The donut editor view.
*/

import SwiftUI
import Decide

struct DonutEditor: View {
    
    @Bind(\FoodTruckState.$editorDonut) var donut
    
    var body: some View {
        ZStack {
            WidthThresholdReader { proxy in
                if proxy.isCompact {
                    Form {
                        donutViewer
                        editorContent
                    }
                } else {
                    HStack(spacing: 0) {
                        donutViewer
                        Divider().ignoresSafeArea()
                        Form {
                            editorContent
                        }
                        .formStyle(.grouped)
                        .frame(width: 350)
                    }
                }
            }
        }
        .toolbar {
            ToolbarTitleMenu {
                Button {

                } label: {
                    Label("My Action", systemImage: "star")
                }
            }
        }
        .navigationTitle(donut.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
    
    var donutViewer: some View {
        DonutView(donut: donut)
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
            .listRowInsets(.init())
            .padding(.horizontal, 40)
            .padding(.vertical)
            .background()
    }
    
    @ViewBuilder
    var editorContent: some View {
        Section("Donut") {
            TextField("Name", text: $donut.name, prompt: Text("Donut Name"))
        }

        Section("Flavor profile") {
            DonatFlavorDetailsView(
                mostPotentFlavor: donut.flavors.mostPotent,
                flavors: donut.flavors
            )
        }
        
        Section("Ingredients") {
            DoughPicker(dough: $donut.dough)

            GlazePicker(glaze: $donut.glaze)

            ToppingPicker(topping: $donut.topping)
        }
    }
}

struct DonutEditor_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            NavigationView {
                DonutEditor()
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
