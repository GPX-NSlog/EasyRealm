//
//  Test_Save.swift
//  EasyRealm
//
//  Created by Allan Vialatte on 10/03/2017.
//

import XCTest
import RealmSwift
import EasyRealm

class TestSave: XCTestCase {
  
  let testPokemon = ["Bulbasaur", "Ivysaur", "Venusaur","Charmander","Charmeleon","Charizard"]
  
  override func setUp() {
    super.setUp()
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
  }
  
  override func tearDown() {
    super.tearDown()
    let realm = try! Realm()
    try! realm.write { realm.deleteAll() }
  }
  
  func testSaveUnmanaged() {
    HelpPokemon.pokemons(with: self.testPokemon).forEach { try! $0.er.save(update: .all) }
    HelpPokemon.pokemons(with: self.testPokemon).forEach { try! $0.er.save(update: .all) }
    try! Pokeball.create().er.save()
    try! Pokeball.create().er.save()
    let numberOfPokemon = try! Pokemon.er.all()
    let numberOfPokeball = try! Pokeball.er.all()
    XCTAssertEqual(self.testPokemon.count, numberOfPokemon.count)
    XCTAssertEqual(2, numberOfPokeball.count)
  }

  func testSaveManaged() {
    HelpPokemon.pokemons(with: self.testPokemon).forEach { try! $0.er.save(update: .all) }
    let managedPokemon = testPokemon.compactMap { try! Pokemon.er.fromRealm(with: $0) }
    managedPokemon.forEach { try! $0.er.save(update: .all) }
  }
  
  func testMeasureSaveUnmanaged() {
    self.measure {
      try! Pokeball.create().er.save()
    }
  }

  func testMeasureSaveManaged() {
    let pokemon = HelpPokemon.pokemons(with: [self.testPokemon[0]]).first!
    try! pokemon.er.save(update: .all)
    self.measure {
      try! pokemon.er.save(update: .all)
    }
  }


  func testSaveLotOfComplexObject() {
    for _ in 0...10000 {
      try! HelpPokemon.generateCapturedRandomPokemon().er.save(update: .all)
    }
  }
  
}
