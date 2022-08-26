////
////  SubscriptionVC.swift
////  MySunless
////
////  Created by Daydream Soft on 08/06/22.
////
//
import UIKit
import Alamofire
import SwiftyStoreKit

protocol SubscriptionInfoProtocol {
    func viewInvoice()
}

class SubscriptionVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var btnBuySubscription: UIButton!
    @IBOutlet weak var vw_searchbar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblSubscription: UITableView!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrSubscription = [SubscriptionList]()
    var filterdata = [SubscriptionList]()
    var searching = false
    var arrPendingSubscription = [SubscriptionList]()

    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        hideKeyboardWhenTappedAround()
        callSubscriptionsListAPI()
        tblSubscription.refreshControl = UIRefreshControl()
        tblSubscription.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_searchbar.layer.borderWidth = 0.5
        vw_searchbar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchbar.layer.cornerRadius = 5.0
        searchBar.delegate = self
    }

    func callSubscriptionsListAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess" ) {
            AppData.sharedInstance.showAlert(title: "No Network Found!", message: "Please check your internet connection.", viewController: self)
            return
        }
        APIUtilities.sharedInstance.GetDictAPICallWith(url: BASE_URL + SUBSCRIPTIONS_LIST, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrSubscription.removeAll()
                            for dic in response {
                                self.arrSubscription.append(SubscriptionList.init(dict: dic))
                            }
                            self.filterdata = self.arrSubscription
                            self.arrPendingSubscription = self.arrSubscription.filter{ $0.status == "Pending" }
                            
                        }
                        DispatchQueue.main.async {
                            self.tblSubscription.reloadData()
                        }
                    }
                }
            }
        }
    }

    func filterContentForSearchText(_ searchText: String) {
        filterdata = arrSubscription.filter({ (subscription:SubscriptionList) -> Bool in
            let invoiceid = subscription.InvoiceID
            let invoice = invoiceid.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let packagename = subscription.PackageType
            let name = packagename.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let amount = subscription.amount
            let Amount = amount.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let dateofbuy = subscription.paytime
            let DateOfBuy = dateofbuy.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let dateofexpire = subscription.packend
            let DateOfExpire = dateofexpire.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let paymenttype = subscription.PaymentType
            let PaymentType = paymenttype.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let status = subscription.status
            let Status = status.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return invoice != nil || name != nil || Amount != nil || DateOfBuy != nil || DateOfExpire != nil || PaymentType != nil || Status != nil
        })
    }

    //MARK:- Actions
    @IBAction func btnBuySubscriptionClick(_ sender: UIButton) {
//        if arrPendingSubscription.count == 1 {
//            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "You already have one pending subscription. Once it activates, you can buy another package.")
//        } else if arrPendingSubscription.count == 0 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionPackageVC") as! SubscriptionPackageVC
            VC.modalTransitionStyle = .crossDissolve
            VC.modalPresentationStyle = .overCurrentContext
            VC.arrActiveSubscription = arrSubscription.filter{ $0.status == "Active" }
            self.present(VC, animated: true, completion: nil)
//        }
    }
    
    @IBAction func btnEndSubscriptionClick(_ sender: UIButton) {
       // itms-apps://apps.apple.com/account/subscriptions
       if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @objc func callPullToRefresh() {
        DispatchQueue.main.async {
            self.callSubscriptionsListAPI()
            self.tblSubscription.refreshControl?.endRefreshing()
            self.tblSubscription.reloadData()
        }
    }
}

//MARK:- UITableView Datasource Methods
extension SubscriptionVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterdata.count
        } else {
            return arrSubscription.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSubscription.dequeueReusableCell(withIdentifier: "SubscriptionInfoCell", for: indexPath) as! SubscriptionInfoCell
        if searching {
            cell.model = filterdata[indexPath.row]
        } else {
            cell.model = arrSubscription[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

//MARK:- UITableView Delegate Methods
extension SubscriptionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- UISearchbar Delegate Methods
extension SubscriptionVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                filterdata = arrSubscription
            }
            tblSubscription.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblSubscription.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension SubscriptionVC: SubscriptionInfoProtocol {
    func viewInvoice() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceVC") as! InvoiceVC
        
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        self.present(VC, animated: true, completion: nil)
    }
    
    
}
