/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The Orders Widget.
*/

import WidgetKit
import SwiftUI
import FoodTruckKit

struct OrdersWidget: Widget {
    static var supportedFamilies: [WidgetFamily] {
        var families: [WidgetFamily] = []
        
        #if os(iOS) || os(watchOS)
        // Common families between iOS and watchOS
        families += [.accessoryRectangular, .accessoryCircular, .accessoryInline]
        #endif
        
        #if os(iOS)
        // Families specific to iOS
        families += [.systemSmall]
        #endif
        
        return families
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Orders", provider: Provider()) { entry in
            OrdersWidgetView(entry: entry)
        }
        .supportedFamilies(OrdersWidget.supportedFamilies)
        .configurationDisplayName("Orders")
        .description("Information about Food Truck's orders and daily quotas.")
    }
    
    struct Provider: TimelineProvider {
        func placeholder(in context: Context) -> Entry { Entry.preview }

        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            completion(.preview)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            var entries: [Entry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = Entry(date: entryDate, orders: 7 + hourOffset, quota: 25)
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    struct Entry: TimelineEntry {
        var date: Date
        var orders: Int
        var quota: Int
        
        static let preview = Entry(date: .now, orders: 7, quota: 13)
    }
}

struct OrdersWidgetView: View {
    var entry: OrdersWidget.Entry
    
    @Environment(\.widgetFamily) private var family
    @Environment(\.widgetRenderingMode) private var widgetRenderingMode
    
    var body: some View {
        switch family {
        #if os(iOS)
        case .systemSmall:
            ZStack {
                LinearGradient(gradient: Gradient.widgetAccent, startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                VStack(alignment: .leading) {
                    Text("Orders")
                        .font(.title)
                    
                    Text("\(entry.orders.formatted()) out of \(entry.quota.formatted())")
                    
                    Gauge(value: Double(entry.orders), in: 0...Double(entry.quota)) {
                        EmptyView()
                    } currentValueLabel: {
                        DonutView(donut: Donut.classic)
                    }
                    .tint(Color.white)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .padding()
            }
        #endif
            
        #if os(iOS) || os(watchOS)
        case .accessoryCircular:
            Gauge(value: Double(entry.orders), in: 0...Double(entry.quota)) {
                Image.donutSymbol
            } currentValueLabel: {
                Text(entry.orders.formatted())
            }
            .gaugeStyle(.accessoryCircular )
            .tint(Gradient.widgetAccent)

        case .accessoryRectangular:
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Image.donutSymbol
                    
                    Text("Orders")
                }
                .font(.headline)
                .foregroundColor(.widgetAccent)
                .widgetAccentable()
                .padding(.top, 4)
                                
                SegmentedGauge(value: entry.orders, total: entry.quota) {
                    Text("\(entry.orders.formatted()) out of \(entry.quota.formatted())")
                }
                .tint(Color.widgetAccent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        case .accessoryInline:
            Label {
                Text("\(entry.orders) of \(entry.quota) Orders")
            } icon: {
                Image.donutSymbol
            }
        #endif
        default:
            Text("Unsupported!")
        }
    }
}

struct OrdersAccessory_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(OrdersWidget.supportedFamilies, id: \.rawValue) { family in
            OrdersWidgetView(entry: .preview)
                .previewContext(WidgetPreviewContext(family: family))
                .previewDisplayName("Orders: \(family)")
        }
    }
}

