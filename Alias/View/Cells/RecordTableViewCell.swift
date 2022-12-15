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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }

    public func configure(record: RecordTeamsEntity) {

        let winnerScore = record.winner?.score
        let looserScore = record.looser?.score

        self.winnerNameLabel.text = record.winner?.name
        self.loosnerNameLabel.text = record.looser?.name
        self.winnerScoreLabel.text = String(format: "Score: %d", winnerScore ?? 0)
        self.looserScoreLabel.text = String(format: "Score: %d", looserScore ?? 0)
        self.winnerAvatar.image = UIImage(systemName: record.winner?.avatar ?? "person.2.circle.fill")
        self.looserAvatar.image = UIImage(systemName: record.looser?.avatar ?? "person.2.circle.fill")
    }

}
