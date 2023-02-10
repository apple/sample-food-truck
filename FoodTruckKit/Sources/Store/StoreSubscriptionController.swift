/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A class that manages StoreKit subscriptions.
*/

import Foundation
import StoreKit
import Combine

@MainActor
public final class StoreSubscriptionController: ObservableObject {
    @Published public internal(set) var subscriptions: [Subscription] = []
    @Published public private(set) var entitledSubscriptionID: String?
    @Published public private(set) var autoRenewPreference: String?
    @Published public private(set) var purchaseError: (any LocalizedError)?
    @Published public private(set) var expirationDate: Date?
    
    private let productIDs: [String]
    
    private var groupID: String? {
        subscriptions.first?.subscriptionGroupID
    }
    
    public var entitledSubscription: Subscription? {
        subscriptions.first { $0.id == entitledSubscriptionID }
    }
    
    public var nextSubscription: Subscription? {
        subscriptions.first { $0.id == autoRenewPreference }
    }
    
    internal nonisolated init(productIDs: [String]) {
        self.productIDs = productIDs
        Task { @MainActor in
            await self.updateEntitlement()
        }
    }
    
    public enum PurchaseFinishedAction {
        case dismissStore
        case noAction
        case displayError
    }
    
    public func purchase(option subscription: Subscription) async -> PurchaseFinishedAction {
        let action: PurchaseFinishedAction
        do {
            let result = try await subscription.product.purchase()
            switch result {
            case .success(let verificationResult):
                let transaction = try verificationResult.payloadValue
                entitledSubscriptionID = transaction.productID
                autoRenewPreference = transaction.productID
                expirationDate = transaction.expirationDate
                await transaction.finish()
                action = .dismissStore
            case .pending:
                print("Purchase pending user action")
                action = .noAction
            case .userCancelled:
                print("User cancelled purchase")
                action = .noAction
            @unknown default:
                print("Unknown result: \(result)")
                action = .noAction
            }
        } catch let error as LocalizedError {
            purchaseError = error
            action = .displayError
        } catch {
            print("Purchase failed: \(error)")
            action = .noAction
        }
        // Check status again.
        await updateEntitlement()
        return action
    }
    
    internal func handle(update status: Product.SubscriptionInfo.Status) {
        guard case .verified(let transaction) = status.transaction,
              case .verified(let renewalInfo) = status.renewalInfo else {
            print("""
            Unverified entitlement for \
            \(status.transaction.unsafePayloadValue.productID)
            """)
            return
        }
        if status.state == .subscribed || status.state == .inGracePeriod {
            entitledSubscriptionID = renewalInfo.currentProductID
            autoRenewPreference = renewalInfo.autoRenewPreference
            expirationDate = transaction.expirationDate
        } else {
            entitledSubscriptionID = nil
            autoRenewPreference = renewalInfo.autoRenewPreference
        }
    }
    
    internal func updateEntitlement() async {
        // Start with nil.
        entitledSubscriptionID = nil
        if let groupID = groupID {
            await updateEntitlement(groupID: groupID)
        } else {
            await updateEntitlementWithProductIDs()
        }
    }
    
    /// Update the entitlement state based on the status API.
    /// - Parameter groupID: The groupID to check status for.
    func updateEntitlement(groupID: String) async {
        guard let statuses = try? await Product.SubscriptionInfo.status(for: groupID) else {
            return
        }
        for status in statuses {
            guard case .verified(let transaction) = status.transaction,
                  case .verified(let renewalInfo) = status.renewalInfo else {
                print("""
                Unverified entitlement for \
                \(status.transaction.unsafePayloadValue.productID)
                """)
                continue
            }
            if status.state == .subscribed || status.state == .inGracePeriod {
                entitledSubscriptionID = renewalInfo.currentProductID
                autoRenewPreference = renewalInfo.autoRenewPreference
                expirationDate = transaction.expirationDate
            }
        }
    }
    
    /// Update the entitlement based on the current entitlement API. Use this if there is no network
    /// connection and the subscription group ID is not accessible.
    private func updateEntitlementWithProductIDs() async {
        for productID in productIDs {
            guard let entitlement = await StoreKit.Transaction.currentEntitlement(for: productID) else {
                continue
            }
            guard case .verified(let transaction) = entitlement else {
                print("""
                Unverified entitlement for \
                \(entitlement.unsafePayloadValue.productID)
                """)
                continue
            }
            entitledSubscriptionID = transaction.productID
            break
        }
    }
    
}
