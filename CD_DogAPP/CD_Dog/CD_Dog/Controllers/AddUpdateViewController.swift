
//
// AddUpdateViewController.swift
// CD_Dog
//
// Created by Elin Ellinor Jernstrom on 12/04/2024.
//

import UIKit
import CoreData

class AddUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

 // Outlets and actions
 @IBOutlet var breedTF: UITextField!
 @IBOutlet var traitsTF: UITextField!
 @IBOutlet var originTF: UITextField!
 @IBOutlet var imageTF: UITextField!
 @IBOutlet var urlTF: UITextField!
    
 @IBOutlet var pickedImageView: UIImageView!
  
    
    @IBAction func pickedImageAction(_ sender: Any) {
        
                // setup the picker
                picker.sourceType = .savedPhotosAlbum
                picker.allowsEditing = false
                picker.delegate = self
        
                // start picking
                present(picker, animated: true)
    }

    
 
 // Property to hold the Dog object
 var pMangedObject: Dog?
 
    //FAVOURITE FUNCTION FOR IMAGE IN THE HEART
    @IBAction func changeFav(_ sender: Any) {
       if pMangedObject!.isFavourite  == false {
           pMangedObject!.isFavourite = true
           heartButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
           print("fill")
       }else{
           pMangedObject!.isFavourite = false
           heartButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
       }
        //SAVING IT INTO PERSISTANT DATA AGAIN
        do {
            print("in")
        try context.save()
        } catch {
        print("CORE DATA CANNOT SAVE")
        }

    }
    
    @IBOutlet var heartButton: UIButton!
    
    
    
    
    // Context for Core Data operations
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Create padding for each text field: source: www.tutorialspoint.com/create-a-space-at-the-beginning-of-a-uitextfield
        let breedPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: breedTF.frame.height))
        let traitsPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: traitsTF.frame.height))
        let originPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: originTF.frame.height))
        let imagePadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: imageTF.frame.height))
        let urlPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: urlTF.frame.height))
        
        // Assign the padding to the left side
        breedTF.leftView = breedPadding
        breedTF.leftViewMode = .always
        traitsTF.leftView = traitsPadding
        traitsTF.leftViewMode = .always
        
        originTF.leftView = originPadding
        originTF.leftViewMode = .always
        
        imageTF.leftView = imagePadding
        imageTF.leftViewMode = .always
        
        urlTF.leftView = urlPadding
        urlTF.leftViewMode = .always
        
        // Fill the fields with pManagedObject data if available
        if let dog = pMangedObject {
            breedTF.text = dog.breed
            traitsTF.text = dog.traits
            originTF.text = dog.origin
            imageTF.text = dog.image
            urlTF.text = dog.url
            
            //have the favourite display onload
            if dog.isFavourite  == true {
                heartButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
            } else{
                heartButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
            }
            
            if imageTF.text != nil{
                getImageToView(name: imageTF.text!)
            }
        }
    }

        
    
 
 // Action to save or update Dog object
 @IBAction func saveAction(_ sender: Any) {
 if pMangedObject != nil {
 updateDog()
 } else {
 insertDog()
 }
     
     navigationController?.popViewController(animated: true)
 }
 
 // Function to insert a new Dog object into Core Data
 func insertDog() {
 // Create a new Dog object
 pMangedObject = Dog(context: context)
 // Populate the Dog object with data from text fields
 pMangedObject?.breed = breedTF.text
 pMangedObject?.traits = traitsTF.text
 pMangedObject?.origin = originTF.text
 pMangedObject?.image = imageTF.text
 pMangedObject?.url = urlTF.text
     
     // save the image
     if pickedImageView.image != nil && imageTF.text != nil {
         saveImage(name: imageTF.text!)
     }
 
 // Save the context
 do {
 try context.save()
 } catch {
 print("CORE DATA CANNOT SAVE")
 }
     

 }
 
 // Function to update an existing Dog object in Core Data
 func updateDog() {
 // Populate the existing Dog object with updated data
 pMangedObject?.breed = breedTF.text
 pMangedObject?.traits = traitsTF.text
 pMangedObject?.origin = originTF.text
 pMangedObject?.image = imageTF.text
 pMangedObject?.url = urlTF.text
     
     

 
 // Save the context
 do {
 try context.save()
     // save the image
     if pickedImageView.image != nil && imageTF.text != nil {
         saveImage(name: imageTF.text!)
     }
 } catch {
 print("CORE DATA CANNOT SAVE")
 }

 }
    
    //MARK: - Image methods
    
    func getImage(name:String)->UIImage! {
        // get an image from Documents and return it
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        
        return UIImage(contentsOfFile: filePath)
    }
    
    func saveImage(name:String) {
        // get the path to the image
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        
        // get a file manager
        let fm = FileManager.default
        
        // generate the png or jpeg data for the imageView
        let image = pickedImageView.image
        let data = image?.pngData()
        
        // file manager to create the file
        fm.createFile(atPath: filePath as String, contents: data)
    }
    //FUNCTION FOR IF IMAGE IS VALID
    func isValidImageName(_ imageName: String) -> Bool {
        return UIImage(named: imageName) != nil
    }

    func getImageToView(name:String) {
        // get an image from Documents and return it
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        //again checking if the name corresponds to valid image or go to placeholder instead
        let fallBackImage = isValidImageName(name) ? UIImage(named: name):UIImage(named: "placeholder_image")!
        //loading the image
        let image = UIImage(contentsOfFile: filePath) ?? fallBackImage
        
        pickedImageView.image = image
    }
    
    //MARK: - Picker methods
    
    let picker = UIImagePickerController()
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get the image from info
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // place it in the view
        pickedImageView.image = image
        // dismiss
        dismiss(animated: true)
    }
    
 
 // Prepare for segue to pass the Dog object to DogViewController
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 if segue.identifier == "dogImageViewSegue" {
 let destination = segue.destination as! DogViewController
 // Pass the Dog object to DogViewController
 destination.dogData = pMangedObject
 }
 }
}



