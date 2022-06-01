/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The order detail view.
*/

import SwiftUI
import FoodTruckKit

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
                    order.markAsComplete()
                } label: {
                    Label("Complete Order", systemImage: "checkmark.circle")
                        .symbolVariant(order.isComplete ? .fill : .none)
                }
                .labelStyle(.iconOnly)
                .disabled(order.isComplete)
            }
        }
    }
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
