/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The food truck model.
*/

import Decide

final class FoodTruckState: AtomicState {
    
    @Mutable @Property public var donuts = Donut.all
    @Mutable @Property public var selectedDonut: Donut = Donut.cosmos

}
