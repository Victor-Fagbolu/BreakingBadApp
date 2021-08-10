//
//  EpisodesViewModel.swift
//  EpisodesViewModel
//
//  Created by COE on 8/9/21.
//

import Foundation

class EpisosdesViewModel: ObservableObject {
    @Published var episodes = [Episode]()
    @Published var characters = [Character]()
    
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
    
    func fetchCharactersForEpisosde(episodeCharacters: [String]) {
        characters.removeAll()
        let sortedCharacters = episodeCharacters.sorted()
        for characterName in sortedCharacters {
            let queryCharacterName = editName(name: characterName)
            let url = URL(string: "https://www.breakingbadapi.com/api/characters?name=\(queryCharacterName)")!
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let character = try decoder.decode([Character].self, from: data)
                            DispatchQueue.main.async {
                                self.characters.append(contentsOf: character)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func editName(name: String) -> String {
        // In some insances, some names in episosdes.characters do not match with the acual name(sometime it uses a nickname)
        // that will be used for lookup.
        // Manually edit them here. However cannot find EVERY instance of this so the episode detail screen mayy not contain all
        // main characters in that episode. However the main-main characters are accounted for.
        var editedName = name
        editedName = editedName.replacingOccurrences(of: "Kim Wexler", with: "Kimberly Wexler")
        editedName = editedName.replacingOccurrences(of: "Nacho Varga", with: "Ignacio Varga")
        editedName = editedName.replacingOccurrences(of: "Mike Erhmantraut", with: "Mike Ehrmantraut")
        editedName = editedName.replacingOccurrences(of: "Charles McGill", with: "Chuck McGill")
        editedName = editedName.replacingOccurrences(of: "Badger", with: "Brandon Mayhew")
        editedName = editedName.replacingOccurrences(of: "Ken Wins", with: "Ken")
        editedName = editedName.replacingOccurrences(of: "Krazy-8", with: "Domingo Molina")
        editedName = editedName.replacingOccurrences(of: "Hank", with: "Henry")
        editedName = editedName.replacingOccurrences(of: " ", with: "+")
        return editedName
    }
    
    static func searchCharacters(characters: [String], text: String) -> Bool {
        for character in characters {
            if searchString(text: character, searchString: text) {
                return true
            }
        }
        return false
    }
    
    static func searchString(text: String, searchString: String) -> Bool {
        return text.replacingOccurrences(of: " ", with: "").lowercased().contains(searchString.replacingOccurrences(of: " ", with: "").lowercased())
    }
}
