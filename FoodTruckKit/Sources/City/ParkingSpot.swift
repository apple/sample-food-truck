/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The parking spot model object.
*/

import Foundation
import CoreLocation

public struct ParkingSpot: Identifiable, Hashable {
    public var id: String { name }
    public var name: String
    public var location: CLLocation
    public var cameraDistance: Double = 1000
}
