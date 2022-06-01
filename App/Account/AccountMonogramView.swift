/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Shows the first initial of the signed in user in a view.
*/

import SwiftUI

struct AccountMonogramView: View {
    var username: String

    var body: some View {
        Text(monogram)
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .background(Color.accentColor.gradient, in: Circle())
    }

    private var monogram: String {
        if let character = username.first {
            return String(character).localizedCapitalized
        }

        return "?"
    }
}

struct AccountMonogramView_Previews: PreviewProvider {
    static var previews: some View {
        AccountMonogramView(username: "jappleseed")
    }
}
