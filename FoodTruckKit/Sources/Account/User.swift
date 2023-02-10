/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A model object to store user status.
*/

public enum User {
    case `default`
    case authenticated(username: String)

    public init(username: String) {
        self = .authenticated(username: username)
    }
}
