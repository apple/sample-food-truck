/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The donuts card showing in the Truck view.
*/

import SwiftUI
import FoodTruckKit

struct TruckDonutsCard: View {
    var donuts: [Donut]
    var navigation: TruckCardHeaderNavigation = .navigationLink
    
    var body: some View {
        VStack {
            CardNavigationHeader(panel: .donuts, navigation: navigation) {
                Label {
                    Text("Donuts")
                } icon: {
                    Image.donutSymbol
                }
            }
            
            (DonutLatticeLayout()) {
                ForEach(donuts.prefix(14)) { donut in
                    DonutView(donut: donut)
                }
            }
            .frame(minHeight: 180, maxHeight: .infinity)
        }
        .padding(10)
        .background()
    }
    
    struct DonutLatticeLayout: Layout {
        var columns: Int
        var rows: Int
        var spacing: Double
        
        init() {
            self.init(columns: 5, rows: 3, spacing: 10)
        }
        
        init(columns: Int, rows: Int, spacing: Double) {
            self.columns = columns
            self.rows = rows
            self.spacing = spacing
        }
        
        var defaultAxesSize: CGSize {
            CGSize(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
            )
        }
        
        func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
            let size = proposal.replacingUnspecifiedDimensions(by: defaultAxesSize)
            let cellLength = min(size.width / Double(columns), size.height / Double(rows))
            return CGSize(
                width: cellLength * Double(columns),
                height: cellLength * Double(rows)
            )
        }
        
        func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
            let size = proposal.replacingUnspecifiedDimensions(by: defaultAxesSize)
            let cellLength = min(size.width / Double(columns), size.height / Double(rows))
            let rectSize = CGSize(width: cellLength * Double(columns), height: cellLength * Double(rows))
            let origin = CGPoint(
                x: bounds.minX + (bounds.width - rectSize.width),
                y: bounds.minY + (bounds.height - rectSize.height)
            )
            for row in 0..<rows {
                let cellY = origin.y + (cellLength * Double(row))
                let columnsForRow = row.isMultiple(of: 2) ? columns : columns - 1
                for column in 0..<columnsForRow {
                    var cellX = origin.x + (cellLength * Double(column))
                    if !row.isMultiple(of: 2) {
                        cellX += cellLength * 0.5
                    }
                    let index: Int = {
                        var result = 0
                        if row > 0 {
                            for completedRow in 0..<row {
                                if completedRow.isMultiple(of: 2) {
                                    result += columns
                                } else {
                                    // We have one less column in odd rows
                                    result += columns - 1
                                }
                            }
                        }
                        return result + column
                    }()
                    guard index < subviews.count else {
                        break
                    }
                    let cellRect = CGRect(x: cellX, y: cellY, width: cellLength, height: cellLength)
                        .insetBy(dx: spacing * 0.5, dy: spacing * 0.5)
                    
                    subviews[index].place(at: cellRect.origin, proposal: ProposedViewSize(cellRect.size))
                }
            }
        }
    }
}

struct TruckDonutsCard_Previews: PreviewProvider {
    static var previews: some View {
        TruckDonutsCard(donuts: Donut.all)
    }
}
