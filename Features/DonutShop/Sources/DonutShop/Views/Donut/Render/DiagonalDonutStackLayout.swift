/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A custom layout that places up to 3 views (tuned for `DonutView`) diagonally inside a square aspect ratio.
*/

import SwiftUI

private let defaultSize = CGSize(width: 60, height: 60)

public struct DiagonalDonutStackLayout: Layout {
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let proposal = proposal.replacingUnspecifiedDimensions(by: defaultSize)
        let minBound = min(proposal.width, proposal.height)
        return CGSize(width: minBound, height: minBound)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let proposal = proposal.replacingUnspecifiedDimensions(by: defaultSize)
        let minBound = min(proposal.width, proposal.height)
        let size = CGSize(width: minBound, height: minBound)
        let rect = CGRect(
            origin: CGPoint(x: bounds.minX + bounds.width - minBound, y: bounds.minY + bounds.height - minBound),
            size: size
        )
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let subviews = subviews.prefix(3)
        for index in subviews.indices {
            switch (index, subviews.count) {
            case (_, 1):
                subviews[index].place(
                    at: center,
                    anchor: .center,
                    proposal: ProposedViewSize(size)
                )
                
            case (_, 2):
                let direction = index == 0 ? -1.0 : 1.0
                let offsetX = minBound * direction * 0.15
                let offsetY = minBound * direction * 0.20
                subviews[index].place(
                    at: CGPoint(x: center.x + offsetX, y: center.y + offsetY),
                    anchor: .center,
                    proposal: ProposedViewSize(CGSize(width: size.width * 0.7, height: size.height * 0.7))
                )
            case (1, 3):
                subviews[index].place(
                    at: center,
                    anchor: .center,
                    proposal: ProposedViewSize(CGSize(width: size.width * 0.65, height: size.height * 0.65))
                )
                
            case (_, 3):
                let direction = index == 0 ? -1.0 : 1.0
                let offsetX = minBound * direction * 0.15
                let offsetY = minBound * direction * 0.23
                subviews[index].place(
                    at: CGPoint(x: center.x + offsetX, y: center.y + offsetY),
                    anchor: .center,
                    proposal: ProposedViewSize(CGSize(width: size.width * 0.7, height: size.height * 0.65))
                )
            default:
                print("Ignore me!")
            }
        }
    }
}
