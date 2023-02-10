/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The city model object.
*/

import Foundation
import CoreLocation

public struct City: Identifiable, Hashable {
    public var id: String { name }
    public var name: String
    public var parkingSpots: [ParkingSpot]
}

public extension City {
    static let sanFrancisco = City(
        name: String(localized: "San Francisco", bundle: .module, comment: "A city in California."),
        parkingSpots: [
            ParkingSpot(
                name: String(localized: "Coit Tower", bundle: .module, comment: "A landmark in San Francisco."),
                location: CLLocation(latitude: 37.8024, longitude: -122.4058),
                cameraDistance: 300
            ),
            ParkingSpot(
                name: String(localized: "Fisherman's Wharf", bundle: .module, comment: "A landmark in San Francisco."),
                location: CLLocation(latitude: 37.8099, longitude: -122.4103),
                cameraDistance: 700
            ),
            ParkingSpot(
                name: String(localized: "Ferry Building", bundle: .module, comment: "A landmark in San Francisco."),
                location: CLLocation(latitude: 37.7956, longitude: -122.3935),
                cameraDistance: 450
            ),
            ParkingSpot(
                name: String(localized: "Golden Gate Bridge", bundle: .module, comment: "A landmark in San Francisco."),
                location: CLLocation(latitude: 37.8199, longitude: -122.4783),
                cameraDistance: 2000
            ),
            ParkingSpot(
                name: String(localized: "Oracle Park", bundle: .module, comment: "A landmark in San Francisco."),
                location: CLLocation(latitude: 37.7786, longitude: -122.3893),
                cameraDistance: 650
            ),
            ParkingSpot(
                name: String(localized: "The Castro Theatre", bundle: .module, comment: "A landmark in San Francisco."),
                location: CLLocation(latitude: 37.7609, longitude: -122.4350),
                cameraDistance: 400
            ),
            ParkingSpot(
                name: String(localized: "Sutro Tower", bundle: .module, comment: "A landmark in San Francisco."),
                location: CLLocation(latitude: 37.7552, longitude: -122.4528)
            ),
            ParkingSpot(
                name: String(localized: "Bay Bridge", bundle: .module, comment: "A landmark in San Francisco."),
                location: CLLocation(latitude: 37.7983, longitude: -122.3778)
            )
        ]
    )
    
    static let cupertino = City(
        name: String(localized: "Cupertino", bundle: .module, comment: "A city in California."),
        parkingSpots: [
            ParkingSpot(
                name: String(localized: "Apple Park", bundle: .module, comment: "Apple's headquarters in California."),
                location: CLLocation(latitude: 37.3348, longitude: -122.0090),
                cameraDistance: 1100
            ),
            ParkingSpot(
                name: String(localized: "Infinite Loop", comment: "One of Apple's buildings in California."),
                location: CLLocation(latitude: 37.3317, longitude: -122.0302)
            )
        ]
    )
    
    static let london = City(
        name: String(localized: "London", bundle: .module, comment: "A city in England."),
        parkingSpots: [
            ParkingSpot(
                name: String(localized: "Big Ben", bundle: .module, comment: "A landmark in London."),
                location: CLLocation(latitude: 51.4994, longitude: -0.1245),
                cameraDistance: 850
            ),
            ParkingSpot(
                name: String(localized: "Buckingham Palace", bundle: .module, comment: "A landmark in London."),
                location: CLLocation(latitude: 51.5014, longitude: -0.1419),
                cameraDistance: 750
            ),
            ParkingSpot(
                name: String(localized: "Marble Arch", bundle: .module, comment: "A landmark in London."),
                location: CLLocation(latitude: 51.5131, longitude: -0.1589)
            ),
            ParkingSpot(
                name: String(localized: "Piccadilly Circus", bundle: .module, comment: "A landmark in London."),
                location: CLLocation(latitude: 51.510_067, longitude: -0.133_869)
            ),
            ParkingSpot(
                name: String(localized: "Shakespeare's Globe", bundle: .module, comment: "A landmark in London."),
                location: CLLocation(latitude: 51.5081, longitude: -0.0972)
            ),
            ParkingSpot(
                name: String(localized: "Tower Bridge", bundle: .module, comment: "A landmark in London."),
                location: CLLocation(latitude: 51.5055, longitude: -0.0754)
            )
        ]
    )
    
    static let all = [cupertino, sanFrancisco, london]
    
    static func identified(by id: City.ID) -> City {
        guard let result = all.first(where: { $0.id == id }) else {
            fatalError("Unknown City ID: \(id)")
        }
        return result
    }
}
