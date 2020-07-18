//
//  TODOListTableViewController.swift
//  TODO
//
//  Created by Valton Sherifi on 7/12/20.
//  Copyright © 2020 Valton Sherifi. All rights reserved.
//

import UIKit
import Firebase

class TODOListTableViewController: UITableViewController {

  // MARK: Constants
  let listToUsers = "ListToUsers"
  //Mark: Properties
    var items : [TodoItem] = [] // inicializimi i modelit per listen e te dhenave Todo
    var user: User! // inicializimi i modelit te Usar-ave
    var userCountBarButtonItem: UIBarButtonItem! // Inicializimi i butonit ne navigation
    
    //Konektimi me Databaze
    let ref = Database.database().reference(withPath: "todo-items") //krijimi i tabeles todo-items ne firebase
    let userRef = Database.database().reference(withPath: "online") // krijimi i tabeles online per perdorues ne firebase
    
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
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // MARK: Add Item
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "TO DO",
                                  message: "Add Task",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .default)
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)
    
    alert.addTextField()
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  @objc func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
}
