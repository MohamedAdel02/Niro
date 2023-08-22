//
//  PaddingLabel.swift
//  Niro
//
//  Created by Mohamed Adel on 09/08/2023.
//

import UIKit

class PaddingLabel: UILabel {

    let topInset: CGFloat = 15
    let bottomInset: CGFloat = 15
    let leftInset: CGFloat = 10
    let rightInset: CGFloat = 10

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
    
}
