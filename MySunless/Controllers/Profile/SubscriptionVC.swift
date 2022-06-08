////
////  SubscriptionVC.swift
////  MySunless
////
////  Created by Daydream Soft on 08/06/22.
////
//
import UIKit
//import Alamofire

class SubscriptionVC: UIViewController {

//    @IBOutlet var btnSubscription: UIButton!
//    @IBOutlet var vw_subscription: UIView!
//    @IBOutlet var searchBar: UISearchBar!
//    @IBOutlet var subscriptionTblview: UITableView!
//    @IBOutlet var vw_invoiceSection: UIView!
//    
//    var token = String()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setInitially()
//
//        subscriptionTblview.register(UINib(nibName: "SubscriptionListCell", bundle: nil), forCellReuseIdentifier: "SubscriptionListCell")
//        subscriptionTblview.register(UINib(nibName: "SubscriptionDataCell", bundle: nil), forCellReuseIdentifier: "SubscriptionDataCell")
//
//        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
//
//        self.hideKeyboardWhenTappedAround()
//        callSubscriptionsListAPI()
//    }
//
//    func setInitially() {
//        subscriptionTblview.layer.borderColor = UIColor.init("005CC8").cgColor
//        subscriptionTblview.layer.borderWidth = 0.5
//       // subscriptionTblview.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 8.0)
//        vw_invoiceSection.layer.borderColor = UIColor.init("005CC8").cgColor
//        vw_invoiceSection.layer.borderWidth = 0.5
//       // vw_invoiceSection.roundCorners(corners: [.topLeft,.topRight], radius: 8.0)
//    }
//
//    func callSubscriptionsListAPI() {
//        AppData.sharedInstance.showLoader()
//
//        let headers: HTTPHeaders = ["Authorization":token]
//        print(headers)
//
////        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess" ) {
////            AppData.sharedInstance.showAlert(title: "No Network Found!", message: "Please check your internet connection.", viewController: self)
////            return
////        }
//
//        APIUtilities.sharedInstance.GetArrayAPICallWith(url: BASE_URL + SUBSCRIPTIONS_LIST, header: headers) { (response, error) in
//            AppData.sharedInstance.dismissLoader()
//            print(response ?? "")
//
//            if let res = response as? [[String:Any]] {
//                for dict in res {
//                   // let invoiceID = dict["InvoiceID"] as? String ?? ""
//                    self.arrSubscription.append(SubscriptionList.init(dict: dict))
//                    self.filterdata = self.arrSubscription
//                  //  self.arrData.append(dict)
//                }
//
//            }
//
//            DispatchQueue.main.async {
//                self.subscriptionTblview.reloadData()
//            }
//
//        }
//
//    }
//
//    func filterContentForSearchText(_ searchText: String) {
//        filterdata = arrSubscription.filter({ (subscription:SubscriptionList) -> Bool in
//            let invoiceid = "\(subscription.invoiceID)"
//            let invoice = invoiceid.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
//            let packagename = subscription.packageType
//            let name = packagename.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
//            return invoice != nil || name != nil
//        })
//    }
//
//    @IBAction func btnBuySubscriptionClick(_ sender: UIButton) {
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionPackageVC") as! SubscriptionPackageVC
//        VC.modalTransitionStyle = .crossDissolve
//        VC.modalPresentationStyle = .overCurrentContext
//        self.present(VC, animated: true, completion: nil)
////        self.navigationController?.pushViewController(VC, animated: true)
//    }
//
//    @objc func headerViewTapped(tapped:UITapGestureRecognizer) {
//        if searching {
//            if filterdata[tapped.view!.tag].collapsed == true {
//                filterdata[tapped.view!.tag].collapsed = false
//            } else {
//                filterdata[tapped.view!.tag].collapsed = true
//            }
//            if let imView = tapped.view?.subviews[1] as? UIImageView {
//                if imView.isKind(of: UIImageView.self) {
//                    if filterdata[tapped.view!.tag].collapsed {
//                        imView.image = UIImage(named: "minus")
//                    } else {
//                        imView.image = UIImage(named: "plus")
//                    }
//                }
//            }
//        } else {
//            if arrSubscription[tapped.view!.tag].collapsed == true {
//                arrSubscription[tapped.view!.tag].collapsed = false
//            } else {
//                arrSubscription[tapped.view!.tag].collapsed = true
//            }
//            if let imView = tapped.view?.subviews[1] as? UIImageView {
//                if imView.isKind(of: UIImageView.self) {
//                    if arrSubscription[tapped.view!.tag].collapsed {
//                        imView.image = UIImage(named: "minus")
//                    } else {
//                        imView.image = UIImage(named: "plus")
//                    }
//                }
//            }
//        }
//        self.searchBar.searchTextField.endEditing(true)
//        subscriptionTblview.reloadData()
//    }
}
//
//extension SubscriptionVC : UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//            if searching {
//                return filterdata.count
//            } else {
//                return arrSubscription.count
//            }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            if searching {
//                let itms = filterdata[section]
//                return !itms.collapsed ? 0 : 1
//            } else {
//                let itms = arrSubscription[section]
//                return !itms.collapsed ? 0 : 1
//            }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = subscriptionTblview.dequeueReusableCell(withIdentifier: "SubscriptionDataCell", for: indexPath) as! SubscriptionDataCell
//            if searching {
//                let model = filterdata[indexPath.section]
//                cell.lblAmount.text = "\(model.amount)"
//                cell.lblPurchaseDate.text = model.paytime
//                cell.lblExpirationDate.text = model.packend
//
//                if model.paymentType == "" {
//                    cell.lblPaymentType.text = "--"
//                } else {
//                    cell.lblPaymentType.text = model.paymentType
//                }
//
//                cell.lblStatus.text = model.status
//            } else {
//                let model = arrSubscription[indexPath.section]
//                cell.lblAmount.text = "\(model.amount)"
//                cell.lblPurchaseDate.text = model.paytime
//                cell.lblExpirationDate.text = model.packend
//
//                if model.paymentType == "" {
//                    cell.lblPaymentType.text = "--"
//                } else {
//                    cell.lblPaymentType.text = model.paymentType
//                }
//
//                cell.lblStatus.text = model.status
//            }
//            return cell
//    }
//}
//
//extension SubscriptionVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 45
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 240
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            let headerCell = subscriptionTblview.dequeueReusableCell(withIdentifier: "SubscriptionListCell") as! SubscriptionListCell
//
//            if searching {
//                headerCell.lblInvoiceID.text = "\(filterdata[section].invoiceID)"
//                headerCell.lblPackageType.text = filterdata[section].packageType
//
//                if filterdata[section].collapsed {
//                    headerCell.expandImageView.image = UIImage(named: "minus")
//                } else {
//                    headerCell.expandImageView.image = UIImage(named: "plus")
//                }
//            } else {
//                headerCell.lblInvoiceID.text = "\(arrSubscription[section].invoiceID)"
//                headerCell.lblPackageType.text = arrSubscription[section].packageType
//
//                if arrSubscription[section].collapsed {
//                    headerCell.expandImageView.image = UIImage(named: "minus")
//                } else {
//                    headerCell.expandImageView.image = UIImage(named: "plus")
//                }
//            }
//
//            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
//            tapGuesture.numberOfTapsRequired = 1
//            headerCell.addGestureRecognizer(tapGuesture)
//            headerCell.tag = section
//
//            return headerCell
//    }
//}
//
//extension SubscriptionVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if let searchText = searchBar.text {
//            filterContentForSearchText(searchText)
//            searching = true
//            if searchText == "" {
//                filterdata = arrSubscription
//            }
//            subscriptionTblview.reloadData()
//        }
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searching = false
//        searchBar.text = ""
//        subscriptionTblview.reloadData()
//        searchBar.resignFirstResponder()
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.searchBar.endEditing(true)
//        searchBar.resignFirstResponder()
//    }
//}
