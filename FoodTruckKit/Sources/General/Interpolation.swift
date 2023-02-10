/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Helper extension to calculate animation progress and timing.
*/

import Foundation

public extension ClosedRange where Bound: BinaryFloatingPoint {
    /// Returns a value between this range's lower and upper bounds, valued by a percentage between the two.
    /// - Parameters:
    ///   - percent: The percentage between lower and upper bound.
    ///   - clamped: Ignores values outside `0...1`, defaults to `true`.
    /// - Returns: A value between lower and upper bound.
    func value(percent: Bound, clamped: Bool = true) -> Bound {
        var percent = percent
        if clamped {
            percent = Swift.min(Swift.max(percent, 0), 1)
        }
        return (1 - percent) * lowerBound + percent * upperBound
    }
    
    /// Returns the percentage of `value` as it lays between this bound's lower and upper bounds.
    /// - Parameters:
    ///   - value: A value between this range's lower and upper bounds.
    ///   - clamped:Clamps the result between `0...1`, defaults to `true`.
    /// - Returns: A value between 0 and 1.
    func percent(for value: Bound, clamped: Bool = true) -> Bound {
        var result = (value - lowerBound) / (upperBound - value)
        if clamped {
            result = Swift.min(Swift.max(result, 0), 1)
        }
        return result
    }
}

public extension BinaryFloatingPoint {
    /// Returns a value that smoothly ramps from 0 to 1, useful for animation purposes.
    ///
    /// > Important: Only call this method on a finite number.
    /// - Parameter clamped: Ignores values outside `0...1`, defaults to `true`.
    /// - Returns: A value that is easing from 0 to 1.
    func easeInOut(clamped: Bool = true) -> Self {
        assert(self.isFinite)
        let timing = clamped ? min(max(self, 0), 1) : self
        return timing * timing * (3.0 - 2.0 * timing)
    }
    
    /// Takes a value from 0 to 1 and returns a value that starts at 0, eases into 1, and eases back into 0.
    ///
    /// For example, the following inputs generate these outputs:
    /// Input  | Output
    /// --- | ---
    /// `0` | `0`
    /// `0.25` | `0.5`
    /// `0.5` | `1`
    /// `0.75` | `0.5`
    /// `1` | `0`
    ///
    /// > Important: Only call this method on a finite number.
    /// - Parameter clamped: Ignores values outside `0...1`, defaults to `true`.
    /// - Returns: A value that is easing from 0 to 1 and back to 0.
    func symmetricEaseInOut(clamped: Bool = true) -> Self {
        assert(self.isFinite)
        let timing = clamped ? min(max(self, 0), 1) : self
        if timing <= 0.5 {
            return (timing * 2).easeInOut(clamped: clamped)
        } else {
            return (2 - (timing * 2)).easeInOut(clamped: clamped)
        }
    }
    
    /// Truncates a value by `truncation` and returns the percentage between that value and `truncation` itself.
    ///
    /// If this value is 175 and you pass 50 for the `truncation` value, this would return 0.5 as it is 50% towards the next `truncation` value.
    ///
    /// > Important: Only call this method on a finite number.
    /// - Parameter truncation: A truncation value that also determines the percentage.
    /// - Returns: A value from 0 to 1.
    func percent(truncation: Self) -> Self {
        assert(self.isFinite)
        assert(!truncation.isZero && truncation.isFinite)
        return self.truncatingRemainder(dividingBy: truncation) / truncation
    }
    
    /// Maps this value, assumed to be a percentage from 0 to 1, to the corresponding value between the `range`'s lower and upper bounds.
    ///
    /// If this value is 0.5 and you pass a range from 0 to 10, the result would be 5 because it's 50% between 0 and 10.
    ///
    /// > Important: Only call this method on a finite number.
    /// - Parameters:
    ///   - range: A closed range.
    ///   - clamped: Ignores values outside `0...1`, defaults to `true`.
    /// - Returns: A value within the range that this value maps to as a percentage.
    func map(to range: ClosedRange<Self>, clamped: Bool = true) -> Self {
        assert(self.isFinite)
        return range.value(percent: self, clamped: clamped)
    }
    
    /// Maps a value from `originalRange` into a percentage that is used to return an equivalent value in `newRange`.
    ///
    /// > Important: The value this method is called on must be a finite number.
    /// - Parameters:
    ///   - originalRange: A range from which this value will be converted into a percentage
    ///   - newRange: A range that determines the possible resulting value
    ///   - clamped: Ignores percentages in either range that are outside `0...1`, defaults to `true`
    /// - Returns: A value within `newRange` that this value maps to as a percentage in `originalRange`.
    func remap(from originalRange: ClosedRange<Self>, to newRange: ClosedRange<Self>, clamped: Bool = true) -> Self {
        assert(self.isFinite)
        return newRange.value(percent: originalRange.percent(for: self, clamped: clamped), clamped: clamped)
    }
    
    func interpolate(to destination: Self, percent: Self, clamped: Bool = true) -> Self {
        let percent = clamped ? min(max(percent, 0), 1) : percent
        return (1 - percent) * self + percent * destination
    }
}
