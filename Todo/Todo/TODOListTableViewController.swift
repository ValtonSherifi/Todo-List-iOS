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
  
  //Krijimi i rrreshtave ne baze te te dhenave ne vargun Items
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let todoItem = items[indexPath.row]
    //vendosja e vlerave ne labela, ne baze te vargut te te dhenave Item
    cell.textLabel?.text = todoItem.name
    cell.detailTextLabel?.text = todoItem.addedByUser
    
    toggleCellCheckbox(cell, isCompleted: todoItem.completed)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  // Funksioni i cili na lejo me e fshi items ne tabele duke bere swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
          let todoItem = items[indexPath.row]// varesisht se cilin rresht duam ta fshijme, mirret index i rreshtit
          todoItem.ref?.removeValue() // fshirja e te dhenes nga lista e te dhenave ne databaze
        }

    }
  //didSelectRowAt eshte funksionaliteti kur te selektojme nje rresht ne tabele
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    let todoItem = items[indexPath.row]// marrja e indeksit te cilin rresht e selektojme
    let toggledCompletion = !todoItem.completed
    toggleCellCheckbox(cell, isCompleted: toggledCompletion) // thirret funksioni per ta dizajni rreshtin me tik nese eshte e selektume
    
    // Editimi i te dhenave ne databaze, nese eshte rreshti i selektuar(kompletuar)
    todoItem.ref?.updateChildValues([
      "completed": toggledCompletion
      ])
  }
  //Kjo metode ka per funksion te i jep dizajnin e rreshtit nese eshte apo jo i selektuar
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = .black
      cell.detailTextLabel?.textColor = .black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = .gray
      cell.detailTextLabel?.textColor = .gray
    }
  }
  }
  
// MARK: Insertimi i te dhenave  ne tabele
    
    //Eshte variabel e cila i jep ne funksionalitet butonit
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    //Paraqitja e shtimit te te dhenave si alert(Pop-up)
    let alert = UIAlertController(title: "TO DO",//titulli i alertit
                                  message: "Add Task", // Udhezimi
                                  preferredStyle: .alert) // forma e paraqitjes se alertit
    //butoni Save ne Alert
    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
        //Kontollimi nese ka te dhena ne fushat e tekstit(textfields), nese nuk ka nderpritet funksioni
      guard let textField = alert.textFields?.first,
        let text = textField.text else { return }
      
        //nese ka te dhena te shkruara ne fushat e tekstit(textfields) behet insertimi i te dhenave ne model
      let todoItem = TodoItem(name: text,
                                    addedByUser: self.user.email,
                                    completed: false)

      let todoItemRef = self.ref.child(text.lowercased()) // Shnderrimi i te dhenave hyrese nga textfields  me shkronja te vogla
        
      //bashkangjitja e te dhenes se referuar me larte ne databaze.
      todoItemRef.setValue(todoItem.toAnyObject())
    }
    //Butoni Cancel ne  alert
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)
    
    
    alert.addTextField()
    //Shtimi i dy butonave ne alert
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  //Funksionaliteti per dergimin nga butoni i krijuar me lart userCountBarButtonItem per te derguar ne screen-in per user-a
  @objc func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
}

