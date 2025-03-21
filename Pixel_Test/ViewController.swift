//
//  ViewController.swift
//  Pixel_Test
//
//  Created by Mark Bonsor on 21/03/2025.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
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
            users.append(User(display_name: name, reputation: reputation, profile_image: image))
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
        
        users = userArray
        print(users)
        self.tableView.reloadData()
    }

}

extension ViewController: UserTableViewCellDelegate {
    func userTableViewCell(_ cell: UserTableViewCell, didTapWith viewModel: UserTableViewCellViewModel) {
        
        // TODO: Save into data source [User]
    }
}
