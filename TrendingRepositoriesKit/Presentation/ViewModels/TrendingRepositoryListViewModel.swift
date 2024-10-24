//
//  TrendingRepositoryListViewModel.swift
//  TrendingRepositoriesKit
//
//  Created by Zara on 10/06/2023.
//

import Foundation
import Combine

protocol TrendingRepositoryListViewModelInputs {
    func onViewLoad()
    func getRepositoryViewModel(for row: Int) -> RepositoryCellViewModelType
    func retry()
}

protocol TrendingRepositoryListViewModelOutputs {
    var repositoryListCount: Int { get }
    var error: AnyPublisher<String, Never> { get }
    var reload: AnyPublisher<Void, Never> { get }
}

typealias TrendingRepositoryListViewModelType = TrendingRepositoryListViewModelInputs & TrendingRepositoryListViewModelOutputs


class TrendingRepositoryListViewModel: TrendingRepositoryListViewModelType {
    
    //subjects
    private let errorSubject = PassthroughSubject<String, Never>()
    private let reloadSubject = PassthroughSubject<Void, Never>()
    private let fetchUseCase: FetchUseCaseType
    private var repositoryCellViewModels: [RepositoryCellViewModelType] = []
    var repositoryListCount: Int = 0
    //publishers
    var error: AnyPublisher<String, Never> { return errorSubject.eraseToAnyPublisher() }
    var reload: AnyPublisher<Void, Never> { return reloadSubject.eraseToAnyPublisher() }
    private var repositoryList: [Repository] = [] {
        didSet {
            repositoryListCount = repositoryList.count
            configureCellViewModels()
        }
    }
    init(fetchUseCase: FetchUseCaseType) {
        self.fetchUseCase = fetchUseCase
    }
    
    func onViewLoad() {
        fetchRepositories()
    }
    
    func getRepositoryViewModel(for row: Int) -> RepositoryCellViewModelType {
        return repositoryCellViewModels[row]
    }
    
    func retry() {
        fetchRepositories()
    }
}


private extension TrendingRepositoryListViewModel {
    func fetchRepositories() {
        self.beginLoading()
        fetchUseCase.fetch { [weak self] (result: Result<[Repository], Error>) -> Void in
            switch result {
                case .success(let response):
                    self?.repositoryList = response
                    self?.stopLoading()
                case .failure(let error):
                    self?.repositoryList = []
                    self?.errorSubject.send(error.localizedDescription)
            }
        }
    }
    
    func configureCellViewModels(with isShimmerOn: Bool = false) {
        repositoryCellViewModels = repositoryList.map { RepositoryCellViewModel(repository: $0, isShimmerOn: isShimmerOn) }
    }
    
    func beginLoading() {
        var dummyList: [Repository] = []
        for _ in 0..<15 {
            dummyList.append(Repository.dummy)
        }
        
        repositoryList = dummyList
        configureCellViewModels(with: true)
        reloadSubject.send()
    }
    
    func stopLoading() {
        reloadSubject.send()
    }
}
