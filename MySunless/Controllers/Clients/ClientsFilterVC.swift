//
//  ClientsFilterVC.swift
//  MySunless
//
//  Created by iMac on 17/03/22.
//

import UIKit
import iOSDropDown
import Alamofire

class ClientsFilterVC: UIViewController {

    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_chooseUser: UIView!
    @IBOutlet var txtChooseUser: DropDown!
    @IBOutlet weak var tblFilter: UITableView!
    @IBOutlet weak var userFilterColview: UICollectionView!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrChooseUser = [SubscriberAdminFilter]()
    var arrEmployeeFilter = [EmployeeFilterList]()
    
    var isFromAdminSubscriber = false
    var delegateAdmin: SubscriberProtocol?
    
    var arrCollectionUsers = [String]()
    var arrCollectionIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblFilter.register(UINib(nibName: "CustomFilterHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomFilterHeaderView")
        tblFilter.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        
        let dummyViewHeight = CGFloat(40)
        tblFilter.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tblFilter.bounds.size.width, height: dummyViewHeight))
        tblFilter.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        callGetUserForFilterAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  print(arrCollectionUsers)
        arrCollectionUsers = UserDefaults.standard.value(forKey: "arrCollectionUsers") as? [String] ?? []
        arrCollectionIds = UserDefaults.standard.value(forKey: "arrCollectionIds") as? [String] ?? []
        if arrCollectionUsers.count != 0 {
            userFilterColview.reloadData()
            userFilterColview.isHidden = false
        } else {
            userFilterColview.isHidden = true
        }
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vw_chooseUser.layer.borderWidth = 0.5
        vw_chooseUser.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblFilter.layer.borderWidth = 0.5
        tblFilter.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblFilter.layer.cornerRadius = 12
        tblFilter.isHidden = true
        tblFilter.tableFooterView = UIView()
        txtChooseUser.delegate = self
        
        let textViewRecognizer = UITapGestureRecognizer()
        textViewRecognizer.addTarget(self, action: #selector(detectTextfieldClick(_:)))
        txtChooseUser.addGestureRecognizer(textViewRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: nil)
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        userFilterColview?.addGestureRecognizer(tap)
        userFilterColview.isHidden = true
    }
    
    func countAdminFilterBadge() -> Int {
        if arrCollectionUsers.count == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    func callGetUserForFilterAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SUBSCRIBER_ADMINFILTER, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrChooseUser.removeAll()
                            for dict in response {
                                self.arrChooseUser.append(SubscriberAdminFilter(dict: dict))
                            }
                            DispatchQueue.main.async {
                                self.tblFilter.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        if isFromAdminSubscriber {
            UserDefaults.standard.set(arrCollectionUsers, forKey: "arrCollectionUsers")
            UserDefaults.standard.set(arrCollectionIds, forKey: "arrCollectionIds")
            let filterBadgeCount = countAdminFilterBadge()
            delegateAdmin?.callSubscriberListAPI(isFilter: true, userId: arrCollectionIds.joined(separator: ","), filterBadgeCount: filterBadgeCount)
          //  self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnResetClick(_ sender: UIButton) {
        if isFromAdminSubscriber {
            txtChooseUser.text = ""
            arrCollectionUsers.removeAll()
            arrCollectionIds.removeAll()
            UserDefaults.standard.removeObject(forKey: "arrCollectionUsers")
            UserDefaults.standard.removeObject(forKey: "arrCollectionIds")
            userFilterColview.isHidden = true
            let filterBadgeCount = countAdminFilterBadge()
            delegateAdmin?.callSubscriberListAPI(isFilter: true, userId: arrCollectionIds.joined(separator: ","), filterBadgeCount: filterBadgeCount)
        }
    }
    
    @objc func closeUserCellClick(_ sender: UIButton) {
        arrCollectionUsers.remove(at: sender.tag)
        arrCollectionIds.remove(at: sender.tag)
        userFilterColview.reloadData()
    }
    
    @objc func detectTextfieldClick(_ sender: UITapGestureRecognizer) {
        if tblFilter.isHidden {
            tblFilter.isHidden = false
        } else {
            tblFilter.isHidden = true
        }
    }
}

extension ClientsFilterVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrChooseUser.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChooseUser[section].employee.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tblFilter.dequeueReusableHeaderFooterView(withIdentifier: "CustomFilterHeaderView") as! CustomFilterHeaderView
        headerView.lblTitle.text = arrChooseUser[section].user_name
        headerView.lblTitle.textColor = UIColor.init("#005CC8")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFilter.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as! SideMenuCell
        let model: NSDictionary = arrChooseUser[indexPath.section].employee[indexPath.row] as NSDictionary
        cell.titleLabel.text = model.value(forKey: "username") as? String ?? ""
        cell.adminFilterId = model.value(forKey: "id") as? Int ?? 0
        
        cell.iconImageLeadingConstraint.constant = 0
        cell.iconImageView.isHidden = true
        cell.expandImageView.isHidden = true
        cell.vw_lock.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tblFilter.cellForRow(at: indexPath) as! SideMenuCell
        let user = cell.titleLabel.text ?? ""
        let id = cell.adminFilterId
        
        if !arrCollectionUsers.contains(user) {
            arrCollectionUsers.append(user)
            arrCollectionIds.append("\(id)")
            userFilterColview.isHidden = false
            userFilterColview.reloadData()
        }
        tblFilter.isHidden = true
//        if arrCollectionUsers.count != 0 {
//            userFilterColview.isHidden = false
//            userFilterColview.reloadData()
//        }
    }
    
}

extension ClientsFilterVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtChooseUser.resignFirstResponder()
        return true
    }
}

extension ClientsFilterVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: userFilterColview)
        if let indexPath = userFilterColview?.indexPathForItem(at: point),
           let cell = userFilterColview?.cellForItem(at: indexPath) {
            return touch.location(in: cell).y > 50
        }
        if tblFilter.isHidden {
            tblFilter.isHidden = false
        } else {
            tblFilter.isHidden = true
        }
        return false
    }
}

//MARK:- CollectionView Methods
extension ClientsFilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCollectionUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userFilterColview.dequeueReusableCell(withReuseIdentifier: "UserFilterCell", for: indexPath) as! UserFilterCell
        cell.cellView.layer.cornerRadius = 8
        cell.lblName.text = arrCollectionUsers[indexPath.item]
        cell.btnClose.tag = indexPath.item
        cell.btnClose.addTarget(self, action: #selector(closeUserCellClick(_:)), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        label.text = arrCollectionUsers[indexPath.item]
        label.sizeToFit()

        let cellWidth = Int(label.frame.width + 40)
        let cellHeight = 38

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tblFilter.isHidden {
            tblFilter.isHidden = false
        } else {
            tblFilter.isHidden = true
        }
    }
}

