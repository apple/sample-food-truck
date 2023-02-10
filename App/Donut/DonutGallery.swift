/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The donut gallery view.
*/

import SwiftUI
import FoodTruckKit

struct DonutGallery: View {
    @ObservedObject var model: FoodTruckModel
    
    @State private var layout = BrowserLayout.grid
    @State private var sort = DonutSortOrder.popularity(.week)
    @State private var popularityTimeframe = Timeframe.week
    @State private var sortFlavor = Flavor.sweet

    @State private var selection = Set<Donut.ID>()
    @State private var searchText = ""
    
    var filteredDonuts: [Donut] {
        model.donuts(sortedBy: sort).filter { $0.matches(searchText: searchText) }
    }
    
    var tableImageSize: Double {
        #if os(macOS)
        return 30
        #else
        return 60
        #endif
    }
    
    var body: some View {
        ZStack {
            if layout == .grid {
                grid
            } else {
                table
            }
        }
        .background()
        #if os(iOS)
        .toolbarRole(.browser)
        #endif
        .toolbar {
            ToolbarItemGroup {
                toolbarItems
            }
        }
        .onChange(of: popularityTimeframe) { newValue in
            if case .popularity = sort {
                sort = .popularity(newValue)
            }
        }
        .onChange(of: sortFlavor) { newValue in
            if case .flavor = sort {
                sort = .flavor(newValue)
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Donuts")
        .navigationDestination(for: Donut.ID.self) { donutID in
            DonutEditor(donut: model.donutBinding(id: donutID))
        }
        .navigationDestination(for: String.self) { _ in
            DonutEditor(donut: $model.newDonut)
        }
    }
    
    var grid: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                DonutGalleryGrid(donuts: filteredDonuts, width: geometryProxy.size.width)
            }
        }
    }
    
    var table: some View {
        Table(filteredDonuts, selection: $selection) {
            TableColumn("Name") { donut in
                NavigationLink(value: donut.id) {
                    HStack {
                        DonutView(donut: donut)
                            .frame(width: tableImageSize, height: tableImageSize)

                        Text(donut.name)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var toolbarItems: some View {
        NavigationLink(value: "New Donut") {
            Label("Create Donut", systemImage: "plus")
        }
        
        Menu {
            Picker("Layout", selection: $layout) {
                ForEach(BrowserLayout.allCases) { option in
                    Label(option.title, systemImage: option.imageName)
                        .tag(option)
                }
            }
            .pickerStyle(.inline)

            Picker("Sort", selection: $sort) {
                Label("Name", systemImage: "textformat")
                    .tag(DonutSortOrder.name)
                Label("Popularity", systemImage: "trophy")
                    .tag(DonutSortOrder.popularity(popularityTimeframe))
                Label("Flavor", systemImage: "fork.knife")
                    .tag(DonutSortOrder.flavor(sortFlavor))
            }
            .pickerStyle(.inline)
            
            if case .popularity = sort {
                Picker("Timeframe", selection: $popularityTimeframe) {
                    Text("Today")
                        .tag(Timeframe.today)
                    Text("Week")
                        .tag(Timeframe.week)
                    Text("Month")
                        .tag(Timeframe.month)
                    Text("Year")
                        .tag(Timeframe.year)
                }
                .pickerStyle(.inline)
            } else if case .flavor = sort {
                Picker("Flavor", selection: $sortFlavor) {
                    ForEach(Flavor.allCases) { flavor in
                        Text(flavor.name)
                            .tag(flavor)
                    }
                }
                .pickerStyle(.inline)
            }
        } label: {
            Label("Layout Options", systemImage: layout.imageName)
                .labelStyle(.iconOnly)
        }
    }
}

enum BrowserLayout: String, Identifiable, CaseIterable {
    case grid
    case list

    var id: String {
        rawValue
    }

    var title: LocalizedStringKey {
        switch self {
        case .grid: return "Icons"
        case .list: return "List"
        }
    }

    var imageName: String {
        switch self {
        case .grid: return "square.grid.2x2"
        case .list: return "list.bullet"
        }
    }
}

struct DonutBakery_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel.preview

        var body: some View {
            DonutGallery(model: model)
        }
    }

    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
