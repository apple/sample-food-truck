/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The order complete view.
*/

import SwiftUI
import FoodTruckKit

struct OrderCompleteView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("versionPromptedForReview") private var versionPromptedForReview: String?
    @AppStorage("datePromptedForReview") private var datePromptedForReview: TimeInterval?
    
    @State private var boxClosed = false
    @State private var boxBounce = false
    
    var order: Order
    
    @Environment(\.dismiss) private var dismiss
    
    var currentAppVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                DonutBoxView(isOpen: boxClosed) {
                    DonutView(donut: order.donuts.first!)
                }
                .offset(y: boxBounce ? 15 : 0)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 300)
                .onTapGesture {
                    Task { @MainActor in
                        await toggleBoxAnimation()
                    }
                }
                
                Text("\(order.id) completed!")
                    .font(.headline)
                HStack(spacing: 4) {
                    Text("\(order.totalSales.formatted()) donuts")
                    Text("•")
                    Text(Date.now.formatted(date: .omitted, time: .shortened))
                }
                .foregroundStyle(.secondary)
            }
            .padding()
            #if os(macOS)
            .frame(minWidth: 300, minHeight: 300)
            #endif
            .task { @MainActor in
                try? await Task.sleep(nanoseconds: .secondsToNanoseconds(0.75))
                await toggleBoxAnimation()
                // Wait 1.5 seconds before displaying.
                try? await Task.sleep(nanoseconds: .secondsToNanoseconds(1.5))
                if shouldRequestReview {
                    requestReview()
                    didRequestReview()
                }
            }
            .navigationTitle(order.id)
            .toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func toggleBoxAnimation() async {
        // Animate the box closing with a slow spring without bounce.
        withAnimation(.spring(response: 0.35, dampingFraction: 1)) {
            boxClosed.toggle()
        }
        if boxClosed {
            try? await Task.sleep(nanoseconds: .secondsToNanoseconds(0.15))
            // Move the box downward with a spring around the time it closes.
            withAnimation(.spring()) {
                boxBounce = true
            }
            try? await Task.sleep(nanoseconds: .secondsToNanoseconds(0.15))
            // Move the box back with a spring to complete the look.
            withAnimation(.spring()) {
                boxBounce = false
            }
        }
    }
    
    var shouldRequestReview: Bool {
        guard
            let versionPromptedForReview = versionPromptedForReview,
            let datePromptedForReview = datePromptedForReview
        else {
            // If we've never asked the user to review, we'll prompt for a review.
            return true
        }
        guard let currentAppVersion = self.currentAppVersion else {
            return false
        }
        
        let dateLastAsked = Date(timeIntervalSince1970: datePromptedForReview)
        
        var dateComponent = DateComponents()
        dateComponent.month = 4
        
        guard let fourMonthsLater = Calendar.current.date(byAdding: dateComponent, to: dateLastAsked) else {
            return false
        }
        
        return fourMonthsLater < .now && versionPromptedForReview != currentAppVersion
    }
    
    func didRequestReview() {
        versionPromptedForReview = self.currentAppVersion
        datePromptedForReview = Date().timeIntervalSince1970
    }
}

struct OrderCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCompleteView(order: .preview)
    }
}
