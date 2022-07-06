//
//  ToDoArchiveCell.swift
//  MySunless
//
//  Created by Daydream Soft on 02/07/22.
//

import UIKit
import Kingfisher

class ToDoArchiveCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblArchive: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    
    var model = ToDoArchiveList(dict: [:])
    var delegate: ToDoArchiveProtocol?
    var arrIds = [String]()
    var parent = ToDoArchiveVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        btnDelete.layer.cornerRadius = 5
        btnRestore.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: model.userimg)
        imgView.kf.setImage(with: imgUrl)
        lblArchive.text = model.firstname + " " + model.lastname + " closed " + model.todoTitle + " from " + model.catname
        var finalDate = AppData.sharedInstance.convertUTCToLocal(date: model.closeddate, fromFormat: "yyyy-MM-dd hh:mm:ss", toFormat: "MMM-dd-yyyy hh:mm")
        finalDate.insert(contentsOf: "at ", at: finalDate.index(finalDate.startIndex, offsetBy: 12))
        lblDateTime.text = finalDate
        btnDelete.tag = index
        btnRestore.tag = index
        btnCheckbox.tag = index
    }
    
    @IBAction func btnCheckboxClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("blank-check-box") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            if !(parent.arrSelectedIds.contains("\(model.id)")) {
                parent.arrSelectedIds.append("\(model.id)")
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            if (parent.arrSelectedIds.contains("\(model.id)")) {
                parent.arrSelectedIds = parent.arrSelectedIds.filter { $0 != "\(model.id)" }
            }
        }
        print("arrSelectedIds:-", parent.arrSelectedIds)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        arrIds.append("\(model.id)")
        delegate?.callDeleteTask(deleteIds: arrIds, action: "delete")
    }
    
    @IBAction func btnRestoreClick(_ sender: UIButton) {
        arrIds.append("\(model.id)")
        delegate?.callDeleteTask(deleteIds: arrIds, action: "restore")
    }
}
