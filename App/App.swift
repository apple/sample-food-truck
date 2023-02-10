/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The single entry point for the Food Truck app on iOS and macOS.
*/

import SwiftUI
import FoodTruckKit

/// The app's entry point.
///
/// The `FoodTruckApp` object is the app's entry point. Additionally, this is the object that keeps the app's state in the `model` and `store` parameters.
///
@main
struct FoodTruckApp: App {
    /// The app's state.
    @StateObject private var model = FoodTruckModel()
    /// The in-app purchase store's state.
    @StateObject private var accountStore = AccountStore()
    
    /// The app's body function.
    ///
    /// This app uses a [`WindowGroup`](https://developer.apple.com/documentation/swiftui/windowgroup) scene, which contains the root view of the app, ``ContentView``.
    /// On macOS, the  [`defaultSize(width:height)`](https://developer.apple.com/documentation/swiftui/scene/defaultsize(_:)) modifier
    /// gives the app an appropriate default size on launch. Similarly, a [`MenuBarExtra`](https://developer.apple.com/documentation/swiftui/menubarextra)
    /// scene is used on macOS to insert a menu into the right side of the menu bar.
    var body: some Scene {
        WindowGroup {
            ContentView(model: model, accountStore: accountStore)
        }
        #if os(macOS)
        .defaultSize(width: 1000, height: 650)
        #endif
        
        #if os(macOS)
        MenuBarExtra {
            ScrollView {
                VStack(spacing: 0) {
                    BrandHeader(animated: false, size: .reduced)
                    Text("Donut stuff!")
                }
            }
        } label: {
            Label("Food Truck", systemImage: "box.truck")
        }
        .menuBarExtraStyle(.window)
        #endif
    }
}
