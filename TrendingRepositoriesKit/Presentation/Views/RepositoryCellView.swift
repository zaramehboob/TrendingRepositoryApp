//
//  RepositoryCellView.swift
//  TrendingRepositoriesKit
//
//  Created by Zara on 11/06/2023.
//

import UIKit
import Combine
import TrendingRepositpriesUIKit


class RepositoryCellView: UITableViewCell, Configurable {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = theme.secondaryLight
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = theme.secondary
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var vLabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, titleLabel, imageContainer])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "icon_star")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = false
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = theme.primary.cgColor
        imageView.layer.cornerRadius = 25
        
        return imageView
    }()
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var primaryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageContainer, vLabelsStackView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = theme.secondaryLight 
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var starsView: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_star"), for: .normal)
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.setTitleColor(theme.secondary , for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        button.isUserInteractionEnabled = false
        button.tintColor = theme.primary
        return button
    }()
    
    private lazy var languageView: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_language"), for: .normal)
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.setTitleColor(theme.secondary , for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.tintColor = theme.greenLight 
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [languageView, starsView])
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var expandableStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, buttonsStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private lazy var vMainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [primaryStackView, expandableStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    private var viewModel: RepositoryCellViewModelType? {
        didSet {
            setupBindings()
        }
    }
    private var imageUrl: String = "" {
        didSet {
            loadImage()
        }
    }
    private var theme: ThemeType = Theme()
    private var cancellables: Set<AnyCancellable> = []
    func configure(with data: Any?) {
        guard let viewModel = data as? RepositoryCellViewModelType else { return }
       
        self.viewModel = viewModel
        
    }
}

    // MARK: View setup
private extension RepositoryCellView {
    
    func setupViews() {
        imageContainer.addSubview(iconImageView)
        contentView.addSubview(vMainStackView)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            vMainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: vMainStackView.trailingAnchor),
            vMainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: vMainStackView.bottomAnchor, constant: 30),
            
            iconImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor,constant: 10),
            iconImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor,constant: 10),


            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            
            imageContainer.widthAnchor.constraint(equalToConstant: 80),
    
        ])
        
    }
    
    func setupBindings() {
        viewModel?.attributes.sink(receiveValue: { [weak self] (title: String, description: String, stars: Int, language: String) in
            self?.titleLabel.text = title
            self?.descriptionLabel.text = description
            self?.starsView.setTitle(String(stars), for: .normal)
            self?.languageView.setTitle(language, for: .normal)
            
        }).store(in: &cancellables)
        
        viewModel?.owner.sink(receiveValue: { [weak self] (name: String, url: String) in
            self?.nameLabel.text = name
            self?.imageUrl = url
        }).store(in: &cancellables)
        
        viewModel?.shimmer.sink(receiveValue: { [weak self] isOn in
            if isOn {
                self?.titleLabel.startShimmeringEffect()
                self?.nameLabel.startShimmeringEffect()
                self?.iconImageView.startShimmeringEffect()
                self?.isUserInteractionEnabled = false
            } else {
                self?.titleLabel.stopShimmeringEffect()
                self?.nameLabel.stopShimmeringEffect()
                self?.iconImageView.stopShimmeringEffect()
                self?.isUserInteractionEnabled = true
            }
        }).store(in: &cancellables)
        
        
        viewModel?.isExpanded.sink(receiveValue: { [weak self] isExpanded in
            self?.expandableStackView.isHidden = !isExpanded
        }).store(in: &cancellables)
    }
    
}

private extension RepositoryCellView {
    func loadImage() {
        ImageLoaderService.loadImage(with: imageUrl) { [weak self] image in
            guard let downloadImage = image else { return }
            self?.iconImageView.image = downloadImage
        }
    }
}
