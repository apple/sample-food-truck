/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The view where the user can sign up for an account.
*/

import SwiftUI
import FoodTruckKit

struct SignUpView: View {
    private enum FocusElement {
        case username
        case password
    }

    private enum SignUpType {
        case passkey
        case password
    }

    @ObservedObject var model: FoodTruckModel

    @EnvironmentObject private var accountStore: AccountStore
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedElement: FocusElement?
    @State private var signUpType = SignUpType.passkey
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        Form {
            Section {
                TextField("User name", text: $username)
                    .textContentType(.username)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    #endif
                    .focused($focusedElement, equals: .username)

                if case .password = signUpType {
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .focused($focusedElement, equals: .password)
                }
            } footer: {
                if case .passkey = signUpType {
                    HStack(spacing: 10) {
                        Image(systemName: "person.badge.key.fill")
                            .font(.title2)

                        Text("When you sign up with a passkey, all you need is a user name. The passkey will be available on all of your devices.")
                    }
                }
            }

            Section {
                Button("Sign Up") {
                    signUp()
                }
                .frame(maxWidth: .infinity)
                .font(.headline)
                .disabled(!isFormValid)
            } footer: {
                changeSignUpTypeButton
            }
        }
        .navigationTitle("Sign Up")
        .defaultFocus($focusedElement, .username)
        .toolbar {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
    }

    private func signUp() {
        Task { @MainActor in
            switch signUpType {
            case .passkey:
                try await accountStore.createPasskeyAccount(username: username)
            case .password:
                try await accountStore.createPasswordAccount(username: username, password: password)
            }
            dismiss()
        }
    }

    private var isFormValid: Bool {
        switch signUpType {
        case .passkey:
            return !username.isEmpty
        case .password:
            return !username.isEmpty && !password.isEmpty
        }
    }

    @ViewBuilder
    private var changeSignUpTypeButton: some View {
        Group {
            switch signUpType {
            case .passkey:
                Button("Sign Up with Password") {
                    signUpType = .password
                }
            case .password:
                Button("Sign Up with Passkey") {
                    signUpType = .passkey
                    password = ""
                }
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .font(.system(.subheadline))
    }
}

struct SignUpView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        @StateObject private var accountStore = AccountStore()

        var body: some View {
            SignUpView(model: model)
                .environmentObject(accountStore)
        }
    }

    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
