/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Helper functions to calculate time.
*/

import Foundation

public extension UInt64 {
    static func secondsToNanoseconds(_ seconds: Double) -> UInt64 {
        UInt64(seconds * 1_000_000_000)
    }
}
