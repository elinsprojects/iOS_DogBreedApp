//
//  XMLBreedsParser.swift
//  CD_Dog
//
//  Created by Elin Ellinor Jernstrom on 12/04/2024.
//

import Foundation

class XMLBreedsParser: NSObject, XMLParserDelegate {
    var xmlName: String
    
    init(xmlName: String) {
        self.xmlName = xmlName
    }
    
    // parsed variable definitions
    var breed, traits, origin, image, url: String!
  
    let tags = ["breed", "traits", "origin", "image", "url"]
    
    // variables for spying
    var elementId = -1
    var passData = false
    
    var dogData: DogModel!
    var breedsData = [DogModel]()
    
    // parser object
    var parser: XMLParser!
    
    // MARK: parsing methods
    // didStartElement
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if tags.contains(elementName) {
            // spying
            passData = true
            // check what tag to spy
            switch elementName {
                case "breed" : elementId = 0
                case "traits" : elementId = 1
                case "origin" : elementId = 2
                case "image" : elementId = 3
                case "url" : elementId = 4

                default: break
            }
        }
    }
    // didEndElement
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // if an end tag is found ==> reset the spies
        if tags.contains(elementName) {
            passData = false
            elementId = -1
        }
        if elementName == "dog" {
            dogData = DogModel(breed: breed, traits: traits, origin: origin, image: image, url: url)
            breedsData.append(dogData)
            
        }
    }
    // found characters
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // if the tag is spying, store the data
        if passData {
            // populate the pVars
            switch elementId {
                case 0: breed = string
                case 1: traits = string
                case 2: origin = string
                case 3: image = string
                case 4: url = string
              
                default: break
            }
        }
    }
    // begin actually parsing
    func parsing() {
        // get the file from the bundle
        let bundle = Bundle.main.bundleURL
        let bundleURL = NSURL(fileURLWithPath: self.xmlName, relativeTo: bundle)
        
        // make the parser, delegate it, and parse
        parser = XMLParser(contentsOf: bundleURL as URL)
        parser.delegate = self
        parser.parse()
    }
}
