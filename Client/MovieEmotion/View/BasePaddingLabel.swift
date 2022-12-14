//
//  BasePaddingLabel.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/09.
//

import UIKit

class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}

class BasePaddingButtton : UIButton
{
    override var intrinsicContentSize: CGSize {
       get {
           let baseSize = super.intrinsicContentSize
           return CGSize(width: baseSize.width + 50,//ex: padding 20
                         height: baseSize.height)
           }
    }
}
