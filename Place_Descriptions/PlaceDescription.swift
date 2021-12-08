import Foundation

/*
* Class allows us to obtain data through JSON or database to use for our place application 
*
* @Author William Sanchez
* @Version October 15, 2021
*/
public class PlaceDescription {
    private var  name: String
    private var description: String
    private var category: String
    private var addressTitle: String
    private var addressStreet: String
    private var elevation: Double
    private var latitude: Double
    private var longitude: Double

    private var defaultString: String = "unknown"

    init() {
        self.name = defaultString
        self.description = defaultString
        self.category = defaultString
        self.addressTitle = defaultString
        self.addressStreet = defaultString
        self.elevation = 0.0
        self.latitude = 0.0
        self.longitude = 0.0
    }

    init?(name :String, description: String, category: String, addressTitle: String, addressStreet: String, elevation: Double, latitude: Double, longitude: Double)
    {
        self.name = name
        self.description = description
        self.category = category
        self.addressTitle = addressTitle
        self.addressStreet = addressStreet
        self.elevation = elevation
        self.latitude = latitude
        self.longitude = longitude
    }

    init (jsonString: String) {
        self.name = ""
        self.description = ""
        self.category = ""
        self.addressTitle = ""
        self.addressStreet = ""
        self.elevation = 0.0
        self.latitude = 0.0
        self.longitude = 0.0
        if let data: Data = jsonString.data(using: String.Encoding.utf8){
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data, options:.mutableContainers) as?[String:Any]
                self.name = (dictionary!["name"] as? String)!
                self.description = (dictionary!["description"] as? String)!
                self.category = (dictionary!["category"] as? String)!
                self.addressTitle = (dictionary!["address-title"] as? String)!
                self.addressStreet = (dictionary!["address-street"] as? String)!
                self.elevation = (dictionary!["elevation"] as? Double)!
                self.latitude = (dictionary!["latitude"] as? Double)!
                self.longitude = (dictionary!["longitude"] as? Double)!
            } catch {
                print ("There was a problem adding this Place!")
            }
        }
    }

    public init(dictionary:[String:Any]) {
        self.name = dictionary["name"] == nil ? "unknown" : dictionary["name"] as! String
        self.description = dictionary["description"] == nil ? "unknown" : dictionary["description"] as! String
        self.category = dictionary["category"] == nil ? "unknown" : dictionary["category"] as! String
        self.addressTitle = dictionary["address-title"] == nil ? "unknown" : dictionary["address-title"] as! String
        self.addressStreet = dictionary["address-street"] == nil ? "unknown" : dictionary["address-street"] as! String
        self.elevation = dictionary["elevation"] == nil ? 0 : dictionary["elevation"] as! Double
        self.latitude = dictionary["latitude"] == nil ? 0.0 : dictionary["latitude"] as! Double
        self.longitude = dictionary["longitude"] == nil ? 0.0 : dictionary["longitude"] as! Double
    }

    func getName() -> String {
        return self.name
    }

    func getDescription() -> String {
        return self.description
    }

    func getCategory() -> String {
        return self.category
    }

    func getAddresTitle() -> String{
        return self.addressTitle
    }

    func getaddressStreet() -> String {
        return self.addressStreet
    }

    func getElevation() -> Double {
        return self.elevation
    }

    func getLatitude() -> Double {
        return self.latitude
    }

    func getLongitude() -> Double {
        return self.longitude
    }

    func setName(name: String) {
        self.name = name
    }

    func setCategory(category: String) {
        self.category = category
    }

    func setAddressTitle(addressTitle: String) {
        self.addressTitle = addressTitle
    }

    func setAddress(addressStreet: String) {
        self.addressStreet = addressStreet
    }

    func setElevation(elevation: Double) {
        self.elevation = elevation
    }

    func setLattitude(latitude: Double) {
        self.latitude = latitude
    }

    func setLongitude(longitude: Double) {
        self.longitude = longitude
    }

    func toJsonString() -> String {
        var jsonString = ""
        let dictionary:[String:Any] = ["name": self.name, "description": self.description, "category": self.category, "address-title": self.addressTitle, "address-street": self.addressStreet, "elevation": self.elevation, "latitude": self.latitude, "longitude": self.longitude] as [String : Any]
        do {
            let jsonData:Data = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        } catch let error as NSError {
            print(error)

        }
        return jsonString
    }

    func toDictionary() -> [String:Any] {
        let dictionary:[String:Any] = ["name": self.name, "description": self.description, "category": self.category, "address-title": self.addressTitle, "address-street": self.addressStreet, "elevation": self.elevation, "latitude": self.latitude, "longitude": self.longitude] as [String : Any]
        return dictionary
    }
}
