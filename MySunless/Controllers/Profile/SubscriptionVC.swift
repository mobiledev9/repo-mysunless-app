////
////  SubscriptionVC.swift
////  MySunless
////
////  Created by Daydream Soft on 08/06/22.
////
//
import UIKit
import Alamofire

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

    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        self.hideKeyboardWhenTappedAround()
        callSubscriptionsListAPI()
        
        tblSubscription.isHidden = true
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
                            for dic in response {
                                self.arrSubscription.append(SubscriptionList.init(dict: dic))
                            }
                            self.filterdata = self.arrSubscription
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
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionPackageVC") as! SubscriptionPackageVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        self.present(VC, animated: true, completion: nil)
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
