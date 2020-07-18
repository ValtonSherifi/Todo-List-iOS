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
  
  
