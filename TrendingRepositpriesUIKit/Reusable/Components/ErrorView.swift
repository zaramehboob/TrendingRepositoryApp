    //
    //  ErrorView.swift
    //  TrendingRepositoriesKit
    //
    //  Created by Zara on 11/06/2023.
    //

import UIKit
import SwiftyGif

final public class ErrorView: UIView {
    
    private let buttonColor: UIColor
    private let onAction: () -> Void
    public var errorText: String = "" {
        didSet {
            errorLabel.text = errorText
        }
    }
    public init(buttonColor: UIColor = .blue, _ onAction: @escaping () -> Void) {
        self.buttonColor = buttonColor
        self.onAction = onAction
        super.init(frame: .zero)
        
        setupView()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imageView: UIImageView!
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = buttonColor.cgColor
        button.layer.borderWidth = 3
        button.setTitleColor(buttonColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onPrimaryAction), for: .touchUpInside)
        return button
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    @objc
    func onPrimaryAction() {
        onAction()
    }
    
}

extension ErrorView {
    
    func setupView() {
        
        do {
            let gif = try UIImage(gifName: "error.gif")
            imageView = UIImageView(gifImage: gif, loopCount: 3) // Will loop 3 times
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
        } catch {
            print(error)
        }
        addSubview(errorLabel)
        addSubview(retryButton)
        
        backgroundColor = .white
        
    }
    
    func setupConstraints() {
        
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -70),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            //errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            errorLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            retryButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: retryButton.trailingAnchor, constant: 20),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            retryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
}
