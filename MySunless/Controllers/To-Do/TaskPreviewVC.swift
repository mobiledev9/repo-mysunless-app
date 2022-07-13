//
//  TaskPreviewVC.swift
//  MySunless
//
//  Created by Daydream Soft on 11/07/22.
//

import UIKit
import Alamofire

class TaskPreviewVC: UIViewController {

    @IBOutlet weak var vw_main: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_bottom: UIView!
    @IBOutlet weak var vw_contentBottom: UIView!
    @IBOutlet weak var heightContentBottomVw: NSLayoutConstraint!    //840
    
    @IBOutlet weak var vw_title: UIView!
    @IBOutlet weak var heightTitleVw: NSLayoutConstraint!      //110
    @IBOutlet weak var btnEditTitle: UIButton!
    @IBOutlet weak var vw_textTitle: UIView!
    @IBOutlet weak var heightTxtTitleVw: NSLayoutConstraint!      //40
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnTickTitle: UIButton!
    @IBOutlet weak var btnCloseTitle: UIButton!
    
    @IBOutlet weak var vw_desc: UIView!
    @IBOutlet weak var heightDescVw: NSLayoutConstraint!   //145
    @IBOutlet weak var btnEditDesc: UIButton!
    @IBOutlet weak var vw_txtDesc: UIView!
    @IBOutlet weak var heightTxtDescVw: NSLayoutConstraint!    //80
    @IBOutlet weak var txtVwDesc: UITextView!
    @IBOutlet weak var btnTickDesc: UIButton!
    @IBOutlet weak var btnCloseDesc: UIButton!
    
    @IBOutlet weak var vw_dueDate: UIView!
    @IBOutlet weak var heightDueDateVw: NSLayoutConstraint!      //110
    @IBOutlet weak var btnEditDueDate: UIButton!
    @IBOutlet weak var vw_txtDueDate: UIView!
    @IBOutlet weak var heightTxtDueDate: NSLayoutConstraint!       //40
    @IBOutlet weak var txtDueDate: UITextField!
    @IBOutlet weak var btnOpenDatePicker: UIButton!
    @IBOutlet weak var btnTickDueDate: UIButton!
    @IBOutlet weak var btnCloseDueDate: UIButton!
    
    //110 vw_activity
    @IBOutlet weak var switchActivity: UISwitch!
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var vw_comment: UIView!
    @IBOutlet weak var txtVwComment: UITextView!
    @IBOutlet weak var btnPostComment: UIButton!
    
    var taskId = Int()
    var token = String()
    var arrAssignTo = [AssignTo]()
    var arrCommentData = [CommentData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callViewTaskDetailAPI()
    }
    
    func setInitially() {
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        vw_textTitle.layer.borderWidth = 0.5
        vw_textTitle.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnTickTitle.layer.cornerRadius = 5
        btnCloseTitle.layer.cornerRadius = 5
        vw_txtDesc.layer.borderWidth = 0.5
        vw_txtDesc.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnTickDesc.layer.cornerRadius = 5
        btnCloseDesc.layer.cornerRadius = 5
        vw_txtDueDate.layer.borderWidth = 0.5
        vw_txtDueDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnTickDueDate.layer.cornerRadius = 5
        btnCloseDueDate.layer.cornerRadius = 5
        btnOpenDatePicker.layer.cornerRadius = 5
        btnOpenDatePicker.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        vw_comment.layer.borderWidth = 0.5
        vw_comment.layer.borderColor = UIColor.init("#15B0DA").cgColor
        switchActivity.set(width: 50.0, height: 20.0)
        btnPostComment.layer.cornerRadius = 5
        txtVwComment.text = "Write a comment..."
        txtVwComment.textColor = UIColor.init("#B3B3B4")
        txtVwComment.delegate = self
    }
    
    func callViewTaskDetailAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["task_id": taskId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + VIEW_TASK_DETAIL, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let taskdetail = res.value(forKey: "taskdetail") as? NSDictionary {
                            if let colorcode = taskdetail.value(forKey: "colorcode") as? String {
                                self.vw_top.backgroundColor = UIColor.init(colorcode)
                            }
                            if let todoTitle = taskdetail.value(forKey: "todoTitle") as? String {
                                self.txtTitle.text = todoTitle
                            }
                            if let todoDesc = taskdetail.value(forKey: "todoDesc") as? String {
                                self.txtVwDesc.text = todoDesc
                            }
                            if let dueDate = taskdetail.value(forKey: "dueDate") as? String {
                                self.txtDueDate.text = AppData.sharedInstance.formattedDateFromString(dateFormat: "yyyy-MM-dd", dateString: dueDate, withFormat: "MMM dd, yyyy")
                            }
                        }
                        if let assignTo = res.value(forKey: "assignTo") as? [[String:Any]] {
                            self.arrAssignTo.removeAll()
                            for dict in assignTo {
                                self.arrAssignTo.append(AssignTo(dict: dict))
                            }
                            DispatchQueue.main.async {
                                
                            }
                        }
                        if let commentData = res.value(forKey: "commment data") as? [[String:Any]] {
                            self.arrCommentData.removeAll()
                            for dict in commentData {
                                self.arrCommentData.append(CommentData(dict: dict))
                            }
                            DispatchQueue.main.async {
                                
                            }
                        }
                    } else {
                        
                    }
                }
            }
        }
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEditTitleClick(_ sender: UIButton) {
    }
    
    @IBAction func btnTickTitleClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCloseTitleClick(_ sender: UIButton) {
    }
    
    @IBAction func btnEditDescClick(_ sender: UIButton) {
    }
    
    @IBAction func btnTickDescClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCloseDescClick(_ sender: UIButton) {
    }
    
    @IBAction func btnEditDuedateClick(_ sender: UIButton) {
    }
    
    @IBAction func btnOpenDatePickerClick(_ sender: UIButton) {
    }
    
    @IBAction func btnTickDueDateClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCloseDueDateClick(_ sender: UIButton) {
    }
    
    @IBAction func switchActivityValueChanged(_ sender: UISwitch) {
    }
    
    @IBAction func btnPostCommentClick(_ sender: UIButton) {
    }
    
}

extension TaskPreviewVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtVwComment.textColor == UIColor.init("#B3B3B4") {
            txtVwComment.text = ""
            txtVwComment.textColor = UIColor.init("#6D778E")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtVwComment.text == "" {
            txtVwComment.text = "Write a comment..."
            txtVwComment.textColor = UIColor.init("#B3B3B4")
        }
    }
}
