//
//  DownloadUtils.swift
//  MyYoutube
//
//  Created by Man Chung Wong on 19/1/2020.
//  Copyright © 2020 Man Chung Wong. All rights reserved.
//

import Foundation
import Alamofire

class DownloadUtils {
    static let shared = DownloadUtils()
        
    private init() {}
    
    func startDownload(videoId: String, completed: @escaping (String?, String?) -> Void) -> Void {
        let apiUrl = "\(ApiClient.shared.host)/api/getmp3/\(videoId)"
        let fileUrl = self.getSaveFileUrl(fileName: apiUrl)
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(apiUrl, to:destination).response { (response) in
            debugPrint(response)
            completed(nil, fileUrl.path)
        }
    }

    func getSaveFileUrl(fileName: String, fileFormat: String = ".mp3") -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)! + fileFormat)
        NSLog(fileURL.absoluteString)
        return fileURL;
    }
    
    func checkVideoExist(videoId: String) -> Bool {
        let fileUrl = getSaveFileUrl(fileName: videoId)
        return FileManager.default.fileExists(atPath: fileUrl.path)
    }
}
