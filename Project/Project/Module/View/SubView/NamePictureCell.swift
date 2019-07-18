//
//  NamePictureCell.swift
//  NewsList
//
//  Created by Rathish Kannan
//  Copyright © 2018 Rathish Kannan. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class NamePictureCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var prefixLabel: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    
    var item: ListViewModelItem? {
        didSet {
            guard let item = item as? List.Fetch.ViewModel.ListItem else {
                return
            }
            prefixLabel.text = "reviewed by"
            nameLabel.text   = item.author
            let title =   item.title != "" ? "\("\"")\(item.title ?? "")\("\"")" : ""
            titleLabel?.text = title
            messageLabel?.text = item.message
            ratingView.rating = NSString(string: item.rating ?? "").doubleValue
            avatarImgView.load(URL.init(string: item.photo ?? ""), placeholder: "placeholder", errorPlaceholder: "placeholder")
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        messageLabel.text = ""
        avatarImgView.image = nil
        prefixLabel.text = ""
    }    
}
