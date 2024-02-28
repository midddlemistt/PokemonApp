//
//  PokemonViewModel.swift
//  PokemonApp
//
//  Created by 123 on 24.02.24.
//

import Foundation
import SwiftUI

final class PokemonViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    
    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetailsCache = [Int: DetailPokemon]()
    @Published var pokemonImageCache = NSCache<NSString, UIImage>()
    @Published var pokemonDetails: DetailPokemon?
    @Published var searchText = ""
    
    var filteredPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter {
            $0.name.contains(searchText.lowercased())
        }
    }
    
    init() {
        loadCachedPokemon()
        fetchPokemon()
    }
    
    func fetchPokemon(offset: Int = 0) {
            pokemonManager.getPokemon(offset: offset) { [weak self] pokemon in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let pokemon = pokemon, !pokemon.isEmpty {
                        self.pokemonList.append(contentsOf: pokemon)
                        let nextOffset = offset + pokemon.count
                        self.fetchPokemon(offset: nextOffset)
                    }
                }
            }
        }
    
    func getPokemonIndex(pokemon:Pokemon) -> Int {
        if let index = self.pokemonList.firstIndex(of: pokemon) {
            return index + 1
        }
        return 0
    }
    
    func getDetails(pokemon:Pokemon) {
        let id = getPokemonIndex(pokemon: pokemon)
        
        if let cachedDetails = pokemonDetailsCache[id] {
            self.pokemonDetails = cachedDetails
        } else {
            self.pokemonDetails = DetailPokemon(types: [], weight: 0, height: 0)
            
            pokemonManager.getDetailedPokemon(id: id) { [weak self] data in
                DispatchQueue.main.async {
                    self?.pokemonDetails = data
                    self?.pokemonDetailsCache[id] = data
                    self?.saveDetails(forId: id)
                }
            }
        }
    }
    
    func saveDetails(forId id: Int) {
            if let details = pokemonDetails {
                if let encodedDetails = try? JSONEncoder().encode(details) {
                    UserDefaults.standard.set(encodedDetails, forKey: "pokemonDetails_\(id)")
                }
            }
        }
    
    func getPokemonImage(pokemon: Pokemon, completion: @escaping (UIImage?) -> Void) {
            guard let index = pokemonList.firstIndex(of: pokemon) else {
                completion(nil)
                return
            }
            
            if let cachedImage = pokemonImageCache.object(forKey: NSString(string: "\(index + 1)")) {
                completion(cachedImage)
            } else {
                guard let urlString = getPokemonImageURL(pokemon: pokemon)?.absoluteString,
                      let url = URL(string: urlString) else {
                    completion(nil)
                    return
                }
                
                URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                    guard let data = data, let image = UIImage(data: data) else {
                        completion(nil)
                        return
                    }
                    
                    self?.pokemonImageCache.setObject(image, forKey: NSString(string: "\(index + 1)"))
                    
                    completion(image)
                }.resume()
            }
        }
    
    func getPokemonImageURL(pokemon: Pokemon) -> URL? {
        guard let index = pokemonList.firstIndex(of: pokemon) else {
            return nil
        }
        
        if let cachedImageURL = getCachedImageURL(forIndex: index) {
            return cachedImageURL
        } else {
            let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index + 1).png"
            downloadAndCacheImage(from: URL(string: urlString), index: index)
            return nil
        }
    }

    private func downloadAndCacheImage(from url: URL?, index: Int) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let fileManager = FileManager.default
            if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
                let imageUrl = cacheDirectory.appendingPathComponent("\(index + 1).png")
                do {
                    try data.write(to: imageUrl)
                } catch {
                    print("Error saving image to cache:", error)
                }
            }
        }.resume()
    }

    private func getCachedImageURL(forIndex index: Int) -> URL? {
        let fileManager = FileManager.default
        if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let imageUrl = cacheDirectory.appendingPathComponent("\(index + 1).png")
            if fileManager.fileExists(atPath: imageUrl.path) {
                return imageUrl
            }
        }
        return nil
    }
    
    func savePokemon() {
        if let encodedPokemon = try? JSONEncoder().encode(self.pokemonList) {
            UserDefaults.standard.set(encodedPokemon, forKey: "cachedPokemon")
        }
    }
    
    func loadCachedPokemon() {
            if let cachedPokemon = UserDefaults.standard.data(forKey: "cachedPokemon") {
                if let decodedPokemon = try? JSONDecoder().decode([Pokemon].self, from: cachedPokemon) {
                    self.pokemonList = decodedPokemon
                }
            }
        }
    
    func formatWeight(value:Int) -> String {
        let doubleValue = Double(value)
        let string = String(format: "%.2f", doubleValue / 10)
        
        return string
    }
    
    func formatHeight(value:Int) -> String {
        let value = Double(value)
        let string = String(value * 10)
        return string
    }
    
}
