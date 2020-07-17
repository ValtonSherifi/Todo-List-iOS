//
//  User.swift
//  Todo
//
//  Created by Djellza Rrustemi on 7/17/20.
//  Copyright © 2020 Valton Sherifi. All rights reserved.
//

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  
  init(authData: Firebase.User) {
    uId = authData.uid
    Email = authData.email!
  }
