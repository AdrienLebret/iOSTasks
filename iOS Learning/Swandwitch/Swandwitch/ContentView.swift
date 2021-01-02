//
//  ContentView.swift
//  Swandwitch
//
//  Created by Adrien Lebret on 10/11/2020.
//

import SwiftUI

struct ContentView: View {
    
    let sandwiches = [
        Sandwich(name: "Toast", ingredients: ["🥑", "🍞"]),
        Sandwich(name: "Burger", ingredients: ["🥑", "🍔", "🥗"]),
        Sandwich(name: "Tacos", ingredients: ["🥑", "🌮"])
    ]
    
    var body: some View {
        NavigationView{
            List{
                // on ajoute les éléments du tableau dans la liste
                ForEach(sandwiches) { sandwich in
                    // l'avantage ici c'est que le nom du sandwich est le nom du fichier image que l'on a mis dans le dossier Assets
                    
                    // Navigation Link : Création de cellules cliquable
                    NavigationLink(
                        destination: SandwichDetail(sandwich: sandwich),
                        label: {
                            // Horizontal Stack
                            HStack{
                                Image(sandwich.name)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill) // garder proportion
                                    .frame(width: 80, height: 80) // changer taille
                                    .clipped() // couper ce qui dépasse
                                    .cornerRadius(10) // bord arrondi
                                
                                VStack(alignment: .leading){
                                    Text(sandwich.name)
                                        .font(.system(size: 22))
                                        .fontWeight(.medium)
                                    Text("\(sandwich.ingredients.count) ingrédients")
                                        .font(.system(size: 12))
                                    
                                }
                            }
                        })
                    
                    
                }
            }.navigationTitle("My Sandwiches")
        }
    }
}

// Défi pour vendredi ?
// Liste de programmes
// Image des frameworks
// Ajout d'une description *en dessous*

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
