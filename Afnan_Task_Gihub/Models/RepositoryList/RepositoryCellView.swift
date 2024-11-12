//
//  RepositoryCellView.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 06/05/1446 AH.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    static let identifier = "RepositoryCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let license: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "Description:"
        label.textColor = .darkGray
        return label
    }()
    
    private let licenseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "License:"
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            descriptionLabel, descriptionText,
            licenseLabel, license
        ])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        addSelectionStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func addSelectionStyle() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        selectedBackgroundView.layer.cornerRadius = 8
        selectedBackgroundView.layer.masksToBounds = true
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func configure(with repository: RepositoryModel) {
        nameLabel.text = repository.name
        descriptionText.text = repository.description
        license.text = repository.license?.name
    }
}
