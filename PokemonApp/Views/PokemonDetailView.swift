//
//  PokemonDetailView.swift
//  PokemonApp
//
//  Created by 123 on 24.02.24.
//

import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            VStack {
                PokemonView(pokemon: pokemon)
                if let types = viewModel.pokemonDetails?.types {
                    ForEach(types.indices, id: \.self) { index in
                        Text("Type: \(types[index].type.name.capitalized)")
                    }
                }
                Text("Weight: \(viewModel.formatWeight(value: viewModel.pokemonDetails?.weight ?? 0)) KG")
                Text("Height: \(viewModel.formatHeight(value: viewModel.pokemonDetails?.height ?? 0)) CM")
            }
        }
        .onAppear {
            viewModel.getDetails(pokemon: pokemon)
        }
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon)
        .environmentObject(PokemonViewModel())
}
