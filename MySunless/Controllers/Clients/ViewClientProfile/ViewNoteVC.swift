//
//  ViewNoteVC.swift
//  MySunless
//
//  Created by Daydream Soft on 30/03/22.
//

import UIKit
import Alamofire

class ViewNoteVC: UIViewController {
    
    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var lblNoteDetail: UILabel!
    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_top: UIView!
    
    var token = String()
    var arrViewNote = [ViewNote]()
    var selectedNoteId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callViewNoteAPI(noteId: selectedNoteId)
    }
    
    func setInitially() {
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func callViewNoteAPI(noteId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["noteid": noteId]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + VIEW_NOTE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? NSDictionary {
                            if let noteTitle = response.value(forKey: "noteTitle") as? String {
                                self.lbltitle.text = noteTitle
                            }
                            if let noteDetail = response.value(forKey: "noteDetail") as? String {
                                self.lblNoteDetail.setHTMLFromString(htmlText: noteDetail)
                                self.lblNoteDetail.textColor = UIColor.init("#6D778E")
                                self.lblNoteDetail.font = UIFont(name: "Roboto-Regular", size: 17)
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    }
                }
            }
        }
    }
   
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
