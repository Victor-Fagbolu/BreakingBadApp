//
//  CharacterViewModel.swift
//  CharacterViewModel
//
//  Created by COE on 8/9/21.
//

import Foundation

class CharactersViewModel: ObservableObject {
    @Published var characters = [Character]()
    
    let favoritesKey = "favorite_key"
    @Published var favoriteCharacters = Set<String>()
    
    func fetchCharacters() {
        let url = URL(string: "https://www.breakingbadapi.com/api/characters")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let characters = try decoder.decode([Character].self, from: data)
                        DispatchQueue.main.async {
                            self.characters = characters
                            self.getFavorites()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    func updateFavorites(name: String) {
        if favoriteCharacters.contains(name) {
            favoriteCharacters.remove(name)
        } else {
            favoriteCharacters.insert(name)
        }
        saveFavorites()
    }
    
    func getFavorites() {
        favoriteCharacters.removeAll()
        guard let favorites = UserDefaults.standard.array(forKey: favoritesKey) else { return }
        for name in favorites {
            favoriteCharacters.insert(name as! String)
        }
        
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteCharacters), forKey: favoritesKey)
    }
}
