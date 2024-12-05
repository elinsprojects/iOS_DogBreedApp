//
//  FavouritesTableViewController.swift
//  CD_Dog
//
//  Created by Elin Ellinor Jernstrom on 12/04/2024.
//


import UIKit
import CoreData


class FavouritesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        // fetch and check fetched results
        do{
            try frc.performFetch()
            
            
        }catch{
            print("CORE DATA CANNOT FETCH")
        }
        
        //HEADER IMAGE
        title = "Favourites"
        
        let imageView = UIImageView(image: UIImage(named: "header.png"))
        imageView.contentMode = .scaleAspectFit
        
        imageView.frame = CGRect(x:0, y:0, width: tableView.frame.width, height:150)
        tableView.tableHeaderView = imageView
        
        
    }
    
    //MARK: - Core Data
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity : NSEntityDescription!
    var pMangedObject : Dog!
    var frc : NSFetchedResultsController<NSFetchRequestResult>!
    
    func makeRequest()->NSFetchRequest<NSFetchRequestResult>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dog")
        
        let sorter1 = NSSortDescriptor(key: "breed", ascending: true)
        let sorter2 = NSSortDescriptor(key: "traits", ascending: true)
        request.sortDescriptors = [sorter1, sorter2]
        
        request.predicate = NSPredicate(format: "isFavourite == true")
        
        // give predicates for filtering
        return request
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return frc.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.sections![section].numberOfObjects
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        // Configure the cell...
        pMangedObject = frc.object(at: indexPath) as? Dog
        
        cell.textLabel?.text = pMangedObject.breed
        cell.detailTextLabel?.text = pMangedObject.traits
        
        //inserting images AND a placeholder image if there is no IMAGE TEXT
        if let imageName = pMangedObject.image, !imageName.isEmpty{
            cell.imageView?.image = getImage(name: pMangedObject.image!)
        } else {
            //placeholder image
            cell.imageView?.image = UIImage(named: "placeholder_image")
        }
        
        return cell
    }
    
    //FUNCTION FOR IF IMAGE IS VALID
    func isValidImageName(_ imageName: String) -> Bool {
        return UIImage(named: imageName) != nil
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete pManagedObject from indexPath
            pMangedObject = frc.object(at: indexPath) as? Dog
            context.delete(pMangedObject)
            
        }
    }
    
    

    
    //GET THE IMAGES TO LOAD FOR THE TABLEVIEW AS FALLBACKS AT THE START
    func getImage(name:String)->UIImage {
        // get an image from Documents and return it
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        
        //CHECKING IF NAME CORRESPONDS WITH VALID IMAGES IN THE BUNDLE AND LOAD IT IF ITS THE CASE. OTHERWISE LOAD PLACEHOLDER IMAGE
        let fallBackImage = isValidImageName(name) ? UIImage(named: name):UIImage(named: "placeholder_image")!
        
        //LOAD IMAGE, OR IF FILE DOESN'T EXISTS ON THE PATH, THEN FALLBACK
        let image = UIImage(contentsOfFile: filePath) ?? fallBackImage
        
        return image!
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellSegue"{
            // Get the new view controller using segue.destination.
            let destination = segue.destination as! AddUpdateViewController
            
            // Pass the selected object to the new view controller.
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            pMangedObject = frc.object(at: indexPath!) as? Dog
            
            destination.pMangedObject = pMangedObject
            
        }

        }
    
    
    
}
