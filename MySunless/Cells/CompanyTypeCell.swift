//
//  CompanyTypeCell.swift
//  MySunless
//
//  Created by iMac on 29/10/21.
//

import UIKit

class CompanyTypeCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblTitle: UILabel!
    
    var buttonTapCallback: () -> ()  = { }
    let button = UIButton()
    let buttonState = UIButton()
    var buttonStateTapCallback: () -> ()  = { }
    
    @objc func didTapButton() {
       // button.isSelected = true
        buttonTapCallback()
    }
    
    @objc func didTapStateButton() {
        buttonStateTapCallback()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Add button
//        contentView.addSubview(button)
//        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//
//        //Set constraints as per your requirements
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
//        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
//
//        //Add button
//        contentView.addSubview(buttonState)
//        buttonState.addTarget(self, action: #selector(didTapStateButton), for: .touchUpInside)
//
//        //Set constraints as per your requirements
//        buttonState.translatesAutoresizingMaskIntoConstraints = false
//        buttonState.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        buttonState.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        buttonState.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
//        buttonState.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        if button.isSelected {
//            button.layer.backgroundColor = UIColor.init("#15B0DA").cgColor
//        } else {
//            button.layer.backgroundColor = UIColor.white.cgColor
//        }
        if selected {
            cellView.backgroundColor = UIColor.init("#15B0DA")
        } else {
            cellView.backgroundColor = UIColor.white
        }
    }

}
