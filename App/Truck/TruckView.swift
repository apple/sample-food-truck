/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's landing page view.
*/

import SwiftUI
import FoodTruckKit

struct TruckView: View {
    @ObservedObject var model: FoodTruckModel
    @Binding var navigationSelection: Panel?
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif

    var body: some View {
        WidthThresholdReader(widthThreshold: 520) { proxy in
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    BrandHeader()
                    
                    Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                        if proxy.isCompact {
                            orders
                            weather
                            donuts
                            socialFeed
                        } else {
                            GridRow {
                                orders
                                weather
                            }
                            GridRow {
                                donuts
                                socialFeed
                            }
                        }
                    }
                    .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.horizontal, .bottom], 16)
                    .frame(maxWidth: 1200)
                }
            }
        }
        #if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
        #else
        .background(.quaternary.opacity(0.5))
        #endif
        .background()
        .navigationTitle("Truck")
        .navigationDestination(for: Panel.self) { panel in
            switch panel {
            case .orders:
                OrdersView(model: model)
            case .donuts:
                DonutGallery(model: model)
            case .socialFeed:
                SocialFeedView()
            case .city(let id):
                CityView(city: City.identified(by: id))
            default:
                DonutGallery(model: model)
            }
        }
    }

    // MARK: - Cards
    
    var orders: some View {
        TruckOrdersCard(model: model, navigation: cardNavigation)
    }
    
    var weather: some View {
        TruckWeatherCard(location: model.truck.location.location, navigation: cardNavigation)
    }
    
    var donuts: some View {
            TruckDonutsCard(donuts: model.donuts, navigation: cardNavigation)
    }

    var socialFeed: some View {
        TruckSocialFeedCard(navigation: cardNavigation)
    }
    
    var cardNavigation: TruckCardHeaderNavigation {
        let useNavigationLink: Bool = {
            #if os(iOS)
            return sizeClass == .compact
            #else
            return false
            #endif
        }()
        if useNavigationLink {
            return .navigationLink
        } else {
            return .selection($navigationSelection)
        }
    }
}

enum TruckCardHeaderNavigation {
    case navigationLink
    case selection(Binding<Panel?>)
}

// MARK: - Previews

struct TruckView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        @State private var navigationSelection: Panel? = Panel.truck
        var body: some View {
            TruckView(model: model, navigationSelection: $navigationSelection)
        }
    }
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
