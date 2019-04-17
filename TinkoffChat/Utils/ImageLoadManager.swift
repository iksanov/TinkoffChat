//
//  ImageLoadManager.swift
//  TinkoffChat
//
//  Created by MacBookPro on 17/04/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class ImageLoadManager {
    private let apiKey: String
    private let urlString: String
    private let url: URL!
    private let request: URLRequest
    private var loadResults: [ [String : AnyObject] ]?
    
    static let shared = ImageLoadManager()
    
    private init() {
        apiKey = "12218316-9e748eb077835282c7389e68c"
        urlString = "https://pixabay.com/api/?key=\(apiKey)&q=yellow+flowers&image_type=photo"
        url = URL(string: urlString)
        request = URLRequest(url: url)
    }
    
    func loadImageData() {
        
        let initialLoadTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] else { return }
                    self.loadResults = json["hits"] as? [ [String : AnyObject] ]
                } catch  {
                    print("Error trying to convert data to JSON")
                    return
                }
            }
        }
        
        initialLoadTask.resume()
    }
}
