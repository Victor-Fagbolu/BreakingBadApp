//
//  EpisodeDetailView.swift
//  EpisodeDetailView
//
//  Created by COE on 8/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct EpisodeDetailView: View {
    @ObservedObject var epiodesViewModel = EpisosdesViewModel()
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16)
    ]
    
    var episode: Episode
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Image(episode.series == "Breaking Bad" ? "breaking-bad-banner" : "better-call-saul-banner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Spacer()
            VStack(alignment: .center) {
                Text(episode.title)
                    .font(.largeTitle)
                Text("Season \(episode.season), Epiosde \(episode.episode)")
                Text("Aired on \(episode.air_date)")
                    .foregroundColor(.secondary)
            }
            Spacer().frame(height: 30)
            VStack(alignment: .leading) {
                Text("Main Characters")
                    .font(.title2)
                ScrollView {
                    LazyVGrid (columns: columns, content: {
                        ForEach(epiodesViewModel.characters) { character in
                            NavigationLink(
                                destination: CharacterDetailsView(character: character),
                                label: {
                                    VStack(alignment: .center) {
                                        WebImage(url: character.img)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 150)
                                            .cornerRadius(8)
                                        Text(character.name)
                                    }
                                })
                        }
                    })
                }
                .onAppear(perform: {
                    epiodesViewModel.fetchCharactersForEpisosde(episodeCharacters: episode.characters)
                })

            }
        }
        
        
    }
}

//struct EpisodeDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EpisodeDetailView()
//    }
//}
