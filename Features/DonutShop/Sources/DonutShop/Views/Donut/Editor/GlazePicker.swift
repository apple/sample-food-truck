//
//  GlazePicker.swift
//  
//
//  Created by Anton Kolchunov on 15.08.23.
//

import SwiftUI

struct GlazePicker: View {

    @Binding var glaze: Donut.Glaze?

    var body: some View {
        Picker("Glaze", selection: $glaze) {
            Section {
                Text("None")
                    .tag(nil as Donut.Glaze?)
            }
            ForEach(Donut.Glaze.all) { glaze in
                Text(glaze.name)
                    .tag(glaze as Donut.Glaze?)
            }
        }
    }
}

struct GlazePicker_Previews: PreviewProvider {

    struct Preview: View {
        var body: some View {
            Form() {
                Section {
                    GlazePicker(glaze: .constant(.blueberry))
                }
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}

