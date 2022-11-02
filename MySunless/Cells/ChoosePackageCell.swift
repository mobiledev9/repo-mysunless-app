//
//  ChoosePackageCell.swift
//  MySunless
//
//  Created by iMac on 08/11/21.
//

import UIKit

class ChoosePackageCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblPackageName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblValidityDay: UILabel!
    @IBOutlet var btnRadio: UIButton!
    @IBOutlet var btnExpand: UIButton!
    @IBOutlet var moreInfoView: UIView!
    @IBOutlet var lblEmpLimit: UILabel!
    @IBOutlet var lblClientLimit: UILabel!
    @IBOutlet var lblDescription: UILabel!
    var model = SelectPackage()
    var isExpand = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //Do reset here
      //  btnRadio.setImage(UIImage(named: "radio-off-button.png"), for: .normal)
      //  btnRadio.setImage(UIImage(named: isSelected ? "radio-off-button.png" : "radio-on-button.png"), for:.normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       // btnRadio.setImage(UIImage(named: selected ? "radio-off-button.png" : "radio-on-button.png"), for:.normal)
    }
    
    func setCell() {
        switch model.id {
        case "24":
            lblEmpLimit.attributedText = setAttributedLabel(headTitle: "Employee Limit: ", subTitle: "0")
            lblClientLimit.attributedText = setAttributedLabel(headTitle: "Clients Limit: ", subTitle: "50")
            lblDescription.attributedText = setAttributedLabel(headTitle: "Package Description: ", subTitle: "Great for new technicians who started to grow their client base - 50 client profiles - Access to all Mysunless features")
        case "25":
            lblEmpLimit.attributedText = setAttributedLabel(headTitle: "Employee Limit: ", subTitle: "0")
            lblClientLimit.attributedText = setAttributedLabel(headTitle: "Clients Limit: ", subTitle: "125")
            lblDescription.attributedText = setAttributedLabel(headTitle: "Package Description: ", subTitle: "Made for businesses with a strong list of clients. - 125 client limit - access to all Mysunless features")
        case "19":
            lblEmpLimit.attributedText = setAttributedLabel(headTitle: "Employee Limit: ", subTitle: "Unlimited")
            lblClientLimit.attributedText = setAttributedLabel(headTitle: "Clients Limit: ", subTitle: "Unlimited")
            lblDescription.attributedText = setAttributedLabel(headTitle: "Package Description: ", subTitle: "- Full access to all features. - Unlimited Employees sub-accounts. - Unlimited customer profiles. Valid for 30 days.")
        case "21":
            lblEmpLimit.attributedText = setAttributedLabel(headTitle: "Employee Limit: ", subTitle: "Unlimited")
            lblClientLimit.attributedText = setAttributedLabel(headTitle: "Clients Limit: ", subTitle: "Unlimited")
            lblDescription.attributedText = setAttributedLabel(headTitle: "Package Description: ", subTitle: "- Full access to all features. - Unlimited Employees sub-accounts. - Unlimited customer profiles. Valid 365 days after purchase.")
        default:
            print("Default")
        }
    }
    

    
    func  setAttributedLabel(headTitle:String,subTitle:String) -> NSMutableAttributedString  {
        let boldFontAttributes = [
            NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 17)!,
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ]
        let normalFontAttributes = [
            NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        let partOne = NSMutableAttributedString(string: headTitle, attributes: boldFontAttributes)
        let partTwo = NSMutableAttributedString(string: subTitle, attributes: normalFontAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }

}
