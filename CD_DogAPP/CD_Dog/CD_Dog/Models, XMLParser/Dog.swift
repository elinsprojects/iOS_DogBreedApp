//
//  Dog.swift
//  CD_Dog
//
//  Created by Elin Ellinor Jernstrom on 12/04/2024.
//

import Foundation

class DogModel{
    
    // class properties
    var breed, traits, origin, image, url : String
    var isFavourite:Bool = false
    
    // class init-s
    init(breed: String, traits: String, origin: String, image: String, url: String) {
        self.breed = breed
        self.traits = traits
        self.origin = origin
        self.image = image
        self.url = url
      
    }

        
}
