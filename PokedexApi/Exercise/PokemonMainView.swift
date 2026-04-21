//
//  ContentView.swift
//  PokedexApi
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonMainView: View {
    @State var pokemons: [ApiNetwork.PokemonListItem] = []
    @State var loading: Bool = false
    @State var currentOffset: Int = 0
    let limit: Int = 20
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if pokemons.isEmpty && loading {
                    ProgressView().tint(.white)
                } else {
                    List {
                        ForEach(pokemons) { pokemon in
                            ZStack {
                                PokemonItem(pokemon: pokemon)
                                
                                NavigationLink(destination: PokemonDetails(id: pokemon.id)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onAppear {
                                if pokemon.id == pokemons.last?.id {
                                    loadMorePokemons()
                                }
                            }
                        }
                        
                        if loading {
                            HStack {
                                Spacer()
                                ProgressView().tint(.white)
                                Spacer()
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Pokédex")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .task {
                if pokemons.isEmpty {
                    await fetchPokemons()
                }
            }
        }
    }
    
    func fetchPokemons() async {
        loading = true
        do {
            let newPokemons = try await ApiNetwork().getPokemons(limit: limit, offset: currentOffset)
            pokemons.append(contentsOf: newPokemons)
            currentOffset += limit
        } catch {
            print("Error cargando pokemons: \(error)")
        }
        loading = false
    }
    
    func loadMorePokemons() {
        guard !loading else { return }
        Task {
            await fetchPokemons()
        }
    }
}

struct PokemonItem: View {
    let pokemon: ApiNetwork.PokemonListItem
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.3))
            
            HStack {
                WebImage(url: pokemon.imageUrl)
                    .resizable()
                    .indicator(.activity)
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("#\(pokemon.id)")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(pokemon.name.capitalized)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding()
        }
        .frame(height: 120)
    }
}

#Preview {
    PokemonMainView()
}
