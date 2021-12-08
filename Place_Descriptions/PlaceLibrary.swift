/*
 * Class allows us to display, add or remove places from JSONRPC server
 *
 * @Author William Sanchez
 * @Version October 25, 2021
 */

import Foundation

public class PlaceLibrary {
    
   static var id:Int = 0
   
   var url:String
   
   init(urlString: String){
       self.url = urlString
   }
   
   func asyncHttpPostJSON(url: String,  data: Data, completion: @escaping (String, String?) -> Void) {
       
       let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
       request.httpMethod = "POST"
       request.addValue("application/json",forHTTPHeaderField: "Content-Type")
       request.addValue("application/json",forHTTPHeaderField: "Accept")
       request.httpBody = data as Data

       let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
           (data, response, error) -> Void in
           if (error != nil) {
               DispatchQueue.main.async(execute: {
                   completion("Error in URL Session", error!.localizedDescription)})
           } else {
               DispatchQueue.main.async(execute: {completion(NSString(data: data!, encoding:String.Encoding.utf8.rawValue)! as String, nil)})
           }
       })
       task.resume()
   }

   func get(name: String, callback: @escaping (String, String?) -> Void) -> Bool{
       var ret:Bool = false
       PlaceLibrary.id = PlaceLibrary.id + 1
       do {
           let dict:[String:Any] = ["jsonrpc":"2.0", "method":"get", "params":[name], "id":PlaceLibrary.id]
           let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options:JSONSerialization.WritingOptions(rawValue: 0))
           self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
           ret = true
       } catch let error as NSError {
           print(error)
       }
       return ret
   }
   
   
   func getNames(callback: @escaping (String, String?) -> Void) -> Bool{
       var ret:Bool = false
       PlaceLibrary.id = PlaceLibrary.id + 1
       do {
           let dict:[String:Any] = ["jsonrpc":"2.0", "method":"getNames", "params":[ ], "id":PlaceLibrary.id]
           let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options:JSONSerialization.WritingOptions(rawValue: 0))
           self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
           ret = true
       } catch let error as NSError {
           print(error)
       }
       return ret
   }

   func add(place: PlaceDescription, callback: @escaping (String, String?) -> Void) -> Bool{
       var ret:Bool = false
       PlaceLibrary.id = PlaceLibrary.id + 1
       do {
        let dict:[String:Any] = ["jsonrpc":"2.0", "method":"add", "params":[place.toDictionary()], "id":PlaceLibrary.id]
           let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options:JSONSerialization.WritingOptions(rawValue: 0))
           self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
           ret = true
       } catch let error as NSError {
           print(error)
       }
       return ret
   }
   
   func remove(placeName: String, callback: @escaping (String, String?) -> Void) -> Bool{
       var ret:Bool = false
       PlaceLibrary.id = PlaceLibrary.id + 1
       do {
           let dict:[String:Any] = ["jsonrpc":"2.0", "method":"remove", "params":[placeName], "id":PlaceLibrary.id]
           let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options:JSONSerialization.WritingOptions(rawValue: 0))
           self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
           ret = true
       } catch let error as NSError {
           print(error)
       }
       return ret
   }
    
}
