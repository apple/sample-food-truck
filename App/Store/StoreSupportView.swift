/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The in-app purchase support view.
*/

import SwiftUI
import StoreKit
import FoodTruckKit

struct StoreSupportView: View {
    #if os(iOS)
    @State private var manageSubscriptionSheetIsPresented = false
    #endif
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            #if os(iOS)
            Button("Manage subscription") {
                manageSubscriptionSheetIsPresented = true
            }
            .manageSubscriptionsSheet(isPresented: $manageSubscriptionSheetIsPresented)
            NavigationLink("Refund purchases") {
                RefundView()
            }
            .foregroundColor(.accentColor)
            #endif
            Button("Restore missing purchases") {
                Task(priority: .userInitiated) {
                    try await AppStore.sync()
                }
            }
        }
        .navigationTitle("Help with purchases")
    }
    
}

struct StoreSupportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StoreSupportView()
        }
    }
}
