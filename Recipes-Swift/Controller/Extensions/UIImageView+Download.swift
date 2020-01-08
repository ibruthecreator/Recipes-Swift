//
//  UIImage+Download.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-02.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//
 
import UIKit

extension UIImageView {
    func download(from link: String) {
        guard let url = URL(string: link) else {
            // URL error
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200, error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                    return // Error
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
