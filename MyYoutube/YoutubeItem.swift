//
//  YoutubeItem.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 19/1/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import Foundation
import RealmSwift

class YoutubeItem: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var thumbnail: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var videoDescription: String = ""
    @objc dynamic var filePathString = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
