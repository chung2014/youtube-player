//
//  ApiClient.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 19/1/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import Foundation
import Alamofire

class ApiClient {
    static let shared = ApiClient()
    
//    let host = "https://leqc5h60ka.execute-api.ap-southeast-1.amazonaws.com/prod"
    let host = "http://localhost:3000"
//    let host = "https://chung2014.hopto.org"
    
    var searchingResultDataList = [String:[YoutubeItem]]()
    var searchingResultNextPage = [String:String]()
    
    private init() {}
    
    func searchText(text: String, completion: @escaping (String?, [YoutubeItem]) -> Void) {
        var parameters = [
            "q": text
        ]
        
        if searchingResultNextPage[text] != nil {
            parameters["pageToken"] = searchingResultNextPage[text]
        }
        
        AF.request("\(host)/api/searchyoutube", parameters: parameters).responseJSON { [unowned self] (response) in
            let json = response.value as! NSDictionary
            let items = json.value(forKeyPath: "result.items") as! [NSDictionary]
            let list = items.map { (object) -> YoutubeItem in
                let id = object.value(forKeyPath: "id.videoId") as! String
                let thumbnail = object.value(forKeyPath: "snippet.thumbnails.default.url") as! String
                let title = object.value(forKeyPath: "snippet.title") as! String
                let description = object.value(forKeyPath: "snippet.description") as! String
                return YoutubeItem(id: id, thumbnail: thumbnail, title: title, description: description)
            }
            
            if self.searchingResultDataList[text] == nil {
                self.searchingResultDataList[text] = []
            }
            
            self.searchingResultDataList[text]!.append(contentsOf: list)
            
            let nextPageId = json.value(forKeyPath: "result.nextPageToken") as! String
            self.searchingResultNextPage[text] = nextPageId
            
            completion(nil, self.searchingResultDataList[text]!)
        }
    }
    
}
