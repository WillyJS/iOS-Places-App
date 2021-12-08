import UIKit

/*
* Class populates our view text fields from JSONRPC server. 
*
* @Author William Sanchez
* @Version October 25, 2021
*/

class ViewController: UIViewController {


       @IBOutlet weak var nameInfo: UITextField!
       
       @IBOutlet weak var descriptionInfo: UITextField!
       
       @IBOutlet weak var categoryInfo: UITextField!
       
       @IBOutlet weak var addressTitleInfo: UITextField!
       
       @IBOutlet weak var addressStreetInfo: UITextField!
       
       @IBOutlet weak var elevationInfo: UITextField!
       
       @IBOutlet weak var latitudeInfo: UITextField!

       @IBOutlet weak var longitudeInfo: UITextField!
       
    
    var selectedPlace:String = "unknown"
    var names:[String]=[String]()

    var urlString:String = "http://127.0.0.1:8080"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlString = self.setURL()
        self.callGetNPopulatUIFields(self.selectedPlace)
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
    
    func callGetNPopulatUIFields(_ name: String){
        let connect:PlaceLibrary = PlaceLibrary(urlString: urlString)
        let _:Bool = connect.get(name: name, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        let dictionary = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                        let dict:[String:AnyObject] = (dictionary!["result"] as? [String:AnyObject])!
                        let placeOfInterest:PlaceDescription = PlaceDescription(dictionary: dict)
                        
                        self.nameInfo.text = placeOfInterest.getName()
                        self.descriptionInfo.text = placeOfInterest.getDescription()
                        self.categoryInfo.text = placeOfInterest.getCategory()
                        self.addressTitleInfo.text = placeOfInterest.getAddresTitle()
                        self.addressStreetInfo.text = placeOfInterest.getAddresTitle()
                        self.elevationInfo.text = "\(placeOfInterest.getElevation())"
                        self.latitudeInfo.text = "\(placeOfInterest.getLatitude())"
                        self.longitudeInfo.text = "\(placeOfInterest.getLongitude())"
                        
                    } catch {
                        NSLog("There was a problem adding this place!")
                    }
                }
            }
    })
    }

}

