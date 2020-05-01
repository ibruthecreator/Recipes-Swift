//
//  Ingredient.swift
//  Quarantine-Chef
//
//  Created by Mohammed Ibrahim on 2020-04-25.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class Ingredient: Codable, Equatable {
    var name: String?
    var image: String?
    
    init(name: String?, image: String?) {
        self.name = name
        self.image = image
    }
    
    // Used to see if an ingredient is included in an array, using its name as its key identifier
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.name == rhs.name
    }
}


