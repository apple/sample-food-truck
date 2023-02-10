/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The weather card showing in the Truck view.
*/

import SwiftUI
import Charts
import FoodTruckKit
@preconcurrency import CoreLocation
@preconcurrency import WeatherKit

struct TruckWeatherCard: View {
    var location: CLLocation
    var headerUsesNavigationLink: Bool = false
    var navigation: TruckCardHeaderNavigation = .navigationLink
    
    @State private var forecast: TruckWeatherForecast = placeholderForecast
    
    var body: some View {
        VStack {
            CardNavigationHeader(panel: .city(City.sanFrancisco.id), navigation: navigation) {
                Label("Forecast", systemImage: "cloud.sun")
            }

            chart
                .frame(minHeight: 180)
        }
        .padding(10)
        .background()
        .task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .hourly).forecast
                forecast = TruckWeatherForecast(entries: weather.map {
                    .init(
                        date: $0.date,
                        degrees: $0.temperature.converted(to: .fahrenheit).value,
                        isDaylight: $0.isDaylight
                    )
                })
            } catch {
                print("Could not load weather", error.localizedDescription)
            }
        }
    }
    
    var chart: some View {
        Chart {
            areaMarks(seriesKey: "Temperature", value: 0)
                .foregroundStyle(.linearGradient(colors: [.teal, .yellow], startPoint: .bottom, endPoint: .top))
            
            ForEach(forecast.nightTimeRanges, id: \.lowerBound) { range in
                RectangleMark(
                    xStart: .value("Hour", range.lowerBound),
                    xEnd: .value("Hour", range.upperBound)
                )
                .opacity(0.5)
                .mask {
                    areaMarks(seriesKey: "Mask", value: range.lowerBound.timeIntervalSince1970)
                }
                
                if range.lowerBound != forecast.entries.first!.date {
                    let date = range.lowerBound
                    RectangleMark(
                        x: .value("Date", date),
                        yStart: .value("Temperature", forecast.low - 0.5),
                        yEnd: .value("Temperature", forecast.temperature(at: date) + 0.5),
                        width: .fixed(4)
                    )
                    .foregroundStyle(.indigo.shadow(.drop(color: .white.opacity(0.25), radius: 0, x: 1)))
                    .cornerRadius(2)
                    .annotation(position: .top, alignment: .bottom, spacing: 5) {
                        Image(systemName: "moon.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .indigo)
                    }
                }
                
                if range.upperBound != forecast.entries.last!.date {
                    let date = range.upperBound
                    RectangleMark(
                        x: .value("Date", date),
                        yStart: .value("Temperature", forecast.low - 0.5),
                        yEnd: .value("Temperature", forecast.temperature(at: date) + 0.5),
                        width: .fixed(4)
                    )
                    .foregroundStyle(.indigo.shadow(.drop(color: .white.opacity(0.25), radius: 0, x: -1)))
                    .cornerRadius(2)
                    .annotation(position: .top, alignment: .bottom, spacing: 5) {
                        Image(systemName: "sun.max.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .indigo)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: DateBins(unit: .hour, by: 3, range: forecast.binRange).thresholds) { _ in
                AxisValueLabel(format: .dateTime.hour())
                AxisTick()
                AxisGridLine()
            }
        }
        .chartYScale(domain: .automatic(includesZero: false))
        .chartYAxis {
            AxisMarks(values: .automatic(minimumStride: 5, desiredCount: 6, roundLowerBound: false)) { value in
                AxisValueLabel("\(value.as(Double.self)!.formatted())°F")
                AxisTick()
                AxisGridLine()
            }
        }
    }
    
    @ChartContentBuilder
    func areaMarks(seriesKey: String, value: Double) -> some ChartContent {
        ForEach(forecast.entries) { entry in
            AreaMark(
                x: .value("Hour", entry.date),
                yStart: .value("Temperature", forecast.low),
                yEnd: .value("Temperature", entry.degrees),
                series: .value(seriesKey, value)
            )
            .interpolationMethod(.catmullRom)
        }
    }
        
    static var placeholderForecast: TruckWeatherForecast {
        func entry(hourOffset: Int, degrees: Double, isDaylight: Bool) -> TruckWeatherForecast.WeatherEntry {
            let startDate = Calendar.current.date(from: DateComponents(year: 2022, month: 5, day: 6, hour: 9))!
            let date = Calendar.current.date(byAdding: DateComponents(hour: hourOffset), to: startDate)!
            return TruckWeatherForecast.WeatherEntry(date: date, degrees: degrees, isDaylight: isDaylight)
        }
        
        return TruckWeatherForecast(entries: [
            entry(hourOffset: 0, degrees: 63, isDaylight: true),
            entry(hourOffset: 1, degrees: 68, isDaylight: true),
            entry(hourOffset: 2, degrees: 72, isDaylight: true),
            entry(hourOffset: 3, degrees: 77, isDaylight: true),
            entry(hourOffset: 4, degrees: 80, isDaylight: true),
            entry(hourOffset: 5, degrees: 82, isDaylight: true),
            entry(hourOffset: 6, degrees: 83, isDaylight: true),
            entry(hourOffset: 7, degrees: 83, isDaylight: true),
            entry(hourOffset: 8, degrees: 81, isDaylight: true),
            entry(hourOffset: 9, degrees: 79, isDaylight: true),
            entry(hourOffset: 10, degrees: 75, isDaylight: true),
            entry(hourOffset: 11, degrees: 70, isDaylight: true),
            entry(hourOffset: 12, degrees: 66, isDaylight: false),
            entry(hourOffset: 13, degrees: 64, isDaylight: false),
            entry(hourOffset: 14, degrees: 63, isDaylight: false),
            entry(hourOffset: 15, degrees: 61, isDaylight: false),
            entry(hourOffset: 16, degrees: 60, isDaylight: false),
            entry(hourOffset: 17, degrees: 59, isDaylight: false),
            entry(hourOffset: 18, degrees: 57, isDaylight: false),
            entry(hourOffset: 19, degrees: 56, isDaylight: false),
            entry(hourOffset: 20, degrees: 55, isDaylight: false),
            entry(hourOffset: 21, degrees: 55, isDaylight: true),
            entry(hourOffset: 22, degrees: 56, isDaylight: true),
            entry(hourOffset: 23, degrees: 59, isDaylight: true),
            entry(hourOffset: 24, degrees: 62, isDaylight: true)
        ])
    }
}

struct TruckWeatherForecast {
    struct WeatherEntry: Identifiable {
        var id: Date { date }
        var date: Date
        var degrees: Double
        var isDaylight: Bool
    }
    
    var entries: [WeatherEntry]
    
    var low: Double {
        return entries.map(\.degrees).min()! - 2
    }
    
    var hottestEntry: WeatherEntry {
        return entries.sorted { $0.degrees > $1.degrees }.first!
    }
    
    var nightTimeRanges: [Range<Date>] {
        var currentLowerBound: Date?
        var results: [Range<Date>] = []
        for entry in entries {
            if entry.isDaylight, let lowerBound = currentLowerBound {
                results.append(lowerBound..<entry.date)
                currentLowerBound = nil
            } else if !entry.isDaylight && currentLowerBound == nil {
                currentLowerBound = entry.date
            }
        }
        if let lowerBound = currentLowerBound {
            results.append(lowerBound..<entries.last!.date)
        }
        return results
    }
    
    var binRange: ClosedRange<Date> {
        let startDate: Date = entries.map(\.date).first(where: {
            Calendar.current.component(.hour, from: $0).isMultiple(of: 3)
        })!
        let endDate: Date = entries.map(\.date).reversed().first(where: {
            Calendar.current.component(.hour, from: $0).isMultiple(of: 3)
        })!
        return startDate ... endDate
    }
    
    func temperature(at date: Date) -> Double {
        entries.first(where: { $0.date == date })!.degrees
    }
}

struct TruckWeatherCard_Previews: PreviewProvider {
    static var previews: some View {
        TruckWeatherCard(location: City.sanFrancisco.parkingSpots[0].location)
            .aspectRatio(2, contentMode: .fit)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
