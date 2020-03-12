//
//  MediaItemViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MediaItemViewController<T: MediaItemPresenter>: UIViewController, Controller, ActivityViewPresenter, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = MediaItemView
    typealias Service = T
    
    enum Section: CaseIterable {
        case main
        case overview
        case similars
    }
    
    // MARK: - Private properties
    
    let loadingView = ActivityView()
    let presenter: Service
    
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
        F.Log(F.toString(Self.self))
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
        self.setupNavigationView()
    }
    
   private func setupNavigationView() {
    
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
    let item = self.presenter.itemModel
    self.rootView?.navigationView?.titleFill(with: item.name ?? "oops")
    
    }
    
    private func cellRegister() {
        self.rootView?.collectionView.register(ImageViewCell.self)
        self.rootView?.collectionView.register(ItemDescriptionViewCell.self)
        self.rootView?.collectionView.register(ItemOverviewViewCell.self)
    }

}
