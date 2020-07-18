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
    
  tableView.allowsMultipleSelectionDuringEditing = false // Lejimi i selektimit te rreshtit ne tabele
    // Bashkangjitja e funksionalitetit ne butonin per numerimin e userave
    userCountBarButtonItem = UIBarButtonItem(title: "1",
                                             style: .plain,
                                             target: self,
                                             action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white // Ngjyrosja e butonit ne navigation bar
    navigationItem.leftBarButtonItem = userCountBarButtonItem // Vendosja butonit te krijuar manualisht(userCountBarButtonItem) ne butonin e navigimit leftbuttonItem
    
    //Bashkangjitja e një dëgjuesi(listener) për të marrë azhurnime sa herë që pika e fundit e sendeve të modifikohet.
    ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
      var newItems: [TodoItem] = []//ruajtja e te dhenave ne variablen lokale sa here qe ndryshojne
        
      //Struktura TodoItem ka nje iniciator qe ruat vetite e tij duke përdorur një DataSnapshot. Vlera snapshot eshte e llojit AnyObject dhe mund te jete nje fjalor, varg, numer ose varg. Pas krijimit te një shembulli të TodoItem, e shton atë në varg qe permban versionin e fundit të të dhënave.
      for child in snapshot.children {
        if let snapshot = child as? DataSnapshot,
          let todoItem = TodoItem(snapshot: snapshot) {
          newItems.append(todoItem)
        }
      }
      //Barazimi i te dhenave me vargun e krijuar lokalisht ne verzionin e fundit te te dhenave nga databaza
      self.items = newItems
       //Refreshimi i tabeles
      self.tableView.reloadData()
    })
       Auth.auth().addStateDidChangeListener { auth, user in
      guard let user = user else { return }
      self.user = User(authData: user)
      
      let currentUserRef = self.usersRef.child(self.user.uid)
      currentUserRef.setValue(self.user.email)
      currentUserRef.onDisconnectRemoveValue()
    }
    //metoda per numerimin e userave
    usersRef.observe(.value, with: { snapshot in
      if snapshot.exists() {// nese ekzistojne usera
        self.userCountBarButtonItem?.title = snapshot.childrenCount.description // numerimi i userave dhe vendosja e numrit ne titull te butonit te krijuar manualisht
      } else {
        // nese nuk gjindet asnje user vendos vleren "0"
        self.userCountBarButtonItem?.title = "0"
      }
    })
  }
   // MARK: UITableView Delegate methods
//Metodat per funksionalitetin e tabelave
    
  //Numri i rreshtave në tabele
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count // Numerimi i listes
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
