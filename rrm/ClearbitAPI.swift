//
//  ClearbitAPI.swift
//  rrm
//
//  Created by Drew Sullivan on 11/10/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class ClearbitAPI {
    
    private static let baseURLString = "https://company.clearbit.com/v1/domains/find?name="
    private static let token = "sk_750f680b99cfe5a0eef8e9869faa605e"

    static func getCompanyLogoURL(from companyName: String, completion: @escaping (UIImage) -> Void) {
        let cleanedName = companyName.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let urlString = "\(baseURLString)\(cleanedName)"
        let searchURL = URL(string: urlString)!
        var urlRequest = URLRequest(url: searchURL)
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                
                guard
                    let jsonDict = jsonObject as? [String:Any],
                    let logoURLString = jsonDict["logo"] as? String else {
                        print("Problem with json")
                        return
                }
                let image = processData(urlString: logoURLString)
                OperationQueue.main.addOperation {
                    completion(image)
                }
            }
        }
        task.resume()
    }
    
    private static func processData(urlString: String) -> UIImage {
        let url = URL(string: urlString)!
        let data = try? Data(contentsOf: url)
        let image = UIImage(data: data!)
        return image!
    }
    
}
