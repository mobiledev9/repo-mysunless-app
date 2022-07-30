//
//  ExportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 06/07/22.
//

import UIKit
import Alamofire

class ExportVC: UIViewController {

    @IBOutlet weak var btnFilterview: UIView!
    @IBOutlet weak var exportColview: UICollectionView!
    
    var arrExport = [ClientAction]()
    var token = String()
    var userID = Int()
    var downloadPdfUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        userID = UserDefaults.standard.value(forKey: "userid") as? Int ?? 0
        arrExport = [ClientAction(title: "Excel", image: UIImage(named: "excel") ?? UIImage()), ClientAction(title: "Google", image: UIImage(named: "google") ?? UIImage()), ClientAction(title: "One Drive", image: UIImage(named: "icloud") ?? UIImage()), ClientAction(title: "DropBox", image: UIImage(named: "dropbox") ?? UIImage())]
        exportColview.register(UINib(nibName: "ImporttExportCell", bundle: nil), forCellWithReuseIdentifier: "ImporttExportCell")
        
        callExportClientSheetAPI()
    }
    
    func saveCSVfile() {
     //   let url = downloadPdfUrl.appending(".csv")
        let url = downloadPdfUrl
        let fileName = downloadPdfUrl.components(separatedBy: "/").last ?? "0000"
        saveCSV(urlString: url, fileName: fileName)
    }
    
    func saveCSV(urlString:String, fileName:String) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(fileName)"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("File Saved Location:\(actualPath)")
                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "csv successfully saved")
            } catch {
                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "csv not saved")
            }
        }
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
            if let url = URL(string: "https://accounts.google.com/o/oauth2/auth/oauthchooseaccount?response_type=code&redirect_uri=https%3A%2F%2Fmysunless.com%2Fcrm%2Fgdrive%2F&client_id=462951383589-nfmd0m40bcf8tg31pg7sm1in9ucu9s04.apps.googleusercontent.com&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&access_type=offline&approval_prompt=force&flowName=GeneralOAuthFlow") {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        default:
            print("Default")
        }
    }
}
