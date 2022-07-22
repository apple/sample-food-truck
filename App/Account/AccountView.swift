/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The account view where the user can sign in and out.
*/

import SwiftUI
import FoodTruckKit
import StoreKit

struct AccountView: View {
    @ObservedObject var model: FoodTruckModel

    @EnvironmentObject private var accountStore: AccountStore
    @State private var isSignUpSheetPresented = false
    @State private var isSignOutAlertPresented = false

    var body: some View {
        List {
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
                Button("Restore missing purchases") {
                    Task(priority: .userInitiated) {
                        try await AppStore.sync()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            #endif

            Section {
                if accountStore.isSignedIn {
                    Button("Sign Out", role: .destructive) {
                        isSignOutAlertPresented = true
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    Button("Sign In") {
                        signIn()
                    }
                    .accountStorePresentationContext { provider in
                        accountStore.presentationContextProvider = provider
                    }
                    Button("Sign Up") {
                        isSignUpSheetPresented = true
                    }
                }
            }
        }
        .navigationTitle("Account")
        #if os(iOS)
        .navigationDestination(for: String.self) { _ in
            StoreSupportView()
        }
        #endif
        .sheet(isPresented: $isSignUpSheetPresented) {
            NavigationStack {
                SignUpView(model: model)
                    .accountStorePresentationContext { provider in
                        accountStore.presentationContextProvider = provider
                    }
            }
        }
        .alert(isPresented: $isSignOutAlertPresented) {
            signOutAlert
        }
    }

    private func signIn() {
        Task { @MainActor in
            try await accountStore.signIn()
        }
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
