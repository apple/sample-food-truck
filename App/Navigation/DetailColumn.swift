/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The detail column of the navigation interface.
*/

import SwiftUI
import FoodTruckKit

/// The detail view of the app's navigation interface.
///
/// The ``ContentView`` presents this view in the detail column on macOS and iPadOS, and in the navigation stack on iOS.
/// The superview passes the person's selection in the ``Sidebar`` as the ``selection`` binding.
struct DetailColumn: View {
    /// The person's selection in the sidebar.
    ///
    /// This value is a binding, and the superview must pass in its value.
    @Binding var selection: Panel?
    /// The app's model the superview must pass in.
    @ObservedObject var model: FoodTruckModel
    @State var timeframe: Timeframe = .today
    
    /// The body function
    ///
    /// This view presents the appropriate view in response to the person's selection in the ``Sidebar``. See ``Panel``
    /// for the views that `DetailColumn`  presents.
    var body: some View {
        switch selection ?? .truck {
        case .truck:
            TruckView(model: model, navigationSelection: $selection)
        case .orders:
            OrdersView(model: model)
        case .socialFeed:
            SocialFeedView()
        #if EXTENDED_ALL
        case .account:
            AccountView(model: model)
        #endif
        case .salesHistory:
            SalesHistoryView(model: model)
        case .donuts:
            DonutGallery(model: model)
        case .donutEditor:
            DonutEditor(donut: $model.newDonut)
        case .topFive:
            TopFiveDonutsView(model: model)
        case .city(let id):
            CityView(city: City.identified(by: id))
        }
    }
}

struct DetailColumn_Previews: PreviewProvider {
    struct Preview: View {
        @State private var selection: Panel? = .truck
        @StateObject private var model = FoodTruckModel.preview
        
        var body: some View {
            DetailColumn(selection: $selection, model: model)
        }
    }
    static var previews: some View {
        Preview()
    }
}
