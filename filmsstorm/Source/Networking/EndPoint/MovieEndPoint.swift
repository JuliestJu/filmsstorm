//
//  MovieEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension APIEndPoint {
    enum MovieEndPoint: EndPointType {
        case getMovieDetails(movieID: Int)
        case getMovieImages(movieID: Int)
        case getMovieVideos(movieID: Int)
        case getMovieSimilars(movieID: Int)
        case getMovieReviews(movieID: Int)
        case rateMovie(movieID: Int, rateValue: Int)
        case deleteMovieRating(movieID: Int)
        case getMovieLatest
        case getMovieNowPlaying
        case getMoviePopular
        case getMovieTopRated
        
        var path: String {
            switch self {
            case .getMovieDetails(let movieID):
                return "/movie/\(movieID)"
            case .getMovieImages(let movieID):
                return "/movie/\(movieID)/images"
            case .getMovieVideos(let movieID):
                return "/movie/\(movieID)/videos"
            case .getMovieSimilars(let movieID):
                return "/movie/\(movieID)/similar"
            case .getMovieReviews(let movieID):
                return "/movie/\(movieID)/reviews"
            case .rateMovie(let movieID, _):
                return "/movie/\(movieID)/rating"
            case .deleteMovieRating(let movieID):
                return "/movie/\(movieID)/rating"
            case .getMovieLatest:
                return "/movie/latest"
            case .getMovieNowPlaying:
                return "/movie/now_playing"
            case .getMoviePopular:
                return "/movie/popular"
            case .getMovieTopRated:
                return "/movie/top_rated"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case
            .getMovieDetails,
            .getMovieImages,
            .getMovieVideos,
            .getMovieSimilars,
            .getMovieReviews,
            .getMovieLatest,
            .getMovieNowPlaying,
            .getMoviePopular,
            .getMovieTopRated:
                return .get
                
            case
            .rateMovie:
                return .post
                
            case
            .deleteMovieRating:
                return .delete
                
            }
        }
        
        var task: HTTPTask {
            switch self {
            case
            .getMovieLatest,
            .getMovieNowPlaying,
            .getMoviePopular,
            .getMovieTopRated,
            .getMovieDetails,
            .getMovieImages,
            .getMovieVideos,
            .getMovieSimilars,
            .getMovieReviews:
                return .requestParameters(bodyParameters: nil, urlParameters:  [Headers.apiKey: Headers.apiKeyValue])
                
            case .rateMovie(_, let rateValue):
                return .requestParametersAndHeaders(bodyParameters: ["value": rateValue],
                                                    urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                    additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            case .deleteMovieRating:
                return .requestParametersAndHeaders(bodyParameters: nil,
                                                    urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                    additionHeaders: [Headers.contentType: Headers.contentTypeValue])
                
            }
        }
        
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
    }
}
