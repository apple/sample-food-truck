/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
AccountStore manages account sign in and out.
*/

#if os(iOS) || os(macOS)

import AuthenticationServices
import SwiftUI
import Combine
import os

public extension Logger {
    static let authorization = Logger(subsystem: "FoodTruck", category: "Food Truck accounts")
}

public enum AuthorizationHandlingError: Error {
    case unknownAuthorizationResult(ASAuthorizationResult)
    case otherError
}

extension AuthorizationHandlingError: LocalizedError {
    public var errorDescription: String? {
            switch self {
            case .unknownAuthorizationResult:
                return NSLocalizedString("Received an unknown authorization result.",
                                         comment: "Human readable description of receiving an unknown authorization result.")
            case .otherError:
                return NSLocalizedString("Encountered an error handling the authorization result.",
                                         comment: "Human readable description of an unknown error while handling the authorization result.")
            }
        }
}

@MainActor
public final class AccountStore: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    @Published public private(set) var currentUser: User? = .default
    
    public weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?
    
    public var isSignedIn: Bool {
        currentUser != nil
    }
    
    public func signIntoPasskeyAccount(authorizationController: AuthorizationController,
                                       options: ASAuthorizationController.RequestOptions = []) async {
        do {
            let authorizationResult = try await authorizationController.performRequests(
                    signInRequests(),
                    options: options
            )
            try await handleAuthorizationResult(authorizationResult)
        } catch let authorizationError as ASAuthorizationError where authorizationError.code == .canceled {
            // The user cancelled the authorization.
            Logger.authorization.log("The user cancelled passkey authorization.")
        } catch let authorizationError as ASAuthorizationError {
            // Some other error occurred occurred during authorization.
            Logger.authorization.error("Passkey authorization failed. Error: \(authorizationError.localizedDescription)")
        } catch AuthorizationHandlingError.unknownAuthorizationResult(let authorizationResult) {
            // Received an unknown response.
            Logger.authorization.error("""
            Passkey authorization handling failed. \
            Received an unknown result: \(String(describing: authorizationResult))
            """)
        } catch {
            // Some other error occurred while handling the authorization.
            Logger.authorization.error("""
            Passkey authorization handling failed. \
            Caught an unknown error during passkey authorization or handling: \(error.localizedDescription)"
            """)
        }
    }
    
    public func createPasskeyAccount(authorizationController: AuthorizationController, username: String,
                                     options: ASAuthorizationController.RequestOptions = []) async {
        do {
            let authorizationResult = try await authorizationController.performRequests(
                    [passkeyRegistrationRequest(username: username)],
                    options: options
            )
            try await handleAuthorizationResult(authorizationResult, username: username)
        } catch let authorizationError as ASAuthorizationError where authorizationError.code == .canceled {
            // The user cancelled the registration.
            Logger.authorization.log("The user cancelled passkey registration.")
        } catch let authorizationError as ASAuthorizationError {
            // Some other error occurred occurred during registration.
            Logger.authorization.error("Passkey registration failed. Error: \(authorizationError.localizedDescription)")
        } catch AuthorizationHandlingError.unknownAuthorizationResult(let authorizationResult) {
            // Received an unknown response.
            Logger.authorization.error("""
            Passkey registration handling failed. \
            Received an unknown result: \(String(describing: authorizationResult))
            """)
        } catch {
            // Some other error occurred while handling the registration.
            Logger.authorization.error("""
            Passkey registration handling failed. \
            Caught an unknown error during passkey registration or handling: \(error.localizedDescription).
            """)
        }
    }

    public func createPasswordAccount(username: String, password: String) async {
        currentUser = .authenticated(username: username)
    }

    public func signOut() {
        currentUser = nil
    }

    // MARK: - Private

    private static let relyingPartyIdentifier = "example.com"

    private func passkeyChallenge() async -> Data {
        Data("passkey challenge".utf8)
    }

    private func passkeyAssertionRequest() async -> ASAuthorizationRequest {
        await ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: Self.relyingPartyIdentifier)
           .createCredentialAssertionRequest(challenge: passkeyChallenge())
    }

    private func passkeyRegistrationRequest(username: String) async -> ASAuthorizationRequest {
        await ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: Self.relyingPartyIdentifier)
           .createCredentialRegistrationRequest(challenge: passkeyChallenge(), name: username, userID: Data(username.utf8))
    }

    private func signInRequests() async -> [ASAuthorizationRequest] {
        await [passkeyAssertionRequest(), ASAuthorizationPasswordProvider().createRequest()]
    }

    // MARK: - Handle the results.
    
    private func handleAuthorizationResult(_ authorizationResult: ASAuthorizationResult, username: String? = nil) async throws {
        switch authorizationResult {
        case let .password(passwordCredential):
            Logger.authorization.log("Password authorization succeeded: \(passwordCredential)")
            currentUser = .authenticated(username: passwordCredential.user)
        case let .passkeyAssertion(passkeyAssertion):
            // The login was successful.
            Logger.authorization.log("Passkey authorization succeeded: \(passkeyAssertion)")
            guard let username = String(bytes: passkeyAssertion.userID, encoding: .utf8) else {
                fatalError("Invalid credential: \(passkeyAssertion)")
            }
            currentUser = .authenticated(username: username)
        case let .passkeyRegistration(passkeyRegistration):
            // The registration was successful.
            Logger.authorization.log("Passkey registration succeeded: \(passkeyRegistration)")
            if let username {
                currentUser = .authenticated(username: username)
            }
        default:
            Logger.authorization.error("Received an unknown authorization result.")
            // Throw an error and return to the caller.
            throw AuthorizationHandlingError.unknownAuthorizationResult(authorizationResult)
        }
        
        // In a real app, call the code at this location to obtain and save an authentication token to the keychain and sign in the user.
    }
}

#endif // os(iOS) || os(macOS)
