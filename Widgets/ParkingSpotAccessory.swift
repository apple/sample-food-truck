/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The Parking Spot Accessory View.
*/

import WidgetKit
import SwiftUI
import FoodTruckKit

struct ParkingSpotAccessory: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Parking Spot", provider: Provider()) { entry in
            ParkingSpotAccessoryView(entry: entry)
        }
        #if os(iOS) || os(watchOS)
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .accessoryCircular])
        #endif
        .configurationDisplayName("Parking Spot")
        .description("Information about your Food Truck's parking spot.")
    }
    
    struct Provider: TimelineProvider {
        func placeholder(in context: Context) -> Entry { Entry.preview }

        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            completion(.preview)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            let timeline = Timeline(entries: [Entry.preview], policy: .never)
            completion(timeline)
        }
    }
    
    struct Entry: TimelineEntry {
        var date: Date
        var city: City
        var parkingSpot: ParkingSpot
        
        static let preview = Entry(date: .now, city: .cupertino, parkingSpot: City.cupertino.parkingSpots[0])
    }
}

struct ParkingSpotAccessoryView: View {
    var entry: ParkingSpotAccessory.Entry
    
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        switch family {
        #if os(iOS) || os(watchOS)
        case .accessoryInline:
            Label(entry.parkingSpot.name, systemImage: "box.truck")
        case .accessoryCircular:
            VStack {
                Image(systemName: "box.truck")
                Text("CUP")
            }

        case .accessoryRectangular:
            Label {
                Text("Parking Spot")
                Text(entry.parkingSpot.name)
                Text(entry.city.name)
            } icon: {
                Image(systemName: "box.truck")
            }
        #endif
        default:
            Text("Unsupported!")
        }
    }
}

struct ParkingSpotAccessory_Previews: PreviewProvider {
    static var previews: some View {
        ParkingSpotAccessoryView(entry: .preview)
            #if os(iOS) || os(watchOS)
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            #endif
    }
}

