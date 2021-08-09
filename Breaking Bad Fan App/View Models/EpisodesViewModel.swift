//
//  EpisodesViewModel.swift
//  EpisodesViewModel
//
//  Created by COE on 8/9/21.
//

import Foundation

class EpisosdesViewModel: ObservableObject {
    @Published var episodes = [Episode]()
    
    func fetchEpisodes() {
        let url = URL(string: "https://www.breakingbadapi.com/api/episodes")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let episodes = try decoder.decode([Episode].self, from: data)
                        DispatchQueue.main.async {
                            self.episodes = episodes
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
}
