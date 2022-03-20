//
//  CreateBookshelfViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import UIKit

class CreateBookshelfViewController: UIViewController, UITextFieldDelegate {
    
    var didCreateBookself: ((Bookshelf) -> Void)?
    
    let headingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "What would you like to name it?"
        
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
        
        view.backgroundColor = .systemGray6
        
        inputTextView = PaddingTextField()
        inputTextView.delegate = self
        inputTextView.clearButtonMode = .always
        inputTextView.font = .systemFont(ofSize: 18, weight: .regular)
        inputTextView.backgroundColor = .systemGray5
        inputTextView.layer.cornerRadius = 5
        
        inputTextView.placeholder = "Name..."
        
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
            createButton.widthAnchor.constraint(equalTo: buttonContainer.widthAnchor, multiplier: 0.8)
        ])
        
        createButton.addTarget(self, action: #selector(createBookshelf), for: .touchUpInside)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        bookshelfName = textField.text
    }
    
    @objc private func createBookshelf() {
        if let bookshelfName = bookshelfName {
            let bookshelf = Bookshelf(id: UUID(), title: bookshelfName, books: [])
            navigationController?.popViewController(animated: true)
            didCreateBookself?(bookshelf)
        }
    }
}
