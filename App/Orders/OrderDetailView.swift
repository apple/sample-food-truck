/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The order detail view.
*/

import SwiftUI
import FoodTruckKit
#if canImport(ActivityKit)
import ActivityKit
#endif

struct OrderDetailView: View {
    @Binding var order: Order
    
    @State private var presentingCompletionSheet = false
    
    var body: some View {
        List {
            Section("Status") {
                HStack {
                    Text(order.status.title)
                    Spacer()
                    Image(systemName: order.status.iconSystemName)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Order Started")
                    Spacer()
                    Text(order.formattedDate)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Donuts") {
                ForEach(order.donuts) { donut in
                    Label {
                        Text(donut.name)
                    } icon: {
                        DonutView(donut: donut)
                    }
                    .badge(order.sales[donut.id]!)
                }
            }
            
            Text("Total Donuts")
                .badge(order.totalSales)
        }
        .navigationTitle(order.id)
        .sheet(isPresented: $presentingCompletionSheet) {
            OrderCompleteView(order: order)
        }
        .onChange(of: order.status) { status in
            if status == .completed {
                presentingCompletionSheet = true
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    order.markAsNextStep { status in
                        if status == .preparing {
                            #if canImport(ActivityKit)
                            print("Start live activity.")
                            prepareOrder()
                            #endif
                        } else if status == .completed {
                            #if canImport(ActivityKit)
                            print("Stop live activity.")
                            endActivity()
                            #endif
                        }
                    }
                } label: {
                    Label(order.status.buttonTitle, systemImage: order.status.iconSystemName)
                        .symbolVariant(order.isComplete ? .fill : .none)
                }
                .labelStyle(.iconOnly)
                .disabled(order.isComplete)
            }
        }
    }
    
    #if canImport(ActivityKit)
    func prepareOrder() {
        let timerSeconds = 60
        let activityAttributes = TruckActivityAttributes(
            orderID: String(order.id.dropFirst(6)),
            order: order.donuts.map(\.id),
            sales: order.sales,
            activityName: "Order preparation activity."
        )
        
        let future = Date(timeIntervalSinceNow: Double(timerSeconds))
        
        let initialContentState = TruckActivityAttributes.ContentState(timerRange: Date.now...future)
        
        let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 2, to: Date())!)
        
        do {
            let myActivity = try Activity<TruckActivityAttributes>.request(attributes: activityAttributes, content: activityContent,
                pushType: nil)
            print(" Requested MyActivity live activity. ID: \(myActivity.id)")
            postNotification()
        } catch let error {
            print("Error requesting live activity: \(error.localizedDescription)")
        }
    }
    
    func endActivity() {
        Task {
            for activity in Activity<TruckActivityAttributes>.activities {
                // Check if this is the activity associated with this order.
                if activity.attributes.orderID == String(order.id.dropFirst(6)) {
                    await activity.end(nil, dismissalPolicy: .immediate)
                }
            }
        }
    }
    #endif
    
    #if os(iOS)
    func postNotification() {
        let timerSeconds = 60
        let content = UNMutableNotificationContent()
        content.title = "Donuts are done!"
        content.body = "Time to take them out of the oven."
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerSeconds), repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
               print("Error posting local notification: \(error?.localizedDescription ?? "no description")")
           } else {
               print("Posted local notification.")
           }
        }
    }
    #endif
}

struct OrderDetailView_Previews: PreviewProvider {
    struct Preview: View {
        @State private var order = Order.preview
        var body: some View {
            OrderDetailView(order: $order)
        }
    }
    
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
