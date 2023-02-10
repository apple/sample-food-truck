/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An animated map view.
*/

import SwiftUI
import FoodTruckKit

struct ParkingSpotShowcaseView: View {
    var spot: ParkingSpot
    var topSafeAreaInset: Double
    var animated = true
    
    var body: some View {
        GeometryReader { proxy in
            TimelineView(.animation(paused: !animated)) { context in
                let seconds = context.date.timeIntervalSince1970
                let rotationPeriod = 240.0
                let headingDelta = seconds.percent(truncation: rotationPeriod)
                let pitchPeriod = 60.0
                let pitchDelta = seconds
                    .percent(truncation: pitchPeriod)
                    .symmetricEaseInOut()
                
                let viewWidthPercent = (350.0 ... 1000).percent(for: proxy.size.width)
                let distanceMultiplier = (1 - viewWidthPercent) * 0.5 + 1
                
                DetailedMapView(
                    location: spot.location,
                    distance: distanceMultiplier * spot.cameraDistance,
                    pitch: (50...60).value(percent: pitchDelta),
                    heading: 360 * headingDelta,
                    topSafeAreaInset: topSafeAreaInset
                )
            }
        }
    }
}

struct ParkingSpotShowcaseView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingSpotShowcaseView(spot: City.cupertino.parkingSpots[0], topSafeAreaInset: 0)
    }
}
