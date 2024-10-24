//
//  TrendingRepositoryListViewController.swift
//  TrendingRepositoriesKit
//
//  Created by Zara on 11/06/2023.
//

import Combine
import UIKit
import TrendingRepositpriesUIKit

class TrendingRepositoryListViewController: UIViewController {
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = theme.background
        return tableView
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView(buttonColor: theme.primary) { [weak self] in
            self?.onRetry()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitleColor(theme.primary , for: .normal)
        button.setTitle("Refresh", for: .normal)
        //button.translatesAutoresizingMaskIntoConstraints = false
        //button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        //button.isUserInteractionEnabled = false
        //button.tintColor = theme.primary
        return button
    }()
    
    private let viewModel: TrendingRepositoryListViewModelType
    private let theme: ThemeType
    private var cancellables: Set<AnyCancellable> = []
    init(viewModel: TrendingRepositoryListViewModelType, theme: ThemeType = Theme()) {
        self.viewModel = viewModel
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onViewLoad()
        setupViews()
        setupBindings()
        setupConstraints()
        registerCell()
        
    }
    
}

private extension TrendingRepositoryListViewController {
    
    func setupViews() {
        view.backgroundColor = theme.background
        view.addSubview(mainView)
        mainView.addSubview(tableView)
        mainView.insertSubview(errorView, aboveSubview: tableView)
        navigationItem.title = "Trending"
        
        let buttonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = buttonItem
        rightButton.addTarget(self, action: #selector(onRefresh), for: .touchUpInside)
        
    }
    
    func setupBindings() {
        viewModel.reload.sink(receiveValue: { [weak self] _ in
            DispatchQueue.main.async { [unowned self] in
                self?.errorView.isHidden = true
                self?.tableView.reloadData()
            }
        }).store(in: &cancellables)
        
        viewModel.error.sink { [weak self] errorMessage in
            DispatchQueue.main.async { [unowned self] in
                self?.errorView.isHidden = false
                self?.errorView.errorText = errorMessage
            }
        }.store(in: &cancellables)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: mainView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: mainView.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }
    
    func registerCell() {
        tableView.register(RepositoryCellView.self, forCellReuseIdentifier: RepositoryCellView.reuseIdentifier )
    }
    
    func onRetry() {
        viewModel.retry()
    }
    
    @objc
    private func onRefresh() {
        onRetry()
    }
}

extension TrendingRepositoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositoryListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.getRepositoryViewModel(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCellView.reuseIdentifier) as! RepositoryCellView
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.getRepositoryViewModel(for: indexPath.row)
        model.expand()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
}

