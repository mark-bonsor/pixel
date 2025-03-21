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
    var imageUrl: String?
    var isCurrentlyFollowing: Bool
    
    init(with model: User) {
        name = model.display_name
        reputation = model.reputation
        imageUrl = model.profile_image
        isCurrentlyFollowing = false
    }
    
}
