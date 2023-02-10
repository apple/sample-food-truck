/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A card view to show the weather.
*/

import SwiftUI
import WeatherKit

struct CityWeatherCard: View {
    var condition: WeatherCondition
    var willRainSoon: Bool
    var symbolName: String

    var body: some View {
        HStack {
            Image(systemName: symbolName)
                .foregroundStyle(.secondary)
                .imageScale(.large)
            
            VStack(alignment: .leading) {
                Text(condition.description)
                    .font(.headline)
                Text(willRainSoon ? "Will rain soon..." : "No chance of rain today")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .frame(maxWidth: 400, alignment: .trailing)
        .padding()
    }
}

struct CityWeatherCard_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherCard(condition: .partlyCloudy, willRainSoon: true, symbolName: "sun.max")
    }
}
