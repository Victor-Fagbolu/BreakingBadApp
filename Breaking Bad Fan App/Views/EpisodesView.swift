//
//  EpisodesView.swift
//  EpisodesView
//
//  Created by COE on 8/9/21.
//

import SwiftUI

struct EpisodesView: View {
    
    @ObservedObject var epiodesViewModel = EpisosdesViewModel()
    
    @State private var searchText = ""
    @State private var searching = false
    
    var searchResults: [Episode] {
        if searchText.isEmpty {
            return epiodesViewModel.episodes
        } else {
            return epiodesViewModel.episodes.filter {
                EpisosdesViewModel.searchString(text: $0.title, searchString: searchText) ||
                EpisosdesViewModel.searchString(text: $0.series, searchString: searchText) ||
                EpisosdesViewModel.searchString(text: $0.season, searchString: searchText) ||
                EpisosdesViewModel.searchString(text: $0.episode, searchString: searchText) ||
                EpisosdesViewModel.searchCharacters(characters: $0.characters, text: searchText)
            }
        }
    }
    
    var body: some View {

        NavigationView {
            VStack {
                
                SearchBarView(searchText: $searchText, searching: $searching)
                
                List {
                    ForEach(searchResults) { episode in
                        NavigationLink(
                            destination: EpisodeDetailView(episode: episode),
                            label: {
                                VStack(alignment: .leading) {
                                    Text("Season # \(episode.season)")
                                    Text("Episode # \(episode.episode)")
                                    Text(episode.title)
                                }
                            })
                    }
                }
                .navigationTitle(searching ? "Searching" : "Episodes")
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
                    epiodesViewModel.fetchEpisodes()
                })
                .gesture(DragGesture()
                            .onChanged({ _ in
                    searching = false
                    UIApplication.shared.dismissKeyboard()
                }))
            }
        }
    }
}

struct EpisodesView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesView()
    }
}
