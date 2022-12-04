//
//  RecordTableViewCell.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 04.12.2022.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    
    static var identifier = "RecordTableViewCell"

    @IBOutlet weak var winnerAvatar: UIImageView!
    @IBOutlet weak var looserAvatar: UIImageView!
    
    @IBOutlet weak var winnerNameLabel: UILabel!
    @IBOutlet weak var loosnerNameLabel: UILabel!
    
    @IBOutlet weak var winnerScoreLabel: UILabel!
    @IBOutlet weak var looserScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))

    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
