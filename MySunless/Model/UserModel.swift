//
//  UserModel.swift
//  MySunless
//
//  Created by iMac on 22/10/21.
//

import UIKit

class UserManager: NSObject {
    static var shared = UserModel()
    
    class func saveUserData() {
        print(UserManager.shared)
        
      // let data = NSKeyedArchiver.archivedData(withRootObject: UserManager.shared)
        let data = try? NSKeyedArchiver.archivedData(withRootObject: UserManager.shared, requiringSecureCoding: true)
        UserDefaults.standard.set(data, forKey: "UserModel")
        UserDefaults.standard.synchronize()
    }
    
    class func getUserData() {
        if let data = UserDefaults.standard.object(forKey: "UserModel") as? Data {
          //  let model = NSKeyedUnarchiver.unarchiveObject(with: data)
            let model = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            UserManager.shared = model as! UserModel
        }
    }
    
    class func removeModel() {
        UserDefaults.standard.removeObject(forKey: "UserModel")
        UserDefaults.standard.synchronize()
    }
}
class UserModel: NSObject, NSCoding {
    
    var email = String()
    var firstname = String()
    var lastname = String()
    var username = String()
    var token = String()
    var userid = String()
    var user_phone_number = String()
    var user_primary_address = String()
    var user_state = String()
    var user_city = String()
    var user_zipcode = String()
    
    override init() {
        
    }
    
    func initModel(attributeDict:NSDictionary) {
        print(attributeDict)
        if let val = attributeDict.value(forKey: "email") as? String {
            self.email = val
        }
        if let val = attributeDict.value(forKey: "first_name") as? String {
            self.firstname = val
        }
        if let val = attributeDict.value(forKey: "last_name") as? String {
            self.lastname = val
        }
        if let val = attributeDict.value(forKey: "username") as? String {
            self.username = val
        }
        if let val = attributeDict.value(forKey: "token") as? String {
            self.token = val
        }
        if let val = attributeDict.value(forKey: "id") as? NSNumber {
            self.userid = val.stringValue
        }
        if let val = attributeDict.value(forKey: "user_phone_number") as? String {
            self.user_phone_number = val
        }
        if let val = attributeDict.value(forKey: "user_primary_address") as? String {
            self.user_primary_address = val
        }
        if let val = attributeDict.value(forKey: "user_state") as? String {
            self.user_state = val
        }
        if let val = attributeDict.value(forKey: "user_city") as? String {
            self.user_city = val
        }
        if let val = attributeDict.value(forKey: "user_zipcode") as? NSNumber {
            self.user_zipcode = val.stringValue
        }
    }
    
    init(email : String,firstname : String,lastname : String,username : String,token : String,userid : String,user_phone_number : String, user_primary_address:String, user_state:String,user_city:String,user_zipcode:String) {
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.token = token
        self.userid = userid
        self.user_phone_number = user_phone_number
        self.user_primary_address = user_primary_address
        self.user_state = user_state
        self.user_city = user_city
        self.user_zipcode = user_zipcode
    }
    
    required convenience init?(coder decoder: NSCoder) {
        
        var Email = String()
        var Firstname = String()
        var Lastname = String()
        var Username = String()
        var Token = String()
        var Userid = String()
        var User_phone_number = String()
        var User_primary_address = String()
        var User_state = String()
        var User_city = String()
        var User_zipcode = String()
        
        if let email = decoder.decodeObject(forKey: "email") as? String
        {
            Email = email
        }
        if let firstname = decoder.decodeObject(forKey: "first_name") as? String
        {
            Firstname = firstname
        }
        if let lastname = decoder.decodeObject(forKey: "last_name") as? String
        {
            Lastname = lastname
        }
        if let username = decoder.decodeObject(forKey: "username") as? String
        {
            Username = username
        }
        if let token = decoder.decodeObject(forKey: "token") as? String
        {
            Token = token
        }
        if let userid = decoder.decodeObject(forKey: "id") as? String
        {
            Userid = userid
        }
        if let user_phone_number = decoder.decodeObject(forKey: "user_phone_number") as? String
        {
            User_phone_number = user_phone_number
        }
        if let user_primary_address = decoder.decodeObject(forKey: "user_primary_address") as? String
        {
            User_primary_address = user_primary_address
        }
        if let user_state = decoder.decodeObject(forKey: "user_state") as? String
        {
            User_state = user_state
        }
        if let user_city = decoder.decodeObject(forKey: "user_city") as? String
        {
            User_city = user_city
        }
        if let user_zipcode = decoder.decodeObject(forKey: "user_zipcode") as? String
        {
            User_zipcode = user_zipcode
        }
        
        self.init(
            email: Email,
            firstname: Firstname,
            lastname: Lastname,
            username: Username,
            token: Token,
            userid: Userid,
            user_phone_number: User_phone_number,
            user_primary_address: User_primary_address,
            user_state: User_state,
            user_city: User_city,
            user_zipcode: User_zipcode
        )
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.firstname, forKey: "first_name")
        aCoder.encode(self.lastname, forKey: "last_name")
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.userid, forKey: "id")
        aCoder.encode(self.user_phone_number, forKey: "user_phone_number")
        aCoder.encode(self.user_primary_address, forKey: "user_primary_address")
        aCoder.encode(self.user_state, forKey: "user_state")
        aCoder.encode(self.user_city, forKey: "user_city")
        aCoder.encode(self.user_zipcode, forKey: "user_zipcode")
    }
}
