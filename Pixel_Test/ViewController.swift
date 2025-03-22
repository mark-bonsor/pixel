//
//  ViewController.swift
//  Pixel_Test
//
//  Created by Mark Bonsor on 21/03/2025.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    
    private var users = [User]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(
            UserTableViewCell.self,
            forCellReuseIdentifier: UserTableViewCell.identifier
        )
        table.rowHeight = 100
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configureUsers()
        fetchUsers()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    private func fetchUsers() {
       Task {
            do {
                try await fetchDataFromAPI()
            } catch {
                // Handle the errors
            }
        }
    }
    
    private func configureUsers() {
        // Dummy data
        let names = ["Albert", "Brian", "Clive", "David", "Eric", "Frank"]
        let reputations = [1000, 2000, 3000, 4000, 5000, 6000]
        let images = ["Albert_img", "Brian_img", "Clive_img", "David_img", "Eric_img", "Frank_img"]
        
        for i in 0...names.count-1 {
            let name = names[i]
            let reputation = reputations[i]
            let image = images[i]
            users.append(User(display_name: name, reputation: reputation, profile_image: image, isFollowing: false))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = users[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.identifier,
            for: indexPath
        ) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: UserTableViewCellViewModel(with: model))
        cell.delegate = self
        return cell
    }
    
    func fetchDataFromAPI() async throws -> Void {
        
        let apiUrl = URL(string: "https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&   sort=reputation&site=stackoverflow")!
        
        var request = URLRequest(url: apiUrl)
        
        request.httpMethod = "GET"  // optional
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print("Error while fetching data:", error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let userItems = try JSONDecoder().decode(UserItems.self, from: data)
                DispatchQueue.main.async {
                    self.setUserData(userArray: userItems.items)
                }
            } catch let jsonError {
                print("Failed to decode json", jsonError)
            }
        }
        task.resume()
    }
    
    func setUserData(userArray: [User]) {
        
        users = loadFollowStates(userArray)
        self.tableView.reloadData()
    }
    
    func saveFollowStates() {
        var followingDict: [String: Bool] = [:]
        for user in users {
            followingDict[user.display_name] = user.isFollowing!
        }
        defaults.set(followingDict, forKey: "followingStates")
    }
    
    func loadFollowStates(_ userArray: [User])->[User] {
        var outputUserArray: [User] = []
        
        if let followingDict = defaults.dictionary(forKey: "followingStates") {
            for var user in userArray {
                if let savedFollowState = followingDict[user.display_name] as? Bool {
                    user.setFollowState(savedFollowState)
                } else {
                    user.setFollowState(false)
                }
                outputUserArray.append(user)
            }
        } else {
            for var user in userArray {
                user.setFollowState(false)
                outputUserArray.append(user)
            }
        }
        
        return outputUserArray
    }

}

extension ViewController: UserTableViewCellDelegate {
    func userTableViewCell(_ cell: UserTableViewCell,
                           didTapWith viewModel: UserTableViewCellViewModel) {
        
        guard let index = tableView.indexPath(for: cell) else { return }
        var user = users[index.row]
        user.setFollowState(viewModel.isCurrentlyFollowing)
        users[index.row] = user
        
        saveFollowStates()
    }
    
}
