/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The accents in the Widget.
*/

import SwiftUI

extension Color {
    static let widgetAccent = Color("AccentColor")
    static let widgetAccentDimmed = Color("AccentColorDimmed")
}

extension Gradient {
    static let widgetAccent = Gradient(colors: [.widgetAccentDimmed, .widgetAccent])
}
