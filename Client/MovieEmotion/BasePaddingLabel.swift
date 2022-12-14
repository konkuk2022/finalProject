//
//  BasePaddingLabel.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/08.
//

import UIKit

class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

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
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        self.font = .systemFont(ofSize: 9, weight: .light)
        super.draw(rect)
    }
}
