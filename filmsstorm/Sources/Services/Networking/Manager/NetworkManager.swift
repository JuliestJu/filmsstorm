//
//  NetworkManager.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

class NetworkManager {
    // MARK: - Properties
    
    private let router = Router<APIEndPoint>(networkService: NetworkService())
    
    // MARK: - Networking methods
    
    func getToken(completion: @escaping (Result<RequestToken, NetworkError>) -> Void) {
        self.router.request(.auth(.createRequestToken), completion: completion)
    }
    
    func validateToken(with model: AuthRequestModel, completion: @escaping (Result<RequestToken, NetworkError>) -> Void) {
        self.router.request(.auth(.validateRequestToken(model)), completion: completion)
    }
    
    func createSession(with model: SessionRequestBody, completion: @escaping (Result<SessionID, NetworkError>) -> Void) {
        self.router.request(.auth(.createSession(model)), completion: completion)
    }
    
    func logout(completion: @escaping (Result<LogoutModel, NetworkError>) -> Void) {
        self.router.request(.auth(.logout(sessionID: KeyChainContainer.sessionID ?? "")), completion: completion)
    }
    
    func getUserDetails(completion: @escaping (Result<UserModel, NetworkError>) -> Void) {
        self.router.request(.account(.getAccountDetails(sessionID: KeyChainContainer.sessionID ?? "")), completion: completion)
    }
    
    func getPopularMovies(completion: @escaping (Result<PopularMoviesModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMoviePopular), completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<UpcomingMoviesModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getUpcoming), completion: completion)
    }
    
    func getPopularShows(completion: @escaping (Result<PopularShowsModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowPopular), completion: completion)
    }
   
}
