//
//  MovieViewModel.swift
//  MoviesApp
//
//  Created by PUTRI RAHMADEWI on 27/02/23.
//

import Foundation
import UIKit

class MovieViewModel {
  private var apiService = ApiService()
  private var popularMovies : [Movie]! = []
  private var currentPopularMovies : [Movie]! = []
  var isSearching = false
  
  func fetchPopularMoviesData(completion: @escaping () -> ()) {
    apiService.getPopularMoviesData { [weak self] (result) in
      switch result {
      case .success(let listOf):
        self?.popularMovies = listOf.movies
        completion()
      case .failure(let error):
        print("Error processing json data: \(error)")
      }
    }
  }
  
  func numberOfRowsInSection(section: Int) -> Int {
    if isSearching{
      return currentPopularMovies.count
    }else{
      return popularMovies.count
    }
    
  }
  
  
  func cellForRowAt (indexPath: IndexPath) -> Movie {
    if isSearching{
      return currentPopularMovies[indexPath.row]
    }else{
      return popularMovies[indexPath.row]
    }
  }
  
  func didSelectRowAt(indexPath: IndexPath) -> Movie{
    if isSearching{
      return currentPopularMovies[indexPath.row]
    }else{
      return popularMovies[indexPath.row]
    }
  }
  
  func textDidChange(searchText: String) -> String{
    if searchText == "" || searchText == nil {
      currentPopularMovies = popularMovies
    } else{
      isSearching = true
      currentPopularMovies = popularMovies.filter({ movie -> Bool in
        return (movie.title?.contains(searchText))!
      })
    }
    return searchText
  }
}

