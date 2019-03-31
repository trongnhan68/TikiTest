//
//  NetworkManager.swift
//  HotKeyword
//
//  Created by Nhan NLT on 3/29/19.
//  Copyright © 2019 Nhan NLT. All rights reserved.
//

import UIKit
import Foundation

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    func getListKeyword(kw: String, onSuccess: @escaping(Keyword) -> Void, onFailure: @escaping(Error) -> Void){
        
        guard let url = URL(string: kw) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            if let keyword = try? JSONDecoder().decode(Keyword.self, from: data) {
                //Get back to the main queue
                DispatchQueue.main.async {
                    onSuccess(keyword)
                }
                
            }
            }.resume()
    }
}
