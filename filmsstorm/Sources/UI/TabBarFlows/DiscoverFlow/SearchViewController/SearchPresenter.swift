//
//  SearchPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum SearchEvent: EventProtocol {
    case mediaItem(DiscoverCellModel)
    case back
    case error(AppError)
}

protocol SearchPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    func moviesSearch(_ query: String, _ completion: (([MovieListResult]) -> Void)?)
    func showsSearch(_ query: String, _ completion: (([ShowListResult]) -> Void)?)
    func onMediaItem(item: DiscoverCellModel)
    func onBack()
}

class SearchPresenterImpl: SearchPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<SearchEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((SearchEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Methods
    
    func moviesSearch(_ query: String, _ completion: (([MovieListResult]) -> Void)?) {
        self.networking.movieSearch(with: query) { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model.results)
            case .failure(let error):
               self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func showsSearch(_ query: String, _ completion: (([ShowListResult]) -> Void)?) {
        self.networking.showSearch(with: query) { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model.results)
            case .failure(let error):
               self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
        
    func onMediaItem(item: DiscoverCellModel) {
        self.eventHandler?(.mediaItem(item))
    }
    
    func onBack() {
        self.eventHandler?(.back)
    }
}
