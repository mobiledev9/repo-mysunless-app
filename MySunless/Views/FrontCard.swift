////
////  FrontCard.swift
////  MySunless
////
////  Created by dds on 08/11/22.
////
//
//import UIKit
//
//final class FrontCard: UIView {
//    lazy var stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .equalSpacing
//
//        return stackView
//    }()
//
//    lazy var numberLabels: [UILabel] = Array(0..<4).map({ _ in return UILabel() })
//    lazy var expirationStaticLabel: UILabel = {
//        let label = UILabel()
//        label.font = R.customFont.regular(10)
//        label.textColor = R.color.darkText
//        return label
//    }()
//
//    lazy var expirationLabel: UILabel = {
//        let label = UILabel()
//        label.font = R.customFont.medium(14)
//        label.textColor = R.color.darkText
//        return label
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
//        addSubview(stackView)
//        numberLabels.forEach {
//            stackView.addArrangedSubview($0)
//        }
//
//        addSubviews([expirationStaticLabel, expirationLabel])
//
//        numberLabels.forEach {
//            $0.font = R.customFont.medium(16)
//            $0.textColor = R.color.darkText
//            $0.textAlignment = .center
//        }
//
//        NSLayoutConstraint.on([
//            stackView.heightAnchor.constraint(equalToConstant: 50),
//            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
//            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
//            stackView.topAnchor.constraint(equalTo: centerYAnchor),
//
//            expirationStaticLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor),
//            expirationStaticLabel.leftAnchor.constraint(equalTo: rightAnchor, constant: -70),
//
//            expirationLabel.leftAnchor.constraint(equalTo: expirationStaticLabel.leftAnchor),
//            expirationLabel.topAnchor.constraint(equalTo: expirationStaticLabel.bottomAnchor)
//        ])
//    }
//}
