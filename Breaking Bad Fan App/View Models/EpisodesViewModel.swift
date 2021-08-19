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
        
    @Published var sriesKeys = [String]()
    @Published var seriesToSeason = [String:[String]]()
    @Published var episosdeStructure = [String: [String:[Episode]]]()
    
    
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
                            self.organizeEpisodes(episodes: episodes)
                            self.episodes = episodes
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    // Creates a trie data scructure using dictionaries
    func organizeEpisodes(episodes : [Episode]) {
        // Reset all organizational structures
        self.sriesKeys.removeAll()
        self.seriesToSeason.removeAll()
        self.episosdeStructure.removeAll()
        for episode in episodes {
            insertIntoStruucture(episode: episode)
        }
    }
    // Inssert an into the correct pisition in the trie data scrcture
    func insertIntoStruucture(episode: Episode) {
        let episodeSeries = episode.series
        let episodeSeason = episode.season.trimmingCharacters(in: .whitespacesAndNewlines)
        //Check Series
        if self.episosdeStructure[episodeSeries] == nil {
            self.sriesKeys.append(episodeSeries)
            self.episosdeStructure[episodeSeries] = [String:[Episode]]()
        }
        
        //Check Season
        if self.episosdeStructure[episodeSeries]![episodeSeason] == nil {
            if self.seriesToSeason[episodeSeries] == nil {
                self.seriesToSeason[episodeSeries] = [String]()
            }
            if !self.seriesToSeason[episodeSeries]!.contains(episodeSeason) { // if the episosde is not already in the array
                //Typo in the API with season:" 1" ... extra space in string
                self.seriesToSeason[episodeSeries]!.append(episodeSeason)
            }
            self.episosdeStructure[episodeSeries]![episodeSeason] = [Episode]()
        }
        
        self.episosdeStructure[episode.series]![episodeSeason]!.append(episode)
    }
    
    // Retrives all character information given a character array
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
    
    //Ussed by the search bar to filter elements
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
