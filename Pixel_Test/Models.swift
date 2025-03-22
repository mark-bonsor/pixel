//
//  Models.swift
//  Pixel_Test
//
//  Created by Mark Bonsor on 21/03/2025.
//

import Foundation

struct UserItems: Codable {
    let items: [User]
}

struct User: Codable {
    let display_name: String
    let reputation: Int
    let profile_image: String?
    var isFollowing: Bool?
    
    init(display_name: String,
         reputation: Int = 0,
         profile_image: String? = nil,
         isFollowing: Bool
    ) {
        self.display_name = display_name
        self.reputation = reputation
        self.profile_image = profile_image
        self.isFollowing = false
    }
    
    mutating func setFollowState(_ followState: Bool) {
        isFollowing = followState
    }

}
