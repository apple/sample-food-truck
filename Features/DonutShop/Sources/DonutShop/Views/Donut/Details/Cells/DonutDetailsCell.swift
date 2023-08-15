//
//  DonutDetailsCell.swift
//  
//
//  Created by Anton Kolchunov on 14.08.23.
//

import SwiftUI
import UIKit

class DonutDetailsCell: UITableViewCell {

    static var identifier = "DonutDetailsCell"

    var hostingController: UIHostingController<AnyView>?

    func configure<T: View>(_ swiftUIView: T) {
        let view = AnyView(swiftUIView)
        hostingController = UIHostingController(rootView: view)
        guard let hostingController = hostingController else { return }
        contentView.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}
