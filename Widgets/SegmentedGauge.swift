/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A Segmented Gauge View.
*/

import SwiftUI

public struct SegmentedGauge<Label: View>: View {
    public var value: Int
    public var total: Int
    @ViewBuilder public var label: () -> Label

    public init(value: Int, total: Int, label: @escaping () -> Label) {
        // Value can't go beyond total.
        self.value = min(value, total)
        // Always show at least one segment.
        // This is second to have it always at least show a segment.
        self.total = max(total, 1)
        self.label = label
    }

    public var body: some View {
        Gauge(value: Double(value), in: 0.0...Double(total), label: label)
            .gaugeStyle(SegmentedGaugeStyle(total: total))
    }
}

struct SegmentedGaugeStyle: GaugeStyle {
    var total: Int
    private var metrics = Metrics()

    init(total: Int) {
        self.total = total
    }

    func makeBody(configuration: Configuration) -> some View {
        let value = Int(configuration.value * Double(total))

        VStack(alignment: .leading, spacing: 4) {
            configuration.label

            HStack(spacing: metrics.gap) {
                ForEach(0..<total, id: \.self) { index in
                    Segment(metrics, position: position(for: index, with: value, in: total))
                        .opacity(opacity(for: index, with: value))
                }
            }
            .frame(height: metrics.height)
        }
    }

    func position(for index: Int, with value: Int, in total: Int) -> Segment.Position {
        if total <= 1 {
            return .single
        } else {
            switch index {
            case 0:
                return .leading
            case total - 1:
                return .trailing
            default:
                return .middle
            }
        }
    }

    func opacity(for index: Int, with value: Int) -> Double {
        index < value ? 1.0 : metrics.unfilledOpacity
    }

    struct Metrics {
        var height: CGFloat { 11.0 }
        var gap: CGFloat { 3.0 }
        var cornerRadius: CGFloat { 2.0 }
        var unfilledOpacity: Double { 0.35 }
    }
    struct Segment: View {
        enum Position {
            case leading
            case trailing
            case middle
            case single
        }

        var metrics: Metrics
        var position: Position
        @Environment(\.layoutDirection) var layoutDirection

        init(_ metrics: Metrics, position: Position) {
            self.metrics = metrics
            self.position = position
        }

        var body: some View {
            Segment(cornerRadius: metrics.cornerRadius, position: position, layoutDirection: layoutDirection)
                .fill(.tint)
        }

        struct Segment: Shape {
            var cornerRadius: CGFloat
            var position: Position
            var layoutDirection: LayoutDirection

            func path(in rect: CGRect) -> Path {
                var path = Path()
                let corners = corners(for: rect)

                // Start at middle of top edge, go clockwise, according to the wall clock.
                // But because positive y is down, we have to flip the argument.
                var point = CGPoint(x: rect.midX, y: rect.minY)
                path.move(to: point)

                // Just before start of top right corner.
                var radius = corners.topRight
                point.x = rect.maxX - radius
                path.addLine(to: point)

                // Top right corner.
                point.y = (rect.minY + radius)
                path.addArc(center: point, radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

                // Just before bottom right corner.
                radius = corners.bottomRight
                point.x = rect.maxX
                point.y = rect.maxY - radius
                path.addLine(to: point)

                // Bottom right corner.
                point.x = rect.maxX - radius
                path.addArc(center: point, radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

                // Just before bottom left corner.
                radius = corners.bottomLeft
                point.x = rect.minX + radius
                point.y = rect.maxY
                path.addLine(to: point)

                // Bottom left corner.
                point.y = rect.maxY - radius
                path.addArc(center: point, radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

                // Just before top left corner.
                radius = corners.topLeft
                point.x = rect.minX
                point.y = rect.minY + radius
                path.addLine(to: point)

                // Top left corner.
                point.x = rect.minX + radius
                path.addArc(center: point, radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

                // Back to top middle.
                point.x = rect.midX
                point.y = rect.minY
                path.addLine(to: point)

                return path
            }

            func corners(for rect: CGRect) -> (topRight: CGFloat, bottomRight: CGFloat, bottomLeft: CGFloat, topLeft: CGFloat) {
                let rectCorner = cornerRadius
                let capsuleCorner = rect.height / 2.0
                let position: Position = {
                    var position = self.position
                    if layoutDirection == .rightToLeft {
                        if position == .leading {
                            position = .trailing
                        } else if position == .trailing {
                            position = .leading
                        }
                    }
                    return position
                }()

                switch position {
                case .leading:
                    return (rectCorner, rectCorner, capsuleCorner, capsuleCorner)
                case .trailing:
                    return (capsuleCorner, capsuleCorner, rectCorner, rectCorner)
                case .middle:
                    return (rectCorner, rectCorner, rectCorner, rectCorner)
                case .single:
                    return (capsuleCorner, capsuleCorner, capsuleCorner, capsuleCorner)
                }
            }
        }
    }
}

struct SegmentedGauge_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedGauge(value: 8, total: 10) {
            Text("8 out of 10 cats!")
        }
        .tint(.mint)
        .padding()
//        .environment(\.layoutDirection, .rightToLeft)
    }
}
