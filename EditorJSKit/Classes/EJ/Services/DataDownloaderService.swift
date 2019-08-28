//
//  DataDownloaderService.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public protocol DataDownloaderServiceProtocol {
    static func downloadFile(at url: URL, completion: @escaping (Data) -> Void)
}

///
class DataDownloaderService: DataDownloaderServiceProtocol {
    static func downloadFile(at url: URL, completion: @escaping (Data) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                print(EJError.errorInDownloadTask)
                return }
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
}
