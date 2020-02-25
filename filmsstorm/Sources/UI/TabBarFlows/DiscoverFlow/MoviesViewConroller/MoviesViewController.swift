//
//  MoviesViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MoviesViewController<T: MoviesPresenterImpl>: UIViewController, Controller, ActivityViewPresenter {
    
    // MARK: - Subtypes
       
    typealias RootViewType = ShowsView
    typealias Service = T
    
    enum Section: CaseIterable {
        case  main
    }
    
    // MARK: - Public Properties
    
    internal let loadingView = ActivityView()
    internal let presenter: Service
    
    // MARK: - Private properties
    
    private var sections = [MovieListResult]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, MovieListResult>?
    
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
        print(F.toString(Self.self))
    }
    
    required init(_ presentation: Service) {
        self.presenter = presentation
        super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHeader()
        self.setCollectionView()
        self.getPopularMovies()
    }
    
    // MARK: - Private Methods
    
    private func getPopularMovies() {
        print("get popular movies")
        self.presenter.getPopularMovies { [weak self] in
            self?.sections = $0
            self?.createDataSource()
        }
    }
    
    private func setCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.455),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.495))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(6)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 7
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 9, bottom: 0, trailing: 9)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        self.rootView?.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupHeader() {
        print("setup header ")
        self.presenter.setTitle()
    }
    
    private func onHeaderEvents() {
        
    }
    
    private func onCardEvent(_ event: MovieCardEvent) {
        switch event {
        case .like:
            print("you liked movie")
        case .favourites:
            print("you added moview to favourites")
        }
    }
    
    // MARK: - set diffableDatasource
    
    func createDataSource() {
        
        guard let collectionView = self.rootView?.collectionView else { return }
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self ] collection, indexPath, item -> UICollectionViewCell? in
            
            let eventModel = MovieCardEventModel {
                self?.onCardEvent($0)
            }
            
            let cell: DiscoverCollectionViewCell = collection.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
            cell.setCornerRadiusWithShadow()
            cell.fill(with: item)
            cell.actionFill(with: eventModel)
            return cell
        }
        let snapshot = self.createSnapshot()
        self.dataSource?.apply(snapshot)
        
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, MovieListResult> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieListResult>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.sections)
        return snapshot
    }
}
