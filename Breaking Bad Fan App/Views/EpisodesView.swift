//
//  EpisodesView.swift
//  EpisodesView
//
//  Created by COE on 8/9/21.
//

import SwiftUI

struct EpisodesView: View {
    
    @ObservedObject var epiodesViewModel = EpisosdesViewModel()
    
    var body: some View {

        NavigationView {
            List {
                ForEach(epiodesViewModel.episodes) { episode in
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
            .navigationTitle("Episodes")
            .onAppear(perform: {
                epiodesViewModel.fetchEpisodes()
            })
        }
    }
}

struct EpisodesView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesView()
    }
}
