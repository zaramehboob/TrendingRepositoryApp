//
//  RepositoryCellViewModel.swift
//  TrendingRepositoriesKit
//
//  Created by Zara on 10/06/2023.
//

import Foundation
import Combine

protocol RepositoryCellViewModelType {
    var attributes: AnyPublisher<(title: String, description: String, stars: Int, language: String), Never> { get }
    var owner: AnyPublisher<(name: String, url: String), Never> { get }
    var shimmer: AnyPublisher<Bool, Never> { get }
    var isExpanded: AnyPublisher<Bool, Never> { get }
    func expand()
}


class RepositoryCellViewModel: RepositoryCellViewModelType {
    private let isShimmerOn: Bool
    //subjects
    private var attributesSubject = CurrentValueSubject<(title: String, description: String, stars: Int, language: String), Never>((title: "", description: "", stars: 0, language: ""))
    private var ownerSubject = CurrentValueSubject<(name: String, url: String), Never>((name: "", url: ""))
    private var shimmerSubject = CurrentValueSubject<Bool, Never>(false)
    private var expandSubject = CurrentValueSubject<Bool, Never>(false)
    //publishers
    var attributes: AnyPublisher<(title: String, description: String, stars: Int, language: String), Never> { return attributesSubject.eraseToAnyPublisher() }
    var owner: AnyPublisher<(name: String, url: String), Never> { return ownerSubject.eraseToAnyPublisher() }
    var shimmer: AnyPublisher<Bool, Never> { return shimmerSubject.eraseToAnyPublisher() }
    var isExpanded: AnyPublisher<Bool, Never> { return  expandSubject.eraseToAnyPublisher()}
    
    init(repository: Repository, isShimmerOn: Bool = false) {
        self.isShimmerOn = isShimmerOn
        
        attributesSubject.send((title: repository.title, description: repository.description, stars: repository.stars, language: repository.language))
        
        ownerSubject.send((name: repository.owner.name, url: repository.owner.avatarUrl))
        
        shimmerSubject.send(isShimmerOn)
    
    }
    
    func expand() {
        let isExpanded = expandSubject.value
        expandSubject.send(!isExpanded)
    }
}

extension RepositoryCellViewModel: Equatable {
    static func == (lhs: RepositoryCellViewModel, rhs: RepositoryCellViewModel) -> Bool {
        true
    }
}

