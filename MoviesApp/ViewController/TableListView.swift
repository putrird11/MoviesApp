//
//  TableListView.swift
//  MoviesApp
//
//  Created by PUTRI RAHMADEWI on 27/02/23.
//

import UIKit

class TableListView: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var lblName: UILabel!
  var isLoading = false
  private var viewModel = MovieViewModel()
  
  //MARK: For initializer user default
  var text = UserDefaults.standard.string(forKey: "username")!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    let backButton = UIBarButtonItem()
    self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    backButton.tintColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
    backButton.customView?.alpha = 1
    loadPopularMoviesData()
    let mainString = "Halo " + text + "!"
    lblName.text = mainString
    }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
  }
  
  private func loadPopularMoviesData() {
    viewModel.fetchPopularMoviesData { [weak self] in
      self?.tableView.register(UINib(nibName: ListViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: "ListViewCell")
      self?.tableView.dataSource = self
      self?.tableView.delegate = self
      self?.searchBar.delegate = self
      //      self?.searchBar.returnKeyType = UIReturnKeyType.done
      self?.tableView.reloadData()
    }
  }
  
  func loadMoreData() {
    if !isLoading {
      isLoading = true
      DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { // Remove the 1-second delay if you want to load the data without waiting
        // Download more data here
        DispatchQueue.main.async {
          self.tableView.reloadData()
          self.isLoading = false
        }
      }
    }
  }
}

// MARK: - TableView
extension TableListView: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowsInSection(section: section)
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
    let movie = viewModel.cellForRowAt(indexPath: indexPath)
    cell.setCellWithValuesOf(movie)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
    let controller = DetailView()
    let movie = viewModel.didSelectRowAt(indexPath: indexPath)
    controller.movie = Movie(title: movie.title, year: movie.year, rate: movie.rate, posterImage: movie.posterImage, overview: movie.overview)
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  //Search Bar Config
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let text = searchBar.text!
    let movie = viewModel.textDidChange(searchText: text)
    tableView.reloadData()
  }
}
