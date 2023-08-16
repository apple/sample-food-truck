//
//  NewDonutEditor.swift
//  
//
//  Created by Anton Kolchunov on 15.08.23.
//

import Decide
import SwiftUI

struct NewDonutEditor: View {

    @Observe(\FoodTruckState.$selectedDonut) var donut

    var body: some View {
        DonutEditor()
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
}

struct NewDonutEditor_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            NavigationView {
                NewDonutEditor()
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
