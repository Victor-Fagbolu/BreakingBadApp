//
//  CharactersView.swift
//  CharactersView
//
//  Created by COE on 8/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharactersView: View {
    
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
                
                ScrollView {
                    LazyVGrid (columns: columns, content: {
                        ForEach(searchResults) { character in
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
                .navigationTitle(searching ? "Searching" : "Characters")
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

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
