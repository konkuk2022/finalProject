//
//  DiaryTableViewCell.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/06/04.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    static let identifier = "DiaryTableViewCell"
    
    private let dateLabel: UILabel = {
        var label = UILabel()
        label.text = "0000.00.00"
        return label
    }()
    
    private let contentLabel: UILabel = {
        var label = UILabel()
        label.text = "내용이 들어감"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
