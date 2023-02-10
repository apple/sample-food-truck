/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A concurrent interface to StoreKit.
*/

import Foundation
import StoreKit

@globalActor public actor StoreActor {
    public static let socialFeedMonthlyID = "socialfeedplus.monthly"
    public static let socialFeedYearlyID = "socialfeedplus.yearly"
    public static let annualHistoryID = "feature.annualhistory"
    
    static let subscriptionIDs: Set<String> = [
        socialFeedMonthlyID,
        socialFeedYearlyID
    ]
    
    static let allProductIDs: Set<String> = {
        var ids = subscriptionIDs
        ids.insert(annualHistoryID)
        return ids
    }()
    
    public static let shared = StoreActor()
    
    private var loadedProducts: [String: Product] = [:]
    private var lastLoadError: Error?
    private var productLoadingTask: Task<Void, Never>?
    
    private var transactionUpdatesTask: Task<Void, Never>?
    private var statusUpdatesTask: Task<Void, Never>?
    private var storefrontUpdatesTask: Task<Void, Never>?

    public nonisolated let productController: StoreProductController
    public nonisolated let subscriptionController: StoreSubscriptionController
    
    init() {
        self.productController = StoreProductController(identifiedBy: Self.annualHistoryID)
        self.subscriptionController = StoreSubscriptionController(productIDs: Array(Self.subscriptionIDs))
        Task(priority: .background) {
            await self.setupListenerTasksIfNecessary()
            await self.loadProducts()
        }
    }
    
    public func product(identifiedBy productID: String) async -> Product? {
        await waitUntilProductsLoaded()
        return loadedProducts[productID]
    }
    
    private func setupListenerTasksIfNecessary() {
        if transactionUpdatesTask == nil {
            transactionUpdatesTask = Task(priority: .background) {
                for await update in StoreKit.Transaction.updates {
                    await self.handle(transaction: update)
                }
            }
        }
        if statusUpdatesTask == nil {
            statusUpdatesTask = Task(priority: .background) {
                for await update in Product.SubscriptionInfo.Status.updates {
                    await subscriptionController.handle(update: update)
                }
            }
        }
        if storefrontUpdatesTask == nil {
            storefrontUpdatesTask = Task(priority: .background) {
                for await update in Storefront.updates {
                    self.handle(storefrontUpdate: update)
                }
            }
        }
    }
    
    private func waitUntilProductsLoaded() async {
        if let task = productLoadingTask {
            await task.value
        }
        // You load all the products at once, so you can skip this if the
        // dictionary is empty.
        else if loadedProducts.isEmpty {
            let newTask = Task {
                await loadProducts()
            }
            productLoadingTask = newTask
            await newTask.value
        }
    }
    
    private func loadProducts() async {
        do {
            let products = try await Product.products(for: Self.allProductIDs)
            try Task.checkCancellation()
            print("Loaded \(products.count) products")
            loadedProducts = products.reduce(into: [:]) {
                $0[$1.id] = $1
            }
            let premiumProduct = loadedProducts[Self.annualHistoryID]
            Task(priority: .utility) { @MainActor in
                self.productController.product = premiumProduct
                self.subscriptionController.subscriptions = products
                    .compactMap { Subscription(subscription: $0) }
                // Now that you have loaded the products, have the subscription
                // controller update the entitlement based on the group ID.
                await self.subscriptionController.updateEntitlement()
            }
        } catch {
            print("Failed to get in-app products: \(error)")
            lastLoadError = error
        }
        productLoadingTask = nil
    }
    
    private func handle(transaction: VerificationResult<StoreKit.Transaction>) async {
        guard case .verified(let transaction) = transaction else {
            print("Received unverified transaction: \(transaction)")
            return
        }
        // If you have a subscription, call checkEntitlement() which gets the
        // full status instead.
        if transaction.productType == .autoRenewable {
            await subscriptionController.updateEntitlement()
        } else if transaction.productID == Self.annualHistoryID {
            await productController.set(isEntitled: !transaction.isRevoked)
        }
        await transaction.finish()
    }
    
    private func handle(storefrontUpdate newStorefront: Storefront) {
        print("Storefront changed to \(newStorefront)")
        // Cancel existing loading task if necessary.
        if let task = productLoadingTask {
            task.cancel()
        }
        // Load products again.
        productLoadingTask = Task(priority: .utility) {
            await self.loadProducts()
        }
    }
    
}

public extension StoreKit.Transaction {
    var isRevoked: Bool {
        // The revocation date is never in the future.
        revocationDate != nil
    }
}
