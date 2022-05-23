//
//  OverviewVC.swift
//  MySunless
//
//  Created by iMac on 22/02/22.
//

import UIKit
import Alamofire

class OverviewVC: UIViewController {
    
//    @IBOutlet var vw_searchbar: UIView!
//    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblOverview: UITableView!
    @IBOutlet var txtVwImportant: UITextView!
    
    var token = String()
    var arrCompletedOrder = [ShowCompletedOrder]()
    var arrOverview = [Overview]()
  //  var arrFilterOverview = [Overview]()
  //  var searching = false
    
    var arrServicePrice = [String]()
    var arrProductPrice = [String]()
    var arrMembershipPrice = [String]()
    var arrIntServicePrice = [Float]()
    var arrIntProductPrice = [Float]()
    var arrIntMembershipPrice = [Float]()
    var arrGiftPrice = [String]()
    var arrFloatGiftPrice = [Float]()
    
    var arrServiceDisount = [String]()
    var arrProductDisount = [String]()
    var arrMembershipDisount = [String]()
    var arrIntServiceDisount = [Float]()
    var arrIntProductDisount = [Float]()
    var arrIntMembershipDisount = [Float]()
    var arrGiftDisount = [String]()
    var arrFloatGiftDisount = [Float]()
    
    var arrServiceTotal = [String]()
    var arrProductTotal = [String]()
    var arrMembershipTotal = [String]()
    var arrIntServiceTotal = [Float]()
    var arrIntProductTotal = [Float]()
    var arrIntMembershipTotal = [Float]()
    var arrGiftTotal = [String]()
    var arrFloatGiftTotal = [Float]()
    
    var arrProductTax = [String]()
    var arrFloatProductTax = [Float]()
    
    var arrTips = [Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        tblOverview.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
      //  searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowCompletedOrderAPI()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
//        vw_searchbar.layer.borderWidth = 0.5
//        vw_searchbar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        
        let attributedString = NSMutableAttributedString.init(string: txtVwImportant.text)
        let range = (txtVwImportant.text as NSString).range(of: "Important:")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init("#005CC8"), range: range)
        let range1 = (txtVwImportant.text as NSString).range(of: "Sub-Total column's data exclude tips, Gift-Card applied.")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init("#6D778E"), range: range1)
        txtVwImportant.attributedText = attributedString
        txtVwImportant.font = UIFont(name: "Roboto-Regular", size: 16)
        txtVwImportant.textAlignment = .justified
        txtVwImportant.isUserInteractionEnabled = true
        txtVwImportant.isEditable = false
    }
    
    func callShowCompletedOrderAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_COMPLETED_ORDER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let resonse = res.value(forKey: "resonse") as? [[String:Any]] {
                            self.arrCompletedOrder.removeAll()
                            for dict in resonse {
                                self.arrCompletedOrder.append(ShowCompletedOrder(dict: dict))
                            }
                            self.setValues(array: self.arrCompletedOrder)
                        }
                    } else {
                        if let resonse = res.value(forKey: "resonse") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: resonse, viewController: self)
                            self.arrCompletedOrder.removeAll()
                        }
                    }
                }
            }
        }
    }
    
    func setValues(array: [ShowCompletedOrder]) {
        for i in self.arrCompletedOrder {
            self.arrServicePrice.append(contentsOf: i.ServicePrice.components(separatedBy: ","))
            self.arrProductPrice.append(contentsOf: i.ProductPrice.components(separatedBy: ","))
            self.arrMembershipPrice.append(contentsOf: i.MembershipPrice.components(separatedBy: ","))
            self.arrGiftPrice.append(contentsOf: i.gServicePrice.components(separatedBy: ","))
            self.arrProductTax.append(contentsOf: i.ProductTaxPrice.components(separatedBy: ","))
            self.arrServiceDisount.append(contentsOf: i.ServiceDiscount.components(separatedBy: ","))
            self.arrProductDisount.append(contentsOf: i.ProductDiscount.components(separatedBy: ","))
            self.arrMembershipDisount.append(contentsOf: i.MembershipDiscount.components(separatedBy: ","))
            self.arrGiftDisount.append(contentsOf: i.gServiceDiscount.components(separatedBy: ","))
            self.arrServiceTotal.append(contentsOf: i.ServiceFianlPrice.components(separatedBy: ","))
            self.arrProductTotal.append(contentsOf: i.ProductFianlPrice.components(separatedBy: ","))
            self.arrMembershipTotal.append(contentsOf: i.MembershipFianlPrice.components(separatedBy: ","))
            self.arrGiftTotal.append(contentsOf: i.gServiceFianlPrice.components(separatedBy: ","))
            self.arrTips.append(i.tips.floatValue() ?? 0.00)
        }
        
        self.arrIntServicePrice = self.arrServicePrice.map{(Float($0) ?? 0.00)}
        self.arrIntProductPrice = self.arrProductPrice.map{(Float($0) ?? 0.00)}
        self.arrFloatProductTax = self.arrProductTax.map{(Float($0) ?? 0.00)}
        self.arrIntMembershipPrice = self.arrMembershipPrice.map{(Float($0) ?? 0.00)}
        self.arrFloatGiftPrice = self.arrGiftPrice.map{(Float($0) ?? 0.00)}
        self.arrIntServiceDisount = self.arrServiceDisount.map{(Float($0) ?? 0.00)}
        self.arrIntProductDisount = self.arrProductDisount.map{(Float($0) ?? 0.00)}
        self.arrIntMembershipDisount = self.arrMembershipDisount.map{(Float($0) ?? 0.00)}
        self.arrFloatGiftDisount = self.arrGiftDisount.map{(Float($0) ?? 0.00)}
        self.arrIntServiceTotal = self.arrServiceTotal.map{(Float($0) ?? 0.00)}
        self.arrIntProductTotal = self.arrProductTotal.map{(Float($0) ?? 0.00)}
        self.arrIntMembershipTotal = self.arrMembershipTotal.map{(Float($0) ?? 0.00)}
        self.arrFloatGiftTotal = self.arrGiftTotal.map{(Float($0) ?? 0.00)}
        
        let texte = "-"
        for i in 0...6 {
            switch i {
                case 0:
                    self.arrOverview.append(Overview(name: "Name", actualamt: 0.00, discount: 0.00, totalsales: 0.00))
                case 1:
                    self.arrOverview.append(Overview(name: "Service", actualamt: self.arrIntServicePrice.sum(), discount: self.arrIntServiceDisount.sum(), totalsales: self.arrIntServiceTotal.sum()))
                case 2:
                    self.arrOverview.append(Overview(name: "Product", actualamt: self.arrIntProductPrice.sum() + self.arrFloatProductTax.sum(), discount: self.arrIntProductDisount.sum(), totalsales: self.arrIntProductTotal.sum(), tax: self.arrFloatProductTax.sum()))
                case 3:
                    self.arrOverview.append(Overview(name: "Package", actualamt: self.arrIntMembershipPrice.sum(), discount: self.arrIntMembershipDisount.sum(), totalsales: self.arrIntMembershipTotal.sum()))
                case 4:
                    self.arrOverview.append(Overview(name: "Gift-Card", actualamt: self.arrFloatGiftPrice.sum(), discount: self.arrFloatGiftDisount.sum(), totalsales: self.arrFloatGiftTotal.sum()))
                case 5:
                    self.arrOverview.append(Overview(name: "Tips", actualamt: self.arrTips.sum(), discount: texte.floatValue() ?? 0.00, totalsales: self.arrTips.sum()))
                case 6:
                    self.arrOverview.append(Overview(name: "Total", actualamt: self.arrOverview.sum(\.actualamt), discount: self.arrOverview.sum(\.discount), totalsales: self.arrOverview.sum(\.totalsales)))
                default:
                    print("Default")
            }
        }
      //  self.arrFilterOverview = self.arrOverview
        DispatchQueue.main.async {
            self.tblOverview.reloadData()
        }
    }
    
  /*  func filterContentForSearchText(_ searchText: String) {
        arrFilterOverview = arrOverview.filter({ (overview: Overview) -> Bool in
            let name = overview.name
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            var actualAmt = String()
            if overview.tax == nil {
                actualAmt = "$" + String(format: "%.02f", overview.actualamt)
            } else {
                let tax = " ($" + String(format: "%.02f", overview.tax ?? 0.00) + " TAX)"
                actualAmt = "$" + String(format: "%.02f", overview.actualamt) + tax
            }
            let ActualAmt = actualAmt.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            var discount = String()
            if overview.actualamt == 0.00 {
                discount = "$" + String(format: "%.02f", overview.discount)
            } else {
                discount = "$" + String(format: "%.02f", overview.discount) + "(applied)"
            }
            let Discount = discount.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let totalsales = "$" + String(format: "%.02f", overview.totalsales)
            let TotalSales = totalsales.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || ActualAmt != nil || Discount != nil || TotalSales != nil
        })
    }        */
}

//MARK:- TableView Delegate and Datasource Methods
extension OverviewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searching {
//            return arrFilterOverview.count
//        } else {
            return arrOverview.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOverview.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as! OverviewCell
//        if searching {
//            cell.model = arrFilterOverview[indexPath.row]
//        } else {
            cell.model = arrOverview[indexPath.row]
//        }
        cell.setCell(index: indexPath.row)
        
        return cell
    }
}

extension OverviewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

////MARK:- SearchBar Delegate Methods
//extension OverviewVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if let searchText = searchBar.text {
//            filterContentForSearchText(searchText)
//            searching = true
//            if searchText == "" {
//                arrFilterOverview = arrOverview
//            }
//            tblOverview.reloadData()
//        }
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searching = false
//        searchBar.text = ""
//        tblOverview.reloadData()
//        searchBar.resignFirstResponder()
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.searchBar.endEditing(true)
//        searchBar.resignFirstResponder()
//    }
//}
