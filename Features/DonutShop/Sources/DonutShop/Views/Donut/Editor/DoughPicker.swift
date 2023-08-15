//
//  DoughPicker.swift
//  
//
//  Created by Anton Kolchunov on 15.08.23.
//

import SwiftUI

struct DoughPicker: View {

    @Binding var dough: Donut.Dough

    var body: some View {
        Picker("Dough", selection: $dough) {
            ForEach(Donut.Dough.all) { dough in
                Text(dough.name)
                    .tag(dough)
            }
        }
    }
}

struct DoughPicker_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            Form() {
                Section {
                    DoughPicker(dough: .constant(.plain))
                }
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}

