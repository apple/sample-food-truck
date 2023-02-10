/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A class that manages and displays StoreKit messages.
*/

#if os(iOS)
import Foundation
import StoreKit
import SwiftUI

@MainActor
public final class StoreMessagesManager {
    private var pendingMessages: [Message] = []
    private var updatesTask: Task<Void, Never>?
    
    public static let shared = StoreMessagesManager()
    
    public var sensitiveViewIsPresented = false {
        didSet {
            handlePendingMessages()
        }
    }
    
    public var displayAction: DisplayMessageAction? {
        didSet {
            handlePendingMessages()
        }
    }
    
    private init() {
        self.updatesTask = Task.detached(priority: .background) {
            await self.updatesLoop()
        }
    }
    
    deinit {
        updatesTask?.cancel()
    }
    
    private func updatesLoop() async {
        for await message in Message.messages {
            if sensitiveViewIsPresented == false, let action = displayAction {
                display(message: message, with: action)
            } else {
                pendingMessages.append(message)
            }
        }
    }
    
    private func handlePendingMessages() {
        if sensitiveViewIsPresented == false, let action = displayAction {
            let pendingMessages = self.pendingMessages
            self.pendingMessages = []
            for message in pendingMessages {
                display(message: message, with: action)
            }
        }
    }
    
    private func display(message: Message, with display: DisplayMessageAction) {
        do {
            try display(message)
        } catch {
            print("Failed to display message: \(error)")
        }
    }
    
}

public struct StoreMessagesDeferredPreferenceKey: PreferenceKey {
    public static let defaultValue = false
    
    public static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

private struct StoreMessagesDeferredModifier: ViewModifier {
    let areDeferred: Bool
    
    func body(content: Content) -> some View {
        content.preference(key: StoreMessagesDeferredPreferenceKey.self, value: areDeferred)
    }
}

public extension View {
    func storeMessagesDeferred(_ storeMessagesDeferred: Bool) -> some View {
        self.modifier(StoreMessagesDeferredModifier(areDeferred: storeMessagesDeferred))
    }
}

#endif // os(iOS)
