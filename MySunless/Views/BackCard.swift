////
////  BackCard.swift
////  MySunless
////
////  Created by dds on 08/11/22.
////
//
//import UIKit
//
//final class BackCard: UIView {
//    lazy var rectangle: UIView = {
//        let view = UIView()
//        view.backgroundColor = R.color.darkText
//        return view
//    }()
//
//    lazy var cvcLabel: UILabel = {
//        let label = UILabel()
//        label.font = R.customFont.medium(14)
//        label.textColor = R.color.darkText
//        label.textAlignment = .center
//        return label
//    }()
//
//    lazy var cvcBox: UIView = {
//        let view = UIView()
//        view.backgroundColor = R.color.lightText
//        return view
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError()
//    }
//
//    private func setup() {
//        addSubviews([rectangle, cvcBox, cvcLabel])
//        NSLayoutConstraint.on([
//            rectangle.leftAnchor.constraint(equalTo: leftAnchor),
//            rectangle.rightAnchor.constraint(equalTo: rightAnchor),
//            rectangle.heightAnchor.constraint(equalToConstant: 52),
//            rectangle.topAnchor.constraint(equalTo: topAnchor, constant: 30),
//
//            cvcBox.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
//            cvcBox.topAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: 16),
//            cvcBox.widthAnchor.constraint(equalToConstant: 66),
//            cvcBox.heightAnchor.constraint(equalToConstant: 30),
//
//            cvcLabel.centerXAnchor.constraint(equalTo: cvcBox.centerXAnchor),
//            cvcLabel.centerYAnchor.constraint(equalTo: cvcBox.centerYAnchor)
//        ])
//    }
//}
