//
//  CreateBookshelfViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import UIKit

class CreateBookshelfViewController: UIViewController, UITextFieldDelegate {
    
    var didCreateBookshelf: ((String) -> Void)?
    
    let headingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "What would you like to name your bookshelf?"
		label.font = .systemFont(ofSize: 24, weight: .bold)
		label.numberOfLines = 0
        
        return label
    }()
    
    var inputTextView: PaddingTextField!
    
    var bookshelfName: String?
    
    let createButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 8, leading: 24, bottom: 8, trailing: 24)
        
        config.title = "Create"
        
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

		setup()

    }
	
	private func setup() {
		view.backgroundColor = .systemBackground
		
		inputTextView = PaddingTextField()
		inputTextView.delegate = self
		inputTextView.clearButtonMode = .always
		inputTextView.font = .systemFont(ofSize: 18, weight: .regular)
		inputTextView.backgroundColor = .secondarySystemBackground
		inputTextView.layer.cornerRadius = 5
		
		inputTextView.placeholder = "Bookshelf name"
		
		let buttonContainer = UIView()
		buttonContainer.addSubview(createButton)
		
		let stackView = UIStackView(arrangedSubviews: [headingLabel, inputTextView, buttonContainer])
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.setCustomSpacing(60, after: inputTextView)
		
		view.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
		])
		
		NSLayoutConstraint.activate([
			createButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
			createButton.heightAnchor.constraint(equalTo: buttonContainer.heightAnchor),
			createButton.widthAnchor.constraint(equalTo: buttonContainer.widthAnchor, multiplier: 0.3)
		])
		
		createButton.addTarget(self, action: #selector(createBookshelf), for: .touchUpInside)
	}
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        bookshelfName = textField.text
    }
    
    @objc private func createBookshelf() {
		if let bookshelfName = bookshelfName, bookshelfName.trimmingCharacters(in: .whitespaces) != "" {
			self.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.didCreateBookshelf?(bookshelfName)
            }
        }
    }

}

