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
    
    var isFirstBatchResultLoaded  = false
    var fetchingMore = false
    var list: [YoutubeItem] = []
    
    var selectedYoutubeItem: YoutubeItem?
    
    // terry add new properties
    let searchController = UISearchController(searchResultsController: nil)
    
    func beginBatchFetch(text: String) {
        fetchingMore = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        ApiClient.shared.searchText(text: text) { (errMsg, items) in
            DispatchQueue.main.async {
                
                if !self.isFirstBatchResultLoaded {
                    self.isFirstBatchResultLoaded = true
                }
                
                self.list = items
                print(self.list.count)
                self.fetchingMore = false
                self.tableView.reloadData()
                
                self.loadMore()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SummaryCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(LoadingCell.self, forCellReuseIdentifier: "loadingCell")
        
        // setup search bar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search song"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
//        tableView.tableFooterView = UIView.init(frame: .zero)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.item = selectedYoutubeItem
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return list.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryCell
                   
                   cell.titleLabel.text = list[indexPath.row].title
                   cell.descLabel.text = list[indexPath.row].description
                   cell.setThumbnail(string: list[indexPath.row].thumbnail)
                   
                   return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            
            cell.spinner.startAnimating()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 44
        }
        
//        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let videoId = list[index].id
        print("selected index \(index) videoId \(videoId)")
        selectedYoutubeItem = list[index]
        performSegue(withIdentifier: "showdetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("[scrollViewDidScroll]")
        loadMore()
    }
    
    func loadMore() {
        let offetY = tableView.contentOffset.y
        let contentSizeHeight = tableView.contentSize.height
        print("offetY \(offetY) | contentSizeHeight \(contentSizeHeight) | tableView.frame.height \(tableView.frame.height)")
        
        if offetY > contentSizeHeight - tableView.frame.height {
            print("isFirstBatchResultLoaded \(isFirstBatchResultLoaded) | !fetchingMore \(!fetchingMore)")
            if isFirstBatchResultLoaded && !fetchingMore {
                print("[scrollViewDidScroll]/[ApiClient.shared.searchText callback] [loadMore] manual trigger event searchBar endediting so that to trigger checking for batch fetch")
                searchController.searchBar.delegate?.searchBarTextDidEndEditing?(searchController.searchBar)
            }
        }
    }
}

extension MainViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    let text = searchBar.text ?? ""
    
    if text.isEmpty {
        return
    }
    
    print("searching \(text)...")
    self.isFirstBatchResultLoaded = false
//    search(text: text)
    beginBatchFetch(text: text)
  }
}
