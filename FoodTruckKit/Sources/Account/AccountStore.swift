/*
See LICENSE folder for this sample’s licensing information.

Abstract:
AccountStore manages account sign in and out.
*/

#if os(iOS) || os(macOS)

import AuthenticationServices
import SwiftUI
import os

private extension Logger {
    static let accounts = Logger(subsystem: "FoodTruck", category: "accounts")
}

public final class AccountStore: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    @Published public private(set) var currentUser: User? = .default
    
    public weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?

    public var isSignedIn: Bool {
        currentUser != nil
    }

    @MainActor
    public func signIn() async throws {
        let credential = try await performRequests(signInRequests())

        switch credential {
        case let credential as ASPasswordCredential:
            currentUser = .authenticated(username: credential.user)
            
        case let credential as ASAuthorizationPlatformPublicKeyCredentialAssertion:
            guard let username = String(bytes: credential.userID, encoding: .utf8) else {
                fatalError("Invalid credential: \(credential)")
            }
            currentUser = .authenticated(username: username)
            
        default:
            fatalError("Invalid credential: \(credential)")
        }
    }

    @MainActor
    public func createPasskeyAccount(username: String) async throws {
        try await performRequests(registerPasskeyRequests(username: username))
        currentUser = .authenticated(username: username)
    }

    @MainActor
    public func createPasswordAccount(username: String, password: String) async throws {
        currentUser = .authenticated(username: username)
    }

    @MainActor
    public func signOut() {
        currentUser = nil
    }

    // MARK: - Private

    private static let relyingPartyIdentifier = "example.com"
    private var currentController: ASAuthorizationController?
    private var currentContinuation: CheckedContinuation<ASAuthorizationCredential, Error>?

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

    private func registerPasskeyRequests(username: String) async -> [ASAuthorizationRequest] {
        await [passkeyRegistrationRequest(username: username)]
    }

    private func preparedAuthorizationController(with requests: [ASAuthorizationRequest]) -> ASAuthorizationController {
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = presentationContextProvider
        return authorizationController
    }

    @discardableResult
    private func performRequests(_ requests: [ASAuthorizationRequest]) async throws -> ASAuthorizationCredential {
        currentController?.cancel()
        currentController = nil

        return try await withCheckedThrowingContinuation {
            currentContinuation = $0

            currentController = preparedAuthorizationController(with: requests)
            currentController?.performRequests()
        }
    }

    // MARK: - ASAuthorizationControllerDelegate

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Logger.accounts.log("Authentication finished: \(authorization)")

        currentContinuation?.resume(returning: authorization.credential)
        currentContinuation = nil

        currentController = nil
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Logger.accounts.error("Authentication failed: \(error as NSError)")

        currentContinuation?.resume(throwing: error)
        currentContinuation = nil

        currentController = nil
    }
}

#if canImport(UIKit)
private typealias ViewRepresentable = UIViewRepresentable
#elseif canImport(AppKit)
private typealias ViewRepresentable = NSViewRepresentable
#endif

public extension View {
    func accountStorePresentationContext(
        onProviderCreated: @escaping (ASAuthorizationControllerPresentationContextProviding) -> Void
    ) -> some View {
        modifier(PresentationContextProviderModifier(onProviderCreated: onProviderCreated))
    }
}

struct PresentationContextProviderModifier: ViewModifier {
    var onProviderCreated: (ASAuthorizationControllerPresentationContextProviding) -> Void
    
    public init(onProviderCreated: @escaping (ASAuthorizationControllerPresentationContextProviding) -> Void) {
        self.onProviderCreated = onProviderCreated
    }
    
    public func body(content: Content) -> some View {
        content.background {
            PresentationContextProviderView(onProviderCreated: onProviderCreated)
                .opacity(0)
        }
    }
}

struct PresentationContextProviderView: ViewRepresentable {
    #if canImport(UIKit)
    typealias ViewType = UIView
    #elseif canImport(AppKit)
    typealias ViewType = NSView
    #endif
    
    var onProviderCreated: (ASAuthorizationControllerPresentationContextProviding) -> Void
    
    class ContextProvidingView: ViewType, ASAuthorizationControllerPresentationContextProviding {
        init(onProviderCreated: (ASAuthorizationControllerPresentationContextProviding) -> Void) {
            super.init(frame: .zero)
            onProviderCreated(self)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            guard let window else {
                fatalError()
            }
            return window
        }
    }
    
    #if canImport(UIKit)
    func makeUIView(context: Context) -> ContextProvidingView {
        ContextProvidingView(onProviderCreated: onProviderCreated)
    }
    
    func updateUIView(_ view: ContextProvidingView, context: Context) {
        
    }
    #elseif canImport(AppKit)
    func makeNSView(context: Context) -> ContextProvidingView {
        ContextProvidingView(onProviderCreated: onProviderCreated)
    }
    
    func updateNSView(_ view: ContextProvidingView, context: Context) {
        
    }
    #endif
}

#endif // os(iOS) || os(macOS)
