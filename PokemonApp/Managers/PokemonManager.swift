//
//  PokemonManager.swift
//  PokemonApp
//
//  Created by 123 on 23.02.24.
//

import Foundation

class PokemonManager {
    func getPokemon(offset: Int = 0, completion: @escaping ([Pokemon]?) -> Void) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/pokemon?offset=\(offset)", model: PokemonPage.self) { (pokemonPage: PokemonPage) in
            let pokemon = pokemonPage.results
            completion(pokemon)
        } failure: { error in
            print("Failed to fetch pokemon:", error)
            completion(nil)
        }
    }
    
    func getDetailedPokemon(id: Int, _ completition:@escaping (DetailPokemon) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/pokemon/\(id)/", model: DetailPokemon.self) {(detailPokemon: DetailPokemon) in
            completition(detailPokemon)
        } failure: { error in
            print(error)
        }
    }
}
