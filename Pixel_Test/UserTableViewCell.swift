//
//  UserTableViewCell.swift
//  Pixel_Test
//
//  Created by Mark Bonsor on 21/03/2025.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    private var viewModel: UserTableViewCellViewModel?
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let reputationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(reputationLabel)
        contentView.addSubview(button)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModel: UserTableViewCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        reputationLabel.text =  "Reputation: \(viewModel.reputation)"
        userImageView.image = viewModel.image
        
        if viewModel.isCurrentlyFollowing {
            button.setTitle("Unfollow", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
        } else {
            button.setTitle("Follow", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .link
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageWidth = contentView.frame.size.height-10
        let labelWidth = contentView.frame.size.width-imageWidth-20
        let labelHeight = CGFloat(30)
        let buttonHeight = CGFloat(30)
        let buttonWidth = CGFloat(100)
        
        userImageView.frame = CGRect(x: 5, y: 5,
                                     width: imageWidth, height: imageWidth)
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.frame = CGRect(x: imageWidth+10, y: 5,
                                 width: labelWidth, height: labelHeight)
        
        reputationLabel.frame = CGRect(x: imageWidth+10, y: labelHeight+5,
                                       width: labelWidth, height: labelHeight)
        
        button.frame = CGRect(x: contentView.frame.size.width-buttonWidth-15,
                              y: contentView.frame.size.height-buttonHeight-10,
                              width: buttonWidth, height: buttonHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
