//
//  CommentCell.swift
//  MySunless
//
//  Created by Daydream Soft on 15/07/22.
//

import UIKit
import Kingfisher

class CommentCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vw_comment: UIView!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var model = CommentData(dict: [:])
    var delegate: TaskPreviewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        btnDelete.layer.cornerRadius = 5
        btnEdit.layer.cornerRadius = 5
        btnClose.layer.cornerRadius = 5
        btnSave.layer.cornerRadius = 5
        btnClose.isHidden = true
        txtComment.isUserInteractionEnabled = false
       // txtComment.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: model.userimg)
        imgProfile.kf.setImage(with: imgUrl)
        lblName.text = model.firstname.capitalized + " " + model.lastname.capitalized
        var date = model.createddate
        date.removeLast(9)
        let finalDate = AppData.sharedInstance.formattedDateFromString(dateFormat: "yyyy-MM-dd", dateString: date, withFormat: "MMM-dd-yyyy")
        var time = AppData.sharedInstance.convertToUTC(dateToConvert: model.createddate)
        time.removeFirst(11)
        time.removeLast(3)
        lblDate.text = (finalDate ?? "") + " at " + time
        txtComment.text = model.comment
        btnEdit.tag = index
        btnSave.tag = index
        btnClose.tag = index
        btnDelete.tag = index
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        AppData.sharedInstance.addCustomAlert(alertMainTitle: "Are you sure?", subTitle: "Once Deleted, you will lost this!") {
            self.delegate?.callDeleteCommentAPI(commentId: self.model.id)
        }
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        btnEdit.isHidden = true
        btnClose.isHidden = false
        txtComment.isUserInteractionEnabled = true
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        btnClose.isHidden = true
        btnEdit.isHidden = false
        txtComment.isUserInteractionEnabled = false
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        delegate?.callAddOrUpdateCommentAPI(isEdit: true, commentId: model.id, editComment: txtComment.text)
    }
}

//extension CommentCell: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        txtComment.layer.borderWidth = 1.0
//        txtComment.layer.borderColor = UIColor.init("#005CC8").cgColor
//    }
//}
