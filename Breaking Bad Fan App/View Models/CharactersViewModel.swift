//
//  CharacterViewModel.swift
//  CharacterViewModel
//
//  Created by COE on 8/9/21.
//

import Foundation

class CharactersViewModel: ObservableObject {
    @Published var characters = [Character]()
    
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
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
}
