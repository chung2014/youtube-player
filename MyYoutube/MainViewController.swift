//
//  MainViewController.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 19/1/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var list: [YoutubeItem] = []
    
    var selectedYoutubeItem: YoutubeItem?
    
    // terry add new properties
    let searchController = UISearchController(searchResultsController: nil)
    
    func search(text: String) {
        
        ApiClient.shared.searchText(text: text) { (errMsg, items) in
            DispatchQueue.main.async {
                self.list = items
                print(self.list.count)
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SummaryCell.self, forCellReuseIdentifier: "cell")
        
        // setup search bar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search song"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.item = selectedYoutubeItem
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryCell
        
        cell.titleLabel.text = list[indexPath.row].title
        cell.descLabel.text = list[indexPath.row].description
        cell.setThumbnail(string: list[indexPath.row].thumbnail)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let videoId = list[index].id
        print("selected index \(index) videoId \(videoId)")
        selectedYoutubeItem = list[index]
//        let detailViewController = DetailViewController()
//        navigationController?.pushViewController(detailViewController, animated: true)
        performSegue(withIdentifier: "showdetail", sender: nil)
//        DownloadUtils.shared.startDownload(videoId: videoId)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    let text = searchBar.text ?? ""
    print("searching \(text)...")
    search(text: text)
  }
}
