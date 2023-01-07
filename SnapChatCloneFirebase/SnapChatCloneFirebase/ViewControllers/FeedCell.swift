//
//  FeedCell.swift
//  SnapChatCloneFirebase
//
//  Created by Onur Sir on 6.01.2023.
//

import UIKit

class FeedCell: UITableViewCell {

    let backgroundImageView = UIImageView()

    @IBOutlet weak var feedUsernameLabel: UILabel!
    @IBOutlet weak var feedimageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundView = backgroundImageView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with image: UIImage) {
            backgroundImageView.image = image
        }

}
