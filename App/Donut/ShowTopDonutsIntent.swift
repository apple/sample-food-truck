/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The "Show Top Donuts" intent.
*/

import FoodTruckKit
import AppIntents
import SwiftUI

struct ShowTopDonutsIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Show Top Donuts"
    
    @Parameter(title: "Timeframe")
    var timeframe: ShowTopDonutsIntentTimeframe
    
    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        .result(view: ShowTopDonutsIntentView(timeframe: timeframe.asTimeframe))
    }
}

enum ShowTopDonutsIntentTimeframe: String, CaseIterable, AppEnum {
    case today
    case week
    case month
    case year
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Timeframe"
        
    public static var caseDisplayRepresentations: [ShowTopDonutsIntentTimeframe: DisplayRepresentation] = [
        .today: "Today",
        .week: "This Week",
        .month: "This Month",
        .year: "This Year"
    ]
    
    var asTimeframe: Timeframe {
        switch self {
        case .today:
            return .today
        case .week:
            return .week
        case .month:
            return .month
        case .year:
            return .year
        }
    }
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
        self.timeframe = timeframe.asIntentTimeframe
    }
}

extension Timeframe {
    var asIntentTimeframe: ShowTopDonutsIntentTimeframe {
        switch self {
        case .today:
            return .today
        case .week:
            return .week
        case .month:
            return .month
        case .year:
            return .year
        }
    }
}
