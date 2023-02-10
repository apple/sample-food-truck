/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The in-app purchase refund view.
*/

import SwiftUI
import StoreKit
import FoodTruckKit
import Foundation

struct RefundView: View {
    @State private var recentTransactions: [StoreKit.Transaction] = []
    @State private var selectedTransactionID: UInt64?
    @State private var refundSheetIsPresented = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List(recentTransactions, selection: $selectedTransactionID) { transaction in
            TransactionRowView(transaction: transaction)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Text("Select a purchase to refund")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                Button {
                    refundSheetIsPresented = true
                } label: {
                    Text("Request a refund")
                        .bold()
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding([.horizontal, .bottom])
                .disabled(selectedTransactionID == nil)
            }
        }
        .task { @MainActor in
            for await transaction in StoreKit.Transaction.all {
                // Ignore the already refunded transactions.
                if transaction.unsafePayloadValue.isRevoked {
                    continue
                }
                recentTransactions.append(transaction.unsafePayloadValue)
                if recentTransactions.count >= 10 {
                    break
                }
            }
        }
        .refundRequestSheet(
            for: selectedTransactionID ?? 0,
            isPresented: $refundSheetIsPresented
        ) { result in
            if case .success(.success) = result {
                dismiss()
            }
        }
        .navigationTitle("Refund purchases")
    }
    
}

struct TransactionRowView: View {
    let transaction: StoreKit.Transaction
    @State private var product: Product?
    
    var title: String {
        product?.displayName ?? transaction.productID
    }
    
    var subtitle: String {
        let purchaseDate = transaction.purchaseDate
            .formatted(date: .long, time: .omitted)
        if transaction.productType == .autoRenewable {
            return String(localized: "Subscribed \(purchaseDate)")
        } else {
            return String(localized: "Purchased \(purchaseDate)")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .bold()
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .task { @MainActor in
            product = await StoreActor.shared
                .product(identifiedBy: transaction.productID)
        }
    }
    
}

struct RefundView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RefundView()
        }
    }
}
