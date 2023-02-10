/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Some content for the social feed view.
*/

import SwiftUI
import FoodTruckKit

struct SocialFeedPost: Identifiable {
    var id = UUID()
    var favoriteDonut: Donut
    var message: LocalizedStringKey
    var date: Date
    var tags: [SocialFeedTag]
}

enum SocialFeedTag: Identifiable {
    case title(LocalizedStringKey)
    case donut(Donut)
    case city(City)
    
    var id: String {
        switch self {
        case .title(let string):
            return "tag title: \(string)"
        case .donut(let donut):
            return "tag donut: \(donut.id)"
        case .city(let city):
            return "tag city: \(city.id)"
        }
    }
    
    @ViewBuilder
    var icon: some View {
        switch self {
        case .title:
            Image(systemName: "tag")
        case .donut(let donut):
            DonutView(donut: donut)
                .padding(-3)
        case .city:
            Image(systemName: "building.2")
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .title(let string):
            return string
        case .donut(let donut):
            return .init(donut.name)
        case .city(let city):
            return .init(city.name)
        }
    }
    
    var label: some View {
        Label {
            Text(title)
        } icon: {
            icon
        }
    }
}

extension SocialFeedPost {
    static let standardContent: [SocialFeedPost] = {
        var date = Date.now
        func olderDate() -> Date {
            // minutes in the past
            date = date.addingTimeInterval(-60 * .random(in: 5...30))
            return date
        }
        return [
            SocialFeedPost(
                favoriteDonut: .classic,
                message: "I can't wait for the Food Truck to make its way to London!",
                date: olderDate(),
                tags: [.city(.london), .title("I'm waiting..."), .title("One of these days!")]
            ),
            SocialFeedPost(
                favoriteDonut: .blackRaspberry,
                message: "I'm really looking forward to trying the new chocolate donuts next time the truck is in town.",
                date: olderDate(),
                tags: [.donut(.lemonChocolate), .title("Chocolate!!!"), .donut(.powderedChocolate), .city(.sanFrancisco)]
            ),
            SocialFeedPost(
                favoriteDonut: .daytime,
                message: "Do you think there are any donuts in space?",
                date: olderDate(),
                tags: [.donut(.cosmos), .title("Space")]
            ),
            SocialFeedPost(
                favoriteDonut: .nighttime,
                message: "Thinking of checking out the Food Truck in its new location in SF today, anyone else down?",
                date: olderDate(),
                tags: [.city(.sanFrancisco), .title("Donuts for one"), .title("Unless...?")]
            ),
            SocialFeedPost(
                favoriteDonut: .custard,
                message: "I heard the Food Truck was in Cupertino today! Did anyone get a chance to visit?",
                date: olderDate(),
                tags: [.city(.cupertino), .title("Food Truck sighting")]
            ),
            SocialFeedPost(
                favoriteDonut: .figureSkater,
                message: "Okay, long day of work complete. Time to grab a bunch of donuts and get out of here!",
                date: olderDate(),
                tags: [.donut(.figureSkater), .donut(.blueberryFrosted), .donut(.powderedStrawberry), .title("Many more")]
            ),
            SocialFeedPost(
                favoriteDonut: .blueberryFrosted,
                message: "I think I just saw the Food Truck on its way to San Francisco! Taxi, follow that truck!",
                date: olderDate(),
                tags: [.donut(.classic), .city(.sanFrancisco), .title("And away we go!")]
            )
        ]
    }()
    
    static let socialFeedPlusContent: [SocialFeedPost] = {
        var date = Date.now
        func olderDate() -> Date {
            // minutes in the past
            date = date.addingTimeInterval(-60 * .random(in: 5...30))
            return date
        }
        return [
            SocialFeedPost(
                favoriteDonut: .picnicBasket,
                message: "I'm going to place a huge order next time the Food Truck is in San Francisco!!",
                date: olderDate(),
                tags: [.city(.sanFrancisco), .donut(.classic), .title("Like two dozen!")]
            ),
            SocialFeedPost(
                favoriteDonut: .rainbow,
                message: "Just told my coworkers about the Food Truck and we are currently a group of 20 heading out.",
                date: olderDate(),
                tags: [.title("How many donuts are too many"), .title("Trick question"), .title("Please don't tell me")]
            ),
            SocialFeedPost(
                favoriteDonut: .fireZest,
                message: "Once the Food Truck adds carrot-flavored donuts; I'm going to order a million of them!",
                date: olderDate(),
                tags: [
                    .title("Carrot"),
                    .title("Carrots of Social Feed"),
                    .title("Bunnies of Social Feed"),
                    .title("Carrots"),
                    .title("Donuts for Bunnies")
                ]
            )
        ]
    }()
}

extension LabelStyle where Self == SocialFeedTagLabelStyle {
    static var socialFeedTag: SocialFeedTagLabelStyle {
        SocialFeedTagLabelStyle()
    }
}

struct SocialFeedTagLabelStyle: LabelStyle {
    @ScaledMetric(relativeTo: .footnote) private var iconWidth = 14.0
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundColor(.secondary)
                .frame(width: iconWidth)
            configuration.title
        }
        .padding(6)
        .background(in: RoundedRectangle(cornerRadius: 5, style: .continuous))
        .font(.caption)
    }
}
