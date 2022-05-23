//
//  NoteCell.swift
//  MySunless
//
//  Created by Daydream Soft on 22/03/22.
//

import UIKit
import Kingfisher
import SCLAlertView

class NoteCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblNoteTitle: UILabel!
    @IBOutlet var lblNoteDetail: UILabel!
    @IBOutlet var lblNoteCreatedDate: UILabel!
    @IBOutlet var lblBeforeNoteTime: UILabel!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
   
    var model = NoteDetail(dict: [:])
    var delegate: NoteListDelegate?
    var alertTitle = "Are you sure?"
    var alertSubtitle = "Once deleted, it will not be recovered!"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        lblNoteDetail.textColor = UIColor.init("#6D778E")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteButton(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: model.userimg)
        imgView.kf.setImage(with: imgUrl)
        lblUserName.text = model.noteCreaterName
        lblNoteTitle.text = model.noteTitle
        lblNoteDetail.setHTMLFromString(htmlText: model.noteDetail)
        lblNoteDetail.textColor = UIColor.init("#6D778E")
        lblNoteCreatedDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: model.datelastupdated)
        lblBeforeNoteTime.text = model.timediff
        btnView.tag = index
        btnEdit.tag = index
        btnDelete.tag = index
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        delegate?.editNote(noteId: model.id, dict: model)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnViewClick(_ sender: UIButton) {
        delegate?.showNote(noteId: model.id)
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        delegate?.deleteNote(noteId: model.id)
    }
    
}
