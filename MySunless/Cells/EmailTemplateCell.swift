//
//  EmailTemplateCell.swift
//  MySunless
//
//  Created by Daydream Soft on 18/04/22.
//

import UIKit

class EmailTemplateCell: UITableViewCell {
   
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblSubject: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    var model = ShowTemplate(dict: [:])
    var delegate: EmailTemplateProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(index: Int) {
        lblName.text = model.Name
        lblSubject.text = model.Subject
        lblMessage.setHTMLFromString(htmlText: model.TextMassage)
        lblMessage.textColor = UIColor.init("#6D778E")
        btnView.tag = index
        btnEdit.tag = index
        btnDelete.tag = index
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        delegate?.editTemplate(index: sender.tag)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        delegate?.callDeleteTemplateAPI(templateId: model.id)
    }
    
    @IBAction func btnViewClick(_ sender: UIButton) {
        delegate?.viewTemplate(index: sender.tag)
    }
  
}
