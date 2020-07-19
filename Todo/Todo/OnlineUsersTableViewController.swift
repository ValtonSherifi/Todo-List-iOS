//
//  OnlineUsersTableViewController.swift
//  TODO
//
//  Created by Valton Sherifi on 7/15/20.
//  Copyright © 2020 Valton Sherifi. All rights reserved.
//
import UIKit
import Firebase

class OnlineUsersTableViewController: UITableViewController {
  
  // MARK: Constants
  let userCell = "UserCell"
  
  // MARK: Properties
  var currentUsers: [String] = []
  let usersRef = Database.database().reference(withPath: "online")
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
//Krijon nje vezhgues që dëgjon per te dhenat e shtuara ne userRef.
    usersRef.observe(.childAdded, with: { snap in
      //Merr vleren e snapshot dhe e vendos ate ne vargun lokal currentUsers
      guard let email = snap.value as? String else { return }
      self.currentUsers.append(email)
      let row = self.currentUsers.count - 1// rreshti eshte gjithmone numri i vargut -1 sepse vargu fillon te numerohet nga 0
      let indexPath = IndexPath(row: row, section: 0)//Krijimi i instances NSIndexPath duke perdorur indeksin e rreshtit llogaritur.
      self.tableView.insertRows(at: [indexPath], with: .top)// Inserton rreshtin duke përdorur një animacion që bën që rreshti të insertohet nga lart.
    })
    //Perdorja e aplikacionit nga perdoruesit te cilet nuk kane lidhje interneti
    usersRef.observe(.childRemoved, with: { snap in
      guard let emailToFind = snap.value as? String else { return }
      for (index, email) in self.currentUsers.enumerated() {
        if email == emailToFind {
          let indexPath = IndexPath(row: index, section: 0)
          self.currentUsers.remove(at: index)
          self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
      }
    })
  }
  
//Numri i rreshtave në tabele
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentUsers.count // Numerimi i listes
  }
  //Krijimi i rreshtave ne baze te te dhenave ne vargun currentUsers
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
    let onlineUserEmail = currentUsers[indexPath.row] //indeksimi per qdo rresht ne tabele
    //vendosja e vlerave ne labela, ne baze te vargut te te dhenave Item
    cell.textLabel?.text = onlineUserEmail
    return cell
  }
  
  // MARK: Actions
  @IBAction func signoutButtonPressed(_ sender: AnyObject) {
    let user = Auth.auth().currentUser!
    let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
    onlineRef.removeValue { (error, _) in
      if let error = error {
        print("Removing online failed: \(error)")
        return
      }
      do {
        try Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
      } catch (let error) {
        print("Auth sign out failed: \(error)")
      }
    }
  }
}
