//
//  EventDetailVC.swift
//  MySunless
//
//  Created by Daydream Soft on 05/04/22.
//

import UIKit
import Kingfisher
import SCLAlertView
import Alamofire

//MARK:- Protocol
protocol AppointmentListProtocol {
    func callAppointmentList()
    
}

class EventDetailVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var optionCollectionView: UICollectionView!
    @IBOutlet var imgViewCustomer: UIImageView!
    @IBOutlet var imgViewServiceProvider: UIImageView!
    @IBOutlet var lblServiceProviderName: UILabel!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var lblAppointmentID: UILabel!
    @IBOutlet var lblCustomerNameInDetail: UILabel!
    @IBOutlet var lblServiceProviderNameInDetil: UILabel!
    @IBOutlet var lblService: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var btnStatusArray: [UIButton]!
    @IBOutlet var vw_Main: UIView!
    @IBOutlet var vw_Detail: UIView!
    
    //MARK:- Variable Declarations
    var appointment :ShowAppointmentList?
    var alertTitle = "Temporary Delete?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
    var token = String()
    var arrButtonText : [String] = ["pending", "pending-payment","in-progress","confirmed","canceled","completed"]
    var downloadPdfUrl : String = ""
    var arrOption : [UIImage] = [ UIImage(named: "sticky-note") ?? UIImage(),
                                  UIImage(systemName: "square.and.pencil") ?? UIImage(),
                                  UIImage(named: "delete (2)") ?? UIImage(),
                                  UIImage(systemName: "eye.fill") ?? UIImage(),
                                  UIImage(systemName: "printer.fill") ?? UIImage(),
                                  UIImage(named: "placeholder") ?? UIImage(),
                                  UIImage(named: "shopping-cart (1)") ?? UIImage()
    ]
    var delegate: AppointmentListProtocol?
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        setInitially()
        setView()
        calldownloadPdfAPI(id: appointment?.id ?? 00)
    }
    
    //MARK:- User-Defined Functions
    func setInitially() {
        vw_Main.layer.borderWidth = 1.0
        vw_Main.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Main.layer.cornerRadius = 5.0
        
        vw_Detail.layer.borderWidth = 1.0
        vw_Detail.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Detail.layer.cornerRadius = 5.0
        imgViewCustomer.layer.cornerRadius = imgViewCustomer.frame.size.height / 2
        imgViewServiceProvider.layer.cornerRadius = imgViewServiceProvider.frame.size.height / 2
    }
    
    func saveInvoicePdf() {
        let url = downloadPdfUrl.appending(".pdf")
        let fileName = downloadPdfUrl.components(separatedBy: "/").last ?? "0000"
        savePdf(urlString: url, fileName: fileName)
    }
    
    func savePdf(urlString: String, fileName: String) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("File Saved Location:\(actualPath)")
                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "pdf successfully saved")
            } catch {
                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "pdf not saved")
            }
        }
    }
    
    func setView() {
        let imgUrlCustomer = URL(string: self.appointment?.userimg ?? "" )
        imgViewCustomer.kf.setImage(with: imgUrlCustomer)
        lblCustomerName.text = (self.appointment?.client_firstname) ?? " " + " " + (self.appointment?.client_Lastname ?? " ")
        
        let imgUrlServiceProvider = URL(string: self.appointment?.profileImg ?? "")
        imgViewServiceProvider.kf.setImage(with: imgUrlServiceProvider)
        lblServiceProviderName.text = (self.appointment?.username)!
        
        lblAppointmentID.text = "\(self.appointment?.id! ?? 000)"
        lblCustomerNameInDetail.text = (self.appointment?.firstName ?? "") + " " + (self.appointment?.lastName ?? "")
        lblServiceProviderNameInDetil.text = (self.appointment?.username)!
        lblDateTime.text = self.appointment?.eventDate
        lblService.text = self.appointment?.title
        lblLocation.text = self.appointment?.location_radio
        setEventStatus(eventStatus:(self.appointment?.eventstatus!)!)
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            self.navigationController?.popViewController(animated: true)
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    //API
    func callDeleteEventAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_FROM_LIST, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func calldownloadPdfAPI(id:Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["OrderId": id]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DOWNLOAD_PDF, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            self.downloadPdfUrl = message
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callStatusChangeEventAPI(id:Int, status:String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id,
                  "status": status]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + Update_Event_Status, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                            
                        }
                    }
                }
            }
        }
    }
    
    func addDeleteAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deletePermanently(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func setEventStatus(eventStatus:String) {
        switch eventStatus.lowercased() {
        case "pending":
            setSelectedButton(index: 0)
            break
        case "pending-payment":
            setSelectedButton(index: 1)
            break
        case "in-progress":
            setSelectedButton(index: 2)
            break
        case "confirmed":
            setSelectedButton(index: 3)
            break
         case "canceled":
            setSelectedButton(index: 4)
            break
        case "completed":
            setSelectedButton(index: 5)
            break
        default:
            print("nothing")
        }
    }
    
    func setSelectedButton(index : Int) {
        for btn in btnStatusArray {
            if btn.tag == index {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
    }
    
    //MARK:- Actions
    @objc func deletePermanently(_ sender: UIButton) {
        callDeleteEventAPI(id:(appointment?.id)!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func UpdateEventStatusClick(_ sender: UIButton) {
        callStatusChangeEventAPI(id: (appointment?.id)!, status: arrButtonText[sender.tag])
        setSelectedButton(index : sender.tag)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShowClientDetailClick(_ sender: UIButton) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClientDetailVC") as! ClientDetailVC
        if let clientId = appointment?.clientid {
            VC.selectedId = clientId
        }
        navigationController?.pushViewController(VC, animated: true)
    }
    
}

//MARk:- UICollectionView Delegate and DataSource Methods
extension EventDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOption.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = optionCollectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as! OptionCell
        let img : UIImage =  arrOption[indexPath.item]
        cell.imgView.image = img
        cell.imgView.setImageColor(color: UIColor.init("#15B0DA"))
        cell.cellView.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (optionCollectionView.frame.width - 30.0)/3, height: (optionCollectionView.frame.height - 20.0)/3 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                //note
                let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteListVC") as! NoteListVC
                navigationController?.pushViewController(VC, animated: true)
                break
            case 1:
                //appointment
                let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookAppointmentVC") as! BookAppointmentVC
                navigationController?.pushViewController(VC, animated: true)
                break
            case 2:
                //delete
                addDeleteAlert()
                break
            case 3:
                //view client
                let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewClientProfileVC") as! ViewClientProfileVC
                if let clientId = appointment?.clientid {
                    VC.selectedID = clientId
                }
                navigationController?.pushViewController(VC, animated: true)
                break
            case 4:
                //print
                saveInvoicePdf()
                break
            case 5:
                //map view
                let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowMapVC") as! ShowMapVC
                var addressText = ""
                if let address = appointment?.address {
                    addressText = addressText.appending(address)
                }
                if let city = appointment?.city {
                    addressText = addressText.appending(",")
                    addressText = addressText.appending(city)
                }
                if let state = appointment?.state {
                    addressText = addressText.appending(",")
                    addressText = addressText.appending(state)
                }
                if let zip = appointment?.zip {
                    addressText = addressText.appending(",")
                    addressText = addressText.appending(zip)
                }
                if let country = appointment?.country {
                    addressText = addressText.appending(",")
                    addressText = addressText.appending(country)
                }
                
                VC.addressText = addressText
                self.present(VC, animated: true)
                
                break
            case 6:
                //book order
                let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddOrderVC") as! AddOrderVC
                navigationController?.pushViewController(VC, animated: true)
                break
            default:
                print()
        }
    }
}

//MARK:- UICollectionView Cell
class OptionCell: UICollectionViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var imgView: UIImageView!
}
