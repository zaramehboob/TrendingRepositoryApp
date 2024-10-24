//
//  TrendingRepositoryContainer.swift
//  TrendingRepositoriesKit
//
//  Created by Zara on 11/06/2023.
//

import Foundation
import UIKit
import Networking

public protocol TrendingRepositoryContainerType {
    func makeRepositoryListController() -> UIViewController
}

public class TrendingRepositoryContainer {
    
    public init() { }
    
    private lazy var networkService: NetworkServiceType = {
        return NetworkService(client: HTTPClient())
    }()
    
    private lazy var fetchUseCase: FetchUseCaseType = {
        return FetchUseCase(service: TrendingRepositoriesService(service: networkService))
    }()
    
    public func makeRepositoryListController() -> UIViewController {
        let viewModel = TrendingRepositoryListViewModel(fetchUseCase: fetchUseCase)
        return TrendingRepositoryListViewController(viewModel: viewModel)
    }
}
