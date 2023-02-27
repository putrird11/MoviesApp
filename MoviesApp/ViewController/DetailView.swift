//
//  DetailView.swift
//  MoviesApp
//
//  Created by PUTRI RAHMADEWI on 27/02/23.
//

import UIKit

class DetailView: UIViewController {
  
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblYear: UILabel!
  @IBOutlet weak var lblOverview: UILabel!
  @IBOutlet weak var lblRate: UILabel!
  @IBOutlet weak var imageMovie: UIImageView!
  private var viewModel = MovieViewModel()
  private var urlString: String = ""
  var movie: Movie!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let backButton = UIBarButtonItem()
    backButton.title = movie.title
    self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    backButton.tintColor = UIColor(ciColor: .white)
    
    lblTitle.text = movie?.title
    lblYear.text = convertDateFormater(movie.year)
    lblOverview.text = movie?.overview
    guard let rate = movie?.rate else {return}
    self.lblRate.text = String(rate)
    
    guard let posterString = movie.posterImage else {return}
    urlString = "https://image.tmdb.org/t/p/w300" + posterString
    
    guard let posterImageURL = URL(string: urlString) else {
      self.imageMovie.image = UIImage(named: "noImageAvailable")
      return
    }
    
    self.imageMovie.image = nil
    getImageDataFrom(url: posterImageURL)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
  }
  
  // MARK: - Get image data
  private func getImageDataFrom(url: URL) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      // Handle Error
      if let error = error {
        print("DataTask error: \(error.localizedDescription)")
        return
      }
      
      guard let data = data else {
        // Handle Empty Data
        print("Empty Data")
        return
      }
      
      DispatchQueue.main.async {
        if let image = UIImage(data: data) {
          self.imageMovie.image = image
        }
      }
    }.resume()
  }
  
  // MARK: Convert date format
  func convertDateFormater(_ date: String?) -> String {
    var fixDate = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let originalDate = date {
      if let newDate = dateFormatter.date(from: originalDate) {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        fixDate = dateFormatter.string(from: newDate)
      }
    }
    return fixDate
  }
  
}
