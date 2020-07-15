//
//  TODOListTableViewController.swift
//  TODO
//
//  Created by Valton Sherifi on 7/12/20.
//  Copyright © 2020 Valton Sherifi. All rights reserved.
//

import UIKit

class TODOListTableViewController: UITableViewController {

  // MARK: Constants
  let listToUsers = "ListToUsers"
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    var userCountBarButtonItem: UIBarButtonItem!
    tableView.allowsMultipleSelectionDuringEditing = false
    
    userCountBarButtonItem = UIBarButtonItem(title: "1",
                                             style: .plain,
                                             target: self,
                                             action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    
  }
