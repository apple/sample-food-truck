//
//  DonutIngredientCell.swift
//  
//
//  Created by Anton Kolchunov on 14.08.23.
//

import Foundation
import UIKit

class DonutIngredientCell: UITableViewCell {

    static var identifier = "DonutIngredientCell"

    let nameLabel = UILabel()
    let valueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
        valueLabel.textColor = .gray

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            valueLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
