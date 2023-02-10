/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The orders view.
*/

import SwiftUI
import FoodTruckKit

struct OrdersView: View {
    @ObservedObject var model: FoodTruckModel
    
    @State private var sortOrder = [KeyPathComparator(\Order.status, order: .reverse)]
    @State private var searchText = ""
    @State private var selection: Set<Order.ID> = []
    @State private var completedOrder: Order?
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.editMode) private var editMode
    #endif
    
    var displayAsList: Bool {
        #if os(iOS)
        return sizeClass == .compact
        #else
        return false
        #endif
    }
    
    var orders: [Order] {
        model.orders.filter { order in
            order.matches(searchText: searchText) || order.donuts.contains(where: { $0.matches(searchText: searchText) })
        }
        .sorted(using: sortOrder)
    }
    
    var orderSections: [OrderStatus: [Order]] {
        var result: [OrderStatus: [Order]] = [:]
        orders.forEach { order in
            result[order.status, default: []].append(order)
        }
        return result
    }
    
    var body: some View {
        ZStack {
            if displayAsList {
                list
            } else {
                OrdersTable(model: model, selection: $selection, completedOrder: $completedOrder, searchText: $searchText)
                    .tableStyle(.inset)
            }
        }
        .navigationTitle("Orders")
        .navigationDestination(for: Order.ID.self) { id in
            OrderDetailView(order: model.orderBinding(for: id))
        }
        .toolbar {
            if !displayAsList {
                toolbarButtons
            }
        }
        .searchable(text: $searchText)
        .sheet(item: $completedOrder) { order in
            OrderCompleteView(order: order)
        }
    }
    
    var list: some View {
        List {
            if let orders = orderSections[.placed] {
                Section("New") {
                    orderRows(orders)
                }
            }
            
            if let orders = orderSections[.preparing] {
                Section("Preparing") {
                    orderRows(orders)
                }
            }
            
            if let orders = orderSections[.ready] {
                Section("Ready") {
                    orderRows(orders)
                }
            }
            
            if let orders = orderSections[.completed] {
                Section("Completed") {
                    orderRows(orders)
                }
            }
        }
        .headerProminence(.increased)
    }
    
    func orderRows(_ orders: [Order]) -> some View {
        ForEach(orders) { order in
            NavigationLink(value: order.id) {
                OrderRow(order: order)
                    .badge(order.totalSales)
            }
        }
    }
    
    @ViewBuilder
    var toolbarButtons: some View {
        NavigationLink(value: selection.first) {
            Label("View Details", systemImage: "list.bullet.below.rectangle")
        }
        .disabled(selection.isEmpty)
        
        Button {
            for orderID in selection {
                model.markOrderAsCompleted(id: orderID)
            }
            if let orderID = selection.first {
                completedOrder = model.orderBinding(for: orderID).wrappedValue
            }
        } label: {
            Label("View Details", systemImage: "checkmark.circle")
        }
        .disabled(selection.isEmpty)
        
        #if os(iOS)
        if editMode?.wrappedValue.isEditing == false {
            Button("Select") {
                editMode?.wrappedValue = .active
            }
        } else {
            EditButton()
        }
        #endif
    }
}

struct OrdersView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel.preview
        
        var body: some View {
            OrdersView(model: model)
        }
    }
    
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
