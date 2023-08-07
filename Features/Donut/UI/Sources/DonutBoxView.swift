/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view showing donuts in a box.
*/

import SwiftUI

public struct DonutBoxView<Content: View>: View {
    var isOpen: Bool
    var content: Content
    
    public init(isOpen: Bool, @ViewBuilder content: () -> Content) {
        self.isOpen = isOpen
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let length = min(proxy.size.width, proxy.size.height)
            ZStack {
                Image("box/Inside", bundle: .module)
                    .resizable()
                    .scaledToFit()
                
                content
                    .padding(floor(length * 0.15))
                    .frame(width: length, height: length)
                
                Image("box/Bottom", bundle: .module)
                    .resizable()
                    .scaledToFit()
                
                if isOpen {
                    Image("box/Lid", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .transition(
                            .scale(scale: 0.75, anchor: .bottom)
                                .combined(with: .offset(y: -length * 0.5))
                                .combined(with: .opacity)
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension DonutBoxView where Content == EmptyView {
    public init(isOpen: Bool) {
        self.init(isOpen: isOpen) {
            EmptyView()
        }
    }
}

struct DonutBoxView_Previews: PreviewProvider {
    struct Preview: View {
        @State private var isOpen = true
        
        var body: some View {
            DonutBoxView(isOpen: isOpen)
                .onTapGesture {
                    withAnimation(.spring(response: 0.25, dampingFraction: 1)) {
                        isOpen.toggle()
                    }
                }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
