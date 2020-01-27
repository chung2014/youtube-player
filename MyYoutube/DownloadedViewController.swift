//
//  DownloadedViewController.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 27/1/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import UIKit
import RealmSwift

class DownloadedViewController: UIViewController {

    let realm = try! Realm()
    var list: Results<YoutubeItem>!
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedYoutubeItem: YoutubeItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SummaryCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        list = realm.objects(YoutubeItem.self)
        notificationToken = list.observe({ [weak self] (changes) in
            print("[DownloadedViewController] list changed happened")
            guard let self = self else { return }
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.item = selectedYoutubeItem
        }
    }
}

extension DownloadedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = list {
            return list.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryCell
        
        cell.titleLabel.text = list[indexPath.row].title
        cell.descLabel.text = list[indexPath.row].videoDescription
        cell.setThumbnail(string: list[indexPath.row].thumbnail)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        selectedYoutubeItem = list[index]
        performSegue(withIdentifier: "showdetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
