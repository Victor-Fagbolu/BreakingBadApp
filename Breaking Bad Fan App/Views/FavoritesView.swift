//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by COE on 8/18/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoritesView: View {
    
    @ObservedObject var characterViewModel = CharactersViewModel()
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16)
    ]
    
    @State private var searchText = ""
    @State private var searching = false
    
    var searchResults: [Character] {
        if searchText.isEmpty {
            return characterViewModel.characters
        } else {
            return characterViewModel.characters.filter {
                EpisosdesViewModel.searchString(text: $0.name, searchString: searchText) ||
                EpisosdesViewModel.searchString(text: $0.nickname, searchString: searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                SearchBarView(searchText: $searchText, searching: $searching)
                if characterViewModel.favoriteCharacters.isEmpty {
                    Text("Your favorite characters will appear here :)")
                        .foregroundColor(.secondary)
                }
                ScrollView {
                    LazyVGrid (columns: columns, content: {
                        ForEach(searchResults) { character in
                            if characterViewModel.favoriteCharacters.contains(character.name) {
                                NavigationLink(
                                    destination: CharacterDetailsView(character: character),
                                    label: {
                                        VStack(alignment: .center) {
                                            ZStack {
                                                WebImage(url: character.img)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 150)
                                                    .cornerRadius(8)
                                                Image(systemName: (characterViewModel.favoriteCharacters.contains(character.name) ? "star.fill" : "star"))
                                                    .frame(width: 20, height: 20, alignment: .leading)
                                                    .position(x: 10, y: 10)
                                                    .foregroundColor(.yellow)
                                                    .onTapGesture(perform: {
                                                        characterViewModel.updateFavorites(name: character.name)
                                                    })
                                                
                                            }
                                            Text(character.nickname)
                                        }
                                    })
                            }
                        }
                    })
                        .padding()
                }
                .navigationTitle(searching ? "Searching" : "Favorites")
                .toolbar {
                    if searching {
                        Button("Cancel") {
                            searchText = ""
                            withAnimation {
                                searching = false
                                UIApplication.shared.dismissKeyboard()
                            }
                        }
                    }
                }
                .onAppear(perform: {
                    characterViewModel.fetchCharacters()
                })
                
            }
        }
        .gesture(DragGesture()
                    .onChanged({ _ in
            searching = false
            UIApplication.shared.dismissKeyboard()
        }))
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
