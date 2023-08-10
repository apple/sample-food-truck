/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The food truck model.
*/

import SwiftUI
import Combine
import Decide


final class FoodTruckState: AtomicState {
    
    @Property public var donuts = Donut.all
    @Mutable @Property public var editorDonut: Donut = Donut(
        id: Donut.all.count,
        name: String(localized: "New Donut", comment: "New donut-placeholder name."),
        dough: .plain,
        glaze: .chocolate,
        topping: .sprinkles
    )
    
}

@MainActor
public class FoodTruckModel: ObservableObject {

    @Published public var donuts = Donut.all
    @Published public var newDonut: Donut

    public init() {
        newDonut = Donut(
            id: Donut.all.count,
            name: String(localized: "New Donut", comment: "New donut-placeholder name."),
            dough: .plain,
            glaze: .chocolate,
            topping: .sprinkles
        )
    }

    public func donuts<S: Sequence>(fromIDs ids: S) -> [Donut] where S.Element == Donut.ID {
        ids.map { donut(id: $0) }
    }

    public func donut(id: Donut.ID) -> Donut {
        donuts[id]
    }
    
    public func donutBinding(id: Donut.ID) -> Binding<Donut> {
        Binding<Donut> {
            self.donuts[id]
        } set: { newValue in
            self.donuts[id] = newValue
        }
    }
    
    public func updateDonut(id: Donut.ID, to newValue: Donut) {
        donutBinding(id: id).wrappedValue = newValue
    }
}

public extension FoodTruckModel {
    static let preview = FoodTruckModel()
}
