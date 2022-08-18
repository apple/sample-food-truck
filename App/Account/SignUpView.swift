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
                            .textContentType(.password)
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
        .frame(maxWidth: 500)
        .navigationTitle("Sign up")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Sign Up") {
                    signUp()
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

    private func signUp() {
        Task { @MainActor in
            if usePasskey {
                try await accountStore.createPasskeyAccount(username: username)
            } else {
                try await accountStore.createPasswordAccount(username: username, password: password)
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

//    @ViewBuilder
//    private var changeSignUpTypeButton: some View {
//        Group {
//            switch signUpType {
//            case .passkey:
//                Button("Sign Up with Password") {
//                    signUpType = .password
//                }
//            case .password:
//                Button("Sign Up with Passkey") {
//                    signUpType = .passkey
//                    password = ""
//                }
//            }
//        }
//        .padding(8)
//        .frame(maxWidth: .infinity)
//        .font(.system(.subheadline))
//    }
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
