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
        configureUsers()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
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
        // cell.textLabel?.text = user.display_name
        cell.configure(with: UserTableViewCellViewModel(with: model))
        return cell
    }


}

