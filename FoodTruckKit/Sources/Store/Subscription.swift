/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A StoreKit subscription model.
*/

import Foundation
import StoreKit

@dynamicMemberLookup
public struct Subscription: Identifiable, Equatable {
    public let product: Product
    public var subscriptionInfo: Product.SubscriptionInfo {
        product.subscription.unsafelyUnwrapped
    }
    
    public var id: String { product.id }
    
    init?(subscription: Product) {
        guard subscription.subscription != nil else {
            return nil
        }
        self.product = subscription
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<Product, T>) -> T {
        product[keyPath: keyPath]
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<Product.SubscriptionInfo, T>) -> T {
        subscriptionInfo[keyPath: keyPath]
    }
    
    public var priceText: String {
        "\(self.displayPrice)/\(self.subscriptionPeriod.unit.localizedDescription.lowercased())"
    }
}

public struct SubscriptionSavings {
    public let percentSavings: Decimal
    public let granularPrice: Decimal
    public let granularPricePeriod: Product.SubscriptionPeriod.Unit
    
    public init(percentSavings: Decimal, granularPrice: Decimal, granularPricePeriod: Product.SubscriptionPeriod.Unit) {
        self.percentSavings = percentSavings
        self.granularPrice = granularPrice
        self.granularPricePeriod = granularPricePeriod
    }
    
    public var formattedPercent: String {
        return percentSavings.formatted(.percent.precision(.significantDigits(3)))
    }
    
    public func formattedPrice(for subscription: Subscription) -> String {
        let currency = granularPrice.formatted(subscription.priceFormatStyle)
        let period = granularPricePeriod.formatted(subscription.subscriptionPeriodUnitFormatStyle)
        return "\(currency)/\(period)"
    }
}
