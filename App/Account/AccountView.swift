/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The account view where the user can sign in and out.
*/

import SwiftUI
import FoodTruckKit
import StoreKit
import AuthenticationServices

struct AccountView: View {
    @ObservedObject var model: FoodTruckModel

    @EnvironmentObject private var accountStore: AccountStore
    @Environment(\.authorizationController) private var authorizationController
    
    @State private var isSignUpSheetPresented = false
    @State private var isSignOutAlertPresented = false

    var body: some View {
        Form {
            if case let .authenticated(username) = accountStore.currentUser {
                Section {
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.accentColor.gradient, in: Circle())

                        Text(username)
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.medium)
                    }
                }
            }
            #if os(iOS)
            NavigationLink(value: "In-app purchase support") {
                Label("In-app purchase support", systemImage: "questionmark.circle")
            }
            #else
            Section {
                LabeledContent("Purchases") {
                    Button("Restore missing purchases") {
                        Task(priority: .userInitiated) {
                            try await AppStore.sync()
                        }
                    }
                }
            }
            #endif

            Section {
                if accountStore.isSignedIn {
                    LabeledContent("Sign out") {
                        Button("Sign Out", role: .destructive) {
                            isSignOutAlertPresented = true
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .labelsHidden()
                } else {
                    LabeledContent("Use existing account") {
                        Button("Sign In") {
                            Task {
                                await signIn()
                            }
                        }
                    }
                    LabeledContent("Create new account") {
                        Button("Sign Up") {
                            isSignUpSheetPresented = true
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Account")
        #if os(iOS)
        .navigationDestination(for: String.self) { _ in
            StoreSupportView()
        }
        #else
        .frame(maxWidth: 500, maxHeight: .infinity)
        #endif
        .sheet(isPresented: $isSignUpSheetPresented) {
            NavigationStack {
                SignUpView(model: model)
            }
        }
        .alert(isPresented: $isSignOutAlertPresented) {
            signOutAlert
        }
    }
    
    private func signIn() async {
        await accountStore.signIntoPasskeyAccount(authorizationController: authorizationController)
    }

    private var signOutAlert: Alert {
        Alert(
            title: Text("Are you sure you want to sign out?"),
            primaryButton: .destructive(Text("Sign Out")) {
                accountStore.signOut()
            },
            secondaryButton: .cancel()
        )
    }
}

struct AccountView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        @StateObject private var accountStore = AccountStore()
        
        var body: some View {
            AccountView(model: model)
                .environmentObject(accountStore)
        }
    }

    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
