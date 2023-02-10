/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The social feed card showing in the Truck view.
*/

import SwiftUI
import FoodTruckKit

struct TruckSocialFeedCard: View {
    var navigation: TruckCardHeaderNavigation = .navigationLink
    
    private let tags: [SocialFeedTag] = [
        .donut(.powderedChocolate), .donut(.blueberryFrosted), .title("Warmed Up"), .title("Room Temperature"),
        .city(.sanFrancisco), .donut(.rainbow), .title("Rainbow Sprinkles"), .donut(.strawberrySprinkles),
        .title("Dairy Free"), .city(.cupertino), .city(.london), .title("Gluten Free"), .donut(.fireZest),
        .donut(.blackRaspberry), .title("Carrots"), .title("Donut vs Doughnut")
    ]
    
    var body: some View {
        VStack {
            CardNavigationHeader(panel: .socialFeed, navigation: navigation) {
                Label("Social Feed", systemImage: "text.bubble")
            }
            
            (FlowLayout(alignment: .center)) {
                ForEach(tags) { tag in
                    tag.label
                }
            }
            .labelStyle(.socialFeedTag)
            #if canImport(UIKit)
            .backgroundStyle(Color(uiColor: .quaternarySystemFill))
            #else
            .backgroundStyle(.quaternary.opacity(0.5))
            #endif
            .frame(maxWidth: .infinity, minHeight: 180)
            .padding(.top, 15)
            
            Text("Trending Topics")
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(10)
        .background()
    }
}

struct TruckSocialFeedCard_Previews: PreviewProvider {
    static var previews: some View {
        TruckSocialFeedCard()
    }
}
