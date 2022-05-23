//
//  SetUpGuideVC.swift
//  MySunless
//
//  Created by iMac on 09/05/22.
//

import UIKit

class SetUpGuideVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var txtView: UITextView!
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        addImageToText()
    }
    
    //MARK:- User-Defined Functions
    func setInitially() {
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_main.layer.cornerRadius = 12
        vw_top.layer.cornerRadius = 12
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        txtView.isUserInteractionEnabled = true
        txtView.isEditable = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResponse(recognizer:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        txtView.addGestureRecognizer(tap)
    }
    
    func addImageToText() {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "list.bullet")
        let imageString = NSAttributedString(attachment: attachment)
        txtView.textStorage.insert(imageString, at: 709)
    }
    
    //MARK:- Actions
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapResponse(recognizer: UITapGestureRecognizer) {
        let location: CGPoint = recognizer.location(in: txtView)
        let position: CGPoint = CGPoint(x: location.x, y: location.y)
        let tapPosition: UITextPosition? = txtView.closestPosition(to: position)
        if tapPosition != nil {
            let textRange: UITextRange? = txtView.tokenizer.rangeEnclosingPosition(tapPosition!, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1))
            if textRange != nil {
                let tappedWord: String? = txtView.text(in: textRange!)
                if (tappedWord == "Register") || (tappedWord == "Login") {
                    print("tapped word : ", tappedWord ?? "")
                    if let url = URL(string: "https://developer.squareup.com/apps") {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        }
    }
}

