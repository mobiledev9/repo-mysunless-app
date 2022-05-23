//
//  ClientDetailVC.swift
//  MySunless
//
//  Created by Daydream Soft on 19/03/22.
//

import UIKit
import Alamofire
import Kingfisher

class ClientDetailVC: UIViewController {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnVisit: UIButton!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblCreatedDate: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var lblZipCode: UILabel!
    @IBOutlet var lblTotalSpent: UILabel!
    @IBOutlet var lblGiftCardBalance: UILabel!
    @IBOutlet var vw_address: UIView!
    @IBOutlet var vw_map: UIView!
 //   @IBOutlet var mapView: MKMapView!
    @IBOutlet var lblNoOfAppBooked: UILabel!
    @IBOutlet var vw_clientDetails: UIView!
    @IBOutlet var vw_otherDetails: UIView!
    @IBOutlet var address: UILabel!
    @IBOutlet var addressWidth: NSLayoutConstraint!
    @IBOutlet var vw_addressHeight: NSLayoutConstraint!
    
    var selectedId = Int()
    var token = String()
    var modelEditClient = ClientList(dict: [:])
    var mapAddress = String()
    var streetaddress = String()
    var city = String()
    var zip = String()
    var state = String()
    var country = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callViewClientInfoAPI(id: selectedId)
    }
    
    func setInitially() {
        vw_clientDetails.layer.borderWidth = 0.5
        vw_clientDetails.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_map.layer.borderWidth = 0.5
        vw_map.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_otherDetails.layer.borderWidth = 0.5
        vw_otherDetails.layer.borderColor = UIColor.init("#15B0DA").cgColor
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
    }
    
    func callViewClientInfoAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["clientid": id]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ALL_CLIENTS, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? NSDictionary {
                                if let profileimg = response.value(forKey: "ProfileImg") as? String {
                                    if let imgUrl = URL(string: profileimg) {
                                        self.imgView.kf.setImage(with: imgUrl)
                                    }
                                }
                                if let fname = response.value(forKey: "FirstName") as? String {
                                    if let lname = response.value(forKey: "LastName") as? String {
                                        self.lblCustomerName.text = fname.capitalized + " " + lname.capitalized
                                    }
                                }
                                if let phone = response.value(forKey: "Phone") as? String {
                                    self.lblPhoneNumber.text = phone
                                }
                                if let email = response.value(forKey: "email") as? String {
                                    self.lblEmail.text = email
                                }
                                if let createdDate = response.value(forKey: "datecreated") as? String {
                                    self.lblCreatedDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: createdDate)
                                }
                                if let address = response.value(forKey: "Address") as? String {
                                    self.streetaddress = address
                                    self.lblAddress.text = address
                                }
                                if let city = response.value(forKey: "City") as? String {
                                    self.city = city
                                    self.lblCity.text = city
                                }
                                if let state = response.value(forKey: "State") as? String {
                                    self.state = state
                                    self.lblState.text = state
                                }
                                if let country = response.value(forKey: "Country") as? String {
                                    self.country = country
                                    self.lblCountry.text = country
                                }
                                if let zip = response.value(forKey: "Zip") as? String {
                                    self.zip = zip
                                    self.lblZipCode.text = zip
                                }
                                if let totalevent = response.value(forKey: "totalevent") as? Int {
                                    self.lblNoOfAppBooked.text = "\(totalevent)"
                                }
                                if let totalOrderAmount = response.value(forKey: "TotalOrderAmount") as? Int {
                                    self.lblTotalSpent.text = "$\(totalOrderAmount)"
                                }
                                if let gbalance = response.value(forKey: "gbalance") as? Int {
                                    self.lblGiftCardBalance.text = "$\(gbalance)"
                                }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnEditProfileClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
        VC.isFromClientDetail = true
        VC.selectedClientDetailID = selectedId
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnVisitProfileClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewClientProfileVC") as! ViewClientProfileVC
        VC.selectedID = selectedId
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMap(_ sender: UIButton) {
        mapAddress = streetaddress + "," + city + "," + zip + "," + state + "," + country
     //   var mapAddress = "7720 autumn lane, loomis, California, 95650, null"
        let testURL: NSURL = NSURL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(testURL as URL) {
            if let address = mapAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                let directionsRequest: String = "comgooglemaps-x-callback://" + "?daddr=\(address)" + "&x-success=sourceapp://?resume=true&x-source=AirApp"
                let directionsURL: NSURL = NSURL(string: directionsRequest)!
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(directionsURL as URL)) {
                    application.open(directionsURL as URL, options: [:], completionHandler: nil)
                }
            }
        } else {
            NSLog("Can't use comgooglemaps-x-callback:// on this device.")
            AppData.sharedInstance.showAlert(title: "Error", message: "Google maps not installed", viewController: self)
        }
    }
    
}

 
