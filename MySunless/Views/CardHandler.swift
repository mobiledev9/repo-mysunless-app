//
//  CardHandler.swift
//  MySunless
//
//  Created by dds on 08/11/22.
//

import UIKit

import Foundation
import Stripe

//final class CardHandler {
//    let cardView: CardView
//
//    init(cardView: CardView) {
//        self.cardView = cardView
//    }
//
//    func reset() {
//        cardView.frontCard.expirationStaticLabel.text = R.string.localizable.cardExpiration()
//        cardView.frontCard.expirationLabel.text = R.string.localizable.cardExpirationPlaceholder()
//        cardView.backCard.cvcLabel.text = R.string.localizable.cardCvcPlaceholder()
//    }
//
//    func showFront() {
//        flip(
//            from: cardView.backCard,
//            to: cardView.frontCard,
//            options: .transitionFlipFromLeft
//        )
//    }
//
//    func showBack() {
//        flip(
//            from: cardView.frontCard,
//            to: cardView.backCard,
//            options: .transitionFlipFromRight
//        )
//    }
//
//    func handle(_ textField: STPPaymentCardTextField) {
//        handle(number: textField.cardNumber ?? "")
//        handle(month: textField.formattedExpirationMonth, year: textField.formattedExpirationYear)
//        handle(cvc: textField.cvc)
//    }
//
//    private func handle(number: String) {
//        let paddedNumber = number.padding(
//            toLength: 16,
//            withPad: R.string.localizable.cardNumberPlaceholder(),
//            startingAt: 0
//        )
//
//        let chunkedNumbers = paddedNumber.chunk(by: 4)
//        zip(cardView.frontCard.numberLabels, chunkedNumbers).forEach { tuple in
//            tuple.0.text = tuple.1
//        }
//    }
//
//    private func handle(cvc: String?) {
//        if let cvc = cvc, !cvc.isEmpty {
//            cardView.backCard.cvcLabel.text = cvc
//        } else {
//            cardView.backCard.cvcLabel.text = R.string.localizable.cardCvcPlaceholder()
//        }
//    }
//
//    private func handle(month: String?, year: String?) {
//        guard
//            let month = month, let year = year,
//            !month.isEmpty
//        else {
//            cardView.frontCard.expirationLabel.text = R.string.localizable.cardExpirationPlaceholder()
//            return
//        }
//
//        let formattedYear = year.ifEmpty(replaceWith: "00")
//        cardView.frontCard.expirationLabel.text = "\(month)/\(formattedYear)"
//    }
//
//    private func flip(from: UIView, to: UIView, options: UIView.AnimationOptions) {
//        UIView.transition(
//            from: from,
//            to: to,
//            duration: 0.25,
//            options: [options, .showHideTransitionViews],
//            completion: nil
//        )
//    }
//}
