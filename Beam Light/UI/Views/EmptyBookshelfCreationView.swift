//
//  EmptyBookshelfCreationView.swift
//  Beam Light
//
//  Created by Gerry Gao on 4/6/2022.
//

import UIKit

class EmptyBookshelfCreationView: UIView {
	
	let messageLabel: UILabel = {
		let label = UILabel()
		
		label.text = "You have no bookshelf"
		label.textColor = .systemGray2
		
		return label
	}()
	
	lazy var createButton: UIButton = {
		let button = UIButton()
		
		var config = UIButton.Configuration.filled()
		config.cornerStyle = .capsule
		config.contentInsets = .init(top: 8, leading: 24, bottom: 8, trailing: 24)
		
		config.title = "Create now"
		
		button.configuration = config
		
		return button
	}()
	
	var didTapButton: (() -> Void)
	
	init(completion: @escaping (() -> Void)) {
		self.didTapButton = completion
		super.init(frame: .zero)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		translatesAutoresizingMaskIntoConstraints = false

		let stackView = UIStackView(arrangedSubviews: [messageLabel, createButton])
		
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .equalCentering
		stackView.spacing = 20
		
		stackView.translatesAutoresizingMaskIntoConstraints = false

		addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
		
		createButton.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
	}
	
	@objc
	private func handleButtonTap() {
		didTapButton()
	}
}
