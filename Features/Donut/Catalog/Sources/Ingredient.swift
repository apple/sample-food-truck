/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The ingredient model object.
*/

import Decide
import Foundation


public final class Ingridient: KeyedState<Ingridient.ID> {
    public typealias ID = UUID
    @Property public var name: String = "Nothing"
    @Property public var flavours: [Flavor.ID] = []
    @Property public var color: String? // color id/name
    @Property public var image: String? // image asset name
}

public final class Flavor: KeyedState<Flavor.ID> {
    public typealias ID = UUID
    @Property public var name: String = "Unflavored"
    @Property public var profile: Flavor.Profile = .init()
}

public extension Flavor {
    enum Kind: String, Identifiable, CaseIterable {
        case salty, sweet, bitter, sour, savory, spicy
        public var id: String { rawValue }
    }

    struct Profile: Hashable, Codable {
        public var salty: Int
        public var sweet: Int
        public var bitter: Int
        public var sour: Int
        public var savory: Int
        public var spicy: Int

        public init(salty: Int = 0, sweet: Int = 0, bitter: Int = 0, sour: Int = 0, savory: Int = 0, spicy: Int = 0) {
            self.salty = salty
            self.sweet = sweet
            self.bitter = bitter
            self.sour = sour
            self.savory = savory
            self.spicy = spicy
        }

        public subscript(flavor: Kind) -> Int {
            get {
                switch flavor {
                case .salty: return salty
                case .sweet: return sweet
                case .bitter: return bitter
                case .sour: return sour
                case .savory: return savory
                case .spicy: return spicy
                }
            }
            set(newValue) {
                switch flavor {
                case .salty: salty = newValue
                case .sweet: sweet = newValue
                case .bitter: bitter = newValue
                case .sour: sour = newValue
                case .savory: savory = newValue
                case .spicy: spicy = newValue
                }
            }
        }

        public func union(with other: Profile) -> Profile {
            var result = self
            for flavor in Kind.allCases {
                result[flavor] += other[flavor]
            }
            return result
        }

        public mutating func formUnion(with other: Profile) {
            self = union(with: other)
        }

        public var mostPotent: (Kind, Int) {
            var highestValue = 0
            var mostPotent = Kind.sweet
            for flavor in Kind.allCases {
                let value = self[flavor]
                if value > highestValue {
                    highestValue = value
                    mostPotent = flavor
                }
            }
            return (mostPotent, highestValue)
        }

        public var mostPotentFlavor: Kind {
            mostPotent.0
        }

        public var mostPotentValue: Int {
            mostPotent.1
        }
    }
}

