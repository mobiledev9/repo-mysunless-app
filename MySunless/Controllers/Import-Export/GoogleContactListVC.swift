//
//  GoogleContactListVC.swift
//  MySunless
//
//  Created by dds on 09/11/22.
//

import UIKit
import Alamofire
import GoogleSignIn
import GoogleAPIClientForREST

class GoogleContactListVC: UIViewController {
    @IBOutlet var btnImgCheckAll: UIButton!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblClientList: UITableView!
    
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var btnSignIn: UIButton!
    //MARK:- Variable Declarations
    var token = String()
    var arrClients = [GoogleClientList]()
    var filterdata = [GoogleClientList]()
    var searching = false
    var model = ClientList(dict: [:])
    var arrSelectedIds = [String]()
    var isCheckAll = false
    private var accessToken: String?
    private let scopes = [kGTLRAuthScopePeopleServiceContactsReadonly]
    private let service = GTLRPeopleServiceService()
    var importContactCount = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSignIn.text = "SignOut"
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblClientList.tableFooterView = UIView()
       
        searchBar.delegate = self
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        self.hideKeyboardWhenTappedAround()
        tblClientList.refreshControl = UIRefreshControl()
        tblClientList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       // SVProgressHUD.setInfoImage(UIImage(named: "MySunless_Symbol")!)
        arrSelectedIds.removeAll()
        //callGetAllClientsAPI()
        searchBar.text = ""
    }
    
    //MARK:- User-defined Functions
    func filterContentForSearchText(_ searchText: String) {
        filterdata = arrClients.filter({ (client:GoogleClientList) -> Bool in
            let name = "\(client.contactName)" + " "
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let phone = client.phone
            let Phone = phone.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let email = client.email
            let Email = email.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Phone != nil || Email != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.fetchContacts()
            self.tblClientList.refreshControl?.endRefreshing()
            self.tblClientList.reloadData()
        }
    }
    func callMultipleSaveCustomer(tag : Int = 0,isLast :Bool? = true ) {
      
        var gData: GoogleClientList?
        if searching {
            gData = filterdata[tag]
        } else {
            gData = arrClients[tag]
        }
      
        let gName = gData?.contactName ?? ""
        let gPhone = gData?.phone == "" ? "--" : gData?.phone ?? "--"
        let gMail = gData?.email == "" ? "\(gData?.contactName)1@gmail.com": gData?.email ?? "--"
        let gImage = gData?.profileUrl
        
        callSaveCustomerAPI(name : gName,
                            phone : gPhone,
                            email : gMail,
                            imageUrl: gImage ?? "",
                            isMultiple: isLast)
        
    }
    
    func callSaveCustomerAPI(name: String,phone: String,email : String, imageUrl : String,isMultiple : Bool? = false) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        var params = NSDictionary()
        let arrName = name.components(separatedBy: " ")
        params = ["firstname" :arrName.first,
                  "lastname" : arrName.last ?? "--",
                  "phone" :phone ?? "--" ,
                  "email" : email ?? "--",
                  ]
       // let clientImg: UIImage = image ?? UIImage()
        guard let url = URL(string:imageUrl) else { return }
        let data = try? Data(contentsOf: url)

        guard let imageData = data else { return }
        
       // let imageData = clientImg.pngData()
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + SAVE_CLIENT, keyName: "clientimage", imageData: imageData, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if (success == "1") {
                        if  isMultiple! {
                            self.importContactCount = self.importContactCount + 1
                            
                        } else {
                            if let message = res.value(forKey: "response") as? String {
                                AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {

                                }
                            }
                        }
                        
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignOut(_ sender: UIButton) {
        initGoogle()
   }
    
    @IBAction func btnSelectAll(_ sender: UIButton) {
    
    }
   
    @IBAction func btnSaveAllContact(_ sender: Any) {
        for i in 0 ..< arrClients.count - 1 { 
            let tag = i
            if i == arrClients.count - 1 {
                callMultipleSaveCustomer(tag: tag, isLast: true)
            }
            callMultipleSaveCustomer(tag:tag)
           
        }
    }
    
    @IBAction func btnCheckAllImgClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("square.fill") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            isCheckAll = true
            for dic in arrClients {
                arrSelectedIds.append("\(dic.contactName)")
            }
        } else {
            sender.setImage(UIImage(systemName: "square.fill"), for: .normal)
            isCheckAll = false
            arrSelectedIds.removeAll()
        }
        tblClientList.reloadData()
    }
    
    
    @IBAction func btnSaveSingleContact(_ sender: UIButton) {
        let  tag = sender.tag
        callMultipleSaveCustomer(tag :tag)
       
    }
    

}
//MARK:- TableView Delegate and Datasource Methods
extension GoogleContactListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterdata.count
        } else {
            return arrClients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblClientList.dequeueReusableCell(withIdentifier: "GoogleClientListCell", for: indexPath) as! GoogleClientListCell
        if searching {
            cell.modelGoogleContact = filterdata[indexPath.row]
        } else {
            cell.modelGoogleContact = arrClients[indexPath.row]
        }
        cell.setCell(index: indexPath.row, isCheckAll: isCheckAll)
        cell.parent = self
        cell.btnSave.tag = indexPath.row
        return cell
    }
}

extension GoogleContactListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if searching {
//            showClientProfileVC(id: filterdata[indexPath.row].id)
//        } else {
//            showClientProfileVC(id: arrClients[indexPath.row].id)
//        }
    }
}

extension GoogleContactListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                filterdata = arrClients
            }
            tblClientList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblClientList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension GoogleContactListVC : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Google sign in error: \(String(describing: error.localizedDescription))")
            return
        }
        btnSignIn.setTitle("SignOut", for: .normal)
        guard let authentication = user.authentication else { return }
        self.accessToken = authentication.accessToken
        fetchContacts()
    }
}

//MARK:- Import google data function
extension GoogleContactListVC {
    
    func fetchContacts(pageSize:Int? = 20) {
 let query = GTLRPeopleServiceQuery_PeopleConnectionsList.query(withResourceName: "people/me")
    let formattedToken = String(format: "Bearer %@", self.accessToken!)
    let headers = ["Authorization": formattedToken, "3.0": "GData-Version"]
    query.additionalHTTPHeaders = headers
    query.personFields = "names,emailAddresses,photos,phoneNumbers,externalIds,memberships"
    query.pageSize = pageSize! //max
    service.shouldFetchNextPages = true
    service.executeQuery(
        query,
        delegate: self,
        didFinish: #selector(getCreatorFromTicket(ticket:finishedWithObject:error:)))
}

@objc func getCreatorFromTicket(
    ticket: GTLRServiceTicket,
    finishedWithObject response: GTLRPeopleService_ListConnectionsResponse,
    error: NSError?) {

    if let error = error {
        print("error: \(error.localizedDescription)")
        AppData.sharedInstance.showAlert(title: "Error", message: error.localizedDescription, viewController: self)
       // showAlert(title: "Error", message: error.localizedDescription)
        return
    }

    if let connections = response.connections, !connections.isEmpty {
      //  AppData.sharedInstance.showAlert(title: "Sucess", message: "you have \(connections.count)", viewController: self)
        self.arrClients.removeAll()
        for connection in connections {
            var displayName : String? = ""
            var emailAddress : String? = ""
            var photoUrl : String? = ""
            var phoneNumber : String? = ""
          
            if let names = connection.names, !names.isEmpty {
                for name in names {
                    if let _ = name.metadata?.primary {
                        displayName = name.displayName
                        print(name.displayName ?? "")
                    }
                }
            }
            if let emailAddresses = connection.emailAddresses, !emailAddresses.isEmpty {
                for email in emailAddresses {
                        if let _ = email.metadata?.primary {
                            emailAddress = email.value
                    print(email.value ?? "")
                    }
                }
            }
            if let photos = connection.photos, !photos.isEmpty {
                for photo in photos {
                    if let _ = photo.metadata?.primary {
                        photoUrl = photo.url
                        print(photo.url ?? "")
                    }
                }
            }
            
            if let phones = connection.phoneNumbers, !phones.isEmpty {
                for phone in phones {
                    if let _ = phone.metadata?.primary {
                        phoneNumber = phone.value
                    }
                }
            }
            let  gData = GoogleClientList(contactName: displayName!, phone: phoneNumber!, email: emailAddress!, profileUrl: photoUrl!)
            self.arrClients.append(gData)
        }
       tblClientList.reloadData()
        
         }
}
    
    func initGoogle() {
        var configureError: NSError?
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        GIDSignIn.sharedInstance().clientID = google_ClientID
        GIDSignIn.sharedInstance().scopes =  ["https://www.googleapis.com/auth/user.phonenumbers.read",
             "https://www.googleapis.com/auth/contacts.readonly",
             "https://www.googleapis.com/auth/contacts"]
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}
