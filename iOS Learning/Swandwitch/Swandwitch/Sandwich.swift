//
//  Sandwich.swift
//  Swandwitch
//
//  Created by Adrien Lebret on 13/11/2020.
//

import Foundation


struct Sandwich: Identifiable {
    // Définition de notre moule de notre structure de données
    let id = UUID().uuidString
    let name: String
    let ingredients: [String]
}
