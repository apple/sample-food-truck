//
//  ToppingPicker.swift
//  
//
//  Created by Anton Kolchunov on 15.08.23.
//

import SwiftUI

struct ToppingPicker: View {

    @Binding var topping: Donut.Topping?

    var body: some View {
        Picker("Topping", selection: $topping) {
            Section {
                Text("None")
                    .tag(nil as Donut.Topping?)
            }
            Section {
                ForEach(Donut.Topping.other) { topping in
                    Text(topping.name)
                        .tag(topping as Donut.Topping?)
                }
            }
            Section {
                ForEach(Donut.Topping.lattices) { topping in
                    Text(topping.name)
                        .tag(topping as Donut.Topping?)
                }
            }
            Section {
                ForEach(Donut.Topping.lines) { topping in
                    Text(topping.name)
                        .tag(topping as Donut.Topping?)
                }
            }
            Section {
                ForEach(Donut.Topping.drizzles) { topping in
                    Text(topping.name)
                        .tag(topping as Donut.Topping?)
                }
            }
        }
    }
}

struct ToppingPicker_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            Form() {
                Section {
                    ToppingPicker(topping: .constant(.blueberryDrizzle))
                }
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}

