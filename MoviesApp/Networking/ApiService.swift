//
//  ApiService.swift
//  MoviesApp
//
//  Created by PUTRI RAHMADEWI on 27/02/23.
//

import Foundation

class ApiService {
  private var dataTask: URLSessionDataTask?
  
  func getPopularMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void) {
    
    let popularMoviesURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=849bcf0a1444ac334d58a758e9006fe5&language=en-US"
    
    guard let url = URL(string: popularMoviesURL) else {return}
    
    // Create URL Session - work on the background
    dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      // Handle Error
      if let error = error {
        completion(.failure(error))
        print("DataTask error: \(error.localizedDescription)")
        return
      }
      
      guard let response = response as? HTTPURLResponse else {
        // Handle Empty Response
        print("Empty Response")
        return
      }
      print("Response status code: \(response.statusCode)")
      
      guard let data = data else {
        // Handle Empty Data
        print("Empty Data")
        return
      }
      
      do {
        // Parse the data
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(MoviesData.self, from: data)
        
        // Back to the main thread
        DispatchQueue.main.async {
          completion(.success(jsonData))
        }
      } catch let error {
        completion(.failure(error))
      }
    }
    dataTask?.resume()
  }
}

