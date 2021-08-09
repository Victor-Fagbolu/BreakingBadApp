//
//  CharactersView.swift
//  CharactersView
//
//  Created by COE on 8/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharactersView: View {
    
    @ObservedObject var characterViewModel = CharacterViewModel()
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid (columns: columns, content: {
                    ForEach(characterViewModel.characters) { character in
                        NavigationLink(
                            destination: CharacterDetailsView(character: character),
                            label: {
                                VStack(alignment: .center) {
                                    WebImage(url: character.img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 150)
                                        .cornerRadius(8)
                                    Text(character.nickname)
                                }
                            })
                    }
                })
                    .padding()
            }
            .navigationTitle("Characters")
            .onAppear(perform: {
                characterViewModel.fetchCharacters()
            })
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
