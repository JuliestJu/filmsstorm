//
//  AppCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 31.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class TabBarContainer: AppEventSource {
    
    // MARK: - Properties
    
    var childCoordinators = [Coordinator]()
    let eventHandler: ((AppEvent) -> Void)?
    private(set) var tabBarController = UITabBarController()
    private let mainFlowNav = UINavigationController()
    private let profileFlow = UINavigationController()
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    deinit {
        self.mainFlowNav.viewControllers.removeAll()
        self.profileFlow.viewControllers.removeAll()
        print(TabBarContainer.self)
    }
    
    init(networking: NetworkManager,
         eventHandler: ((AppEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = eventHandler
        self.createTabBar()
    }
    
    private func createTabBar() {
        self.createDiscoverFlowCoordinator()
        self.createProfileFlowCoordinator()
        let controllers = self.childCoordinators.compactMap { $0.navigationController }
        self.tabBarController.setViewControllers(controllers, animated: true)
        
        self.tabBarController.tabBar.isTranslucent = false
        self.tabBarController.tabBar.barTintColor = UIColor(named: .background)
        self.tabBarController.tabBar.tintColor = UIColor(named: .primary)
    }
    
    private func createDiscoverFlowCoordinator() {
        let coordinator = DiscoverFlowCoordinator(networking: self.networking, navigationController: self.mainFlowNav,
                                                  eventHandler: self.eventHandler)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func createProfileFlowCoordinator() {
        let coordinator = ProfileFlowCoordinator(networking: self.networking, navigationController: self.profileFlow,
                                                 eventHandler: self.eventHandler)
        
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
