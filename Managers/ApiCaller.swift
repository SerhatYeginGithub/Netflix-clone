//
//  ApiCaller.swift
//  Netflix-Clone
//
//  Created by serhat on 11.07.2024.
//

import Foundation

enum MovieUrl: String {
    case BASE_URL = "https://api.themoviedb.org/3"
    case API_KEY  = "api_key=f1299c57ab014c339c5df3b239dd708e"
    case YOUTUBE_API_KEY = "AIzaSyAohVtyw6Hb48iQxsuiLNA9xwf0X3qk9rA"
    case YOUTUBE_BASE_URL = "https://youtube.googleapis.com/youtube/v3/search?"
    static func getTrendingMovieUrl()->String{BASE_URL.rawValue + "/trending/movie/day?" + API_KEY.rawValue}
    static func getTrendingTVUrl()->String {BASE_URL.rawValue + "/trending/tv/day?" + API_KEY.rawValue}
    static func getPopularMoviesUrl()->String { BASE_URL.rawValue + "/movie/popular?" + API_KEY.rawValue}
    static func getTopRatedMoviesUrl() ->String { BASE_URL.rawValue + "/movie/top_rated?" + API_KEY.rawValue}
    static func getUPComingMoviesUrl()->String {BASE_URL.rawValue + "/movie/upcoming?" + API_KEY.rawValue}
    static func getDiscoverMoviesUrl()->String {BASE_URL.rawValue + "/discover/movie?" + API_KEY.rawValue}
    static func getSearchMovieUrl()->String{BASE_URL.rawValue + "/search/movie?" + API_KEY.rawValue + "&query="}
}

class ApiCaller {
    static let shared = ApiCaller()
    
    func getTrendingMovies(completed: @escaping (Result<MovieModel,MovieError>)->Void){
        guard let url = URL(string: MovieUrl.getTrendingMovieUrl()) else {
            completed(.failure(.invalidUrl))
            return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                completed(.failure(.invalidData))
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MovieModel.self, from: data)
                completed(.success(results))
            } catch{
                print(String(describing: error))
                completed(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
    
    func getTrendingTV(completed: @escaping (Result<MovieModel,MovieError>)->Void){
        guard let url = URL(string: MovieUrl.getTrendingTVUrl()) else {
            completed(.failure(.invalidUrl))
            return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                completed(.failure(.invalidData))
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MovieModel.self, from: data)
                completed(.success(results))
            } catch{
                print(String(describing: error))
                completed(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
    
    func getPopularMovies(completed: @escaping (Result<MovieModel,MovieError>)->Void){
        guard let url = URL(string: MovieUrl.getPopularMoviesUrl()) else {
            completed(.failure(.invalidUrl))
            return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                completed(.failure(.invalidData))
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MovieModel.self, from: data)
                completed(.success(results))
            } catch{
                print(String(describing: error))
                completed(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
    
    func getUPComingMovies(completed: @escaping (Result<MovieModel,MovieError>)->Void){
        guard let url = URL(string: MovieUrl.getUPComingMoviesUrl()) else {
            completed(.failure(.invalidUrl))
            return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                completed(.failure(.invalidData))
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MovieModel.self, from: data)
                completed(.success(results))
            } catch {
                print(String(describing: error))
                completed(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
    
    func getTopRatedMovies(completed: @escaping (Result<MovieModel,MovieError>)->Void){
        guard let url = URL(string: MovieUrl.getTopRatedMoviesUrl()) else {
            completed(.failure(.invalidUrl))
            return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                completed(.failure(.invalidData))
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MovieModel.self, from: data)
                completed(.success(results))
            } catch{
                print(String(describing: error))
                completed(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
    
    
    func getDiscoverMovies(completed: @escaping (Result<MovieModel,MovieError>)->Void){
        guard let url = URL(string: MovieUrl.getDiscoverMoviesUrl()) else {
            completed(.failure(.invalidUrl))
            return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                completed(.failure(.invalidData))
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MovieModel.self, from: data)
                completed(.success(results))
            } catch{
                print(String(describing: error))
                completed(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
    
    func search(with query: String, completed: @escaping (Result<MovieModel,MovieError>)->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completed(.failure(.invalidUrl))
            return
        }
        guard let url = URL(string: MovieUrl.getSearchMovieUrl() + "\(query)") else {
            completed(.failure(.invalidUrl))
            return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                completed(.failure(.invalidData))
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MovieModel.self, from: data)
                completed(.success(results))
            } catch{
                print(String(describing: error))
                completed(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
    
    func getMovieFromYoutube(with query: String, completed: @escaping (Result<VideoElement,MovieError>)->Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completed(.failure(.invalidData))
            return}
        guard let url = URL(string: "\(MovieUrl.YOUTUBE_BASE_URL.rawValue)q=\(query)&key=\(MovieUrl.YOUTUBE_API_KEY.rawValue)") else{
            completed(.failure(.invalidUrl))
            return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(YoutubeSearchModel.self, from: data)
                let resultsFiltered = results.items.filter{$0.id.videoId != nil}
                completed(.success(resultsFiltered[0]))
            } catch{
                print(String(describing: error))
                completed(.failure(.invalidData))
                
            }
            
            
        }
        task.resume()
        
    }
    
}
