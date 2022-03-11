//
//  Pokemon.swift
//  EasyRealm
//
//  Created by Allan Vialatte on 10/03/2017.
//


import Foundation
import RealmSwift

final class Pokeball:Object {
  @objc dynamic var identifier = UUID().uuidString
  @objc dynamic var level = 1
  @objc dynamic var branding = ""
  
  override static func primaryKey() -> String? {
    return "identifier"
  }
  
  static func create() -> Pokeball {
    let ball = Pokeball()
    ball.level = Int(arc4random()) % 5
    return ball
  }
  
}

final class Pokemon: Object {
  @objc dynamic var name: String?
  @objc dynamic var level: Int = 1
  @objc dynamic var pokeball:Pokeball?
  let specialBoost = RealmProperty<Int?>()
  
  override static func primaryKey() -> String? {
    return "name"
  }
}
