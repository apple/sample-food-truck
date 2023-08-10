/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The food truck model.
*/

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
