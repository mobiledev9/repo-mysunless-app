//
//  Archive_EventCell.swift
//  MySunless
//
//  Created by Daydream Soft on 09/03/22.
//

import UIKit
import SCLAlertView

class Archive_EventCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblIdName: UILabel!
    @IBOutlet var lblClientName: UILabel!
    @IBOutlet var lblApointmentInfo: UILabel!
    @IBOutlet var lblCreatedBy: UILabel!
    @IBOutlet var lblDeletedDate: UILabel!
    @IBOutlet var imageViewCreatedBy: UIImageView!
    @IBOutlet var imageViewClientName: UIImageView!
    @IBOutlet var btnCheckMark: UIButton!
    @IBOutlet var btnRestore: UIButton!
    @IBOutlet var btnClientDetail: UIButton!
    @IBOutlet var btnUserDetail: UIButton!
    
    var modelEvent = ShowEventList(dict: [:])
    var delegate: RestoreEventDelegate?
    var parent = ArchiveListVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imageViewCreatedBy.layer.cornerRadius = imageViewCreatedBy.frame.size.height / 2
        imageViewClientName.layer.cornerRadius = imageViewClientName.frame.size.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: modelEvent.ProfileImg)
        imageViewClientName.kf.setImage(with: imgUrl)
        let imgUrl2 = URL(string: modelEvent.userimg)
        imageViewCreatedBy.kf.setImage(with: imgUrl2)
        lblIdName.text = "\(modelEvent.id)"
        lblClientName.text = modelEvent.FirstName.capitalized + " " + modelEvent.LastName.capitalized
        
        let finalText = modelEvent.title + "\n" + modelEvent.EventDate + "\n" + modelEvent.eventstatus
        let attributedstring = NSAttributedString(string: finalText)
        lblApointmentInfo.attributedText = attributedstring
        
        lblCreatedBy.text = modelEvent.Fullname
        lblDeletedDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: modelEvent.datelastupdated)
        btnClientDetail.tag = index
        btnUserDetail.tag = index
        btnRestore.tag = index
        btnCheckMark.tag = index
        btnCheckMark.setImage(UIImage(named: "blank-check-box"), for: .normal)
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(restoreClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess("Restore?", subTitle: "")
    }
    
    @IBAction func btnExportClick(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnCheckMarkClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("blank-check-box") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            if !(parent.arrEventSelectedIds.contains("\(modelEvent.id)")) {
                parent.arrEventSelectedIds.append("\(modelEvent.id)")
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            if (parent.arrEventSelectedIds.contains("\(modelEvent.id)")) {
                parent.arrEventSelectedIds = parent.arrEventSelectedIds.filter { $0 != "\(modelEvent.id)" }
            }
        }
    }
    
    @IBAction func btnClientDetailClick(_ sender: UIButton) {
       
    }
    
    @IBAction func btnUserDetailClick(_ sender: UIButton) {
       
    }
    
    @objc func restoreClick(_ sender: UIButton) {
        delegate?.callRestoreEventAPI(id: ["\(modelEvent.id)"])
    }
   
}
