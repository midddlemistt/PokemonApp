//
//  PokemonView.swift
//  PokemonApp
//
//  Created by 123 on 24.02.24.
//

import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            AsyncImage(url: viewModel.getPokemonImageURL(pokemon: pokemon)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
            } placeholder: {
                ProgressView()
                    .frame(width: 180, height: 180)
            }
                
                Text("\(pokemon.name.capitalized)")
                    .font(.system(size: 25, weight: .bold, design: .monospaced))
                    .foregroundStyle(.black)
                    .padding(.bottom, 10)
                
            }
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

#Preview {
    PokemonView(pokemon: Pokemon.samplePokemon)
        .environmentObject(PokemonViewModel())
}
