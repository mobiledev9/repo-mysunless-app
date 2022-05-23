//
//  Model.swift
//  MySunless
//
//  Created by iMac on 06/10/21.
//

import Foundation
import UIKit

struct SideMenuModel {
    var icon: UIImage
    var title: String
}

class personalInfoModel: NSObject {
    
    var firstname = String()
    var lastname = String()
    var username = String()
    var user_phone_number = String()
    var user_primary_address = String()
    var user_state = String()
    var user_city = String()
    var user_zipcode = String()
    var userimage = String()
    
    override init() {
        
    }
    
    init(dict:NSDictionary) {
        if let firstname = dict.value(forKey: "firstname") as? String {
            self.firstname = firstname
        }
        if let lastname = dict.value(forKey: "lastname") as? String {
            self.lastname = lastname
        }
        if let username = dict.value(forKey: "username") as? String {
            self.username = username
        }
        if let user_phone_number = dict.value(forKey: "user_phone_number") as? String {
            self.user_phone_number = user_phone_number
        }
        if let user_primary_address = dict.value(forKey: "user_primary_address") as? String {
            self.user_primary_address = user_primary_address
        }
        if let user_state = dict.value(forKey: "user_state") as? String {
            self.user_state = user_state
        }
        if let user_city = dict.value(forKey: "user_city") as? String {
            self.user_city = user_city
        }
        if let user_zipcode = dict.value(forKey: "user_zipcode") as? String {
            self.user_zipcode = user_zipcode
        }
        if let userimage = dict.value(forKey: "userimage") as? String {
            self.userimage = userimage
        }
    }
}

//class showPackage: NSObject {
//
//    var packageName = String()
//    var price = String()
//    var validityDay = String()
//
//    override init() {
//
//    }
//
//    init(dict:NSDictionary)
//    {
//        if let packageName = dict.value(forKey: "PackageName") as? String
//        {
//            self.packageName = packageName
//        }
//        if let price = dict.value(forKey: "Price") as? String
//        {
//            self.price = price
//        }
//        if let validityDay = dict.value(forKey: "ValidityDay") as? String
//        {
//            self.validityDay = validityDay
//        }
//    }
//}

/*class ShowPackage: NSObject, NSCoding {
    var id = Int()
    var packageName = String()
    var price = Double()
    var validityDay = Int()
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.packageName = dict["PackageName"] as? String ?? ""
        self.price = dict["Price"] as? Double ?? 0.0
        self.validityDay = dict["ValidityDay"] as? Int ?? 0
    }
    
    override init() {
        
    }
    
    func initModel(attributeDict:NSDictionary) {
        print(attributeDict)
        if let val = attributeDict.value(forKey: "id") as? Int {
            self.id = val
        }
        if let val = attributeDict.value(forKey: "PackageName") as? String {
            self.packageName = val
        }
        if let val = attributeDict.value(forKey: "Price") as? Double {
            self.price = val
        }
        if let val = attributeDict.value(forKey: "ValidityDay") as? Int {
            self.validityDay = val
        }
    }
    
    init(id : Int,packageName : String,price : Double,validityDay: Int) {
        self.id = id
        self.packageName = packageName
        self.price = price
        self.validityDay = validityDay
    }

    required convenience init?(coder decoder: NSCoder) {
        var Id = Int()
        var PackageName = String()
        var Price = Double()
        var ValidityDay = Int()
        
        if let id = decoder.decodeObject(forKey: "id") as? Int {
            Id = id
        }
        if let packageName = decoder.decodeObject(forKey: "PackageName") as? String {
            PackageName = packageName
        }
        if let price = decoder.decodeObject(forKey: "Price") as? Double {
            Price = price
        }
        if let validityDay = decoder.decodeObject(forKey: "ValidityDay") as? Int {
            ValidityDay = validityDay
        }
        
        self.init(id: Id,packageName: PackageName,price: Price,validityDay: ValidityDay)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.packageName, forKey: "PackageName")
        aCoder.encode(self.price, forKey: "Price")
        aCoder.encode(self.validityDay, forKey: "ValidityDay")
    }
}       */

//struct ShowPackageData: Decodable {
//    let id: Int
//    let PackageName: String
//    let Price: Int
//    let ValidityDay: Int
//}
//
//struct ShowPackage {
//    let id: Int
//    let PackageName: String
//    let Price: Int
//    let ValidityDay: Int
//
//    init(id: Int, PackageName: String, Price: Int, ValidityDay: Int) {
//        self.id = id
//        self.PackageName = PackageName
//        self.Price = Price
//        self.ValidityDay = ValidityDay
//    }
//}

struct ChoosePackage {
    let id: Int
    let PackageName: String
    let Price: Int
    let employeeLimit: String
    let ClientsLimit: String
    let ValidityDay: Int
    let packagedesc: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let default_package: Int
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.PackageName = dict["PackageName"] as? String ?? ""
        self.Price = dict["Price"] as? Int ?? 0
        self.employeeLimit = dict["employeeLimit"] as? String ?? ""
        self.ClientsLimit = dict["ClientsLimit"] as? String ?? ""
        self.ValidityDay = dict["ValidityDay"] as? Int ?? 0
        self.packagedesc = dict["packagedesc"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.default_package = dict["default_package"] as? Int ?? 0
    }
}

struct SubscriptionList {
    let invoiceID: Int
    let packageType: String
    let amount: Int
    let paytime: String
    let packend: String
    let paymentType: String
    let status: String
    var collapsed: Bool
    
    init(dict: [String:Any]) {
        self.invoiceID = dict["InvoiceID"] as? Int ?? 0
        self.packageType = dict["PackageType"] as? String ?? ""
        self.amount = dict["amount"] as? Int ?? 0
        self.paytime = dict["paytime"] as? String ?? ""
        self.packend = dict["packend"] as? String ?? ""
        self.paymentType = dict["PaymentType"] as? String ?? ""
        self.status = dict["status"] as? String ?? ""
        self.collapsed = false
    }
}

struct ClientList {
    let id: Int
    let sid: Int
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
    let ClientImg: String
    let ProfileImg: String
    let solution: String
    let privateNotes: String
    let address: String
    let zip: String
    let city: String
    let state: String
    let country: String
    let dateCreated: String
    let dateLastUpdated: String
    let createdfk: String
    let updatedfk: String
    let isActive: Int
    let document: String
    let fileName: String
    let tags: String
    let giftCardBal: String
    let selectPackage: String
    let employeeSold: String
    let package_sd: String
    let package_ed: String
    let campaignsid: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.sid = dict["sid"] as? Int ?? 0
        self.firstName = dict["FirstName"] as? String ?? ""
        self.lastName = dict["LastName"] as? String ?? ""
        self.phone = dict["Phone"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.ClientImg = dict["ClientImg"] as? String ?? ""
        self.ProfileImg = dict["ProfileImg"] as? String ?? ""
        self.solution = dict["Solution"] as? String ?? ""
        self.privateNotes = dict["PrivateNotes"] as? String ?? ""
        self.address = dict["Address"] as? String ?? ""
        self.zip = dict["Zip"] as? String ?? ""
        self.city = dict["City"] as? String ?? ""
        self.state = dict["State"] as? String ?? ""
        self.country = dict["Country"] as? String ?? ""
        self.dateCreated = dict["datecreated"] as? String ?? ""
        self.dateLastUpdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? String ?? ""
        self.updatedfk = dict["updatedfk"] as? String ?? ""
        self.isActive = dict["isactive"] as? Int ?? 0
        self.document = dict["document"] as? String ?? ""
        self.fileName = dict["fileName"] as? String ?? ""
        self.tags = dict["Tags"] as? String ?? ""
        self.giftCardBal = dict["giftcardbal"] as? String ?? ""
        self.selectPackage = dict["SelectPackage"] as? String ?? ""
        self.employeeSold = dict["employeeSold"] as? String ?? ""
        self.package_sd = dict["package_sd"] as? String ?? ""
        self.package_ed = dict["package_ed"] as? String ?? ""
        self.campaignsid = dict["Campaignsid"] as? String ?? ""
    }
}

struct EmployeeList {
    let id: Int
    let adminId: Int
    let sid: Int
    let userName: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let companyName: String
    let companyType: String
    let companyWebsite: String
    let primaryAddress: String
    let secondaryAddress: String
    let zipCode: String
    let city: String
    let state: String
    let country: String
    let userType: String
    let user_image: String
    let compImg: String
    let status: String
    let createdAt: String
    let updatedAt: String
    let emailStatus: String
    let emailSendTime: String
    let loginStatus: String
    let notificationStatus: String
    let userCreate: String
    let employeeCreate: String
    let clientCreate: String
    let schedulesCreate: String
    let toDoCreate: String
    let servicesCreate: String
    let orderCreate: String
    let usersLimit: String
    let clientsLimit: String
    let employeeLimit: String
    let whatsApp: String
    let salesGoal: Int
    let clientGoal: Int
    let autoPayment: Int
    let paymentStatus: Int
    let commentStatus: String
    let currentStatus: String
    let maintenance: String
    let gmailValue: String
    let gmailDisplayName: String
    let gmailUrl: String
    let loginPermission: String
    let points: Int
    let signImage: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.adminId = dict["adminid"] as? Int ?? 0
        self.sid = dict["sid"] as? Int ?? 0
        self.userName = dict["username"] as? String ?? ""
        self.firstName = dict["firstname"] as? String ?? ""
        self.lastName = dict["lastname"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.phoneNumber = dict["phonenumber"] as? String ?? ""
        self.companyName = dict["companyname"] as? String ?? ""
        self.companyType = dict["companytype"] as? String ?? ""
        self.companyWebsite = dict["companywebsite"] as? String ?? ""
        self.primaryAddress = dict["primaryaddress"] as? String ?? ""
        self.secondaryAddress = dict["secondaryaddress"] as? String ?? ""
        self.zipCode = dict["zipcode"] as? String ?? ""
        self.city = dict["city"] as? String ?? ""
        self.state = dict["state"] as? String ?? ""
        self.country = dict["country"] as? String ?? ""
        self.userType = dict["usertype"] as? String ?? ""
        self.user_image = dict["user_image"] as? String ?? ""
        self.compImg = dict["compimg"] as? String ?? ""
        self.status = dict["status"] as? String ?? ""
        self.createdAt = dict["created_at"] as? String ?? ""
        self.updatedAt = dict["updated_at"] as? String ?? ""
        self.emailStatus = dict["emailstatus"] as? String ?? ""
        self.emailSendTime = dict["emaisendtime"] as? String ?? ""
        self.loginStatus = dict["loginstatus"] as? String ?? ""
        self.notificationStatus = dict["NotificationStatus"] as? String ?? ""
        self.userCreate = dict["UserCreate"] as? String ?? ""
        self.employeeCreate = dict["EmployeeCreate"] as? String ?? ""
        self.clientCreate = dict["ClientCreate"] as? String ?? ""
        self.schedulesCreate = dict["SchedulesCreate"] as? String ?? ""
        self.toDoCreate = dict["TodoCreate"] as? String ?? ""
        self.servicesCreate = dict["ServicesCreate"] as? String ?? ""
        self.orderCreate = dict["OrderCreate"] as? String ?? ""
        self.usersLimit = dict["UsersLimit"] as? String ?? ""
        self.clientsLimit = dict["ClientsLimit"] as? String ?? ""
        self.employeeLimit = dict["employeeLimit"] as? String ?? ""
        self.whatsApp = dict["whatsapp"] as? String ?? ""
        self.salesGoal = dict["salesgoal"] as? Int ?? 0
        self.clientGoal = dict["clientgoal"] as? Int ?? 0
        self.autoPayment = dict["autopayment"] as? Int ?? 0
        self.paymentStatus = dict["paymentstatus"] as? Int ?? 0
        self.commentStatus = dict["comment_status"] as? String ?? ""
        self.currentStatus = dict["CurrentStatus"] as? String ?? ""
        self.maintenance = dict["Maintenance"] as? String ?? ""
        self.gmailValue = dict["Gmail_value"] as? String ?? ""
        self.gmailDisplayName = dict["Gmail_displayName"] as? String ?? ""
        self.gmailUrl = dict["Gmail_url"] as? String ?? ""
        self.loginPermission = dict["login_permission"] as? String ?? ""
        self.points = dict["points"] as? Int ?? 0
        self.signImage = dict["sign_image"] as? String ?? ""
    }
}

/*struct ShowCompany {
    let id: Int
    let companyName: String
    let phone: String
    let email: String
    let compImg: String
    let address: String
    let zip: String
    let city: String
    let state: String
    let country: String
    let dateCreated: String
    let dateLastUpdated: String
    let createdfk: Int
    let updatedfk: Int
    let isActive: String
    let cTheme: String
    let customWidget: String
    let toDoList: String
    let compImg2: String
    let salesTax: String
    let bookingEndpoint: String
    let customerInstruction: String
    let qrImage: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.companyName = dict["CompanyName"] as? String ?? ""
        self.phone = dict["Phone"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.compImg = dict["compimg"] as? String ?? ""
        self.address = dict["Address"] as? String ?? ""
        self.zip = dict["Zip"] as? String ?? ""
        self.city = dict["City"] as? String ?? ""
        self.state = dict["State"] as? String ?? ""
        self.country = dict["Country"] as? String ?? ""
        self.dateCreated = dict["datecreated"] as? String ?? ""
        self.dateLastUpdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isActive = dict["isactive"] as? String ?? ""
        self.cTheme = dict["ctheme"] as? String ?? ""
        self.customWidget = dict["customwidget"] as? String ?? ""
        self.toDoList = dict["todolist"] as? String ?? ""
        self.compImg2 = dict["compimg2"] as? String ?? ""
        self.salesTax = dict["sales_tax"] as? String ?? ""
        self.bookingEndpoint = dict["booking_endpoint"] as? String ?? ""
        self.customerInstruction = dict["customer_instruction"] as? String ?? ""
        self.qrImage = dict["qr_image"] as? String ?? ""
    }
}      */

struct ShowTemplate {
    let id: Int
    let Name: String
    let Subject: String
    let TextMassage: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.Name = dict["Name"] as? String ?? ""
        self.Subject = dict["Subject"] as? String ?? ""
        self.TextMassage = dict["TextMassage"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
    }
}

struct ShowPackageList {
    let id: Int
    let name: String
    let price: String
    let tracking: String
    let description: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let commissionAmount: Int
    let service: String
    let noofvisit: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.name = dict["Name"] as? String ?? ""
        self.price = dict["Price"] as? String ?? ""
        self.tracking = dict["Tracking"] as? String ?? ""
        self.description = dict["Description"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.commissionAmount = dict["CommissionAmount"] as? Int ?? 0
        self.service = dict["service"] as? String ?? ""
        self.noofvisit = dict["Noofvisit"] as? String ?? ""
        
    }
}

struct ActiveMember {
    let id: Int
    let orderID: Int
    let invoiceNumber: String
    let cid: Int
    let createdfk: Int
    let eid: Int
    let membershipID: Int
    let membershipDiscount :String
    let membershipPrice :String
    let memberDiscoutInParentage :String
    let membershipFianlPrice :String
    let orderTime : String
    let noofvisit : String
    let packageAutonew : String
    let packageRenwal : String
    let pckageCarryford: String
    let packageExpireDate: String
    let packageStartDate: String
    let active: String
    let username :String
    let name :String
    let firstName:String
    let profileImg: String
    let lastName: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.orderID = dict["OrderId"] as? Int ?? 0
        self.invoiceNumber = dict["InvoiceNumber"] as? String ?? ""
        self.cid = dict["Cid"] as? Int ?? 0
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.eid = dict["eid"] as? Int ?? 0
        self.membershipID = dict["MembershipID"] as? Int ?? 0
        self.membershipDiscount = dict["MembershipDiscount"] as? String ?? ""
        self.membershipPrice = dict["MembershipPrice"] as? String ?? ""
        self.memberDiscoutInParentage = dict["MemberDiscoutInParentage"] as? String ?? ""
        self.membershipFianlPrice = dict["MembershipFianlPrice"] as? String ?? ""
        self.orderTime = dict["OrderTime"] as? String ?? ""
        self.noofvisit = dict["Noofvisit"] as? String ?? ""
        self.packageAutonew = dict["Package_Autonew"] as? String ?? ""
        self.packageRenwal = dict["Package_renwal"] as? String ?? ""
        self.pckageCarryford = dict["Pckage_carryford"] as? String ?? ""
        self.packageExpireDate = dict["package_expire_date"] as? String ?? ""
        self.packageStartDate = dict["package_start_date"] as? String ?? ""
        self.active = dict["Active"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.name = dict["Name"] as? String ?? ""
        self.firstName = dict["FirstName"] as? String ?? ""
        self.profileImg = dict["ProfileImg"] as? String ?? ""
        self.lastName = dict["lastName"] as? String ?? ""
      
    }
}

struct SelectServiceData {
    let id: Int
    let serviceName:String
    let price: String
    let duration: String
    let category: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let users: String
    let type: String
    let info: String
    let starttime: String
    let endtime: String
    let cusmerlimt: String
    let asper: String
    let commissionAmount: Int
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.serviceName = dict["ServiceName"] as? String ?? ""
        self.price = dict["Price"] as? String ?? ""
        self.duration = dict["Duration"] as? String ?? ""
        self.category = dict["Category"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.users = dict["Users"] as? String ?? ""
        self.type = dict["Type"] as? String ?? ""
        self.info = dict["Info"] as? String ?? ""
        self.starttime = dict[ "starttime"] as? String ?? ""
        self.endtime = dict["endtime"] as? String ?? ""
        self.cusmerlimt = dict["cusmerlimt"] as? String ?? ""
        self.asper = dict["asper"] as? String ?? ""
        self.commissionAmount = dict["CommissionAmount"] as? Int ?? 0
    }
    
}

struct SelectServiceAppointment {
    let id: Int
    let serviceName:String
    let price: String
    let duration: String
    let category: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let users: String
    let type: String
    let info: String
    let starttime: String
    let endtime: String
    let cusmerlimt: String
    let asper: String
    let commissionAmount: Int
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.serviceName = dict["ServiceName"] as? String ?? ""
        self.price = dict["Price"] as? String ?? ""
        self.duration = dict["Duration"] as? String ?? ""
        self.category = dict["Category"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.users = dict["Users"] as? String ?? ""
        self.type = dict["Type"] as? String ?? ""
        self.info = dict["Info"] as? String ?? ""
        self.starttime = dict[ "starttime"] as? String ?? ""
        self.endtime = dict["endtime"] as? String ?? ""
        self.cusmerlimt = dict["cusmerlimt"] as? String ?? ""
        self.asper = dict["asper"] as? String ?? ""
        self.commissionAmount = dict["CommissionAmount"] as? Int ?? 0
    }
    
}

struct ChooseCustomer {
    let id: Int
    let sid: Int
    let FirstName: String
    let LastName: String
    let Phone: String
    let email: String
    let ClientImg: String
    let ProfileImg: String
    let Solution: String
    let PrivateNotes: String
    let Address: String
    let Zip: String
    let City: String
    let State: String
    let Country: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let document: String
    let fileName: String
    let Tags: String
    let giftcardbal: String
    let SelectPackage: String
    let employeeSold: String
    let package_sd: String
    let package_ed: String
    let Campaignsid: Int
    let client_image: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.sid = dict["sid"] as? Int ?? 0
        self.FirstName = dict["FirstName"] as? String ?? ""
        self.LastName = dict["LastName"] as? String ?? ""
        self.ClientImg = dict["ClientImg"] as? String ?? ""
        self.ProfileImg = dict["ProfileImg"] as? String ?? ""
        self.Phone = dict["Phone"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.Solution = dict["Solution"] as? String ?? ""
        self.PrivateNotes = dict["PrivateNotes"] as? String ?? ""
        self.Address = dict["Address"] as? String ?? ""
        self.Zip = dict["Zip"] as? String ?? ""
        self.City = dict["City"] as? String ?? ""
        self.State = dict["State"] as? String ?? ""
        self.Country = dict["Country"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.document = dict["document"] as? String ?? ""
        self.fileName = dict["fileName"] as? String ?? ""
        self.Tags = dict["Tags"] as? String ?? ""
        self.giftcardbal = dict["giftcardbal"] as? String ?? ""
        self.SelectPackage = dict["SelectPackage"] as? String ?? ""
        self.employeeSold = dict["employeeSold"] as? String ?? ""
        self.package_sd = dict["package_sd"] as? String ?? ""
        self.package_ed = dict["package_ed"] as? String ?? ""
        self.Campaignsid = dict["Campaignsid"] as? Int ?? 0
        self.client_image = dict["client_image"] as? String ?? ""
    }
}

struct EventList {
    let id: Int
    let FirstName: String
    let LastName: String
    let Phone: String
    let Email: String
    let EventDate: String
    let eventstatus: String
    let Address: String
    let Zip: String
    let City: String
    let State: String
    let country: String
    let CostOfService: String
    let EmailInstruction: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let title: String
    let start_date: String
    let end_date: String
    let description: String
    let Appcanmsgfcus: String
    let UserID: Int
    let ServiceName: Int
    let ServiceProvider: Int
    let cid: Int
    let Location_radio: String
    let Accepted: String
    let sync: Int
    let client_phone: String
    let phonenumber: String
    let username: String
    let userimg: String
    let User_firstname: String
    let User_lastname: String
    let ProfileImg: String
    let client_firstname: String
    let client_Lastname: String
    let client_email: String
    let clientid: Int
    let OrderID: Int
    let InvoiceNumber: Int
    let timediff: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.FirstName = dict["FirstName"] as? String ?? ""
        self.LastName = dict["LastName"] as? String ?? ""
        self.Phone = dict["Phone"] as? String ?? ""
        self.Email = dict["Email"] as? String ?? ""
        self.EventDate = dict["EventDate"] as? String ?? ""
        self.eventstatus = dict["eventstatus"] as? String ?? ""
        self.Address = dict["Address"] as? String ?? ""
        self.Zip = dict["Zip"] as? String ?? ""
        self.City = dict["City"] as? String ?? ""
        self.State = dict["State"] as? String ?? ""
        self.country = dict["country"] as? String ?? ""
        self.CostOfService = dict["CostOfService"] as? String ?? ""
        self.EmailInstruction = dict["EmailInstruction"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.title = dict["title"] as? String ?? ""
        self.start_date = dict["start_date"] as? String ?? ""
        self.end_date = dict["end_date"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
        self.Appcanmsgfcus = dict["Appcanmsgfcus"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.ServiceName = dict["ServiceName"] as? Int ?? 0
        self.ServiceProvider = dict["ServiceProvider"] as? Int ?? 0
        self.cid = dict["cid"] as? Int ?? 0
        self.Location_radio = dict["Location_radio"] as? String ?? ""
        self.Accepted = dict["Accepted"] as? String ?? ""
        self.sync = dict["sync"] as? Int ?? 0
        self.client_phone = dict["client_phone"] as? String ?? ""
        self.phonenumber = dict["phonenumber"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
        self.User_firstname = dict["User_firstname"] as? String ?? ""
        self.User_lastname = dict["User_lastname"] as? String ?? ""
        self.ProfileImg = dict["ProfileImg"] as? String ?? ""
        self.client_firstname = dict["client_firstname"] as? String ?? ""
        self.client_Lastname = dict["client_Lastname"] as? String ?? ""
        self.client_email = dict["client_email"] as? String ?? ""
        self.clientid = dict["clientid"] as? Int ?? 0
        self.OrderID = dict["OrderID"] as? Int ?? 0
        self.InvoiceNumber = dict["InvoiceNumber"] as? Int ?? 0
        self.timediff = dict["timediff"] as? String ?? ""
    }
}

struct NoteDetail {
    let id: Int
    let noteTitle: String
    let noteDetail: String
    let datelastupdated: String
    let noteCreaterName: String
    let userimg: String
    let timediff: String
    
    init(dict: [String:Any]) {
        self.id = dict["noteId"] as? Int ?? 0
        self.noteTitle = dict["noteTitle"] as? String ?? ""
        self.noteDetail = dict["noteDetail"] as? String ?? ""
        self.datelastupdated = dict["datecreated"] as? String ?? ""
        self.noteCreaterName = dict["noteCreaterName"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
        self.timediff = dict["timediff"] as? String ?? ""
    }
}

struct ShowCompletedOrder {
    let ino: String
    let UserID: Int
    let firstname: String
    let lastname: String
    let username: String
    let userimg: String
    let PaymentType: String
    let PaymentDetail: String
    let PaymentAmount: String
    let Orderdate: String
    let orderid: Int
    let FirstName: String
    let LastName: String
    let email: String
    let Phone: String
    let clientID: Int
    let ProfileImg: String
    let id: Int
    let InvoiceNumber: String
    let pservicename: String
    let pservicepackage: String
    let pvisit: String
  //  let ServiceName: String
    let ServiceName: [[String:Any]]
    let ServicProvider: String
    let ServiceStartTime: String
    let ServicePrice: String
    let ServiceDiscount: String
    let ServiceDiscoutInParentage: String
    let ServiceFianlPrice: String
  //  let ProdcutName: String
    let ProdcutName: [[String:Any]]
    let ProdcutQuality: String
    let ProductPrice: String
    let ProductCostPrice: String
    let ProductDiscount: String
    let ProductDiscountInParentage: String
    let ProductTaxPrice: String
    let ProductFianlPrice: String
  //  let MembershipName: String
    let MembershipName: [[String:Any]]
    let MembershipPrice: String
    let MembershipDiscount: String
    let MemberDiscoutInParentage: String
    let MembershipFianlPrice: String
    let TotalOrderAmount: String
    let TotalseriveAmount: String
    let TotalProductAmount: String
    let TotalMembershipAmount: String
    let GetTotalPoint: Int
    let UsePoint: Int
    let Remainepoints: Int
    let cid: Int
    let eid: Int
    let datecreated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let datelastupdated: String
    let payment_status: String
    let sales_tax: String
    let tips: String
    let giftapp: String
    let PackageName: String
    let PckageAmount: String
    let Noofvisit: String
    let Package_Autonew: String
    let Package_renwal: String
    let Pckage_carryford: String
    let package_expire_date: String
    let gServiceName: String
    let gServicePrice: String
    let gServiceDiscount: String
    let gServiceDiscoutInParentage: String
    let gServiceFianlPrice: String
    let TotalgiftAmount: String
    let gstatus: Int
    let Package_Price: String
    let PackageDiscount: String
    let PacakageDiscounPersentage: String
    let PackageFinalPrice: String
    
    init(dict: [String:Any]) {
        self.ino = dict["ino"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.firstname = dict["firstname"] as? String ?? ""
        self.lastname = dict["lastname"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
        self.PaymentType = dict["PaymentType"] as? String ?? ""
        self.PaymentDetail = dict["PaymentDetail"] as? String ?? ""
        self.PaymentAmount = dict["PaymentAmount"] as? String ?? ""
        self.Orderdate = dict["Orderdate"] as? String ?? ""
        self.orderid = dict["orderid"] as? Int ?? 0
        self.FirstName = dict["FirstName"] as? String ?? ""
        self.LastName = dict["LastName"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.Phone = dict["Phone"] as? String ?? ""
        self.clientID = dict["clientID"] as? Int ?? 0
        self.ProfileImg = dict["ProfileImg"] as? String ?? ""
        self.id = dict["id"] as? Int ?? 0
        self.InvoiceNumber = dict["InvoiceNumber"] as? String ?? ""
        self.pservicename = dict["pservicename"] as? String ?? ""
        self.pservicepackage = dict["pservicepackage"] as? String ?? ""
        self.pvisit = dict["pvisit"] as? String ?? ""
//        self.ServiceName = dict["ServiceName"] as? String ?? ""
        self.ServiceName = dict["ServiceName"] as? [[String:Any]] ?? []
        self.ServicProvider = dict["ServicProvider"] as? String ?? ""
        self.ServiceStartTime = dict["ServiceStartTime"] as? String ?? ""
        self.ServicePrice = dict["ServicePrice"] as? String ?? ""
        self.ServiceDiscount = dict["ServiceDiscount"] as? String ?? ""
        self.ServiceDiscoutInParentage = dict["ServiceDiscoutInParentage"] as? String ?? ""
        self.ServiceFianlPrice = dict["ServiceFianlPrice"] as? String ?? ""
//        self.ProdcutName = dict["ProdcutName"] as? String ?? ""
        self.ProdcutName = dict["ProdcutName"] as? [[String:Any]] ?? []
        self.ProdcutQuality = dict["ProdcutQuality"] as? String ?? ""
        self.ProductPrice = dict["ProductPrice"] as? String ?? ""
        self.ProductCostPrice = dict["ProductCostPrice"] as? String ?? ""
        self.ProductDiscount = dict["ProductDiscount"] as? String ?? ""
        self.ProductDiscountInParentage = dict["ProductDiscountInParentage"] as? String ?? ""
        self.ProductTaxPrice = dict["ProductTaxPrice"] as? String ?? ""
        self.ProductFianlPrice = dict["ProductFianlPrice"] as? String ?? ""
//        self.MembershipName = dict["MembershipName"] as? String ?? ""
        self.MembershipName = dict["MembershipName"] as? [[String:Any]] ?? []
        self.MembershipPrice = dict["MembershipPrice"] as? String ?? ""
        self.MembershipDiscount = dict["MembershipDiscount"] as? String ?? ""
        self.MemberDiscoutInParentage = dict["MemberDiscoutInParentage"] as? String ?? ""
        self.MembershipFianlPrice = dict["MembershipFianlPrice"] as? String ?? ""
        self.TotalOrderAmount = dict["TotalOrderAmount"] as? String ?? ""
        self.TotalseriveAmount = dict["TotalseriveAmount"] as? String ?? ""
        self.TotalProductAmount = dict["TotalProductAmount"] as? String ?? ""
        self.TotalMembershipAmount = dict["TotalMembershipAmount"] as? String ?? ""
        self.GetTotalPoint = dict["GetTotalPoint"] as? Int ?? 0
        self.UsePoint = dict["UsePoint"] as? Int ?? 0
        self.Remainepoints = dict["Remainepoints"] as? Int ?? 0
        self.cid = dict["cid"] as? Int ?? 0
        self.eid = dict["eid"] as? Int ?? 0
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.payment_status = dict["payment_status"] as? String ?? ""
        self.sales_tax = dict["sales_tax"] as? String ?? ""
        self.tips = dict["tips"] as? String ?? ""
        self.giftapp = dict["giftapp"] as? String ?? ""
        self.PackageName = dict["PackageName"] as? String ?? ""
        self.PckageAmount = dict["PckageAmount"] as? String ?? ""
        self.Noofvisit = dict["Noofvisit"] as? String ?? ""
        self.Package_Autonew = dict["Package_Autonew"] as? String ?? ""
        self.Package_renwal = dict["Package_renwal"] as? String ?? ""
        self.Pckage_carryford = dict["Pckage_carryford"] as? String ?? ""
        self.package_expire_date = dict["package_expire_date"] as? String ?? ""
        self.gServiceName = dict["gServiceName"] as? String ?? ""
        self.gServicePrice = dict["gServicePrice"] as? String ?? ""
        self.gServiceDiscount = dict["gServiceDiscount"] as? String ?? ""
        self.gServiceDiscoutInParentage = dict["gServiceDiscoutInParentage"] as? String ?? ""
        self.gServiceFianlPrice = dict["gServiceFianlPrice"] as? String ?? ""
        self.TotalgiftAmount = dict["TotalgiftAmount"] as? String ?? ""
        self.gstatus = dict["gstatus"] as? Int ?? 0
        self.Package_Price = dict["Package_Price"] as? String ?? ""
        self.PackageDiscount = dict["PackageDiscount"] as? String ?? ""
        self.PacakageDiscounPersentage = dict["PacakageDiscounPersentage"] as? String ?? ""
        self.PackageFinalPrice = dict["PackageFinalPrice"] as? String ?? ""
    }
}

struct Service {
    let servicename: String
    let ServicProvider: String
    let ServiceStartTime: String
    let ServicePrice: String
    let ServiceDiscount: String
    let ServiceDiscoutInParentage: String
    let ServiceFianlPrice: String
    
    init(dict: [String:Any]) {
        self.servicename = dict["servicename"] as? String ?? ""
        self.ServicProvider = dict["ServicProvider"] as? String ?? ""
        self.ServiceStartTime = dict["ServiceStartTime"] as? String ?? ""
        self.ServicePrice = dict["ServicePrice"] as? String ?? ""
        self.ServiceDiscount = dict["ServiceDiscount"] as? String ?? ""
        self.ServiceDiscoutInParentage = dict["ServiceDiscoutInParentage"] as? String ?? ""
        self.ServiceFianlPrice = dict["ServiceFianlPrice"] as? String ?? ""
    }
}

struct Product {
    let productid: Int
    let productname: String
    let productprice: String
    let productQuantity: String
    let ProductPrice: String
    let ProductDiscount: String
    let ProductDiscountInParentage: String
    let ProductTaxPrice: String
    let ProductFianlPrice: String
    
    init(dict: [String:Any]) {
        self.productid = dict["productid"] as? Int ?? 0
        self.productname = dict["productname"] as? String ?? ""
        self.productprice = dict["productprice"] as? String ?? ""
        self.productQuantity = dict["productQuantity"] as? String ?? ""
        self.ProductPrice = dict["ProductPrice"] as? String ?? ""
        self.ProductDiscount = dict["ProductDiscount"] as? String ?? ""
        self.ProductDiscountInParentage = dict["ProductDiscountInParentage"] as? String ?? ""
        self.ProductTaxPrice = dict["ProductTaxPrice"] as? String ?? ""
        self.ProductFianlPrice = dict["ProductFianlPrice"] as? String ?? ""
    }
}

struct Membership {
    let membershipname: String
    let MembershipPrice: String
    let MembershipDiscount: String
    let MemberDiscoutInParentage: String
    let MembershipFianlPrice: String
    
    init(dict: [String:Any]) {
        self.membershipname = dict["membershipname"] as? String ?? ""
        self.MembershipPrice = dict["MembershipPrice"] as? String ?? ""
        self.MembershipDiscount = dict["MembershipDiscount"] as? String ?? ""
        self.MemberDiscoutInParentage = dict["MemberDiscoutInParentage"] as? String ?? ""
        self.MembershipFianlPrice = dict["MembershipFianlPrice"] as? String ?? ""
    }
}

struct ShowPendingOrder {
    let id: Int
    let InvoiceNumber: String
    let pservicename: String
    let pservicepackage: String
    let pvisit: String
    let ServiceName: String
    let ServicProvider: String
    let ServiceStartTime: String
    let ServicePrice: String
    let ServiceDiscount: String
    let ServiceDiscoutInParentage: String
    let ServiceFianlPrice: String
    let ProdcutName: String
    let ProdcutQuality: String
    let ProductPrice: String
    let ProductCostPrice: String
    let ProductDiscount: String
    let ProductDiscountInParentage: String
    let ProductTaxPrice: String
    let ProductFianlPrice: String
    let MembershipName: String
    let MembershipPrice: String
    let MembershipDiscount: String
    let MemberDiscoutInParentage: String
    let MembershipFianlPrice: String
    let TotalOrderAmount: String
    let TotalseriveAmount: String
    let TotalProductAmount: String
    let TotalMembershipAmount: String
    let GetTotalPoint: Int
    let UsePoint: Int
    let Remainepoints: Int
    let cid: Int
    let eid: Int
    let datecreated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let datelastupdated: String
    let payment_status: String
    let sales_tax: String
    let tips: String
    let giftapp: String
    let PackageName: String
    let PckageAmount: String
    let Noofvisit: String
    let Package_Autonew: String
    let Package_renwal: String
    let Pckage_carryford: String
    let package_expire_date: String
    let gServiceName: String
    let gServicePrice: String
    let gServiceDiscount: String
    let gServiceDiscoutInParentage: String
    let gServiceFianlPrice: String
    let TotalgiftAmount: String
    let gstatus: Int
    let Package_Price: String
    let PackageDiscount: String
    let PacakageDiscounPersentage: String
    let PackageFinalPrice: String
    let ino: String
    let UserID: Int
    let firstname: String
    let lastname: String
    let username: String
    let userimg: String
    let Orderdate: String
    let orderid: Int
    let FirstName: String
    let LastName: String
    let ProfileImg: String
    let PaymentAmount: String
    let PaymentType: String
    let OrderPayment_status: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.InvoiceNumber = dict["InvoiceNumber"] as? String ?? ""
        self.pservicename = dict["pservicename"] as? String ?? ""
        self.pservicepackage = dict["pservicepackage"] as? String ?? ""
        self.pvisit = dict["pvisit"] as? String ?? ""
        self.ServiceName = dict["ServiceName"] as? String ?? ""
        self.ServicProvider = dict["ServicProvider"] as? String ?? ""
        self.ServiceStartTime = dict["ServiceStartTime"] as? String ?? ""
        self.ServicePrice = dict["ServicePrice"] as? String ?? ""
        self.ServiceDiscount = dict["ServiceDiscount"] as? String ?? ""
        self.ServiceDiscoutInParentage = dict["ServiceDiscoutInParentage"] as? String ?? ""
        self.ServiceFianlPrice = dict["ServiceFianlPrice"] as? String ?? ""
        self.ProdcutName = dict["ProdcutName"] as? String ?? ""
        self.ProdcutQuality = dict["ProdcutQuality"] as? String ?? ""
        self.ProductPrice = dict["ProductPrice"] as? String ?? ""
        self.ProductCostPrice = dict["ProductCostPrice"] as? String ?? ""
        self.ProductDiscount = dict["ProductDiscount"] as? String ?? ""
        self.ProductDiscountInParentage = dict["ProductDiscountInParentage"] as? String ?? ""
        self.ProductTaxPrice = dict["ProductTaxPrice"] as? String ?? ""
        self.ProductFianlPrice = dict["ProductFianlPrice"] as? String ?? ""
        self.MembershipName = dict["MembershipName"] as? String ?? ""
        self.MembershipPrice = dict["MembershipPrice"] as? String ?? ""
        self.MembershipDiscount = dict["MembershipDiscount"] as? String ?? ""
        self.MemberDiscoutInParentage = dict["MemberDiscoutInParentage"] as? String ?? ""
        self.MembershipFianlPrice = dict["MembershipFianlPrice"] as? String ?? ""
        self.TotalOrderAmount = dict["TotalOrderAmount"] as? String ?? ""
        self.TotalseriveAmount = dict["TotalseriveAmount"] as? String ?? ""
        self.TotalProductAmount = dict["TotalProductAmount"] as? String ?? ""
        self.TotalMembershipAmount = dict["TotalMembershipAmount"] as? String ?? ""
        self.GetTotalPoint = dict["GetTotalPoint"] as? Int ?? 0
        self.UsePoint = dict["UsePoint"] as? Int ?? 0
        self.Remainepoints = dict["Remainepoints"] as? Int ?? 0
        self.cid = dict["cid"] as? Int ?? 0
        self.eid = dict["eid"] as? Int ?? 0
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.payment_status = dict["payment_status"] as? String ?? ""
        self.sales_tax = dict["sales_tax"] as? String ?? ""
        self.tips = dict["tips"] as? String ?? ""
        self.giftapp = dict["giftapp"] as? String ?? ""
        self.PackageName = dict["PackageName"] as? String ?? ""
        self.PckageAmount = dict["PckageAmount"] as? String ?? ""
        self.Noofvisit = dict["Noofvisit"] as? String ?? ""
        self.Package_Autonew = dict["Package_Autonew"] as? String ?? ""
        self.Package_renwal = dict["Package_renwal"] as? String ?? ""
        self.Pckage_carryford = dict["Pckage_carryford"] as? String ?? ""
        self.package_expire_date = dict["package_expire_date"] as? String ?? ""
        self.gServiceName = dict["gServiceName"] as? String ?? ""
        self.gServicePrice = dict["gServicePrice"] as? String ?? ""
        self.gServiceDiscount = dict["gServiceDiscount"] as? String ?? ""
        self.gServiceDiscoutInParentage = dict["gServiceDiscoutInParentage"] as? String ?? ""
        self.gServiceFianlPrice = dict["gServiceFianlPrice"] as? String ?? ""
        self.TotalgiftAmount = dict["TotalgiftAmount"] as? String ?? ""
        self.gstatus = dict["gstatus"] as? Int ?? 0
        self.Package_Price = dict["Package_Price"] as? String ?? ""
        self.PackageDiscount = dict["PackageDiscount"] as? String ?? ""
        self.PacakageDiscounPersentage = dict["PacakageDiscounPersentage"] as? String ?? ""
        self.PackageFinalPrice = dict["PackageFinalPrice"] as? String ?? ""
        self.ino = dict["ino"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.firstname = dict["firstname"] as? String ?? ""
        self.lastname = dict["lastname"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
        self.Orderdate = dict["Orderdate"] as? String ?? ""
        self.orderid = dict["orderid"] as? Int ?? 0
        self.FirstName = dict["FirstName"] as? String ?? ""
        self.LastName = dict["LastName"] as? String ?? ""
        self.ProfileImg = dict["ProfileImg"] as? String ?? ""
        self.PaymentAmount = dict["PaymentAmount"] as? String ?? ""
        self.PaymentType = dict["PaymentType"] as? String ?? ""
        self.OrderPayment_status = dict["OrderPayment_status"] as? String ?? ""
    }
}

struct ChooseUser {
    let id: Int
    let firstname: String
    let lastname: String
    let UserName: String
    let sign_image: String
    let user_image: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.firstname = dict["firstname"] as? String ?? ""
        self.lastname = dict["lastname"] as? String ?? ""
        self.UserName = dict["UserName"] as? String ?? ""
        self.sign_image = dict["sign_image"] as? String ?? ""
        self.user_image = dict["user_image"] as? String ?? ""
    }
}

struct ChooseCustomerList {
    let FirstName: String
    let LastName: String
    
    init(dict: [String:Any]) {
        self.FirstName = dict["FirstName"] as? String ?? ""
        self.LastName = dict["LastName"] as? String ?? ""
    }
}

struct ClientData {
    let id: Int
    let sid: Int
    let FirstName: String
    let LastName: String
    let Phone: String
    let email: String
    let ClientImg: String
    let ProfileImg: String
    let Solution: String
    let PrivateNotes: String
    let Address: String
    let Zip: String
    let City: String
    let State: String
    let Country: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let document: String
    let fileName: String
    let Tags: String
    let giftcardbal: String
    let SelectPackage: String
    let employeeSold: String
    let package_sd: String
    let package_ed: String
    let Campaignsid: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.sid = dict["sid"] as? Int ?? 0
        self.FirstName = dict["FirstName"] as? String ?? ""
        self.LastName = dict["LastName"] as? String ?? ""
        self.Phone = dict["Phone"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.ClientImg = dict["ClientImg"] as? String ?? ""
        self.ProfileImg = dict["ProfileImg"] as? String ?? ""
        self.Solution = dict["Solution"] as? String ?? ""
        self.PrivateNotes = dict["PrivateNotes"] as? String ?? ""
        self.Address = dict["Address"] as? String ?? ""
        self.Zip = dict["Zip"] as? String ?? ""
        self.City = dict["City"] as? String ?? ""
        self.State = dict["State"] as? String ?? ""
        self.Country = dict["Country"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.document = dict["document"] as? String ?? ""
        self.fileName = dict["fileName"] as? String ?? ""
        self.Tags = dict["Tags"] as? String ?? ""
        self.giftcardbal = dict["giftcardbal"] as? String ?? ""
        self.SelectPackage = dict["SelectPackage"] as? String ?? ""
        self.employeeSold = dict["employeeSold"] as? String ?? ""
        self.package_sd = dict["package_sd"] as? String ?? ""
        self.package_ed = dict["package_ed"] as? String ?? ""
        self.Campaignsid = dict["Campaignsid"] as? String ?? ""
    }
}

struct NotesData {
    let noteTitle: String
    
    init(dict: [String:Any]) {
        self.noteTitle = dict["noteTitle"] as? String ?? ""
    }
}

struct ProviderData {
    let id: Int
    let firstname: String
    let lastname: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.firstname = dict["firstname"] as? String ?? ""
        self.lastname = dict["lastname"] as? String ?? ""
    }
}

struct ShowPerformance {
    let email: Int
    let sms: Int
    let app_book: Int
    let app_confirm: Int
    let order_no: Int
    let username: String
    let userimg: String
    
    init(dict: [String:Any]) {
        self.email = dict["email"] as? Int ?? 0
        self.sms = dict["sms"] as? Int ?? 0
        self.app_book = dict["app_book"] as? Int ?? 0
        self.app_confirm = dict["app_confirm"] as? Int ?? 0
        self.order_no = dict["order_no"] as? Int ?? 0
        self.username = dict["username"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
    }
}

struct ShowLoginLog {
    let id: Int
    let UserId: String
    let LoginTime: String
    let LogoutTime: String
    let TotalHours: String
    let REMOTE_ADDR: String
    let HTTP_USER_AGENT: String
    let UserToken: String
    let Validity: String
    let RunTime: Int
    let username: String
    let userimg: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.UserId = dict["UserId"] as? String ?? ""
        self.LoginTime = dict["LoginTime"] as? String ?? ""
        self.LogoutTime = dict["LogoutTime"] as? String ?? ""
        self.TotalHours = dict["TotalHours"] as? String ?? ""
        self.REMOTE_ADDR = dict["REMOTE_ADDR"] as? String ?? ""
        self.HTTP_USER_AGENT = dict["HTTP_USER_AGENT"] as? String ?? ""
        self.UserToken = dict["UserToken"] as? String ?? ""
        self.Validity = dict["Validity"] as? String ?? ""
        self.RunTime = dict["RunTime"] as? Int ?? 0
        self.username = dict["username"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
    }
}

struct ShowListOfService {
    let id: Int
    let ServiceName: String
    let Price: String
    let Duration: String
    let Category: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let Users: String
    let type: String
    let Info: String
    let starttime: String
    let endtime: String
    let cusmerlimt: String
    let asper: String
    let CommissionAmount: Int
    let userbane: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.ServiceName = dict["ServiceName"] as? String ?? ""
        self.Price = dict["Price"] as? String ?? ""
        self.Duration = dict["Duration"] as? String ?? ""
        self.Category = dict["Category"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.Users = dict["Users"] as? String ?? ""
        self.type = dict["Type"] as? String ?? ""
        self.Info = dict["Info"] as? String ?? ""
        self.starttime = dict["starttime"] as? String ?? ""
        self.endtime = dict["endtime"] as? String ?? ""
        self.cusmerlimt = dict["cusmerlimt"] as? String ?? ""
        self.asper = dict["asper"] as? String ?? ""
        self.CommissionAmount = dict["CommissionAmount"] as? Int ?? 0
        self.userbane = dict["userbane"] as? String ?? ""
    }
}

struct ShowBannerImageList {
    let id: Int
    let user_id: Int
    let banner_img: String
    let created_at: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.user_id = dict["user_id"] as? Int ?? 0
        self.banner_img = dict["banner_img"] as? String ?? ""
        self.created_at = dict["created_at"] as? String ?? ""
    }
}

struct ShowGallaryImageList {
    let id: Int
    let user_id: Int
    let image: String
    let title: String
    let description: String
    let created_at: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.user_id = dict["user_id"] as? Int ?? 0
        self.image = dict["image"] as? String ?? ""
        self.title = dict["title"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
        self.created_at = dict["created_at"] as? String ?? ""
    }
}

struct ShowServiceList {
    let id: Int
    let ServiceName: String
    let Price: String
    let Duration: String
    let Category: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let Users: String
    let type: String
    let Info: String
    let starttime: String
    let endtime: String
    let cusmerlimt: String
    let asper: String
    let CommissionAmount: Int
    let Fullname: String
    let UserID: Int
    let userimg: String
    let userbane: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.ServiceName = dict["ServiceName"] as? String ?? ""
        self.Price = dict["Price"] as? String ?? ""
        self.Duration = dict["Duration"] as? String ?? ""
        self.Category = dict["Category"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.Users = dict["Users"] as? String ?? ""
        self.type = dict["Type"] as? String ?? ""
        self.Info = dict["Info"] as? String ?? ""
        self.starttime = dict["starttime"] as? String ?? ""
        self.endtime = dict["endtime"] as? String ?? ""
        self.cusmerlimt = dict["cusmerlimt"] as? String ?? ""
        self.asper = dict["asper"] as? String ?? ""
        self.CommissionAmount = dict["CommissionAmount"] as? Int ?? 0
        self.Fullname = dict["Fullname"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.userimg = dict["userimg"] as? String ?? ""
        self.userbane = dict["userbane"] as? String ?? ""
    }
}

struct ShowEventList {
    let id: Int
    let FirstName: String
    let LastName: String
    let Phone: String
    let Email: String
    let EventDate: String
    let eventstatus: String
    let Address: String
    let Zip: String
    let City: String
    let State: String
    let country: String
    let CostOfService: String
    let EmailInstruction: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let title: String
    let start_date: String
    let end_date: String
    let description: String
    let Appcanmsgfcus: String
    let UserID: Int
    let ServiceName: Int
    let ServiceProvider: Int
    let cid: Int
    let Location_radio: String
    let Accepted: String
    let sync: Int
    let ProfileImg: String
    let Fullname: String
    let userimg: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.FirstName = dict["FirstName"] as? String ?? ""
        self.LastName = dict["LastName"] as? String ?? ""
        self.Phone = dict["Phone"] as? String ?? ""
        self.Email = dict["Email"] as? String ?? ""
        self.EventDate = dict["EventDate"] as? String ?? ""
        self.eventstatus = dict["eventstatus"] as? String ?? ""
        self.Address = dict["Address"] as? String ?? ""
        self.Zip = dict["Zip"] as? String ?? ""
        self.City = dict["City"] as? String ?? ""
        self.State = dict["State"] as? String ?? ""
        self.country = dict["country"] as? String ?? ""
        self.CostOfService = dict["CostOfService"] as? String ?? ""
        self.EmailInstruction = dict["EmailInstruction"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.title = dict["title"] as? String ?? ""
        self.start_date = dict["start_date"] as? String ?? ""
        self.end_date = dict["end_date"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
        self.Appcanmsgfcus = dict["Appcanmsgfcus"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.ServiceName = dict["ServiceName"] as? Int ?? 0
        self.ServiceProvider = dict["ServiceProvider"] as? Int ?? 0
        self.cid = dict["cid"] as? Int ?? 0
        self.Location_radio = dict["Location_radio"] as? String ?? ""
        self.Accepted = dict["Accepted"] as? String ?? ""
        self.sync = dict["sync"] as? Int ?? 0
        self.ProfileImg = dict["ProfileImg"] as? String ?? ""
        self.Fullname = dict["Fullname"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
    }
    
}

struct ShowClient {
    let id: Int
    let sid: Int
    let FirstName: String
    let LastName: String
    let Phone: String
    let email: String
    let ClientImg: String
    let ProfileImg: String
    let Solution: String
    let PrivateNotes: String
    let Address: String
    let Zip: String
    let City: String
    let State: String
    let Country: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let document: String
    let fileName: String
    let Tags: String
    let giftcardbal: String
    let SelectPackage: String
    let employeeSold: String
    let package_sd: String
    let package_ed: String
    let Campaignsid: String
    let Fullname: String
    let UserID: Int
    let userimg: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.sid = dict["sid"] as? Int ?? 0
        self.FirstName = dict["FirstName"] as? String ?? ""
        self.LastName = dict["LastName"] as? String ?? ""
        self.Phone = dict["Phone"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.ClientImg = dict["ClientImg"] as? String ?? ""
        self.ProfileImg = dict["ProfileImg"] as? String ?? ""
        self.Solution = dict["Solution"] as? String ?? ""
        self.PrivateNotes = dict["PrivateNotes"] as? String ?? ""
        self.Address = dict["Address"] as? String ?? ""
        self.Zip = dict["Zip"] as? String ?? ""
        self.City = dict["City"] as? String ?? ""
        self.State = dict["State"] as? String ?? ""
        self.Country = dict["Country"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.document = dict["document"] as? String ?? ""
        self.fileName = dict["fileName"] as? String ?? ""
        self.Tags = dict["Tags"] as? String ?? ""
        self.giftcardbal = dict["giftcardbal"] as? String ?? ""
        self.SelectPackage = dict["SelectPackage"] as? String ?? ""
        self.employeeSold = dict["employeeSold"] as? String ?? ""
        self.package_sd = dict["package_sd"] as? String ?? ""
        self.package_ed = dict["package_ed"] as? String ?? ""
        self.Campaignsid = dict["Campaignsid"] as? String ?? ""
        self.Fullname = dict["Fullname"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.userimg = dict["userimg"] as? String ?? ""
    }
}

struct ShowProductCategory {
    let id: Int
    let Category: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let Fullname: String
    let UserID: Int
    let userimg: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.Category = dict["Category"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.Fullname = dict["Fullname"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.userimg = dict["userimg"] as? String ?? ""
    }
}

struct ShowMembershipPackage {
    let id: Int
    let Name: String
    let Price: String
    let Tracking: String
    let Description: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let CommissionAmount: Int
    let service: String
    let Noofvisit: String
    let Fullname: String
    let UserID: Int
    let userimg: String

    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.Name = dict["Name"] as? String ?? ""
        self.Price = dict["Price"] as? String ?? ""
        self.Tracking = dict["Tracking"] as? String ?? ""
        self.Description = dict["Description"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.CommissionAmount = dict["CommissionAmount"] as? Int ?? 0
        self.service = dict["service"] as? String ?? ""
        self.Noofvisit = dict["Noofvisit"] as? String ?? ""
        self.Fullname = dict["Fullname"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.userimg = dict["userimg"] as? String ?? ""
    }
}

struct ShowProductList {
    let id: Int
    let barcode: String
    let ProductTitle: String
    let ProductDescription: String
    let CompanyCost: Int
    let SellingPrice: Int
    let ProductCategory: String
    let ProductBrand: String
    let ProductImage: String
    let NoofPorduct: Int
    let createdfk: Int
    let updatedfk: Int
    let datecreated: String
    let datelastupdated: String
    let isactive: Int
    let isarchive: Int
    let discountinparst: String
    let CommissionAmount: Int
    let sales_tax: String
    let SellingPricewithouttax: String
    let onlytax: String
    let Fullname: String
    let UserID: Int
    let userimg: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.barcode = dict["barcode"] as? String ?? ""
        self.ProductTitle = dict["ProductTitle"] as? String ?? ""
        self.ProductDescription = dict["ProductDescription"] as? String ?? ""
        self.CompanyCost = dict["CompanyCost"] as? Int ?? 0
        self.SellingPrice = dict["SellingPrice"] as? Int ?? 0
        self.ProductCategory = dict["ProductCategory"] as? String ?? ""
        self.ProductBrand = dict["ProductBrand"] as? String ?? ""
        self.ProductImage = dict["ProductImage"] as? String ?? ""
        self.NoofPorduct = dict["NoofPorduct"] as? Int ?? 0
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.isactive = dict["isactive"] as? Int ?? 0
        self.isarchive = dict["isarchive"] as? Int ?? 0
        self.discountinparst = dict["discountinparst"] as? String ?? ""
        self.CommissionAmount = dict["CommissionAmount"] as? Int ?? 0
        self.sales_tax = dict["sales_tax"] as? String ?? ""
        self.SellingPricewithouttax = dict["SellingPricewithouttax"] as? String ?? ""
        self.onlytax = dict["onlytax"] as? String ?? ""
        self.Fullname = dict["Fullname"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.userimg = dict["userimg"] as? String ?? ""
    }
}

struct ClientAction {
    let title: String
    let image: UIImage
}

struct ViewAppointmentUserInfo {
    let id: Int
    let FirstName: String
    let LastName: String
    let Phone: String
    let Email: String
    let EventDate: String
    let eventstatus: String
    let Address: String
    let Zip: String
    let City: String
    let State: String
    let country: String
    let CostOfService: String
    let EmailInstruction: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let title: String
    let start_date: String
    let end_date: String
    let description: String
    let Appcanmsgfcus: String
    let UserID: Int
    let ServiceName: Int
    let ServiceProvider: Int
    let cid: Int
    let Location_radio: String
    let Accepted: String
    let sync: Int
    let client_phone: String
    let phonenumber: String
    let username: String
    let userimg: String
    let User_firstname: String
    let User_lastname: String
    let ProfileImg: String
    let client_firstname: String
    let client_Lastname: String
    let client_email: String
    let clientid: Int
    let OrderID: Int
    let InvoiceNumber: Int
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.FirstName = dict["FirstName"] as? String ?? ""
        self.LastName = dict["LastName"] as? String ?? ""
        self.Phone = dict["Phone"] as? String ?? ""
        self.Email = dict["Email"] as? String ?? ""
        self.EventDate = dict["EventDate"] as? String ?? ""
        self.eventstatus = dict["eventstatus"] as? String ?? ""
        self.Address = dict["Address"] as? String ?? ""
        self.Zip = dict["Zip"] as? String ?? ""
        self.City = dict["City"] as? String ?? ""
        self.State = dict["State"] as? String ?? ""
        self.country = dict["country"] as? String ?? ""
        self.CostOfService = dict["CostOfService"] as? String ?? ""
        self.EmailInstruction = dict["EmailInstruction"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.title = dict["title"] as? String ?? ""
        self.start_date = dict["start_date"] as? String ?? ""
        self.end_date = dict["end_date"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
        self.Appcanmsgfcus = dict["Appcanmsgfcus"] as? String ?? ""
        self.UserID = dict["UserID"] as? Int ?? 0
        self.ServiceName = dict["ServiceName"] as? Int ?? 0
        self.ServiceProvider = dict["ServiceProvider"] as? Int ?? 0
        self.cid = dict["cid"] as? Int ?? 0
        self.Location_radio = dict["Location_radio"] as? String ?? ""
        self.Accepted = dict["Accepted"] as? String ?? ""
        self.sync = dict["sync"] as? Int ?? 0
        self.client_phone = dict["client_phone"] as? String ?? ""
        self.phonenumber = dict["phonenumber"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
        self.User_firstname = dict["User_firstname"] as? String ?? ""
        self.User_lastname = dict["User_lastname"] as? String ?? ""
        self.ProfileImg = dict["ProfileImg"] as? String ?? ""
        self.client_firstname = dict["client_firstname"] as? String ?? ""
        self.client_Lastname = dict["client_Lastname"] as? String ?? ""
        self.client_email = dict["client_email"] as? String ?? ""
        self.clientid = dict["clientid"] as? Int ?? 0
        self.OrderID = dict["OrderID"] as? Int ?? 0
        self.InvoiceNumber = dict["InvoiceNumber"] as? Int ?? 0
    }
}

struct ViewSalesUserInfo {
    public var ino : String?
    public var userID : Int?
    public var firstname : String?
    public var lastname : String?
    public var username : String?
    public var userimg : String?
    public var paymentType : String?
    public var paymentDetail : String?
    public var paymentAmount : String?
    public var orderdate : String?
    public var orderid : Int?
    public var client_Fullname : String?
    public var clientID : Int?
    public var profileImg : String?
    public var id : Int?
    public var invoiceNumber : String?
    public var pservicename : String?
    public var pservicepackage : String?
    public var pvisit : String?
    public var serviceName : String?
    public var servicProvider : String?
    public var serviceStartTime : String?
    public var servicePrice : String?
    public var serviceDiscount : String?
    public var serviceDiscoutInParentage : String?
    public var serviceFianlPrice : String?
    public var prodcutName : String?
    public var prodcutQuality : String?
    public var productPrice : String?
    public var productCostPrice : String?
    public var productDiscount : String?
    public var productDiscountInParentage : String?
    public var productTaxPrice : String?
    public var productFianlPrice : String?
    public var membershipName : String?
    public var membershipPrice : String?
    public var membershipDiscount : String?
    public var memberDiscoutInParentage : String?
    public var membershipFianlPrice : String?
    public var totalOrderAmount : String?
    public var totalseriveAmount : String?
    public var totalProductAmount : String?
    public var totalMembershipAmount : String?
    public var getTotalPoint : Int?
    public var usePoint : Int?
    public var remainepoints : Int?
    public var cid : Int?
    public var eid : Int?
    public var datecreated : String?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var isactive : Int?
    public var datelastupdated : String?
    public var payment_status : String?
    public var sales_tax : String?
    public var tips : String?
    public var giftapp : String?
    public var packageName : String?
    public var pckageAmount : String?
    public var noofvisit : String?
    public var package_Autonew : String?
    public var package_renwal : String?
    public var pckage_carryford : String?
    public var package_expire_date : String?
    public var gServiceName : String?
    public var gServicePrice : String?
    public var gServiceDiscount : String?
    public var gServiceDiscoutInParentage : String?
    public var gServiceFianlPrice : String?
    public var totalgiftAmount : String?
    public var gstatus : Int?
    public var package_Price : String?
    public var packageDiscount : String?
    public var pacakageDiscounPersentage : String?
    public var packageFinalPrice : String?
    
    init?(dictionary: [String:Any]) {
        ino = dictionary["ino"] as? String
        userID = dictionary["UserID"] as? Int
        firstname = dictionary["firstname"] as? String
        lastname = dictionary["lastname"] as? String
        username = dictionary["username"] as? String
        userimg = dictionary["userimg"] as? String
        paymentType = dictionary["PaymentType"] as? String
        paymentDetail = dictionary["PaymentDetail"] as? String
        paymentAmount = dictionary["PaymentAmount"] as? String
        orderdate = dictionary["Orderdate"] as? String
        orderid = dictionary["orderid"] as? Int
        client_Fullname = dictionary["Client_Fullname"] as? String
        clientID = dictionary["clientID"] as? Int
        profileImg = dictionary["ProfileImg"] as? String
        id = dictionary["id"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        pservicename = dictionary["pservicename"] as? String
        pservicepackage = dictionary["pservicepackage"] as? String
        pvisit = dictionary["pvisit"] as? String
        serviceName = dictionary["ServiceName"] as? String
        servicProvider = dictionary["ServicProvider"] as? String
        serviceStartTime = dictionary["ServiceStartTime"] as? String
        servicePrice = dictionary["ServicePrice"] as? String
        serviceDiscount = dictionary["ServiceDiscount"] as? String
        serviceDiscoutInParentage = dictionary["ServiceDiscoutInParentage"] as? String
        serviceFianlPrice = dictionary["ServiceFianlPrice"] as? String
        prodcutName = dictionary["ProdcutName"] as? String
        prodcutQuality = dictionary["ProdcutQuality"] as? String
        productPrice = dictionary["ProductPrice"] as? String
        productCostPrice = dictionary["ProductCostPrice"] as? String
        productDiscount = dictionary["ProductDiscount"] as? String
        productDiscountInParentage = dictionary["ProductDiscountInParentage"] as? String
        productTaxPrice = dictionary["ProductTaxPrice"] as? String
        productFianlPrice = dictionary["ProductFianlPrice"] as? String
        membershipName = dictionary["MembershipName"] as? String
        membershipPrice = dictionary["MembershipPrice"] as? String
        membershipDiscount = dictionary["MembershipDiscount"] as? String
        memberDiscoutInParentage = dictionary["MemberDiscoutInParentage"] as? String
        membershipFianlPrice = dictionary["MembershipFianlPrice"] as? String
        totalOrderAmount = dictionary["TotalOrderAmount"] as? String
        totalseriveAmount = dictionary["TotalseriveAmount"] as? String
        totalProductAmount = dictionary["TotalProductAmount"] as? String
        totalMembershipAmount = dictionary["TotalMembershipAmount"] as? String
        getTotalPoint = dictionary["GetTotalPoint"] as? Int
        usePoint = dictionary["UsePoint"] as? Int
        remainepoints = dictionary["Remainepoints"] as? Int
        cid = dictionary["cid"] as? Int
        eid = dictionary["eid"] as? Int
        datecreated = dictionary["datecreated"] as? String
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        datelastupdated = dictionary["datelastupdated"] as? String
        payment_status = dictionary["payment_status"] as? String
        sales_tax = dictionary["sales_tax"] as? String
        tips = dictionary["tips"] as? String
        giftapp = dictionary["giftapp"] as? String
        packageName = dictionary["PackageName"] as? String
        pckageAmount = dictionary["PckageAmount"] as? String
        noofvisit = dictionary["Noofvisit"] as? String
        package_Autonew = dictionary["Package_Autonew"] as? String
        package_renwal = dictionary["Package_renwal"] as? String
        pckage_carryford = dictionary["Pckage_carryford"] as? String
        package_expire_date = dictionary["package_expire_date"] as? String
        gServiceName = dictionary["gServiceName"] as? String
        gServicePrice = dictionary["gServicePrice"] as? String
        gServiceDiscount = dictionary["gServiceDiscount"] as? String
        gServiceDiscoutInParentage = dictionary["gServiceDiscoutInParentage"] as? String
        gServiceFianlPrice = dictionary["gServiceFianlPrice"] as? String
        totalgiftAmount = dictionary["TotalgiftAmount"] as? String
        gstatus = dictionary["gstatus"] as? Int
        package_Price = dictionary["Package_Price"] as? String
        packageDiscount = dictionary["PackageDiscount"] as? String
        pacakageDiscounPersentage = dictionary["PacakageDiscounPersentage"] as? String
        packageFinalPrice = dictionary["PackageFinalPrice"] as? String
    }
}

struct SalesOverview {
    let id: Int
    let totalamount: Int
    let clientname: String
    let image: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.totalamount = dict["totalamount"] as? Int ?? 0
        self.clientname = dict["clientname"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
    }
}

struct ViewClientInfo {
    public var id : Int?
    public var sid : Int?
    public var firstName : String?
    public var lastName : String?
    public var phone : String?
    public var email : String?
    public var clientImg : String?
    public var profileImg : String?
    public var solution : String?
    public var privateNotes : String?
    public var address : String?
    public var zip : String?
    public var city : String?
    public var state : String?
    public var country : String?
    public var datecreated : String?
    public var datelastupdated : String?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var isactive : Int?
    public var document : String?
    public var fileName : String?
    public var tags : String?
    public var giftcardbal : String?
    public var selectPackage : String?
    public var employeeSold : String?
    public var package_sd : String?
    public var package_ed : String?
    public var campaignsid : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        sid = dictionary["sid"] as? Int
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        phone = dictionary["Phone"] as? String
        email = dictionary["email"] as? String
        clientImg = dictionary["ClientImg"] as? String
        profileImg = dictionary["ProfileImg"] as? String
        solution = dictionary["Solution"] as? String
        privateNotes = dictionary["PrivateNotes"] as? String
        address = dictionary["Address"] as? String
        zip = dictionary["Zip"] as? String
        city = dictionary["City"] as? String
        state = dictionary["State"] as? String
        country = dictionary["Country"] as? String
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        document = dictionary["document"] as? String
        fileName = dictionary["fileName"] as? String
        tags = dictionary["Tags"] as? String
        giftcardbal = dictionary["giftcardbal"] as? String
        selectPackage = dictionary["SelectPackage"] as? String
        employeeSold = dictionary["employeeSold"] as? String
        package_sd = dictionary["package_sd"] as? String
        package_ed = dictionary["package_ed"] as? String
        campaignsid = dictionary["Campaignsid"] as? String
    }
}   

struct ShowDocument {
    let id: Int
    let UserID: Int
    let fileName: String
    let document: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: Int
    let Riminederdate: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.UserID = dict["UserID"] as? Int ?? 0
        self.fileName = dict["fileName"] as? String ?? ""
        self.document = dict["document"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.Riminederdate = dict["Riminederdate"] as? String ?? ""
    }
}

struct ViewNote {
    let id: Int
    let noteTitle: String
    let noteDetail: String
    let noteRelated: String
    let datecreated: String
    let datelastupdated: String
    let createdfk: Int
    let updatedfk: Int
    let isactive: String
    let cid: Int
    let enterdate: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.noteTitle = dict["noteTitle"] as? String ?? ""
        self.noteDetail = dict["noteDetail"] as? String ?? ""
        self.noteRelated = dict["noteRelated"] as? String ?? ""
        self.datecreated = dict["datecreated"] as? String ?? ""
        self.datelastupdated = dict["datelastupdated"] as? String ?? ""
        self.createdfk = dict["createdfk"] as? Int ?? 0
        self.updatedfk = dict["updatedfk"] as? Int ?? 0
        self.isactive = dict["isactive"] as? String ?? ""
        self.cid = dict["cid"] as? Int ?? 0
        self.enterdate = dict["enterdate"] as? String ?? ""
    }
}

struct ContactHistory {
    let id: Int
    let type: String
    let message: String
    let subject: String
    let cid: String
    let Createid: String
    let comtime: String
    let firstname: String
    let lastname: String
    let userimg: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.type = dict["type"] as? String ?? ""
        self.message = dict["message"] as? String ?? ""
        self.subject = dict["subject"] as? String ?? ""
        self.cid = dict["cid"] as? String ?? ""
        self.Createid = dict["Createid"] as? String ?? ""
        self.comtime = dict["comtime"] as? String ?? ""
        self.firstname = dict["firstname"] as? String ?? ""
        self.lastname = dict["lastname"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
    }
}

struct OrderHistory {
    public var ino : String?
    public var userID : Int?
    public var firstname : String?
    public var lastname : String?
    public var username : String?
    public var userimg : String?
    public var paymentType : String?
    public var paymentDetail : String?
    public var paymentAmount : String?
    public var orderdate : String?
    public var orderid : Int?
    public var firstName : String?
    public var lastName : String?
    public var cid : Int?
    public var profileImg : String?
    public var id : Int?
    public var invoiceNumber : String?
    public var pservicename : String?
    public var pservicepackage : String?
    public var pvisit : String?
    public var serviceName : String?
    public var servicProvider : String?
    public var serviceStartTime : String?
    public var servicePrice : String?
    public var serviceDiscount : String?
    public var serviceDiscoutInParentage : String?
    public var serviceFianlPrice : String?
    public var prodcutName : String?
    public var prodcutQuality : String?
    public var productPrice : String?
    public var productCostPrice : String?
    public var productDiscount : String?
    public var productDiscountInParentage : String?
    public var productTaxPrice : String?
    public var productFianlPrice : String?
    public var membershipName : String?
    public var membershipPrice : String?
    public var membershipDiscount : String?
    public var memberDiscoutInParentage : String?
    public var membershipFianlPrice : String?
    public var totalOrderAmount : String?
    public var totalseriveAmount : String?
    public var totalProductAmount : String?
    public var totalMembershipAmount : String?
    public var getTotalPoint : Int?
    public var usePoint : Int?
    public var remainepoints : Int?
    public var eid : Int?
    public var datecreated : String?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var isactive : Int?
    public var datelastupdated : String?
    public var payment_status : String?
    public var sales_tax : String?
    public var tips : String?
    public var giftapp : String?
    public var packageName : String?
    public var pckageAmount : String?
    public var noofvisit : String?
    public var package_Autonew : String?
    public var package_renwal : String?
    public var pckage_carryford : String?
    public var package_expire_date : String?
    public var gServiceName : String?
    public var gServicePrice : String?
    public var gServiceDiscount : String?
    public var gServiceDiscoutInParentage : String?
    public var gServiceFianlPrice : String?
    public var totalgiftAmount : String?
    public var gstatus : Int?
    public var package_Price : String?
    public var packageDiscount : String?
    public var pacakageDiscounPersentage : String?
    public var packageFinalPrice : String?
    public var timediff : String?
    
    public init?(dictionary: [String:Any]) {
        ino = dictionary["ino"] as? String
        userID = dictionary["UserID"] as? Int
        firstname = dictionary["firstname"] as? String
        lastname = dictionary["lastname"] as? String
        username = dictionary["username"] as? String
        userimg = dictionary["userimg"] as? String
        paymentType = dictionary["PaymentType"] as? String
        paymentDetail = dictionary["PaymentDetail"] as? String
        paymentAmount = dictionary["PaymentAmount"] as? String
        orderdate = dictionary["Orderdate"] as? String
        orderid = dictionary["orderid"] as? Int
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        cid = dictionary["cid"] as? Int
        profileImg = dictionary["ProfileImg"] as? String
        id = dictionary["id"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        pservicename = dictionary["pservicename"] as? String
        pservicepackage = dictionary["pservicepackage"] as? String
        pvisit = dictionary["pvisit"] as? String
        serviceName = dictionary["ServiceName"] as? String
        servicProvider = dictionary["ServicProvider"] as? String
        serviceStartTime = dictionary["ServiceStartTime"] as? String
        servicePrice = dictionary["ServicePrice"] as? String
        serviceDiscount = dictionary["ServiceDiscount"] as? String
        serviceDiscoutInParentage = dictionary["ServiceDiscoutInParentage"] as? String
        serviceFianlPrice = dictionary["ServiceFianlPrice"] as? String
        prodcutName = dictionary["ProdcutName"] as? String
        prodcutQuality = dictionary["ProdcutQuality"] as? String
        productPrice = dictionary["ProductPrice"] as? String
        productCostPrice = dictionary["ProductCostPrice"] as? String
        productDiscount = dictionary["ProductDiscount"] as? String
        productDiscountInParentage = dictionary["ProductDiscountInParentage"] as? String
        productTaxPrice = dictionary["ProductTaxPrice"] as? String
        productFianlPrice = dictionary["ProductFianlPrice"] as? String
        membershipName = dictionary["MembershipName"] as? String
        membershipPrice = dictionary["MembershipPrice"] as? String
        membershipDiscount = dictionary["MembershipDiscount"] as? String
        memberDiscoutInParentage = dictionary["MemberDiscoutInParentage"] as? String
        membershipFianlPrice = dictionary["MembershipFianlPrice"] as? String
        totalOrderAmount = dictionary["TotalOrderAmount"] as? String
        totalseriveAmount = dictionary["TotalseriveAmount"] as? String
        totalProductAmount = dictionary["TotalProductAmount"] as? String
        totalMembershipAmount = dictionary["TotalMembershipAmount"] as? String
        getTotalPoint = dictionary["GetTotalPoint"] as? Int
        usePoint = dictionary["UsePoint"] as? Int
        remainepoints = dictionary["Remainepoints"] as? Int
        eid = dictionary["eid"] as? Int
        datecreated = dictionary["datecreated"] as? String
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        datelastupdated = dictionary["datelastupdated"] as? String
        payment_status = dictionary["payment_status"] as? String
        sales_tax = dictionary["sales_tax"] as? String
        tips = dictionary["tips"] as? String
        giftapp = dictionary["giftapp"] as? String
        packageName = dictionary["PackageName"] as? String
        pckageAmount = dictionary["PckageAmount"] as? String
        noofvisit = dictionary["Noofvisit"] as? String
        package_Autonew = dictionary["Package_Autonew"] as? String
        package_renwal = dictionary["Package_renwal"] as? String
        pckage_carryford = dictionary["Pckage_carryford"] as? String
        package_expire_date = dictionary["package_expire_date"] as? String
        gServiceName = dictionary["gServiceName"] as? String
        gServicePrice = dictionary["gServicePrice"] as? String
        gServiceDiscount = dictionary["gServiceDiscount"] as? String
        gServiceDiscoutInParentage = dictionary["gServiceDiscoutInParentage"] as? String
        gServiceFianlPrice = dictionary["gServiceFianlPrice"] as? String
        totalgiftAmount = dictionary["TotalgiftAmount"] as? String
        gstatus = dictionary["gstatus"] as? Int
        package_Price = dictionary["Package_Price"] as? String
        packageDiscount = dictionary["PackageDiscount"] as? String
        pacakageDiscounPersentage = dictionary["PacakageDiscounPersentage"] as? String
        packageFinalPrice = dictionary["PackageFinalPrice"] as? String
        timediff = dictionary["timediff"] as? String
    }
}

struct PackageHistory {
    let Noofvisit: String
    let id: Int
    let orid: Int
    let odatecreated: String
    let Name: String
    let packageCreatorName: String
    let userimg: String
    let timediff: String
    
    init(dict: [String:Any]) {
        self.Noofvisit = dict["Noofvisit"] as? String ?? ""
        self.id = dict["id"] as? Int ?? 0
        self.orid = dict["orid"] as? Int ?? 0
        self.odatecreated = dict[""] as? String ?? ""
        self.Name = dict["Name"] as? String ?? ""
        self.packageCreatorName = dict["packageCreatorName"] as? String ?? ""
        self.userimg = dict["userimg"] as? String ?? ""
        self.timediff = dict["timediff"] as? String ?? ""
    }
}

struct MemberPackage {
    public var cid : Int?
    public var phone : String?
    public var firstName : String?
    public var lastName : String?
    public var email : String?
    public var profileImg : String?
    public var oid : Int?
    public var id : Int?
    public var orderId : Int?
    public var invoiceNumber : String?
    public var Cid : Int?
    public var createdfk : Int?
    public var eid : Int?
    public var membershipId : Int?
    public var membershipPrice : String?
    public var membershipDiscount : String?
    public var memberDiscoutInParentage : String?
    public var membershipFianlPrice : String?
    public var orderTime : String?
    public var noofvisit : String?
    public var package_Autonew : String?
    public var package_renwal : String?
    public var pckage_carryford : String?
    public var package_expire_date : String?
    public var package_start_date : String?
    public var active : String?
    public var name : String?
    public var cpackagid : Int?
    public var giftcardbal : String?
    
    public init?(dictionary: [String:Any]) {
        
        cid = dictionary["cid"] as? Int
        phone = dictionary["Phone"] as? String
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        email = dictionary["email"] as? String
        profileImg = dictionary["ProfileImg"] as? String
        oid = dictionary["oid"] as? Int
        id = dictionary["id"] as? Int
        orderId = dictionary["OrderId"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        Cid = dictionary["Cid"] as? Int
        createdfk = dictionary["createdfk"] as? Int
        eid = dictionary["eid"] as? Int
        membershipId = dictionary["MembershipId"] as? Int
        membershipPrice = dictionary["MembershipPrice"] as? String
        membershipDiscount = dictionary["MembershipDiscount"] as? String
        memberDiscoutInParentage = dictionary["MemberDiscoutInParentage"] as? String
        membershipFianlPrice = dictionary["MembershipFianlPrice"] as? String
        orderTime = dictionary["OrderTime"] as? String
        noofvisit = dictionary["Noofvisit"] as? String
        package_Autonew = dictionary["Package_Autonew"] as? String
        package_renwal = dictionary["Package_renwal"] as? String
        pckage_carryford = dictionary["Pckage_carryford"] as? String
        package_expire_date = dictionary["package_expire_date"] as? String
        package_start_date = dictionary["package_start_date"] as? String
        active = dictionary["Active"] as? String
        name = dictionary["Name"] as? String
        cpackagid = dictionary["cpackagid"] as? Int
        giftcardbal = dictionary["giftcardbal"] as? String
    }
}

struct CartList {
    var item: String
    var qty: String
    var price: Float
    var tax: Float
    var discount: Float
    var discountPercent: Float
    var totalPrice: Float
    var showTax: Bool
    var selectedItem: String
    var productIds: [String]?
    var productCostPrice: Int?
    var serviceComissionAmt: Int?
    var productComissionAmt: Int?
    var packageComissionAmt: Int?
    
    init(item: String, qty: String, price: Float, tax: Float, discount: Float, discountPercent: Float, totalPrice: Float, showTax: Bool, selectedItem: String, serviceComissionAmt: Int?=nil, packageComissionAmt: Int?=nil) {
        self.item = item
        self.qty = qty
        self.price = price
        self.tax = tax
        self.discount = discount
        self.discountPercent = discountPercent
        self.totalPrice = totalPrice
        self.showTax = showTax
        self.selectedItem = selectedItem
    }
    
    init(item: String, qty: String, price: Float, tax: Float, discount: Float, discountPercent: Float, totalPrice: Float, showTax: Bool, selectedItem: String, productIds: [String], productCostPrice: Int?=nil, productComissionAmt: Int?=nil) {
        self.item = item
        self.qty = qty
        self.price = price
        self.tax = tax
        self.discount = discount
        self.discountPercent = discountPercent
        self.totalPrice = totalPrice
        self.showTax = showTax
        self.selectedItem = selectedItem
        self.productIds = productIds
    }
    
    init() {
        self.item = ""
        self.qty = ""
        self.price = 0.00
        self.tax = 0.00
        self.discount = 0.00
        self.discountPercent = 0.00
        self.totalPrice = 0.00
        self.showTax = false
        self.selectedItem = ""
        self.productIds = []
    }
}

struct ViewProduct {
    public var id : Int?
    public var barcode : String?
    public var productTitle : String?
    public var productDescription : String?
    public var companyCost : Int?
    public var sellingPrice : Int?
    public var productCategory : String?
    public var productBrand : String?
    public var productImage : String?
    public var noofPorduct : Int?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var datecreated : String?
    public var datelastupdated : String?
    public var isactive : Int?
    public var isarchive : Int?
    public var discountinparst : String?
    public var commissionAmount : Int?
    public var sales_tax : String?
    public var sellingPricewithouttax : String?
    public var onlytax : String?
    
    init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        barcode = dictionary["barcode"] as? String
        productTitle = dictionary["ProductTitle"] as? String
        productDescription = dictionary["ProductDescription"] as? String
        companyCost = dictionary["CompanyCost"] as? Int
        sellingPrice = dictionary["SellingPrice"] as? Int
        productCategory = dictionary["ProductCategory"] as? String
        productBrand = dictionary["ProductBrand"] as? String
        productImage = dictionary["ProductImage"] as? String
        noofPorduct = dictionary["NoofPorduct"] as? Int
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        isactive = dictionary["isactive"] as? Int
        isarchive = dictionary["isarchive"] as? Int
        discountinparst = dictionary["discountinparst"] as? String
        commissionAmount = dictionary["CommissionAmount"] as? Int
        sales_tax = dictionary["sales_tax"] as? String
        sellingPricewithouttax = dictionary["SellingPricewithouttax"] as? String
        onlytax = dictionary["onlytax"] as? String
    }
}

struct OrderProduct {
    let productTitle: String
    let productPrice: Int
    var productCostPrice: Int
    let productId: Int
    let productCommission: Int
    var noOfProduct: Int
    let productSalesTax: String
    let tax_on_qty1: Float
    let productQuantity: Int
    var productDiscount: Int
    var productPercentage: Int
    
    init(dict: [String:Any]) {
        self.productTitle = dict["productTitle"] as? String ?? ""
        self.productPrice = dict["productPrice"] as? Int ?? 0
        self.productCostPrice = dict["productCostPrice"] as? Int ?? 0
        self.productId = dict["productId"] as? Int ?? 0
        self.productCommission = dict["productCommission"] as? Int ?? 0
        self.noOfProduct = dict["noOfProduct"] as? Int ?? 0
        self.productSalesTax = dict["productSalesTax"] as? String ?? ""
        self.tax_on_qty1 = dict["tax_on_qty1"] as? Float ?? 0.00
        self.productQuantity = dict["productQuantity"] as? Int ?? 0
        self.productDiscount = dict["productDiscount"] as? Int ?? 0
        self.productPercentage = dict["productPercentage"] as? Int ?? 0
    }
}

struct ViewPackage {
    public var id : Int?
    public var name : String?
    public var price : String?
    public var tracking : String?
    public var description : String?
    public var datecreated : String?
    public var datelastupdated : String?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var isactive : Int?
    public var commissionAmount : Int?
    public var service : String?
    public var noofvisit : String?
    
    init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        name = dictionary["Name"] as? String
        price = dictionary["Price"] as? String
        tracking = dictionary["Tracking"] as? String
        description = dictionary["Description"] as? String
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        commissionAmount = dictionary["CommissionAmount"] as? Int
        service = dictionary["service"] as? String
        noofvisit = dictionary["Noofvisit"] as? String
    }
}

struct Response_service {
    public var id : Int?
    public var orderId : Int?
    public var invoiceNumber : String?
    public var cid : Int?
    public var createdfk : Int?
    public var eid : Int?
    public var seriveId : Int?
    public var servicProvider : String?
    public var serviceStartTime : String?
    public var servicePrice : String?
    public var serviceDiscount : String?
    public var serviceDiscoutInParentage : String?
    public var serviceFianlPrice : String?
    public var orderTime : String?
    public var sid : Int?
    public var firstName : String?
    public var lastName : String?
    public var phone : String?
    public var email : String?
    public var clientImg : String?
    public var profileImg : String?
    public var solution : String?
    public var privateNotes : String?
    public var address : String?
    public var zip : String?
    public var city : String?
    public var state : String?
    public var country : String?
    public var datecreated : String?
    public var datelastupdated : String?
    public var updatedfk : Int?
    public var isactive : Int?
    public var document : String?
    public var fileName : String?
    public var tags : String?
    public var giftcardbal : String?
    public var selectPackage : String?
    public var employeeSold : String?
    public var package_sd : String?
    public var package_ed : String?
    public var campaignsid : String?
    public var serviceName : String?
    public var price : String?
    public var duration : String?
    public var category : String?
    public var users : String?
    public var type : String?
    public var info : String?
    public var starttime : String?
    public var endtime : String?
    public var cusmerlimt : String?
    public var asper : String?
    public var commissionAmount : Int?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        orderId = dictionary["OrderId"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        cid = dictionary["Cid"] as? Int
        createdfk = dictionary["createdfk"] as? Int
        eid = dictionary["eid"] as? Int
        seriveId = dictionary["SeriveId"] as? Int
        servicProvider = dictionary["ServicProvider"] as? String
        serviceStartTime = dictionary["ServiceStartTime"] as? String
        servicePrice = dictionary["ServicePrice"] as? String
        serviceDiscount = dictionary["ServiceDiscount"] as? String
        serviceDiscoutInParentage = dictionary["ServiceDiscoutInParentage"] as? String
        serviceFianlPrice = dictionary["ServiceFianlPrice"] as? String
        orderTime = dictionary["OrderTime"] as? String
        sid = dictionary["sid"] as? Int
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        phone = dictionary["Phone"] as? String
        email = dictionary["email"] as? String
        clientImg = dictionary["ClientImg"] as? String
        profileImg = dictionary["ProfileImg"] as? String
        solution = dictionary["Solution"] as? String
        privateNotes = dictionary["PrivateNotes"] as? String
        address = dictionary["Address"] as? String
        zip = dictionary["Zip"] as? String
        city = dictionary["City"] as? String
        state = dictionary["State"] as? String
        country = dictionary["Country"] as? String
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        document = dictionary["document"] as? String
        fileName = dictionary["fileName"] as? String
        tags = dictionary["Tags"] as? String
        giftcardbal = dictionary["giftcardbal"] as? String
        selectPackage = dictionary["SelectPackage"] as? String
        employeeSold = dictionary["employeeSold"] as? String
        package_sd = dictionary["package_sd"] as? String
        package_ed = dictionary["package_ed"] as? String
        campaignsid = dictionary["Campaignsid"] as? String
        serviceName = dictionary["ServiceName"] as? String
        price = dictionary["Price"] as? String
        duration = dictionary["Duration"] as? String
        category = dictionary["Category"] as? String
        users = dictionary["Users"] as? String
        type = dictionary["Type"] as? String
        info = dictionary["Info"] as? String
        starttime = dictionary["starttime"] as? String
        endtime = dictionary["endtime"] as? String
        cusmerlimt = dictionary["cusmerlimt"] as? String
        asper = dictionary["asper"] as? String
        commissionAmount = dictionary["CommissionAmount"] as? Int
    }
}

struct Allgiftcard {
    public var id : Int?
    public var orderId : Int?
    public var invoiceNumber : String?
    public var cid : Int?
    public var createdfk : Int?
    public var eid : Int?
    public var gSeriveId : Int?
    public var gServicePrice : String?
    public var gServiceDiscount : String?
    public var gServiceDiscoutInParentage : String?
    public var gServiceFianlPrice : String?
    public var totalgiftAmount : String?
    public var orderTime : String?
    public var sid : Int?
    public var firstName : String?
    public var lastName : String?
    public var phone : String?
    public var email : String?
    public var clientImg : String?
    public var profileImg : String?
    public var solution : String?
    public var privateNotes : String?
    public var address : String?
    public var zip : String?
    public var city : String?
    public var state : String?
    public var country : String?
    public var datecreated : String?
    public var datelastupdated : String?
    public var updatedfk : Int?
    public var isactive : Int?
    public var document : String?
    public var fileName : String?
    public var tags : String?
    public var giftcardbal : String?
    public var selectPackage : String?
    public var employeeSold : String?
    public var package_sd : String?
    public var package_ed : String?
    public var campaignsid : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        orderId = dictionary["OrderId"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        cid = dictionary["Cid"] as? Int
        createdfk = dictionary["createdfk"] as? Int
        eid = dictionary["eid"] as? Int
        gSeriveId = dictionary["gSeriveId"] as? Int
        gServicePrice = dictionary["gServicePrice"] as? String
        gServiceDiscount = dictionary["gServiceDiscount"] as? String
        gServiceDiscoutInParentage = dictionary["gServiceDiscoutInParentage"] as? String
        gServiceFianlPrice = dictionary["gServiceFianlPrice"] as? String
        totalgiftAmount = dictionary["TotalgiftAmount"] as? String
        orderTime = dictionary["OrderTime"] as? String
        sid = dictionary["sid"] as? Int
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        phone = dictionary["Phone"] as? String
        email = dictionary["email"] as? String
        clientImg = dictionary["ClientImg"] as? String
        profileImg = dictionary["ProfileImg"] as? String
        solution = dictionary["Solution"] as? String
        privateNotes = dictionary["PrivateNotes"] as? String
        address = dictionary["Address"] as? String
        zip = dictionary["Zip"] as? String
        city = dictionary["City"] as? String
        state = dictionary["State"] as? String
        country = dictionary["Country"] as? String
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        document = dictionary["document"] as? String
        fileName = dictionary["fileName"] as? String
        tags = dictionary["Tags"] as? String
        giftcardbal = dictionary["giftcardbal"] as? String
        selectPackage = dictionary["SelectPackage"] as? String
        employeeSold = dictionary["employeeSold"] as? String
        package_sd = dictionary["package_sd"] as? String
        package_ed = dictionary["package_ed"] as? String
        campaignsid = dictionary["Campaignsid"] as? String
    }
}

struct Response_product {
    public var id : Int?
    public var orderId : Int?
    public var invoiceNumber : String?
    public var cid : Int?
    public var createdfk : Int?
    public var eid : Int?
    public var prodcutId : Int?
    public var prodcutQuality : String?
    public var productPrice : String?
    public var productCostPrice : String?
    public var productDiscount : String?
    public var productDiscountInParentage : String?
    public var productTaxPrice : String?
    public var productFianlPrice : String?
    public var orderTime : String?
    public var sid : Int?
    public var firstName : String?
    public var lastName : String?
    public var phone : String?
    public var email : String?
    public var clientImg : String?
    public var profileImg : String?
    public var solution : String?
    public var privateNotes : String?
    public var address : String?
    public var zip : String?
    public var city : String?
    public var state : String?
    public var country : String?
    public var datecreated : String?
    public var datelastupdated : String?
    public var updatedfk : Int?
    public var isactive : Int?
    public var document : String?
    public var fileName : String?
    public var tags : String?
    public var giftcardbal : String?
    public var selectPackage : String?
    public var employeeSold : String?
    public var package_sd : String?
    public var package_ed : String?
    public var campaignsid : String?
    public var barcode : String?
    public var productTitle : String?
    public var productDescription : String?
    public var companyCost : Int?
    public var sellingPrice : Int?
    public var productCategory : String?
    public var productBrand : String?
    public var productImage : String?
    public var noofPorduct : Int?
    public var isarchive : Int?
    public var discountinparst : String?
    public var commissionAmount : Int?
    public var sales_tax : String?
    public var sellingPricewithouttax : String?
    public var onlytax : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        orderId = dictionary["OrderId"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        cid = dictionary["Cid"] as? Int
        createdfk = dictionary["createdfk"] as? Int
        eid = dictionary["eid"] as? Int
        prodcutId = dictionary["ProdcutId"] as? Int
        prodcutQuality = dictionary["ProdcutQuality"] as? String
        productPrice = dictionary["ProductPrice"] as? String
        productCostPrice = dictionary["ProductCostPrice"] as? String
        productDiscount = dictionary["ProductDiscount"] as? String
        productDiscountInParentage = dictionary["ProductDiscountInParentage"] as? String
        productTaxPrice = dictionary["ProductTaxPrice"] as? String
        productFianlPrice = dictionary["ProductFianlPrice"] as? String
        orderTime = dictionary["OrderTime"] as? String
        sid = dictionary["sid"] as? Int
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        phone = dictionary["Phone"] as? String
        email = dictionary["email"] as? String
        clientImg = dictionary["ClientImg"] as? String
        profileImg = dictionary["ProfileImg"] as? String
        solution = dictionary["Solution"] as? String
        privateNotes = dictionary["PrivateNotes"] as? String
        address = dictionary["Address"] as? String
        zip = dictionary["Zip"] as? String
        city = dictionary["City"] as? String
        state = dictionary["State"] as? String
        country = dictionary["Country"] as? String
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        document = dictionary["document"] as? String
        fileName = dictionary["fileName"] as? String
        tags = dictionary["Tags"] as? String
        giftcardbal = dictionary["giftcardbal"] as? String
        selectPackage = dictionary["SelectPackage"] as? String
        employeeSold = dictionary["employeeSold"] as? String
        package_sd = dictionary["package_sd"] as? String
        package_ed = dictionary["package_ed"] as? String
        campaignsid = dictionary["Campaignsid"] as? String
        barcode = dictionary["barcode"] as? String
        productTitle = dictionary["ProductTitle"] as? String
        productDescription = dictionary["ProductDescription"] as? String
        companyCost = dictionary["CompanyCost"] as? Int
        sellingPrice = dictionary["SellingPrice"] as? Int
        productCategory = dictionary["ProductCategory"] as? String
        productBrand = dictionary["ProductBrand"] as? String
        productImage = dictionary["ProductImage"] as? String
        noofPorduct = dictionary["NoofPorduct"] as? Int
        isarchive = dictionary["isarchive"] as? Int
        discountinparst = dictionary["discountinparst"] as? String
        commissionAmount = dictionary["CommissionAmount"] as? Int
        sales_tax = dictionary["sales_tax"] as? String
        sellingPricewithouttax = dictionary["SellingPricewithouttax"] as? String
        onlytax = dictionary["onlytax"] as? String
    }
}

struct Response_membership {
    public var id : Int?
    public var orderId : Int?
    public var invoiceNumber : String?
    public var cid : Int?
    public var createdfk : Int?
    public var eid : Int?
    public var membershipId : Int?
    public var membershipPrice : String?
    public var membershipDiscount : String?
    public var memberDiscoutInParentage : String?
    public var membershipFianlPrice : String?
    public var orderTime : String?
    public var noofvisit : String?
    public var package_Autonew : String?
    public var package_renwal : String?
    public var pckage_carryford : String?
    public var package_expire_date : String?
    public var package_start_date : String?
    public var active : String?
    public var sid : Int?
    public var firstName : String?
    public var lastName : String?
    public var phone : String?
    public var email : String?
    public var clientImg : String?
    public var profileImg : String?
    public var solution : String?
    public var privateNotes : String?
    public var address : String?
    public var zip : String?
    public var city : String?
    public var state : String?
    public var country : String?
    public var datecreated : String?
    public var datelastupdated : String?
    public var updatedfk : Int?
    public var isactive : Int?
    public var document : String?
    public var fileName : String?
    public var tags : String?
    public var giftcardbal : String?
    public var selectPackage : String?
    public var employeeSold : String?
    public var package_sd : String?
    public var package_ed : String?
    public var campaignsid : String?
    public var name : String?
    public var price : String?
    public var tracking : String?
    public var description : String?
    public var commissionAmount : Int?
    public var service : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        orderId = dictionary["OrderId"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        cid = dictionary["Cid"] as? Int
        createdfk = dictionary["createdfk"] as? Int
        eid = dictionary["eid"] as? Int
        membershipId = dictionary["MembershipId"] as? Int
        membershipPrice = dictionary["MembershipPrice"] as? String
        membershipDiscount = dictionary["MembershipDiscount"] as? String
        memberDiscoutInParentage = dictionary["MemberDiscoutInParentage"] as? String
        membershipFianlPrice = dictionary["MembershipFianlPrice"] as? String
        orderTime = dictionary["OrderTime"] as? String
        noofvisit = dictionary["Noofvisit"] as? String
        package_Autonew = dictionary["Package_Autonew"] as? String
        package_renwal = dictionary["Package_renwal"] as? String
        pckage_carryford = dictionary["Pckage_carryford"] as? String
        package_expire_date = dictionary["package_expire_date"] as? String
        package_start_date = dictionary["package_start_date"] as? String
        active = dictionary["Active"] as? String
        sid = dictionary["sid"] as? Int
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        phone = dictionary["Phone"] as? String
        email = dictionary["email"] as? String
        clientImg = dictionary["ClientImg"] as? String
        profileImg = dictionary["ProfileImg"] as? String
        solution = dictionary["Solution"] as? String
        privateNotes = dictionary["PrivateNotes"] as? String
        address = dictionary["Address"] as? String
        zip = dictionary["Zip"] as? String
        city = dictionary["City"] as? String
        state = dictionary["State"] as? String
        country = dictionary["Country"] as? String
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        document = dictionary["document"] as? String
        fileName = dictionary["fileName"] as? String
        tags = dictionary["Tags"] as? String
        giftcardbal = dictionary["giftcardbal"] as? String
        selectPackage = dictionary["SelectPackage"] as? String
        employeeSold = dictionary["employeeSold"] as? String
        package_sd = dictionary["package_sd"] as? String
        package_ed = dictionary["package_ed"] as? String
        campaignsid = dictionary["Campaignsid"] as? String
        name = dictionary["Name"] as? String
        price = dictionary["Price"] as? String
        tracking = dictionary["Tracking"] as? String
        description = dictionary["Description"] as? String
        commissionAmount = dictionary["CommissionAmount"] as? Int
        service = dictionary["service"] as? String
    }
}

/*struct Response_order {
    public var id : Int?
    public var invoiceNumber : String?
    public var pservicename : Array<String>?
    public var pservicepackage : Array<String>?
    public var pvisit : Array<String>?
    public var serviceName : String?
    public var servicProvider : String?
    public var serviceStartTime : String?
    public var servicePrice : String?
    public var serviceDiscount : String?
    public var serviceDiscoutInParentage : String?
    public var serviceFianlPrice : String?
    public var prodcutName : String?
    public var prodcutQuality : String?
    public var productPrice : String?
    public var productCostPrice : String?
    public var productDiscount : String?
    public var productDiscountInParentage : String?
    public var productTaxPrice : String?
    public var productFianlPrice : String?
    public var membershipName : String?
    public var membershipPrice : String?
    public var membershipDiscount : String?
    public var memberDiscoutInParentage : String?
    public var membershipFianlPrice : String?
    public var totalOrderAmount : String?
    public var totalseriveAmount : String?
    public var totalProductAmount : String?
    public var totalMembershipAmount : String?
    public var getTotalPoint : Int?
    public var usePoint : Int?
    public var remainepoints : Int?
    public var cid : Int?
    public var eid : Int?
    public var datecreated : String?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var isactive : Int?
    public var datelastupdated : String?
    public var payment_status : String?
    public var sales_tax : String?
    public var tips : String?
    public var giftapp : String?
    public var packageName : Array<String>?
    public var pckageAmount : String?
    public var noofvisit : String?
    public var package_Autonew : String?
    public var package_renwal : String?
    public var pckage_carryford : String?
    public var package_expire_date : String?
    public var gServiceName : String?
    public var gServicePrice : String?
    public var gServiceDiscount : String?
    public var gServiceDiscoutInParentage : String?
    public var gServiceFianlPrice : String?
    public var totalgiftAmount : String?
    public var gstatus : Int?
    public var package_Price : String?
    public var packageDiscount : String?
    public var pacakageDiscounPersentage : String?
    public var packageFinalPrice : String?
    public var sid : Int?
    public var firstName : String?
    public var lastName : String?
    public var phone : String?
    public var email : String?
    public var clientImg : String?
    public var profileImg : String?
    public var solution : String?
    public var privateNotes : String?
    public var address : String?
    public var zip : String?
    public var city : String?
    public var state : String?
    public var country : String?
    public var document : String?
    public var fileName : String?
    public var tags : String?
    public var giftcardbal : String?
    public var selectPackage : String?
    public var employeeSold : String?
    public var package_sd : String?
    public var package_ed : String?
    public var campaignsid : String?
    public var orderdatecreated : String?

    public init?(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        if (dictionary["pservicename"] != nil) { pservicename = Pservicename.modelsFromDictionaryArray(dictionary["pservicename"] as! NSArray) }
        if (dictionary["pservicepackage"] != nil) { pservicepackage = Pservicepackage.modelsFromDictionaryArray(dictionary["pservicepackage"] as! NSArray) }
        if (dictionary["pvisit"] != nil) { pvisit = Pvisit.modelsFromDictionaryArray(dictionary["pvisit"] as! NSArray) }
        serviceName = dictionary["ServiceName"] as? String
        servicProvider = dictionary["ServicProvider"] as? String
        serviceStartTime = dictionary["ServiceStartTime"] as? String
        servicePrice = dictionary["ServicePrice"] as? String
        serviceDiscount = dictionary["ServiceDiscount"] as? String
        serviceDiscoutInParentage = dictionary["ServiceDiscoutInParentage"] as? String
        serviceFianlPrice = dictionary["ServiceFianlPrice"] as? String
        prodcutName = dictionary["ProdcutName"] as? String
        prodcutQuality = dictionary["ProdcutQuality"] as? String
        productPrice = dictionary["ProductPrice"] as? String
        productCostPrice = dictionary["ProductCostPrice"] as? String
        productDiscount = dictionary["ProductDiscount"] as? String
        productDiscountInParentage = dictionary["ProductDiscountInParentage"] as? String
        productTaxPrice = dictionary["ProductTaxPrice"] as? String
        productFianlPrice = dictionary["ProductFianlPrice"] as? String
        membershipName = dictionary["MembershipName"] as? String
        membershipPrice = dictionary["MembershipPrice"] as? String
        membershipDiscount = dictionary["MembershipDiscount"] as? String
        memberDiscoutInParentage = dictionary["MemberDiscoutInParentage"] as? String
        membershipFianlPrice = dictionary["MembershipFianlPrice"] as? String
        totalOrderAmount = dictionary["TotalOrderAmount"] as? String
        totalseriveAmount = dictionary["TotalseriveAmount"] as? String
        totalProductAmount = dictionary["TotalProductAmount"] as? String
        totalMembershipAmount = dictionary["TotalMembershipAmount"] as? String
        getTotalPoint = dictionary["GetTotalPoint"] as? Int
        usePoint = dictionary["UsePoint"] as? Int
        remainepoints = dictionary["Remainepoints"] as? Int
        cid = dictionary["cid"] as? Int
        eid = dictionary["eid"] as? Int
        datecreated = dictionary["datecreated"] as? String
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        datelastupdated = dictionary["datelastupdated"] as? String
        payment_status = dictionary["payment_status"] as? String
        sales_tax = dictionary["sales_tax"] as? String
        tips = dictionary["tips"] as? String
        giftapp = dictionary["giftapp"] as? String
        if (dictionary["PackageName"] != nil) { packageName = PackageName.modelsFromDictionaryArray(dictionary["PackageName"] as! NSArray) }
        pckageAmount = dictionary["PckageAmount"] as? String
        noofvisit = dictionary["Noofvisit"] as? String
        package_Autonew = dictionary["Package_Autonew"] as? String
        package_renwal = dictionary["Package_renwal"] as? String
        pckage_carryford = dictionary["Pckage_carryford"] as? String
        package_expire_date = dictionary["package_expire_date"] as? String
        gServiceName = dictionary["gServiceName"] as? String
        gServicePrice = dictionary["gServicePrice"] as? String
        gServiceDiscount = dictionary["gServiceDiscount"] as? String
        gServiceDiscoutInParentage = dictionary["gServiceDiscoutInParentage"] as? String
        gServiceFianlPrice = dictionary["gServiceFianlPrice"] as? String
        totalgiftAmount = dictionary["TotalgiftAmount"] as? String
        gstatus = dictionary["gstatus"] as? Int
        package_Price = dictionary["Package_Price"] as? String
        packageDiscount = dictionary["PackageDiscount"] as? String
        pacakageDiscounPersentage = dictionary["PacakageDiscounPersentage"] as? String
        packageFinalPrice = dictionary["PackageFinalPrice"] as? String
        sid = dictionary["sid"] as? Int
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        phone = dictionary["Phone"] as? String
        email = dictionary["email"] as? String
        clientImg = dictionary["ClientImg"] as? String
        profileImg = dictionary["ProfileImg"] as? String
        solution = dictionary["Solution"] as? String
        privateNotes = dictionary["PrivateNotes"] as? String
        address = dictionary["Address"] as? String
        zip = dictionary["Zip"] as? String
        city = dictionary["City"] as? String
        state = dictionary["State"] as? String
        country = dictionary["Country"] as? String
        document = dictionary["document"] as? String
        fileName = dictionary["fileName"] as? String
        tags = dictionary["Tags"] as? String
        giftcardbal = dictionary["giftcardbal"] as? String
        selectPackage = dictionary["SelectPackage"] as? String
        employeeSold = dictionary["employeeSold"] as? String
        package_sd = dictionary["package_sd"] as? String
        package_ed = dictionary["package_ed"] as? String
        campaignsid = dictionary["Campaignsid"] as? String
        orderdatecreated = dictionary["Orderdatecreated"] as? String
    }
}   */

struct Order_note {
    public var order_note : String?
    
    public init?(dictionary: NSDictionary) {
        order_note = dictionary["order_note"] as? String
    }
}

struct Other {
    public var order_note : String?
    
    public init?(dictionary: NSDictionary) {
        order_note = dictionary["order_note"] as? String
    }
}

struct ProductReport {
    public var id : Int?
    public var barcode : String?
    public var productTitle : String?
    public var productDescription : String?
    public var companyCost : Int?
    public var sellingPrice : Int?
    public var productCategory : String?
    public var productBrand : String?
    public var productImage : String?
    public var noofPorduct : Int?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var datecreated : String?
    public var datelastupdated : String?
    public var isactive : Int?
    public var isarchive : Int?
    public var discountinparst : String?
    public var commissionAmount : Int?
    public var sales_tax : String?
    public var sellingPricewithouttax : String?
    public var onlytax : String?
    public var orderId : Int?
    public var invoiceNumber : String?
    public var productTaxPrice : String?
    public var productPrice : String?
    public var category : String?
    public var brand : String?
    public var custname : String?
    public var productId : Int?
    public var clientid : Int?
    public var profileImg : String?
    public var prodcutQuality : String?
    public var productCostPrice : String?
    public var fullname : String?
    public var userID : Int?
    public var username : String?
    public var userimg : String?
    public var productFianlPrice : String?
    public var profit : String?
    public var orderTime : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        barcode = dictionary["barcode"] as? String
        productTitle = dictionary["ProductTitle"] as? String
        productDescription = dictionary["ProductDescription"] as? String
        companyCost = dictionary["CompanyCost"] as? Int
        sellingPrice = dictionary["SellingPrice"] as? Int
        productCategory = dictionary["ProductCategory"] as? String
        productBrand = dictionary["ProductBrand"] as? String
        productImage = dictionary["ProductImage"] as? String
        noofPorduct = dictionary["NoofPorduct"] as? Int
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        isactive = dictionary["isactive"] as? Int
        isarchive = dictionary["isarchive"] as? Int
        discountinparst = dictionary["discountinparst"] as? String
        commissionAmount = dictionary["CommissionAmount"] as? Int
        sales_tax = dictionary["sales_tax"] as? String
        sellingPricewithouttax = dictionary["SellingPricewithouttax"] as? String
        onlytax = dictionary["onlytax"] as? String
        orderId = dictionary["OrderId"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        productTaxPrice = dictionary["ProductTaxPrice"] as? String
        productPrice = dictionary["ProductPrice"] as? String
        category = dictionary["Category"] as? String
        brand = dictionary["Brand"] as? String
        custname = dictionary["custname"] as? String
        productId = dictionary["ProductId"] as? Int
        clientid = dictionary["clientid"] as? Int
        profileImg = dictionary["ProfileImg"] as? String
        prodcutQuality = dictionary["ProdcutQuality"] as? String
        productCostPrice = dictionary["ProductCostPrice"] as? String
        fullname = dictionary["fullname"] as? String
        userID = dictionary["UserID"] as? Int
        username = dictionary["username"] as? String
        userimg = dictionary["userimg"] as? String
        productFianlPrice = dictionary["ProductFianlPrice"] as? String
        profit = dictionary["profit"] as? String
        orderTime = dictionary["OrderTime"] as? String
    }
}

struct CategoryReport {
    public var category : String?
    public var brand : String?
    public var quantity : Int?
    public var productTax : Double?
    public var cost_Price : Int?
    public var productFianlPrice : Double?
    public var profit : String?
    public var finalcost : Int?
    
    public init?(dictionary: [String:Any]) {
        category = dictionary["Category"] as? String
        brand = dictionary["Brand"] as? String
        quantity = dictionary["Quantity"] as? Int
        productTax = dictionary["ProductTax"] as? Double
        cost_Price = dictionary["Cost_Price"] as? Int
        productFianlPrice = dictionary["ProductFianlPrice"] as? Double
        profit = dictionary["profit"] as? String
        finalcost = dictionary["finalcost"] as? Int
    }
}

struct PaymentList {
    public var userID : Int?
    public var firstname : String?
    public var lastname : String?
    public var username : String?
    public var userimg : String?
    public var client_Fullname : String?
    public var clientid : Int?
    public var profileImg : String?
    public var invoiceNumber : String?
    public var id : Int?
    public var orderId : String?
    public var orderdate : String?
    public var cid : String?
    public var cratedfk : String?
    public var paymentType : String?
    public var paymentDetail : [String:Any]?
    public var payment_status : String?
    public var submitdate : String?
    public var amount : String?
    public var usertype : String?
    
    public init?(dictionary: [String:Any]) {
        userID = dictionary["UserID"] as? Int
        firstname = dictionary["firstname"] as? String
        lastname = dictionary["lastname"] as? String
        username = dictionary["username"] as? String
        userimg = dictionary["userimg"] as? String
        client_Fullname = dictionary["Client_Fullname"] as? String
        clientid = dictionary["clientid"] as? Int
        profileImg = dictionary["ProfileImg"] as? String
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        id = dictionary["id"] as? Int
        orderId = dictionary["OrderId"] as? String
        orderdate = dictionary["Orderdate"] as? String
        cid = dictionary["Cid"] as? String
        cratedfk = dictionary["Cratedfk"] as? String
        paymentType = dictionary["PaymentType"] as? String
        paymentDetail = dictionary["PaymentDetail"] as? [String:Any]
        payment_status = dictionary["payment_status"] as? String
        submitdate = dictionary["submitdate"] as? String
        amount = dictionary["amount"] as? String
        usertype = dictionary["usertype"] as? String
    }
}

struct TopSellingProducts {
    let ProdcutId: Int
    let SUMProductFianlPrice: Int
    let SUMProdcutQuality: Int
    let ProductTitle: String
    let SellingPrice: Int
    
    init(dict: [String:Any]) {
        ProdcutId = dict["ProdcutId"] as? Int ?? 0
        SUMProductFianlPrice = dict["SUM(OrderProduct.ProductFianlPrice)"] as? Int ?? 0
        SUMProdcutQuality = dict["SUM(OrderProduct.ProdcutQuality)"] as? Int ?? 0
        ProductTitle = dict["ProductTitle"] as? String ?? ""
        SellingPrice = dict["SellingPrice"] as? Int ?? 0
    }
}

struct RecentTransaction {
    public var id : Int?
    public var invoiceNumber : String?
    public var pservicename : String?
    public var pservicepackage : String?
    public var pvisit : String?
    public var serviceName : String?
    public var servicProvider : String?
    public var serviceStartTime : String?
    public var servicePrice : String?
    public var serviceDiscount : String?
    public var serviceDiscoutInParentage : String?
    public var serviceFianlPrice : String?
    public var prodcutName : String?
    public var prodcutQuality : String?
    public var productPrice : String?
    public var productCostPrice : String?
    public var productDiscount : String?
    public var productDiscountInParentage : String?
    public var productTaxPrice : String?
    public var productFianlPrice : String?
    public var membershipName : String?
    public var membershipPrice : String?
    public var membershipDiscount : String?
    public var memberDiscoutInParentage : String?
    public var membershipFianlPrice : String?
    public var totalOrderAmount : String?
    public var totalseriveAmount : String?
    public var totalProductAmount : String?
    public var totalMembershipAmount : String?
    public var getTotalPoint : Int?
    public var usePoint : Int?
    public var remainepoints : Int?
    public var cid : Int?
    public var eid : Int?
    public var datecreated : String?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var isactive : Int?
    public var datelastupdated : String?
    public var payment_status : String?
    public var sales_tax : String?
    public var tips : String?
    public var giftapp : String?
    public var packageName : String?
    public var pckageAmount : String?
    public var noofvisit : String?
    public var package_Autonew : String?
    public var package_renwal : String?
    public var pckage_carryford : String?
    public var package_expire_date : String?
    public var gServiceName : String?
    public var gServicePrice : String?
    public var gServiceDiscount : String?
    public var gServiceDiscoutInParentage : String?
    public var gServiceFianlPrice : String?
    public var totalgiftAmount : String?
    public var gstatus : Int?
    public var package_Price : String?
    public var packageDiscount : String?
    public var pacakageDiscounPersentage : String?
    public var packageFinalPrice : String?
    public var ino : String?
    public var orderid : Int?
    public var userID : Int?
    public var firstname : String?
    public var lastname : String?
    public var username : String?
    public var userimg : String?
    public var orderdate : String?
    public var firstName : String?
    public var lastName : String?
    public var profileImg : String?
    public var paymentAmount : String?
    public var paymentType : String?
    public var orderPayment_status : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
        pservicename = dictionary["pservicename"] as? String
        pservicepackage = dictionary["pservicepackage"] as? String
        pvisit = dictionary["pvisit"] as? String
        serviceName = dictionary["ServiceName"] as? String
        servicProvider = dictionary["ServicProvider"] as? String
        serviceStartTime = dictionary["ServiceStartTime"] as? String
        servicePrice = dictionary["ServicePrice"] as? String
        serviceDiscount = dictionary["ServiceDiscount"] as? String
        serviceDiscoutInParentage = dictionary["ServiceDiscoutInParentage"] as? String
        serviceFianlPrice = dictionary["ServiceFianlPrice"] as? String
        prodcutName = dictionary["ProdcutName"] as? String
        prodcutQuality = dictionary["ProdcutQuality"] as? String
        productPrice = dictionary["ProductPrice"] as? String
        productCostPrice = dictionary["ProductCostPrice"] as? String
        productDiscount = dictionary["ProductDiscount"] as? String
        productDiscountInParentage = dictionary["ProductDiscountInParentage"] as? String
        productTaxPrice = dictionary["ProductTaxPrice"] as? String
        productFianlPrice = dictionary["ProductFianlPrice"] as? String
        membershipName = dictionary["MembershipName"] as? String
        membershipPrice = dictionary["MembershipPrice"] as? String
        membershipDiscount = dictionary["MembershipDiscount"] as? String
        memberDiscoutInParentage = dictionary["MemberDiscoutInParentage"] as? String
        membershipFianlPrice = dictionary["MembershipFianlPrice"] as? String
        totalOrderAmount = dictionary["TotalOrderAmount"] as? String
        totalseriveAmount = dictionary["TotalseriveAmount"] as? String
        totalProductAmount = dictionary["TotalProductAmount"] as? String
        totalMembershipAmount = dictionary["TotalMembershipAmount"] as? String
        getTotalPoint = dictionary["GetTotalPoint"] as? Int
        usePoint = dictionary["UsePoint"] as? Int
        remainepoints = dictionary["Remainepoints"] as? Int
        cid = dictionary["cid"] as? Int
        eid = dictionary["eid"] as? Int
        datecreated = dictionary["datecreated"] as? String
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        datelastupdated = dictionary["datelastupdated"] as? String
        payment_status = dictionary["payment_status"] as? String
        sales_tax = dictionary["sales_tax"] as? String
        tips = dictionary["tips"] as? String
        giftapp = dictionary["giftapp"] as? String
        packageName = dictionary["PackageName"] as? String
        pckageAmount = dictionary["PckageAmount"] as? String
        noofvisit = dictionary["Noofvisit"] as? String
        package_Autonew = dictionary["Package_Autonew"] as? String
        package_renwal = dictionary["Package_renwal"] as? String
        pckage_carryford = dictionary["Pckage_carryford"] as? String
        package_expire_date = dictionary["package_expire_date"] as? String
        gServiceName = dictionary["gServiceName"] as? String
        gServicePrice = dictionary["gServicePrice"] as? String
        gServiceDiscount = dictionary["gServiceDiscount"] as? String
        gServiceDiscoutInParentage = dictionary["gServiceDiscoutInParentage"] as? String
        gServiceFianlPrice = dictionary["gServiceFianlPrice"] as? String
        totalgiftAmount = dictionary["TotalgiftAmount"] as? String
        gstatus = dictionary["gstatus"] as? Int
        package_Price = dictionary["Package_Price"] as? String
        packageDiscount = dictionary["PackageDiscount"] as? String
        pacakageDiscounPersentage = dictionary["PacakageDiscounPersentage"] as? String
        packageFinalPrice = dictionary["PackageFinalPrice"] as? String
        ino = dictionary["ino"] as? String
        orderid = dictionary["orderid"] as? Int
        userID = dictionary["UserID"] as? Int
        firstname = dictionary["firstname"] as? String
        lastname = dictionary["lastname"] as? String
        username = dictionary["username"] as? String
        userimg = dictionary["userimg"] as? String
        orderdate = dictionary["Orderdate"] as? String
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        profileImg = dictionary["ProfileImg"] as? String
        paymentAmount = dictionary["PaymentAmount"] as? String
        paymentType = dictionary["PaymentType"] as? String
        orderPayment_status = dictionary["OrderPayment_status"] as? String
    }
}

struct ShowProducts {
    public var id : Int?
    public var barcode : String?
    public var productTitle : String?
    public var productDescription : String?
    public var companyCost : Int?
    public var sellingPrice : Int?
    public var productCategory : String?
    public var productBrand : String?
    public var productImage : String?
    public var noofPorduct : Int?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var datecreated : String?
    public var datelastupdated : String?
    public var isactive : Int?
    public var isarchive : Int?
    public var discountinparst : String?
    public var commissionAmount : Int?
    public var sales_tax : String?
    public var sellingPricewithouttax : String?
    public var onlytax : String?
    public var brand : String?
    public var category : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        barcode = dictionary["barcode"] as? String
        productTitle = dictionary["ProductTitle"] as? String
        productDescription = dictionary["ProductDescription"] as? String
        companyCost = dictionary["CompanyCost"] as? Int
        sellingPrice = dictionary["SellingPrice"] as? Int
        productCategory = dictionary["ProductCategory"] as? String
        productBrand = dictionary["ProductBrand"] as? String
        productImage = dictionary["ProductImage"] as? String
        noofPorduct = dictionary["NoofPorduct"] as? Int
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        isactive = dictionary["isactive"] as? Int
        isarchive = dictionary["isarchive"] as? Int
        discountinparst = dictionary["discountinparst"] as? String
        commissionAmount = dictionary["CommissionAmount"] as? Int
        sales_tax = dictionary["sales_tax"] as? String
        sellingPricewithouttax = dictionary["SellingPricewithouttax"] as? String
        onlytax = dictionary["onlytax"] as? String
        brand = dictionary["Brand"] as? String
        category = dictionary["category"] as? String
    }
}

struct ShowProductCategoryInventory {
    let id: Int
    let Category: String
    let pcount: Int
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.Category = dict["Category"] as? String ?? ""
        self.pcount = dict["pcount"] as? Int ?? 0
    }
}

struct ShowProductBrand {
    let id: Int
    let Brand: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.Brand = dict["Brand"] as? String ?? ""
    }
}

struct GetProdByBarcode {
    public var id : Int?
    public var barcode : String?
    public var productTitle : String?
    public var productDescription : String?
    public var companyCost : Int?
    public var sellingPrice : Int?
    public var productCategory : String?
    public var productBrand : String?
    public var productImage : String?
    public var noofPorduct : Int?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var datecreated : String?
    public var datelastupdated : String?
    public var isactive : Int?
    public var isarchive : Int?
    public var discountinparst : String?
    public var commissionAmount : Int?
    public var sales_tax : String?
    public var sellingPricewithouttax : String?
    public var onlytax : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        barcode = dictionary["barcode"] as? String
        productTitle = dictionary["ProductTitle"] as? String
        productDescription = dictionary["ProductDescription"] as? String
        companyCost = dictionary["CompanyCost"] as? Int
        sellingPrice = dictionary["SellingPrice"] as? Int
        productCategory = dictionary["ProductCategory"] as? String
        productBrand = dictionary["ProductBrand"] as? String
        productImage = dictionary["ProductImage"] as? String
        noofPorduct = dictionary["NoofPorduct"] as? Int
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        isactive = dictionary["isactive"] as? Int
        isarchive = dictionary["isarchive"] as? Int
        discountinparst = dictionary["discountinparst"] as? String
        commissionAmount = dictionary["CommissionAmount"] as? Int
        sales_tax = dictionary["sales_tax"] as? String
        sellingPricewithouttax = dictionary["SellingPricewithouttax"] as? String
        onlytax = dictionary["onlytax"] as? String
    }
}

struct ShowAppointmentList {
    public var id : Int?
    public var firstName : String?
    public var lastName : String?
    public var phone : String?
    public var email : String?
    public var eventDate : String?
    public var eventstatus : String?
    public var address : String?
    public var zip : String?
    public var city : String?
    public var state : String?
    public var country : String?
    public var costOfService : String?
    public var emailInstruction : String?
    public var datecreated : String?
    public var datelastupdated : String?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var isactive : Int?
    public var title : String?
    public var start_date : String?
    public var end_date : String?
    public var description : String?
    public var appcanmsgfcus : String?
    public var userID : Int?
    public var serviceName : Int?
    public var serviceProvider : Int?
    public var cid : Int?
    public var location_radio : String?
    public var accepted : String?
    public var sync : Int?
    public var client_phone : String?
    public var phonenumber : String?
    public var username : String?
    public var userimg : String?
    public var user_firstname : String?
    public var user_lastname : String?
    public var profileImg : String?
    public var client_firstname : String?
    public var client_Lastname : String?
    public var client_email : String?
    public var clientid : Int?
    public var orderID : Int?
    public var invoiceNumber : String?
    
    public init?(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        phone = dictionary["Phone"] as? String
        email = dictionary["Email"] as? String
        eventDate = dictionary["EventDate"] as? String
        eventstatus = dictionary["eventstatus"] as? String
        address = dictionary["Address"] as? String
        zip = dictionary["Zip"] as? String
        city = dictionary["City"] as? String
        state = dictionary["State"] as? String
        country = dictionary["country"] as? String
        costOfService = dictionary["CostOfService"] as? String
        emailInstruction = dictionary["EmailInstruction"] as? String
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        title = dictionary["title"] as? String
        start_date = dictionary["start_date"] as? String
        end_date = dictionary["end_date"] as? String
        description = dictionary["description"] as? String
        appcanmsgfcus = dictionary["Appcanmsgfcus"] as? String
        userID = dictionary["UserID"] as? Int
        serviceName = dictionary["ServiceName"] as? Int
        serviceProvider = dictionary["ServiceProvider"] as? Int
        cid = dictionary["cid"] as? Int
        location_radio = dictionary["Location_radio"] as? String
        accepted = dictionary["Accepted"] as? String
        sync = dictionary["sync"] as? Int
        client_phone = dictionary["client_phone"] as? String
        phonenumber = dictionary["phonenumber"] as? String
        username = dictionary["username"] as? String
        userimg = dictionary["userimg"] as? String
        user_firstname = dictionary["User_firstname"] as? String
        user_lastname = dictionary["User_lastname"] as? String
        profileImg = dictionary["ProfileImg"] as? String
        client_firstname = dictionary["client_firstname"] as? String
        client_Lastname = dictionary["client_Lastname"] as? String
        client_email = dictionary["client_email"] as? String
        clientid = dictionary["clientid"] as? Int
        orderID = dictionary["OrderID"] as? Int
        invoiceNumber = dictionary["InvoiceNumber"] as? String
    }
}

struct RevenuReport {
    public var month : String?
    public var finalcost : Int?
    public var finalprice : String?
    public var totaltax : String?
    
    public init?(dictionary: NSDictionary) {
        month = dictionary["month"] as? String
        finalcost = dictionary["Finalcost"] as? Int
        finalprice = dictionary["finalprice"] as? String
        totaltax = dictionary["totaltax"] as? String
    }
}

struct ProductSalesReport {
    public var month : String?
    public var service : String?
    public var product : String?
    public var package : String?
    public var gift : String?
    public var allsum : String?
    
    public init?(dictionary: NSDictionary) {
        month = dictionary["month"] as? String
        service = dictionary["service"] as? String
        product = dictionary["Product"] as? String
        package = dictionary["Package"] as? String
        gift = dictionary["Gift"] as? String
        allsum = dictionary["allsum"] as? String
    }
}

struct RequestedEventList {
    public var id : Int?
    public var firstName : String?
    public var lastName : String?
    public var phone : String?
    public var email : String?
    public var eventDate : String?
    public var eventstatus : String?
    public var address : String?
    public var zip : String?
    public var city : String?
    public var state : String?
    public var country : String?
    public var costOfService : String?
    public var emailInstruction : String?
    public var datecreated : String?
    public var datelastupdated : String?
    public var createdfk : Int?
    public var updatedfk : Int?
    public var isactive : Int?
    public var title : String?
    public var start_date : String?
    public var end_date : String?
    public var description : String?
    public var appcanmsgfcus : String?
    public var userID : Int?
    public var serviceName : Int?
    public var serviceProvider : Int?
    public var cid : Int?
    public var location_radio : String?
    public var accepted : String?
    public var sync : Int?
    public var firstname : String?
    public var lastname : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        firstName = dictionary["FirstName"] as? String
        lastName = dictionary["LastName"] as? String
        phone = dictionary["Phone"] as? String
        email = dictionary["Email"] as? String
        eventDate = dictionary["EventDate"] as? String
        eventstatus = dictionary["eventstatus"] as? String
        address = dictionary["Address"] as? String
        zip = dictionary["Zip"] as? String
        city = dictionary["City"] as? String
        state = dictionary["State"] as? String
        country = dictionary["country"] as? String
        costOfService = dictionary["CostOfService"] as? String
        emailInstruction = dictionary["EmailInstruction"] as? String
        datecreated = dictionary["datecreated"] as? String
        datelastupdated = dictionary["datelastupdated"] as? String
        createdfk = dictionary["createdfk"] as? Int
        updatedfk = dictionary["updatedfk"] as? Int
        isactive = dictionary["isactive"] as? Int
        title = dictionary["title"] as? String
        start_date = dictionary["start_date"] as? String
        end_date = dictionary["end_date"] as? String
        description = dictionary["description"] as? String
        appcanmsgfcus = dictionary["Appcanmsgfcus"] as? String
        userID = dictionary["UserID"] as? Int
        serviceName = dictionary["ServiceName"] as? Int
        serviceProvider = dictionary["ServiceProvider"] as? Int
        cid = dictionary["cid"] as? Int
        location_radio = dictionary["Location_radio"] as? String
        accepted = dictionary["Accepted"] as? String
        sync = dictionary["sync"] as? Int
        firstname = dictionary["firstname"] as? String
        lastname = dictionary["lastname"] as? String
    }
}

struct ShowReminderData {
    public var id : Int?
    public var message : String?
    public var repeatDay : String?
    public var createdfk : Int?
    public var datecreated : String?
    public var dateupdated : String?
    
    public init?(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        message = dictionary["Message"] as? String
        repeatDay = dictionary["RepeatDay"] as? String
        createdfk = dictionary["createdfk"] as? Int
        datecreated = dictionary["datecreated"] as? String
        dateupdated = dictionary["dateupdated"] as? String
    }
}

struct ShowSaleProfitGraphData {
    public var month : String?
    public var finalcost : String?
    public var finalprise : String?
    public var totaltax : String?
    
    public init?(dictionary: [String:Any]) {
        month = dictionary["month"] as? String
        finalcost = dictionary["Finalcost"] as? String
        finalprise = dictionary["finalprise"] as? String
        totaltax = dictionary["totaltax"] as? String
    }
}

struct Overview {
    let name: String
    let actualamt: Float
    let discount: Float
    let totalsales: Float
    var tax: Float?
    
    init(dict: [String:Any]) {
        self.name = dict["name"] as? String ?? ""
        self.actualamt = dict["actualamt"] as? Float ?? 0.00
        self.discount = dict["discount"] as? Float ?? 0.00
        self.totalsales = dict["totalsales"] as? Float ?? 0.00
        self.tax = dict["tax"] as? Float ?? 0.00
    }
    
    init(name: String, actualamt: Float, discount: Float, totalsales: Float) {
        self.name = name
        self.actualamt = actualamt
        self.discount = discount
        self.totalsales = totalsales
    }
    
    init(name: String, actualamt: Float, discount: Float, totalsales: Float, tax: Float) {
        self.name = name
        self.actualamt = actualamt
        self.discount = discount
        self.totalsales = totalsales
        self.tax = tax
    }
}

struct SalesGraph {
    let month: String
    let Service: String
    let Product: String
    let Package: String
    let Gift: String
    let allsum: String
    
    init(dict: [String:Any]) {
        self.month = dict["month"] as? String ?? ""
        self.Service = dict["Service"] as? String ?? ""
        self.Product = dict["Product"] as? String ?? ""
        self.Package = dict["Package"] as? String ?? ""
        self.Gift = dict["Gift"] as? String ?? ""
        self.allsum = dict["allsum"] as? String ?? ""
    }
}

struct EventLineChart {
    let month: String
    let count: String
    
    init(dict: [String:Any]) {
        self.month = dict["month"] as? String ?? ""
        self.count = dict["count"] as? String ?? ""
    }
}

struct EventPieChart {
    let eventstatus: String
    let eventcount: Int
    
    init(dict: [String:Any]) {
        self.eventstatus = dict["eventstatus"] as? String ?? ""
        self.eventcount = dict["eventcount"] as? Int ?? 0
    }
}

struct WorkingHoursData {
    let Day: String
    let Status: String
    let starttime: String
    let endtime: String
    
    init(dict: [String:Any]) {
        self.Day = dict["Day"] as? String ?? ""
        self.Status = dict["Status"] as? String ?? ""
        self.starttime = dict["starttime"] as? String ?? ""
        self.endtime = dict["endtime"] as? String ?? ""
    }
    
    init(day: String, status: String, Starttime: String, Endtime: String) {
        self.Day = day
        self.Status = status
        self.starttime = Starttime
        self.endtime = Endtime
    }
}

struct BlockTime {
    let Customdate: String
    let starttime: String
    let endtime: String
    
    init(dict: [String:Any]) {
        self.Customdate = dict["Customdate"] as? String ?? ""
        self.starttime = dict["starttime"] as? String ?? ""
        self.endtime = dict["endtime"] as? String ?? ""
    }
}
