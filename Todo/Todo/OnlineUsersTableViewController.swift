//
//  OnlineUsersTableViewController.swift
//  Todo
//
//  Created by Valton Sherifi on 15/07/2020.
//  Copyright © 2020 Valton Sherifi. All rights reserved.
//
import UIKit
import Firebase

class OnlineUsersTableViewController: UITableViewController {
  // MARK: Constants
  let userCell = "UserCell"
  
  // Mark: Properties
  var currentUsers: [String] = []
  let usersRef = Database.database().reference(withPath: "online)
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
   
    return cell
  }
  
  // MARK: Actions
  @IBAction func signoutButtonPressed(_ sender: AnyObject) {

  }
}
