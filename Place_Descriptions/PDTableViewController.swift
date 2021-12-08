import UIKit

/*
* Class allows manipulation of data in our table view. 
*
* @Author William Sanchez
* @Version October 25, 2021
*/
class PDTableViewController: UITableViewController {
    
    var names:[String]=[String]()
       
       var urlString:String = "http://127.0.0.1:8080"
       
       override func viewDidLoad() {
           super.viewDidLoad()
           self.urlString = self.setURL()
           self.updateTableWithNames()
           self.navigationItem.leftBarButtonItem = self.editButtonItem
           let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action:#selector(PDTableViewController.addPlace))
           self.navigationItem.rightBarButtonItem = addButton
       }
       
       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
       
       func setURL () -> String {
           var host:String = "localhost"
           var port:String = "8080"
           var sProtocol:String = "http"
           if let path = Bundle.main.path(forResource: "JSONRPCServerInfo", ofType: "plist"){
               if let dict = NSDictionary(contentsOfFile: path) as? [String:AnyObject] {
                   host = (dict["serverHost"] as? String)!
                   port = (dict["jsonrpcPort"] as? String)!
                   sProtocol = (dict["serverProtocol"] as? String)!
               }
           }
           print("setURL returning: \(sProtocol)://\(host):\(port)")
           return "\(sProtocol)://\(host):\(port)"
       }

       func updateTableWithNames() {
           let connect:PlaceLibrary = PlaceLibrary(urlString: urlString)
           let _:Bool = connect.getNames(callback: { (res: String, err: String?) -> Void in
               if err != nil {
                   NSLog(err!)
               }else{
                   NSLog(res)
                   if let data: Data = res.data(using: String.Encoding.utf8){
                       do{
                           let dictionary = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                           self.names = (dictionary!["result"] as? [String])!
                           self.names = Array(self.names).sorted()
                           if self.names.count > 0 {
                               self.tableView.reloadData()
                           }
                       } catch {
                           print("There was a problem adding this Place!")
                       }
                   }
                   
               }
           })
       }
       
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           print("tableView editing row at: \(indexPath.row)")
           if editingStyle == .delete {
               let selectedPlace:String = names[indexPath.row]
               print("deleting the place \(selectedPlace)")
               let connect:PlaceLibrary = PlaceLibrary(urlString: urlString)
               let _:Bool = connect.remove(placeName: names[indexPath.row], callback: { _,_  in
                   self.updateTableWithNames()
                   })
           }
       }
       
       @objc func addPlace(_ sender: Any) {
           let newPlace = UIAlertController(title: "New Place Name", message: "Enter all Fields for Place", preferredStyle: UIAlertController.Style.alert)
           newPlace.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
           newPlace.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
               let nameInput = (newPlace.textFields?[0].text)!
               let descriptionInput = (newPlace.textFields?[1].text)!
               let categoryInput = (newPlace.textFields?[2].text)!
               let addressTitleInput = (newPlace.textFields?[3].text)!
               let addressStreetInput = (newPlace.textFields?[4].text)!
               let latitudeInput = Double((newPlace.textFields?[5].text)!)
               let longitudeInput = Double((newPlace.textFields?[6].text)!)
               let elevationInput = Double((newPlace.textFields?[7].text)!)
            
               if !self.names.contains(nameInput) {
                   let addPlace:PlaceDescription = PlaceDescription(dictionary:["name":nameInput, "description":descriptionInput, "category":categoryInput, "address-title":addressTitleInput, "address-street":addressStreetInput, "latitude":latitudeInput!, "longitude":longitudeInput!, "elevation":elevationInput!])
                   let connect:PlaceLibrary = PlaceLibrary(urlString: self.urlString)
                   let _:Bool = connect.add(place: addPlace,callback: { _,_  in
                    print("\(addPlace.getName()) added as: \(addPlace.toJsonString())")
                       self.updateTableWithNames()})
               }
           }))
           newPlace.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "name"})
           newPlace.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "description"})
           newPlace.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "category"})
           newPlace.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "address title"})
           newPlace.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "address street"})
           newPlace.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "latitude"})
           newPlace.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "longitude"})
           newPlace.addTextField(configurationHandler: {(textField: UITextField!) in textField.placeholder = "elevation"})
           present(newPlace, animated: true, completion: nil)
       }

       // MARK: - Table view data source

       override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return names.count
       }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
           cell.textLabel?.text=names[indexPath.row]
           return cell
       }
       
       // MARK: - Navigation

       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier=="PlaceDescriptionSelection" {
               let vC:ViewController=segue.destination as! ViewController
               let indexPath=self.tableView.indexPathForSelectedRow!
               vC.names=self.names
               vC.selectedPlace=self.names[indexPath.row]
           }
       }
}
