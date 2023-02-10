/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The Widget entry point.
*/

import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
    var body: some Widget {
        // MARK: - Live Activity Widgets
        #if canImport(ActivityKit)
        TruckActivityWidget()
        #endif
        
        // MARK: - Accessory Widgets
        #if os(iOS) || os(watchOS)
        OrdersWidget()
        ParkingSpotAccessory()
        #endif
        
        // MARK: - Widgets
        #if os(iOS) || os(macOS)
        DailyDonutWidget()
        #endif
    }
}
 
