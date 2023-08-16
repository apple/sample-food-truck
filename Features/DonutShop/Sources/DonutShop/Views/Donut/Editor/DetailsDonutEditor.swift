//
//  DetailsDonutEditor.swift
//  
//
//  Created by Anton Kolchunov on 15.08.23.
//

import SwiftUI

struct DetailsDonutEditor: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
           DonutEditor()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("Edit Donut")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Close") {
            dismiss()
        })
    }
}

struct DetailsDonutEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailsDonutEditor()
        }
    }
}


