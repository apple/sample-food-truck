/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The Truck model.
*/

import Foundation

public struct Truck {
    public var city: City = .cupertino
    public var location: ParkingSpot = City.cupertino.parkingSpots[0]
}

public extension Truck {
    static var preview = Truck()
}
