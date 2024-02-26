//
//  ContentView.swift
//  PokemonApp
//
//  Created by 123 on 23.02.24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel = PokemonViewModel()
    
    let adaptiveColumns = [
        GridItem(.adaptive(minimum: 180))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(viewModel.filteredPokemon) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                            PokemonView(pokemon: pokemon)
                        }
                    }
                }
                .padding(10)
                .animation(.easeIn(duration: 0.3), value: viewModel.filteredPokemon.count)
                .navigationTitle("Pokedex")
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(Color(.red))
            .searchable(text: $viewModel.searchText)
            
        }
        .environmentObject(viewModel)
        
    }
}


#Preview {
    ContentView()
}
