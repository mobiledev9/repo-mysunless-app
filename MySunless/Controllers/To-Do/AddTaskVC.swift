//
//  AddTaskVC.swift
//  MySunless
//
//  Created by Daydream Soft on 24/06/22.
//

import UIKit
import iOSDropDown
import ColorPalette
import Alamofire

class AddTaskVC: UIViewController {
    
    @IBOutlet weak var vw_main: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_bottom: UIView!
    @IBOutlet weak var vw_innerbottom: UIView!
    @IBOutlet weak var vw_title: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var vw_desc: UIView!
    @IBOutlet weak var txtVwDesc: UITextView!
    @IBOutlet weak var vw_dueDate: UIView!
    @IBOutlet weak var txtDuedate: UITextField!
    @IBOutlet weak var vw_datePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var vw_datePickerHeight: NSLayoutConstraint!    //200
    @IBOutlet weak var vw_assign: UIView!
    @IBOutlet weak var txtAssign: DropDown!
    @IBOutlet weak var assignColview: UICollectionView!
    @IBOutlet weak var lblAssign: UILabel!
    @IBOutlet weak var lblRadioColorPicker: UILabel!
    @IBOutlet weak var colorStackView: UIStackView!
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var colorPalette: ColorPaletteView!
    @IBOutlet weak var btnAddTask: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    //  var arrColors = ["#0062ff", "#DB2828", "#21BA45", "#ebb30a", "#000000", "#F2711C", "#00B5AD", "#0062ff", "#6435C9", "#A333C8", "#E03997"]
    
    var arrColors: [UIColor] = [UIColor.init("#0062ff"),UIColor.init("#DB2828"),UIColor.init("#21BA45"),UIColor.init("#ebb30a"),UIColor.init("#000000"),UIColor.init("#F2711C"),UIColor.init("#00B5AD"),UIColor.init("#6435C9"),UIColor.init("#A333C8"),UIColor.init("#E03997")]
    var token = String()
    var arrEmployee = [EmployeeList]()
    var arrEmployeeName = [String]()
    var arrEmployeeIds = [Int]()
    var selectedEmployeeId = Int()
    
    var arrSelectedEmpName = [String]()
    var arrSelectedEmpId = [String]()
    var categoryId = Int()
    var selectedHexColor = String()
    var delegate: ToDoProtocol?
    var selectedTaskId = Int()
    var isEdit = false
    var model = NSDictionary()
    var userId = Int()
    var isTodoCat = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userId = UserDefaults.standard.value(forKey: "userid") as? Int ?? 0
        if isEdit {
            if categoryId == 1 {
                assignColview.isHidden = true
                txtAssign.isUserInteractionEnabled = false
                vw_assign.backgroundColor = UIColor.init("#D4D4D4")
                txtAssign.text = "Self"
                arrSelectedEmpId.append("\(userId)")
                btnAddTask.setTitle("Update Task", for: .normal)
                lblMainTitle.text = "Update Task"
                let colorcode = model.value(forKey: "colorcode") as? String ?? ""
                vw_top.backgroundColor = UIColor.init(colorcode)
                selectedColorView.backgroundColor = UIColor.init(colorcode)
                selectedHexColor = colorcode
                txtTitle.text = model.value(forKey: "todoTitle") as? String
                txtVwDesc.text = model.value(forKey: "todoDesc") as? String
                txtVwDesc.textColor = UIColor.black
                let date = model.value(forKey: "newduedate") as? String
                txtDuedate.text = AppData.sharedInstance.formattedDateFromString(dateFormat: "MM dd, yyyy", dateString: date ?? "", withFormat: "dd/MM/yyyy")
            } else {
                btnAddTask.setTitle("Update Task", for: .normal)
                lblMainTitle.text = "Update Task"
                let colorcode = model.value(forKey: "colorcode") as? String ?? ""
                vw_top.backgroundColor = UIColor.init(colorcode)
                selectedColorView.backgroundColor = UIColor.init(colorcode)
                selectedHexColor = colorcode
                txtTitle.text = model.value(forKey: "todoTitle") as? String
                txtVwDesc.text = model.value(forKey: "todoDesc") as? String
                txtVwDesc.textColor = UIColor.black
                let date = model.value(forKey: "newduedate") as? String
                txtDuedate.text = AppData.sharedInstance.formattedDateFromString(dateFormat: "MM dd, yyyy", dateString: date ?? "", withFormat: "dd/MM/yyyy")
                var arrUseData = [Usedata]()
                let usedata = model.value(forKey: "usedata") as? [[String:Any]] ?? []
                for dict in usedata {
                    arrUseData.append(Usedata(dict: dict))
                }
                for dic in arrUseData {
                    arrSelectedEmpId.append("\(dic.id)")
                    arrSelectedEmpName.append(dic.firstname + " " + dic.lastname)
                }
                if arrSelectedEmpId.contains("\(userId)") {
                    for (index, _) in arrSelectedEmpId.enumerated() {
                        if arrSelectedEmpId[index] == "\(userId)" {
                            arrSelectedEmpName[index] = "Self"
                        }
                    }
                }
                callShowEmployeesAPI()
            }
        } else {
            if categoryId == 1 {
                assignColview.isHidden = true
                txtAssign.isUserInteractionEnabled = false
                vw_assign.backgroundColor = UIColor.init("#D4D4D4")
                txtAssign.text = "Self"
                arrSelectedEmpId.append("\(userId)")
                btnAddTask.setTitle("Add Task", for: .normal)
                lblMainTitle.text = "Add Task"
            } else {
                btnAddTask.setTitle("Add Task", for: .normal)
                lblMainTitle.text = "Add Task"
                callShowEmployeesAPI()
            }
        }
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
        vw_title.layer.borderWidth = 0.5
        vw_title.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_desc.layer.borderWidth = 0.5
        vw_desc.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_dueDate.layer.borderWidth = 0.5
        vw_dueDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_datePicker.layer.borderWidth = 0.5
        vw_datePicker.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_assign.layer.borderWidth = 0.5
        vw_assign.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_datePicker.isHidden = true
        txtVwDesc.text = "Enter Task Description..."
        txtVwDesc.textColor = UIColor.init("#B3B3B4")
        txtVwDesc.delegate = self
        
        colorPalette?.delegate = self
        colorPalette?.dataSource = self
        colorPalette?.reloadPalette()
        
        colorPalette.columnCount = 5
        colorPalette.horizontalSpacing = 20
        
        selectedColorView?.layer.borderWidth = 1
        selectedColorView?.layer.borderColor = ColorPaletteItemViewOptions.default.borderColor.cgColor
        selectedColorView?.layer.cornerRadius = ColorPaletteItemViewOptions.default.cornerRadius
        selectedColorView?.backgroundColor = UIColor.init("#0062ff")
        vw_top?.backgroundColor = UIColor.init("#0062ff")
        selectedHexColor = "#0062ff"
        assignColview.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: nil)
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        assignColview?.addGestureRecognizer(tap)
        
    }
    
    func setValidation() -> Bool {
        if txtTitle.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter title", viewController: self)
        } else if txtVwDesc.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter description", viewController: self)
        } else if txtDuedate.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select date", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func setAssignDropdown() {
        arrEmployeeName = arrEmployee.map{ $0.firstName + " " + $0.lastName }
        arrEmployeeName[0] = "Self"
        arrEmployeeIds = arrEmployee.map{ $0.id }
        arrEmployeeIds[0] = userId
        txtAssign.optionArray = arrEmployeeName
        txtAssign.optionIds = arrEmployeeIds
        txtAssign.didSelect { selectedText, index, id in
            self.assignColview.isHidden = false
            if !self.arrSelectedEmpId.contains("\(id)") {
                self.arrSelectedEmpId.append("\(id)")
                self.arrSelectedEmpName.append(selectedText)
            }
            self.assignColview.reloadData()
        }
        if arrSelectedEmpName.count != 0 {
            assignColview.isHidden = false
        }
        self.assignColview.reloadData()
    }
    
    func callShowEmployeesAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_EMPLOYEE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
                AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                    AppData.sharedInstance.dismissLoader()
                }
                return
            }
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrEmployee.removeAll()
                            for dict in response {
                                self.arrEmployee.append(EmployeeList.init(dict: dict))
                            }
                            self.setAssignDropdown()
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrEmployee.removeAll()
                        }
                    }
                }
            }
        }
     }
    
    func callAddTaskAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        var assignTo = String()
        if arrEmployeeIds.count == 1 {
            assignTo = arrSelectedEmpId[0]
        } else {
            assignTo = arrSelectedEmpId.joined(separator: ",")
        }
        if isEdit {
            params = ["categoryId": categoryId,
                      "taskId": selectedTaskId,
                      "todoTitle": txtTitle.text ?? "",
                      "todoDescription": txtVwDesc.text ?? "",
                      "dueDate": AppData.sharedInstance.formattedDateFromString(dateFormat: "dd/MM/yyyy", dateString: txtDuedate.text ?? "", withFormat: "yyyy-MM-dd") ?? "",
                      "assignTo": assignTo,
                      "color": selectedHexColor
            ]
        } else {
            params = ["categoryId": categoryId,
                      "todoTitle": txtTitle.text ?? "",
                      "todoDescription": txtVwDesc.text ?? "",
                      "dueDate": AppData.sharedInstance.formattedDateFromString(dateFormat: "dd/MM/yyyy", dateString: txtDuedate.text ?? "", withFormat: "yyyy-MM-dd") ?? "",
                      "assignTo": assignTo,
                      "color": selectedHexColor
            ]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_TASK, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
                                self.dismiss(animated: true) {
                                    self.delegate?.callShowAllTodoCategory()
                                }
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
                                self.dismiss(animated: true) {
                                    self.delegate?.callShowAllTodoCategory()
                                }
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
    
    @IBAction func btnDatepickerClick(_ sender: UIButton) {
        if sender.isSelected {
            vw_datePicker.isHidden = true
            lblAssign.isHidden = false
            vw_assign.isHidden = false
            lblRadioColorPicker.isHidden = false
            colorStackView.isHidden = false
        } else {
            vw_datePicker.isHidden = false
            lblAssign.isHidden = true
            vw_assign.isHidden = true
            lblRadioColorPicker.isHidden = true
            colorStackView.isHidden = true
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtDuedate.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func btnAddTaskClick(_ sender: UIButton) {
        if setValidation() {
            callAddTaskAPI()
        }
    }
    
    @objc func closeUserCellClick(_ sender: UIButton) {
        arrSelectedEmpName.remove(at: sender.tag)
        arrSelectedEmpId.remove(at: sender.tag)
        assignColview.reloadData()
    }
    
}

extension AddTaskVC: ColorPaletteViewDataSource {
    func colorPalette(_ colorPalette: ColorPaletteView, colorAt index: Int) -> UIColor? {
        if index >= arrColors.endIndex {
            return nil
        }
        return arrColors[index]
    }
}

extension AddTaskVC: ColorPaletteViewDelegate {
    func colorPalette(_ colorPalette: ColorPaletteView, didSelect color: UIColor, at index: Int) {
        // print("color at \(index) selected")
        selectedColorView?.backgroundColor = color
        vw_top.backgroundColor = color
        
        switch index {
        case 0:
            selectedHexColor = "#0062ff"
        case 1:
            selectedHexColor = "#DB2828"
        case 2:
            selectedHexColor = "#21BA45"
        case 3:
            selectedHexColor = "#ebb30a"
        case 4:
            selectedHexColor = "#000000"
        case 5:
            selectedHexColor = "#F2711C"
        case 6:
            selectedHexColor = "#00B5AD"
        case 7:
            selectedHexColor = "#6435C9"
        case 8:
            selectedHexColor = "#A333C8"
        case 9:
            selectedHexColor = "#E03997"
        default:
            selectedHexColor = "#0062ff"
        }
    }
}

extension AddTaskVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSelectedEmpName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = assignColview.dequeueReusableCell(withReuseIdentifier: "UserFilterCell", for: indexPath) as! UserFilterCell
        cell.cellView.layer.cornerRadius = 8
        cell.lblName.text = arrSelectedEmpName[indexPath.item]
        cell.btnClose.tag = indexPath.item
        cell.btnClose.addTarget(self, action: #selector(closeUserCellClick(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        txtAssign.showList()
    }
}

extension AddTaskVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        label.text = arrSelectedEmpName[indexPath.item]
        label.sizeToFit()

        let cellWidth = Int(label.frame.width + 40)
        let cellHeight = 38

        return CGSize(width: cellWidth, height: cellHeight)
    }
}      

extension AddTaskVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtVwDesc.textColor == UIColor.init("#B3B3B4") {
            txtVwDesc.text = ""
            txtVwDesc.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtVwDesc.text == "" {
            txtVwDesc.text = "Enter Task Description..."
            txtVwDesc.textColor = UIColor.init("#B3B3B4")
        }
    }
}

extension AddTaskVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: assignColview)
        if let indexPath = assignColview?.indexPathForItem(at: point),
           let cell = assignColview?.cellForItem(at: indexPath) {
            return touch.location(in: cell).y > 50
        }
        txtAssign.showList()
        return false
    }
}
