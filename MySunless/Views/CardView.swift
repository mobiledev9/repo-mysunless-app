////
////  CardView.swift
////  MySunless
////
////  Created by dds on 08/11/22.
////
//
//import UIKit
//
//final class CardView: UIView {
//    let backCard = BackCard()
//    let frontCard = FrontCard()
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
//        addSubview(backCard)
//        addSubview(frontCard)
//
//        [backCard, frontCard].forEach {
//            NSLayoutConstraint.on([
//                $0.pinEdges(view: self)
//            ])
//
//            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 10
//            $0.backgroundColor = R.color.card.background
//        }
//    }
//}
