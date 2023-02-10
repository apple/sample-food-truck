/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The view where the user can sign up for an account.
*/

import SwiftUI
import FoodTruckKit
import AuthenticationServices

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
    @Environment(\.authorizationController) private var authorizationController
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedElement: FocusElement?
    @State private var usePasskey: Bool = true
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        Form {
            Section {
                LabeledContent("User name") {
                    TextField("User name", text: $username)
                        .textContentType(.username)
                        .multilineTextAlignment(.trailing)
#if os(iOS)
                    
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
#endif
                        .focused($focusedElement, equals: .username)
                        .labelsHidden()
                }
                
                if !usePasskey {
                    LabeledContent("Password") {
                        SecureField("Password", text: $password)
                        #if os(macOS)
                            .textContentType(.password)
                        #elseif os(iOS)
                            .textContentType(.newPassword)
                        #endif
                            .multilineTextAlignment(.trailing)
                            .focused($focusedElement, equals: .password)
                            .labelsHidden()
                    }
                }
                
                LabeledContent("Use Passkey") {
                    Toggle("Use Passkey", isOn: $usePasskey)
                        .labelsHidden()
                }
            } header: {
                Text("Create an account")
            } footer: {
                Label("""
                    When you sign up with a passkey, all you need is a user name. \
                    The passkey will be available on all of your devices.
                    """, systemImage: "person.badge.key.fill")
            }
        }
        .formStyle(.grouped)
        .animation(.default, value: usePasskey)
        #if !os(iOS)
        .frame(maxWidth: 500)
        #endif
        .navigationTitle("Sign up")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Sign Up") {
                    Task {
                        await signUp()
                    }
                }
                .disabled(!isFormValid)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    print("Canceled sign up.")
                    dismiss()
                }
            }
        }
        .onAppear {
            focusedElement = .username
        }
    }

    private func signUp() async {
        Task {
            if usePasskey {
                await accountStore.createPasskeyAccount(authorizationController: authorizationController, username: username)
            } else {
                await accountStore.createPasswordAccount(username: username, password: password)
            }
            dismiss()
        }
    }

    private var isFormValid: Bool {
        if usePasskey {
            return !username.isEmpty
        } else {
            return !username.isEmpty && !password.isEmpty
        }
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
