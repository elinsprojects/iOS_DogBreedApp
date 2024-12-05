//
//  DogViewController.swift
//  CD_Dog
//
//  Created by Elin Ellinor Jernstrom on 14/04/2024.
//


import UIKit


class DogViewController: UIViewController {
    
    // Outlets for UI elements
    
    @IBOutlet var dogImageView: UIImageView!
    @IBOutlet var dogShortInfoLabel: UILabel!
    @IBOutlet var traitsLabel: UILabel!
    
    //    @IBOutlet weak var dogImageView: UIImageView!
    //    @IBOutlet weak var dogShortInfoLabel: UILabel!
    //    @IBOutlet weak var traitsLabel: UILabel!
    //
    // Property to hold the Dog object
    var dogData: Dog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the dog data
        if let dog = dogData {
            dogShortInfoLabel.text = dog.breed
            traitsLabel.text = dog.traits
            // Load image
            if let imageName = dog.image {
                if let image = UIImage(named: imageName) {
                    dogImageView.image = image
                } else {
                    // placeholder image
                    dogImageView.image = UIImage(named: "placeholder_image")
                }
                
            }
            
        }
    }
                
                /*
                 // MARK: - Navigation
                 
                 // In a storyboard-based application, you will often want to do a little preparation before navigation
                 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                 // Get the new view controller using segue.destination.
                 // Pass the selected object to the new view controller.
                 }
                 */
                
   
}
