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
    
    @State private var isExpanded = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText, searching: $searching)
                if searchText.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading) { // ScrollView Containter
                            ForEach(epiodesViewModel.sriesKeys, id: \.self) { series in
                                VStack(alignment: .leading) { // Series Containter
                                    Text(series)
                                        .font(.title)
                                    ForEach((epiodesViewModel.seriesToSeason[series] != nil) ? epiodesViewModel.seriesToSeason[series]! : [], id: \.self) { season in
                                        VStack(alignment: .leading) { // Seasons Containter
                                            SeasonsDisclosureGroup(series: series, season: season, viewModel: epiodesViewModel)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    Spacer().frame(height: 20)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    List {
                        ForEach(searchResults) { episode in
                            VStack {
                                NavigationLink(
                                    destination: EpisodeDetailView(episode: episode),
                                    label: {
                                        VStack(alignment: .leading) {
                                            Text("Season \(episode.season)")
                                            Text("Episode \(episode.episode)")
                                            Text(episode.title)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    })
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
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
            .gesture(DragGesture()
                        .onChanged({ _ in
                searching = false
                UIApplication.shared.dismissKeyboard()
            }))
        }
        .onAppear(perform: {
            epiodesViewModel.fetchEpisodes()
        })
    }
}

struct EpisodesView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesView()
    }
}
