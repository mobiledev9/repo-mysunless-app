//
//  ExportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 06/07/22.
//

import UIKit
import Alamofire

class ExportVC: UIViewController {

    @IBOutlet weak var tblExport: UITableView!
    
    var arrExport = [ClientAction]()
    var token = String()
    var userID = Int()
    var downloadPdfUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        userID = UserDefaults.standard.value(forKey: "userid") as? Int ?? 0
        arrExport = [ClientAction(title: "Excel", image: UIImage(named: "excel") ?? UIImage()), ClientAction(title: "Google", image: UIImage(named: "google") ?? UIImage()), ClientAction(title: "One Drive", image: UIImage(named: "icloud") ?? UIImage()), ClientAction(title: "DropBox", image: UIImage(named: "dropbox") ?? UIImage())]
        tblExport.register(UINib(nibName: "ImportExportCell", bundle: nil), forCellReuseIdentifier: "ImportExportCell")
        tblExport.tableFooterView = UIView()
        
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
}

extension ExportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrExport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblExport.dequeueReusableCell(withIdentifier: "ImportExportCell", for: indexPath) as! ImportExportCell
        cell.lblName.text = arrExport[indexPath.row].title
        cell.imgview.image = arrExport[indexPath.row].image
        return cell
    }
}

extension ExportVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveCSVfile()
    }
}
