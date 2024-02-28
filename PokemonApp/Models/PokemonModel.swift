//
//  PokemonModel.swift
//  PokemonApp
//
//  Created by 123 on 23.02.24.
//

import Foundation

struct PokemonPage: Codable {
    let count: Int
    let next: String?
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: String
    
    static var samplePokemon = Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
}

struct DetailPokemon: Codable {
    let types: [PokemonTypeSlot]
    let weight: Int
    let height: Int
    
    
}

struct PokemonTypeSlot: Codable {
    var id: Int { slot }
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: String
}
