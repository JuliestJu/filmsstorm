//
//  SessionIDViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum SessionIDEvent: EventProtocol {
    case logout
    case error(AppError)
}

class SessionIDViewController: UIViewController, Controller, ActivityViewPresenter {

    // MARK: - Subtypes

    typealias RootViewType = SessionIDView
    
    // MARK: - temporary values
    
    let apiKey = "f4559f172e8c6602b3e2dd52152aca52"
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    let eventHandler: ((SessionIDEvent) -> Void)?
    let loadingView = ActivityView()
    
    // MARK: - Init and deinit
    
    deinit {
    }
    
    init(networking: NetworkManager, event: ((SessionIDEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTaapped(_ sender: Any) {
        UserDefaultsContainer.unregister()
        self.logout()
    }
    @IBAction func getUserButton(_ sender: Any) {
        self.getUserDetails()
    }
    
    // MARK: - Private Methods
    
    private func getUserDetails() {
        let sessionID = UserDefaultsContainer.session
        self.networking.getUserDetails(sessionID: sessionID) { [weak self] result in
            switch result {
            case .success(let usermodel):
                UserDefaultsContainer.username = usermodel.username ?? ""
                DispatchQueue.main.async {
                    self?.rootView?.fillLabel()
                }
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
                print(error.stringDescription)
            }
        }
    }
    
    private func logout() {
        self.showActivity()
        let sessionID = UserDefaultsContainer.session
        self.networking.logout(sessionID: sessionID) { [weak self] result in
            switch result {
            case .success:
                UserDefaultsContainer.unregister()
                self?.eventHandler?(.logout)
                self?.hideActivity()
            case .failure(let error):
                self?.hideActivity()
                self?.eventHandler?(.error(.networkingError(error)))
                
            }
        }
    }
}
