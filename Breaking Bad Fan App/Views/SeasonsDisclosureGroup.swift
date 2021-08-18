//
//  SeasonsDisclosureGroup.swift
//  SeasonsDisclosureGroup
//
//  Created by COE on 8/17/21.
//

import SwiftUI

struct SeasonsDisclosureGroup: View {
    @State private var isExpanded = false
    
    var series: String
    var season: String
    @ObservedObject var viewModel: EpisosdesViewModel
    
    init(series: String, season: String, viewModel: EpisosdesViewModel) {
        self.series = series
        self.season = season
        self.viewModel = viewModel
    }
    
    var body: some View {
        DisclosureGroup(
          content: {
              VStack {
                  Divider()
                  ForEach(viewModel.episosdeStructure[series]![season]!) { episode in
                      NavigationLink(
                          destination: EpisodeDetailView(episode: episode),
                          label: {
                              VStack{ // Episode Containter
                                  Text("\(episode.episode). \(episode.title)")
                                      .frame(maxWidth: .infinity, alignment: .leading)
                                      .padding()
                              }
                          })
                  }
              }
          },
          label: {
            Text("Season \(season)")
                  .font(.title2)
          }
        )
            .accentColor(.white)
            .font(.title2)
            .foregroundColor(.white)
            .padding(.all)
            .background(Color("SeasonsClosureBackground"))
            .cornerRadius(8)
            Spacer()
            
                .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//struct SeasonsDisclosureGroup_Previews: PreviewProvider {
//    static var previews: some View {
//        SeasonsDisclosureGroup()
//    }
//}
