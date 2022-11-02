//
//  AlertVC.swift
//  MySunless
//
//  Created by dds on 21/10/22.
//

import UIKit

class AlertVC: UIViewController {
    
    
    @IBOutlet weak var vw_main: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_bottom: UIView!
    
    var isChecked : Bool = false
    var delegate : showAlertDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
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
    }

    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOkayClick(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.callShowAlert(isChecked: self.isChecked)
        }
    }
    
    @IBAction func btnDoNotShowClick(_ sender: UIButton) {
        if isChecked {
            sender.isSelected = false
            isChecked = false
         } else {
             sender.isSelected = true
             isChecked = true
        }
    }

}


