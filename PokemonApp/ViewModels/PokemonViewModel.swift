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
    @Published var pokemonDetails: DetailPokemon?
    @Published var searchText = ""
    
    var filteredPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter {
            $0.name.contains(searchText.lowercased())
        }
    }
    
    init() {
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
        
        self.pokemonDetails = DetailPokemon(types: [], weight: 0, height: 0)
        
        pokemonManager.getDetailedPokemon(id: id) {data in
            DispatchQueue.main.async {
                self.pokemonDetails = data
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
