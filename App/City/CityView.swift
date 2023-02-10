/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that shows details about a city.
*/

import SwiftUI
import FoodTruckKit
@preconcurrency import WeatherKit
@preconcurrency import CoreLocation

/// The view that displays weather information about a city.
///
/// This view is presented by the ``DetailColumn`` view.
struct CityView: View {
    var city: City
    
    @State private var spot: ParkingSpot = City.cupertino.parkingSpots[0]
    
    /// The current weather condition for the city.
    @State private var condition: WeatherCondition?
    /// Indicates whether it will rain soon.
    @State private var willRainSoon: Bool?
    @State private var cloudCover: Double?
    @State private var temperature: Measurement<UnitTemperature>?
    @State private var symbolName: String?
    
    @State private var attributionLink: URL?
    @State private var attributionLogo: URL?
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    /// The body function.
    ///
    /// The body function implements a [`VStack` ](https://developer.apple.com/documentation/swiftui/vstack) to
    /// display various information about thee city and the parking spot. It presents the following views:
    /// - ``ParkingSpotShowcaseView``
    /// - ``CityWeatherCard``
    /// - ``RecommendedParkingSpotCard``
    /// - A [`Group`](https://developer.apple.com/documentation/swiftui/group) showing relevant information
    ///   about the parking spot in the city.
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ZStack {
                    Text("Beautiful Map Goes Here")
                        .hidden()
                        .frame(height: 350)
                        .frame(maxWidth: .infinity)
                }
                .background(alignment: .bottom) {
                    ParkingSpotShowcaseView(spot: spot, topSafeAreaInset: 0)
                        #if os(iOS)
                        .mask {
                            LinearGradient(
                                stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .black.opacity(0.15), location: 0.1),
                                    .init(color: .black, location: 0.6),
                                    .init(color: .black, location: 1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .padding(.top, -150)
                        #endif
                }
                .overlay(alignment: .bottomTrailing) {
                    if let currentWeatherCondition = condition, let willRainSoon = willRainSoon, let symbolName = symbolName {
                        CityWeatherCard(
                            condition: currentWeatherCondition,
                            willRainSoon: willRainSoon,
                            symbolName: symbolName
                        )
                        .padding(.bottom)
                    }
                }
                
                VStack {
                    RecommendedParkingSpotCard(
                        parkingSpot: spot,
                        condition: condition ?? .clear,
                        temperature: temperature ?? Measurement(value: 72, unit: .fahrenheit),
                        symbolName: symbolName ?? "sun.max"
                    )
                    
                    Group {
                        Text("Cloud cover percentage is currently \(String(format: "%.0f", (cloudCover ?? 0) * 100))% in \(city.name)")
                        Text("Popular donuts this season include Custard, Super Lemon, and Rainbow")
                        Text("Recommendation to stock up on cold ingredients and popular toppings to be prepared for the season")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding()
                
                VStack {
                    AsyncImage(url: attributionLogo) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                            .controlSize(.mini)
                    }
                    .frame(width: 20, height: 20)
                    
                    Link("Other data sources", destination: attributionLink ?? URL(string: "https://weather-data.apple.com/legal-attribution.html")!)
                }
                .font(.footnote)
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
        .navigationTitle(city.name)
        .onChange(of: city) { newValue in
            spot = newValue.parkingSpots[0]
        }
        .onAppear {
            spot = city.parkingSpots[0]
        }
        .task(id: city.id) {
            for parkingSpot in city.parkingSpots {
                do {
                    let weather = try await WeatherService.shared.weather(for: parkingSpot.location)
                    condition = weather.currentWeather.condition
                    willRainSoon = weather.minuteForecast?.contains(where: { $0.precipitationChance >= 0.3 })
                    cloudCover = weather.currentWeather.cloudCover
                    temperature = weather.currentWeather.temperature
                    symbolName = weather.currentWeather.symbolName
                    
                    let attribution = try await WeatherService.shared.attribution
                    attributionLink = attribution.legalPageURL
                    attributionLogo = colorScheme == .light ? attribution.combinedMarkLightURL : attribution.combinedMarkDarkURL
                    
                    if willRainSoon == false {
                        spot = parkingSpot
                        break
                    }
                } catch {
                    print("Could not gather weather information...", error.localizedDescription)
                    condition = .clear
                    willRainSoon = false
                    cloudCover = 0.15
                }
            }
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView(city: .cupertino)
    }
}

