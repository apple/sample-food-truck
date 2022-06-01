/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The "Show Top Donuts" intent.
*/

import FoodTruckKit
import AppIntents
import SwiftUI

struct ShowTopDonutsIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Top Donuts"
    
    @Parameter(title: "Timeframe")
    var timeframe: Timeframe
    
    @MainActor
    func perform() async throws -> some IntentPerformResult {
        return .finished {
            ShowTopDonutsIntentView(timeframe: timeframe)
        }
    }
}

extension Timeframe: AppEnum {
    public static var typeDisplayName: LocalizedStringResource = "Timeframe"
    
    public static var caseDisplayRepresentations: [Timeframe: DisplayRepresentation] = [
        .today: "Today",
        .week: "This Week",
        .month: "This Month",
        .year: "This Year"
    ]
}

struct FoodTruckShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: ShowTopDonutsIntent(), phrases: [
            "\(.applicationName) Trends for \(\.$timeframe)"
        ])
    }
}

extension ShowTopDonutsIntent {
    init(timeframe: Timeframe) {
        self.timeframe = timeframe
    }
}
