//
//  ExportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 06/07/22.
//

import UIKit
import Alamofire
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

class ExportVC: UIViewController {

    @IBOutlet weak var btnFilterview: UIView!
    @IBOutlet weak var exportColview: UICollectionView!
    
    var arrExport = [ClientAction]()
    var token = String()
    var userID = Int()
    var downloadPdfUrl = String()
    let googleDriveService = GTLRDriveService()
    var googleUser: GIDGoogleUser?
    var uploadFolderID: String?
    private let scopes = [kGTLRAuthScopeDrive,kGTLRAuthScopeDriveFile,kGTLRAuthScopeDriveAppdata]
    private let service = GTLRDriveService()
    var documentdireactoyPath : URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        userID = UserDefaults.standard.value(forKey: "userid") as? Int ?? 0
        arrExport = [ClientAction(title: "Excel", image: UIImage(named: "excel") ?? UIImage()), ClientAction(title: "Google", image: UIImage(named: "google") ?? UIImage()), ClientAction(title: "One Drive", image: UIImage(named: "icloud") ?? UIImage()), ClientAction(title: "DropBox", image: UIImage(named: "dropbox") ?? UIImage())]
        exportColview.register(UINib(nibName: "ImporttExportCell", bundle: nil), forCellWithReuseIdentifier: "ImporttExportCell")
        
        callExportClientSheetAPI()
    }
    
    func saveCSVfile(isNotNotify : Bool? = false) {
     //   let url = downloadPdfUrl.appending(".csv")
        let url = downloadPdfUrl
        let fileName = downloadPdfUrl.components(separatedBy: "/").last ?? "0000"
        saveCSV(urlString: url, fileName: fileName,isNotNotify :isNotNotify)
    }
    
    func saveCSV(urlString:String, fileName:String, isNotNotify: Bool? = false) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(fileName)"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            self.documentdireactoyPath = actualPath
            if isNotNotify! {
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("File Saved Location:\(actualPath)")
                } catch {
                    AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "csv not saved")
                }
            } else {
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("File Saved Location:\(actualPath)")
                    AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "csv successfully saved")
                } catch {
                    AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "csv not saved")
                }
            }
        }
    }
    
    func initGoogle () {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().clientID = google_ClientID
        GIDSignIn.sharedInstance()?.scopes = scopes
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func uploadFile(name: String,fileURL: URL,mimeType: String,service: GTLRDriveService) {
        let file = GTLRDrive_File()
        file.name = name
        let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
           print("\(totalBytesUploaded)")
        }
         service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
             AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "export data successfully")
            // Successful upload if no error is returned.
        }
    }
    
    func uploadMyFile() {
         let fileURL = self.documentdireactoyPath
         let fileName = downloadPdfUrl.components(separatedBy: "/").last ?? "0000"
        let date = Date().description.doubleValue
         uploadFile(
            name: "MySunless_\(date).csv",
            fileURL: fileURL!,
            mimeType: "text/csv",
            service: googleDriveService)
    }
    
   func callExportClientSheetAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["id": userID]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + EXPORT_CLIENT_SHEET, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let successs = res.value(forKey: "successs") as? Int {
                    if successs == 1 {
                        if let ExcelSheetLink = res.value(forKey: "ExcelSheetLink") as? String {
                            self.downloadPdfUrl = ExcelSheetLink
                            self.saveCSVfile(isNotNotify:true)
                        }
                    } else {
                        
                    }
                }
            }
        }
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        
    }
    
}

extension ExportVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrExport.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = exportColview.dequeueReusableCell(withReuseIdentifier: "ImporttExportCell", for: indexPath) as! ImporttExportCell
        cell.lblName.text = arrExport[indexPath.row].title
        cell.imgView.image = arrExport[indexPath.row].image
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (exportColview.frame.size.width-20) / 2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            saveCSVfile()
        case 1:
            initGoogle()
        default:
            print("Default")
        }
    }
}

extension ExportVC : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
                    // Include authorization headers/values with each Drive API request.
                    self.googleDriveService.authorizer = user.authentication.fetcherAuthorizer()
                    self.googleUser = user
                    uploadMyFile()
                } else {
                    self.googleDriveService.authorizer = nil
                    self.googleUser = nil
                }
    }
    
    
}
