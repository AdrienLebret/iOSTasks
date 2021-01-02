//
//  SandwichDetail.swift
//  Swandwitch
//
//  Created by Adrien Lebret on 13/11/2020.
//

import SwiftUI

struct SandwichDetail: View {
    
    @State var isZoomed: Bool = false
    
    let sandwich: Sandwich
    
    var body: some View {
        VStack {
            Image(sandwich.name)
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(height: isZoomed ? nil : 300)
                .clipped()
                .onTapGesture(count: 1, perform: {
                    withAnimation{
                        isZoomed.toggle() // toggle - inversion du booléan
                    }
                }) // lorsque je tape sur l'image
            Spacer()
        }
    }
}

struct SandwichDetail_Previews: PreviewProvider {
    
    // test pour la preview
    static let testSand = Sandwich(name: "Tacos", ingredients: ["", "", ""])
    
    // ce qu'on a besoin de nous transmettre
    static var previews: some View {
        SandwichDetail(sandwich: testSand)
    }
}
