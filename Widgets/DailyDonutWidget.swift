/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The Daily Donut Widget.
*/

import WidgetKit
import SwiftUI
import FoodTruckKit

struct DailyDonutWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Daily Donut", provider: Provider()) { entry in
            DailyDonutWidgetView(entry: entry)
        }
        #if os(iOS)
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
        #elseif os(macOS)
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        #endif
        .configurationDisplayName("Daily Donut")
        .description("Showcasing the latest trending donuts.")
    }
    
    struct Provider: TimelineProvider {
        func placeholder(in context: Context) -> Entry {
            Entry.preview
        }

        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            completion(.preview)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            var entries: [Entry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = Entry(date: entryDate, donut: Donut.all[hourOffset % Donut.all.count])
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    struct Entry: TimelineEntry {
        var date: Date
        var donut: Donut
        
        static let preview = Entry(date: .now, donut: .preview)
    }
}

struct DailyDonutWidgetView: View {
    var entry: DailyDonutWidget.Entry
    
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                DonutView(donut: entry.donut)
                Text(entry.donut.name)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.indigo.gradient)
            
        case .systemMedium:
            HStack {
                VStack {
                    DonutView(donut: entry.donut)
                    Text(entry.donut.name)
                }
                
                Text("Trend Data...")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.indigo.gradient)

        case .systemLarge:
            HStack {
                VStack {
                    DonutView(donut: entry.donut)
                    Text(entry.donut.name)
                }
                
                Text("Trend Data...")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.indigo.gradient)
            
        case .systemExtraLarge:
            HStack {
                VStack {
                    DonutView(donut: entry.donut)
                    Text(entry.donut.name)
                }
                
                Text("Trend Data...")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.indigo.gradient)
            
        default:
            Text("Unsupported!")
        }
    }
}

#if os(iOS) || os(macOS)
struct DailyDonutWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyDonutWidgetView(entry: .preview)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif
