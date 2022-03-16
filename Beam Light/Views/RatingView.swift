//
//  RatingView.swift
//  Beam Light
//
//  Created by Gerry Gao on 1/3/2022.
//

import UIKit

public class RatingView: UIView {
  
    public var rating: Double = 0 {
        didSet {
            for i in 0..<5 {
                imageViews[i].tintColor = Double(i) < rating ? .orange : .gray
            }
        }
    }
    
    private let imageViews: [UIImageView]
    
    public init() {
        
        imageViews = (0..<5).map { _ in
            return UIImageView(image: UIImage(named: "star")?.withRenderingMode(.alwaysTemplate))
        }
        
        super.init(frame: .zero)
        
        commonInit()
    }
        
    required init?(coder: NSCoder) {
        
        imageViews = (0..<5).map { _ in
            UIImageView(image: UIImage(named: "star"))
        }
        
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        directionalLayoutMargins = .zero
        
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        imageViews.forEach({
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 20),
                $0.widthAnchor.constraint(equalToConstant: 20)
            ])
        })
        
        addSubview(stackView)
    
        NSLayoutConstraint.activate([
          stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
          stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
          stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
          stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
    
}
