//
//  WorkingHoursCell.swift
//  MySunless
//
//  Created by iMac on 18/12/21.
//

import UIKit

class WorkingHoursCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var switchValue: UISwitch!
    @IBOutlet var lblDay: UILabel!
    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var txtTo: UITextField!
    
    var vc = WorkingHoursVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.borderColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        
        txtFrom.delegate = self
        txtTo.delegate = self
        
        if switchValue.isOn {
            cellView.layer.backgroundColor = UIColor.white.cgColor
            txtFrom.isUserInteractionEnabled = true
            txtTo.isUserInteractionEnabled = true
        } else {
            cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
            txtFrom.isUserInteractionEnabled = false
            txtTo.isUserInteractionEnabled = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if switchValue.isOn {
            cellView.layer.backgroundColor = UIColor.white.cgColor
            txtFrom.isUserInteractionEnabled = true
            txtTo.isUserInteractionEnabled = true
            switch sender.tag {
                case 0:
                    vc.monday = "1"
                    vc.mondayStartTime = txtFrom.text ?? ""
                    vc.mondayEndTime = txtTo.text ?? ""
                case 1:
                    vc.tuesday = "1"
                    vc.tuesdayStartTime = txtFrom.text ?? ""
                    vc.tuesdayEndTime = txtTo.text ?? ""
                case 2:
                    vc.wednesday = "1"
                    vc.wednesdayStartTime = txtFrom.text ?? ""
                    vc.wednesdayEndTime = txtTo.text ?? ""
                case 3:
                    vc.thursday = "1"
                    vc.thursdayStartTime = txtFrom.text ?? ""
                    vc.thursdayEndTime = txtTo.text ?? ""
                case 4:
                    vc.friday = "1"
                    vc.fridayStartTime = txtFrom.text ?? ""
                    vc.fridayEndTime = txtTo.text ?? ""
                case 5:
                    vc.saturday = "1"
                    vc.saturdayStartTime = txtFrom.text ?? ""
                    vc.saturdayEndTime = txtTo.text ?? ""
                case 6:
                    vc.sunday = "1"
                    vc.sundayStartTime = txtFrom.text ?? ""
                    vc.sundayEndTime = txtTo.text ?? ""
                default:
                    print("Default")
            }
            
        } else {
            cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
            txtFrom.isUserInteractionEnabled = false
            txtTo.isUserInteractionEnabled = false
            switch sender.tag {
                case 0:
                    vc.monday = "0"
                    vc.mondayStartTime = txtFrom.text ?? ""
                    vc.mondayEndTime = txtTo.text ?? ""
                case 1:
                    vc.tuesday = "0"
                    vc.tuesdayStartTime = txtFrom.text ?? ""
                    vc.tuesdayEndTime = txtTo.text ?? ""
                case 2:
                    vc.wednesday = "0"
                    vc.wednesdayStartTime = txtFrom.text ?? ""
                    vc.wednesdayEndTime = txtTo.text ?? ""
                case 3:
                    vc.thursday = "0"
                    vc.thursdayStartTime = txtFrom.text ?? ""
                    vc.thursdayEndTime = txtTo.text ?? ""
                case 4:
                    vc.friday = "0"
                    vc.fridayStartTime = txtFrom.text ?? ""
                    vc.fridayEndTime = txtTo.text ?? ""
                case 5:
                    vc.saturday = "0"
                    vc.saturdayStartTime = txtFrom.text ?? ""
                    vc.saturdayEndTime = txtTo.text ?? ""
                case 6:
                    vc.sunday = "0"
                    vc.sundayStartTime = txtFrom.text ?? ""
                    vc.sundayEndTime = txtTo.text ?? ""
                default:
                    print("Default")
            }
        }
        
    }
    
    @objc func tapFromStartTimeDone() {
        if let datePicker = self.txtFrom.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm a"
            self.txtFrom.text = dateformatter.string(from: datePicker.date).lowercased()
        }
        self.txtFrom.resignFirstResponder()
        switch lblDay.text {
            case "Monday":
                vc.mondayStartTime = txtFrom.text ?? ""
            case "Tuesday":
                vc.tuesdayStartTime = txtFrom.text ?? ""
            case "Wednesday":
                vc.wednesdayStartTime = txtFrom.text ?? ""
            case "Thursday":
                vc.thursdayStartTime = txtFrom.text ?? ""
            case "Friday":
                vc.fridayStartTime = txtFrom.text ?? ""
            case "Saturday":
                vc.saturdayStartTime = txtFrom.text ?? ""
            case "Sunday":
                vc.sundayStartTime = txtFrom.text ?? ""
            default:
                print("Default")
        }
        
        
    }
    
    @objc func tapToEndTimeDone() {
        if let datePicker = self.txtTo.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm a"
            self.txtTo.text = dateformatter.string(from: datePicker.date).lowercased()
        }
        self.txtTo.resignFirstResponder()
        switch lblDay.text {
            case "Monday":
                vc.mondayEndTime = txtTo.text ?? ""
            case "Tuesday":
                vc.tuesdayEndTime = txtTo.text ?? ""
            case "Wednesday":
                vc.wednesdayEndTime = txtTo.text ?? ""
            case "Thursday":
                vc.thursdayEndTime = txtTo.text ?? ""
            case "Friday":
                vc.fridayEndTime = txtTo.text ?? ""
            case "Saturday":
                vc.saturdayEndTime = txtTo.text ?? ""
            case "Sunday":
                vc.sundayEndTime = txtTo.text ?? ""
            default:
                print("Default")
        }
        
    }
}

extension WorkingHoursCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFrom {
            self.txtFrom.setInputViewTimePicker(target: self, selector: #selector(tapFromStartTimeDone))
        } else if textField == txtTo {
            self.txtTo.setInputViewTimePicker(target: self, selector: #selector(tapToEndTimeDone))
        }
        
    }
}
