//
//  APIUtilities.swift
//  MySunless
//
//  Created by iMac on 07/10/21.
//

import Foundation
import UIKit
import Alamofire
import Reachability

class APIUtilities: NSObject {
    
    static let sharedInstance = APIUtilities()
    
    //MARK:- Alamofire Methods
    func GetAPICallWith(url:String, completionHandler:@escaping (AnyObject?, NSError?)->()) -> () {
        print("-------------------------------------------------------------------")
        print("URL:",url)
        print("-------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess" ) {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return
        }
        
      //  let headers = ["Accept":"application/json","Authorization":UserManager.shared.token]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        if let JSON = value as? [String: Any] {
                            completionHandler(JSON as AnyObject?, nil)
                        }
                    case .failure(let error):
                        completionHandler(nil, error as NSError)
                        print(error)
                        
                }
            }
    }
    
    func GetArrayAPICallWith(url:String, header: HTTPHeaders, completionHandler:@escaping (AnyObject?, NSError?)->()) -> () {
        //response is in array of dictionary
        print("-------------------------------------------------------------------")
        print("URL:",url)
        print("Headers :",header)
        print("-------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess" ) {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return
        }
        
        //  let headers = ["Accept":"application/json","Authorization":UserManager.shared.token]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        if let JSON = value as? [[String: Any]] {
                            completionHandler(JSON as AnyObject?, nil)
                        }
                    case .failure(let error):
                        completionHandler(nil, error as NSError)
                        print(error)
                        
                }
            }
    }
    
    func GetDictAPICallWith(url:String, header: HTTPHeaders, completionHandler:@escaping (AnyObject?, NSError?)->()) -> () {
        //response is in dictionary
        print("-------------------------------------------------------------------")
        print("URL:",url)
        print("Headers :",header)
        print("-------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess" ) {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return
        }
        
        //  let headers = ["Accept":"application/json","Authorization":UserManager.shared.token]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        if let JSON = value as? [String: Any] {
                            completionHandler(JSON as AnyObject?, nil)
                        }
                    case .failure(let error):
                        completionHandler(nil, error as NSError)
                        print(error)
                        
                }
            }
        
    
    }
    
    //MARK:- POST
    func POSTAPICallWith(url:String, param:AnyObject, completionHandler:@escaping (AnyObject?, NSError?)->()) -> ()
    {
        print("-------------------------------------------------------------------")
        print("URL :",url)
        print("Request Parameters : ",param)
        print("-------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess" ) {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return
        }
        
       // print("Bearer Token :=>",UserManager.shared.token)
        
       // let headers = ["Accept":"application/json","Authorization":UserManager.shared.token]

       // AF.request(url, method: HTTPMethod.post, parameters: param as? Parameters, encoder: URLEncoding.default as! ParameterEncoder, headers: headers)
        AF.request(url, method: .post, parameters: param as? Parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
            
                switch response.result {
                    case .success(let value):
                        if let JSON = value as? [String: Any] {
                            if let message = (JSON as NSDictionary).value(forKey: "response") as? String {
                                if message == "Token is Expired" {
//                                    UserManager.removeModel()
//                                    UserManager.getUserData()
//                                    UserManager.shared.userid = ""
//                                    UserManager.shared.token = ""
//                                    print(UserManager.shared.userid)
//                                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                                    let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                                    UIApplication.shared.windows.first?.rootViewController = redViewController
//                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                } else {
                                    completionHandler(JSON as AnyObject?, nil)
                                }
                            } else {
                                completionHandler(JSON as AnyObject?, nil)
                            }
                        }
                    case .failure(let error):
                        print(error)
                }
            }
    }
    
    func PpOSTAPICallWith(url:String, param:AnyObject, header: HTTPHeaders, completionHandler:@escaping (AnyObject?, NSError?)->()) -> ()
    {
        print("-------------------------------------------------------------------")
        print("URL :",url)
        print("Headers :",header)
        print("Request Parameters : ",param)
        print("-------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess" ) {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return
        }
        
        // print("Bearer Token :=>",UserManager.shared.token)
        
        // let headers = ["Accept":"application/json","Authorization":UserManager.shared.token]
        
        // AF.request(url, method: HTTPMethod.post, parameters: param as? Parameters, encoder: URLEncoding.default as! ParameterEncoder, headers: headers)
        AF.request(url, method: .post, parameters: param as? Parameters, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) in
                
                switch response.result {
                    case .success(let value):
                        if let JSON = value as? [String: Any] {
                            if let message = (JSON as NSDictionary).value(forKey: "response") as? String {
                                if message == "Token is Expired" {
                                    //                                    UserManager.removeModel()
                                    //                                    UserManager.getUserData()
                                    //                                    UserManager.shared.userid = ""
                                    //                                    UserManager.shared.token = ""
                                    //                                    print(UserManager.shared.userid)
                                    //                                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                                    //                                    let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                    //                                    UIApplication.shared.windows.first?.rootViewController = redViewController
                                    //                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                } else {
                                    completionHandler(JSON as AnyObject?, nil)
                                }
                            } else {
                                completionHandler(JSON as AnyObject?, nil)
                            }
                        }
                    case .failure(let error):
                        print(error)
                }
            }
    }
    
    func PpOSTArrayAPICallWith(url:String, param:AnyObject, header: HTTPHeaders, completionHandler:@escaping (AnyObject?, NSError?)->()) -> ()
    {
        print("-------------------------------------------------------------------")
        print("URL :",url)
        print("Headers :",header)
        print("Request Parameters : ",param)
        print("-------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess" ) {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return
        }
        
        AF.request(url, method: .post, parameters: param as? Parameters, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) in
                
                switch response.result {
                    case .success(let value):
                        if let JSON = value as? [[String: Any]] {
                            if let message = (JSON as NSArray).value(forKey: "response") as? String {
                                if message == "Token is Expired" {
                                    //                                    UserManager.removeModel()
                                    //                                    UserManager.getUserData()
                                    //                                    UserManager.shared.userid = ""
                                    //                                    UserManager.shared.token = ""
                                    //                                    print(UserManager.shared.userid)
                                    //                                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                                    //                                    let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                    //                                    UIApplication.shared.windows.first?.rootViewController = redViewController
                                    //                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                } else {
                                    completionHandler(JSON as AnyObject?, nil)
                                }
                            } else {
                                completionHandler(JSON as AnyObject?, nil)
                            }
                        }
                    case .failure(let error):
                        print(error)
                }
            }
    }

    func UuuploadImage(url:String, keyName: String, imageData: Data?, param:NSDictionary, header: HTTPHeaders, completionHandler:@escaping (AnyObject?, NSError?)->()) ->() {
        print("-------------------------------------------------------------------")
        print("URL :",url)
        print("Headers : ",header)
        print("Request Parameters : ",param)
        print("-------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess" ) {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key as! String + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            if let data = imageData {
                multipartFormData.append(data, withName: keyName, fileName: "\(Date.init().timeIntervalSince1970).png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: header)
        .responseJSON { (response) in
            print(response)
            
            switch response.result {
                case .success(_):
                    if let JSON = response.value as? [String: Any] {
                        completionHandler(JSON as AnyObject?, nil)
                    }
                    break
                case .failure(let error):
                    completionHandler(nil,error as NSError?)
                    print("failure")
                    break
            }
        }
    }
    
    func uploadTwoImages(url:String, keyName1: String, keyName2: String, imageData1: Data?, imageData2: Data?, param:NSDictionary, header: HTTPHeaders, completionHandler:@escaping (AnyObject?, NSError?)->()) ->() {
        print("-------------------------------------------------------------------")
        print("URL :",url)
        print("Headers : ",header)
        print("Request Parameters : ",param)
        print("-------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess" ) {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return
        }
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key as! String + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            if let data = imageData1 {
                multipartFormData.append(data, withName: keyName1, fileName: "\(Date.init().timeIntervalSince1970).png", mimeType: "image/png")
            }
            if let data = imageData2 {
                multipartFormData.append(data, withName: keyName2, fileName: "\(Date.init().timeIntervalSince1970).png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: header)
        .responseJSON { (response) in
            print(response)
            
            switch response.result {
                case .success(_):
                    if let JSON = response.value as? [String: Any] {
                        completionHandler(JSON as AnyObject?, nil)
                    }
                    break
                case .failure(let error):
                    completionHandler(nil,error as NSError?)
                    print("failure")
                    break
            }
        }
    }
    
    func uploadMultipleImages(url:String, keyName: String, imageArrData: [UIImage], param:NSDictionary, header: HTTPHeaders, completionHandler:@escaping (AnyObject?, NSError?)->()) ->() {
        print("-------------------------------------------------------------------")
        print("URL :",url)
        print("Headers : ",header)
        print("Request Parameters : ",param)
        print("-------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess" ) {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return
        }
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key as! String + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            let count = imageArrData.count
            for i in 0..<count{
                //multipartFormData.append(imageArrData[i], withName: keyName, fileName: "\(Date.init().timeIntervalSince1970).png", mimeType: "image/png")
                let imageData1 = imageArrData[i].jpegData(compressionQuality: 1.0)!
             //   multipartFormData.append(imageData1, withName: "morephoto[\(i)]" , fileName: "photo" + String(i) + ".jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageData1, withName: keyName, fileName: "\(Date.init().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
            }
            
        }, to: url, method: .post, headers: header)
        .responseJSON { (response) in
            print(response)
            
            switch response.result {
                case .success(_):
                    if let JSON = response.value as? [String: Any] {
                        completionHandler(JSON as AnyObject?, nil)
                    }
                    break
                case .failure(let error):
                    completionHandler(nil,error as NSError?)
                    print("failure")
                    break
            }
        }
    }
    
    //MARK: Network Check
    func checkNetworkConnectivity() -> String {
        let network:Reachability = try! Reachability()
        var networkValue:String = "" as String
        
        switch network.connection {
            case .wifi:
                networkValue = "Network Reachable through Wifi"
                print("Reachable via WiFi")
            case .cellular:
                networkValue = "Network Reachable through Cellular Data"
                print("Reachable via Cellular")
            case .unavailable:
                networkValue = "NoAccess"
                print("Network not reachable")
            case .none:
                print("None")
        }
        
        return networkValue
    }
    
    func callNetworkAlert() {
        let alert = UIAlertView()
        alert.title = "No Network Found!"
        alert.message = "Please check your internet connection."
        alert.addButton(withTitle: "OK")
        alert.show()
        
    }
    
//    func callNetworkAlert(viewController : UIViewController)->Void {
//        let alert = UIAlertController(title: "No Network Found!", message: "Please check your internet connection.", preferredStyle: UIAlertController.Style.alert)
//        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (dd) -> Void in
//
//        }
//        alert.addAction(action1)
//        viewController.present(alert, animated: true, completion: nil)
//    }
}
