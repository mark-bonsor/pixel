//
//  UserTableViewCellViewModel.swift
//  Pixel_Test
//
//  Created by Mark Bonsor on 21/03/2025.
//

import UIKit

struct UserTableViewCellViewModel {
    let name: String
    let reputation: Int
    var image: UIImage?
    var isCurrentlyFollowing: Bool
    
    init(with model: User) {
        name = model.display_name
        reputation = model.reputation
        image = UIImage(systemName: "person")
        isCurrentlyFollowing = false
    }
    
}
