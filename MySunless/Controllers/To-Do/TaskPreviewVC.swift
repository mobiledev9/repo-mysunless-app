//
//  TaskPreviewVC.swift
//  MySunless
//
//  Created by Daydream Soft on 11/07/22.
//

import UIKit
import Alamofire
import Kingfisher

protocol TaskPreviewProtocol {
    func callAddOrUpdateCommentAPI(isEdit: Bool, commentId: Int?)
    func callDeleteCommentAPI(commentId: Int)
}

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
    @IBOutlet weak var vw_datePicker: UIView!
    @IBOutlet weak var heightDatePickerVw: NSLayoutConstraint!       //200
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtDueDate: UITextField!
    @IBOutlet weak var btnOpenDatePicker: UIButton!
    @IBOutlet weak var btnTickDueDate: UIButton!
    @IBOutlet weak var btnCloseDueDate: UIButton!
    
    @IBOutlet weak var vw_assignedUser: UIView!
    @IBOutlet weak var assignedUserColview: UICollectionView!
    
    //110 vw_activity
    @IBOutlet weak var switchActivity: UISwitch!
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var vw_comment: UIView!
    @IBOutlet weak var txtVwComment: UITextView!
    @IBOutlet weak var btnPostComment: UIButton!
    @IBOutlet weak var tblComments: UITableView!
    
    var taskId = Int()
    var token = String()
    var arrAssignTo = [AssignTo]()
    var arrCommentData = [CommentData]()
    var arrImgs = [String]()
    var arrUsername = [String]()
    var tittle = String()
    var desc = String()
    var dueDate = String()
    var delegate: ToDoProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideEditInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblComments.tableFooterView = UIView()
        tblComments.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
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
        
        txtTitle.isUserInteractionEnabled = false
        txtVwDesc.isUserInteractionEnabled = false
        txtDueDate.isUserInteractionEnabled = false
        btnTickTitle.layer.cornerRadius = 5
        btnCloseTitle.layer.cornerRadius = 5
        btnTickDesc.layer.cornerRadius = 5
        btnCloseDesc.layer.cornerRadius = 5
        btnTickDueDate.layer.cornerRadius = 5
        btnCloseDueDate.layer.cornerRadius = 5
        vw_datePicker.layer.borderWidth = 0.5
        vw_datePicker.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_datePicker.isHidden = true
        btnOpenDatePicker.layer.cornerRadius = 5
        btnOpenDatePicker.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        vw_comment.layer.borderWidth = 0.5
        vw_comment.layer.borderColor = UIColor.init("#15B0DA").cgColor
        switchActivity.set(width: 50.0, height: 20.0)
        btnPostComment.layer.cornerRadius = 5
        txtVwComment.text = "Write a comment..."
        txtVwComment.textColor = UIColor.init("#B3B3B4")
        txtVwComment.delegate = self
        btnPostComment.isHidden = true
        tblComments.isHidden = true
        imgActivity.layer.cornerRadius = imgActivity.frame.size.height / 2
    }
    
    func hideEditInitially() {
        btnTickTitle.isHidden = true
        btnCloseTitle.isHidden = true
        btnTickDesc.isHidden = true
        btnCloseDesc.isHidden = true
        btnTickDueDate.isHidden = true
        btnCloseDueDate.isHidden = true
        btnOpenDatePicker.isHidden = true
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
                            if let userimage = taskdetail.value(forKey: "userimage") as? String {
                                let imgUrl = URL(string: userimage)
                                self.imgActivity.kf.setImage(with: imgUrl)
                            }
                        }
                        if let assignTo = res.value(forKey: "assignTo") as? [[String:Any]] {
                            self.arrAssignTo.removeAll()
                            for dict in assignTo {
                                self.arrAssignTo.append(AssignTo(dict: dict))
                            }
                            self.arrImgs = self.arrAssignTo.map{ $0.user_image }
                            self.arrUsername = self.arrAssignTo.map{ $0.firstname + " " + $0.lastname }
                            DispatchQueue.main.async {
                                self.assignedUserColview.reloadData()
                            }
                        }
                        if let commentData = res.value(forKey: "commment data") as? [[String:Any]] {
                            self.arrCommentData.removeAll()
                            for dict in commentData {
                                self.arrCommentData.append(CommentData(dict: dict))
                            }
                            DispatchQueue.main.async {
                                self.tblComments.reloadData()
                            }
                        }
                    } else {
                        
                    }
                }
            }
        }
    }
    
    func callUpdatePreview() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["taskid": taskId,
                  "title": tittle,
                  "desc": desc,
                  "tododate": dueDate
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + UPDATE_PREVIEW_DATA, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.callShowAllTodoCategory()
        }
    }
    
    @IBAction func btnEditTitleClick(_ sender: UIButton) {
        btnTickTitle.isHidden = false
        btnCloseTitle.isHidden = false
        vw_textTitle.layer.borderWidth = 0.5
        vw_textTitle.layer.borderColor = UIColor.init("#15B0DA").cgColor
        txtTitle.isUserInteractionEnabled = true
    }
    
    @IBAction func btnTickTitleClick(_ sender: UIButton) {
        tittle = txtTitle.text ?? ""
        desc = ""
        dueDate = ""
        callUpdatePreview() 
    }
    
    @IBAction func btnCloseTitleClick(_ sender: UIButton) {
        btnTickTitle.isHidden = true
        btnCloseTitle.isHidden = true
        vw_textTitle.layer.borderWidth = 0
        txtTitle.isUserInteractionEnabled = false
    }
    
    @IBAction func btnEditDescClick(_ sender: UIButton) {
        btnTickDesc.isHidden = false
        btnCloseDesc.isHidden = false
        vw_txtDesc.layer.borderWidth = 0.5
        vw_txtDesc.layer.borderColor = UIColor.init("#15B0DA").cgColor
        txtVwDesc.isUserInteractionEnabled = true
    }
    
    @IBAction func btnTickDescClick(_ sender: UIButton) {
        desc = txtVwDesc.text ?? ""
        tittle = ""
        dueDate = ""
        callUpdatePreview()
    }
    
    @IBAction func btnCloseDescClick(_ sender: UIButton) {
        btnTickDesc.isHidden = true
        btnCloseDesc.isHidden = true
        vw_txtDesc.layer.borderWidth = 0
        txtVwDesc.isUserInteractionEnabled = false
    }
    
    @IBAction func btnEditDuedateClick(_ sender: UIButton) {
        btnTickDueDate.isHidden = false
        btnCloseDueDate.isHidden = false
        vw_txtDueDate.layer.borderWidth = 0.5
        vw_txtDueDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        txtDueDate.isUserInteractionEnabled = true
        btnOpenDatePicker.isHidden = false
    }
    
    @IBAction func btnOpenDatePickerClick(_ sender: UIButton) {
        if sender.isSelected {
            vw_datePicker.isHidden = true
            btnTickDueDate.isHidden = false
            btnCloseDueDate.isHidden = false
            vw_assignedUser.isHidden = false
        } else {
            vw_datePicker.isHidden = false
            btnTickDueDate.isHidden = true
            btnCloseDueDate.isHidden = true
            vw_assignedUser.isHidden = true
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        txtDueDate.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func btnTickDueDateClick(_ sender: UIButton) {
        dueDate = AppData.sharedInstance.formattedDateFromString(dateFormat: "MMM dd, yyyy", dateString: txtDueDate.text ?? "", withFormat: "yyyy-MM-dd") ?? ""
        tittle = ""
        desc = ""
        callUpdatePreview()
    }
    
    @IBAction func btnCloseDueDateClick(_ sender: UIButton) {
        btnTickDueDate.isHidden = true
        btnCloseDueDate.isHidden = true
        vw_txtDueDate.layer.borderWidth = 0
        txtDueDate.isUserInteractionEnabled = false
    }
    
    @IBAction func switchActivityValueChanged(_ sender: UISwitch) {
        if switchActivity.isOn {
            tblComments.isHidden = false
        } else {
            tblComments.isHidden = true
        }
    }
    
    @IBAction func btnPostCommentClick(_ sender: UIButton) {
        callAddOrUpdateCommentAPI(isEdit: false)
    }
    
}

extension TaskPreviewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = assignedUserColview.dequeueReusableCell(withReuseIdentifier: "TaskPreviewAssignedCell", for: indexPath) as! TaskPreviewAssignedCell
        let imgUrl = URL(string: arrImgs[indexPath.item])
        cell.imgUser.kf.setImage(with: imgUrl)
        cell.lblName.text = arrUsername[indexPath.item]
        return cell
    }
}

extension TaskPreviewVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtVwComment.textColor == UIColor.init("#B3B3B4") {
            txtVwComment.text = ""
            txtVwComment.textColor = UIColor.init("#6D778E")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if txtVwComment.text.isEmpty {
            btnPostComment.isHidden = true
        } else {
            btnPostComment.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtVwComment.text.isEmpty {
            txtVwComment.text = "Write a comment..."
            txtVwComment.textColor = UIColor.init("#B3B3B4")
        }
    }
}

extension TaskPreviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCommentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblComments.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.delegate = self
        cell.model = arrCommentData[indexPath.row]
        cell.setCell(index: indexPath.row)
        
        
//        let url = URL(string: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/vibrant-pink-and-white-summer-flowering-cosmos-royalty-free-image-1653499726.jpg?crop=0.66541xw:1xh;center,top&resize=480:*")
//        cell.imgProfile.kf.setImage(with: url)
//        cell.lblName.text = "Test"
//        cell.lblDate.text = "2022-07-16"
//        cell.txtComment.setHTMLFromString(htmlText: "again test comment")
        
        return cell
    }
}

extension TaskPreviewVC: TaskPreviewProtocol {
    func callAddOrUpdateCommentAPI(isEdit: Bool, commentId: Int?=nil) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if isEdit {
            params = ["comment": txtVwComment.text ?? "",
                      "todoid": taskId,
                      "cmtid": commentId ?? 0
            ]
        } else {
            params = ["comment": txtVwComment.text ?? "",
                      "todoid": taskId
            ]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + POST_COMMENT, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: response) {
                                self.callViewTaskDetailAPI()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: response) {
                                self.callViewTaskDetailAPI()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteCommentAPI(commentId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
            params = ["chat_id": commentId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_COMMENT, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: response) {
                                self.callViewTaskDetailAPI()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: response) {
                                self.callViewTaskDetailAPI()
                            }
                        }
                    }
                }
            }
        }
    }
}
