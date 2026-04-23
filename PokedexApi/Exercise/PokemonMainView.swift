//
//  PokemonMainView.swift
//  PokedexApi
//

import SwiftUI
import SDWebImageSwiftUI

/// Vista principal de la Pokédex.
/// Muestra listado paginado con carga infinita.
struct PokemonMainView: View {
    
    /// Lista acumulada de Pokémon cargados.
    @State var pokemons: [ApiNetwork.PokemonListItem] = []
    
    /// Indica si se está realizando una petición.
    @State var loading: Bool = false
    
    /// Offset actual para paginación.
    @State var currentOffset: Int = 0
    
    /// Número de elementos por página.
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
                                
                                NavigationLink(
                                    destination: PokemonDetails(id: pokemon.id)
                                ) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .onAppear {
                                // Carga infinita al llegar al último elemento
                                if pokemon.id == pokemons.last?.id {
                                    loadMorePokemons()
                                }
                            }
                        }
                        
                        if loading {
                            ProgressView().tint(.white)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Pokédex")
            .task {
                if pokemons.isEmpty {
                    await fetchPokemons()
                }
            }
        }
    }
    
    /// Realiza la petición paginada de Pokémon.
    func fetchPokemons() async {
        loading = true
        do {
            let newPokemons = try await ApiNetwork()
                .getPokemons(limit: limit, offset: currentOffset)
            
            pokemons.append(contentsOf: newPokemons)
            currentOffset += limit
        } catch {
            print("Error cargando pokemons: \(error)")
        }
        loading = false
    }
    
    /// Dispara nueva carga si no se está ya cargando.
    func loadMorePokemons() {
        guard !loading else { return }
        Task {
            await fetchPokemons()
        }
    }
}

/// Vista que representa una celda individual del listado.
struct PokemonItem: View {
    
    /// Pokémon a representar
    let pokemon: ApiNetwork.PokemonListItem
    
    var body: some View {
        HStack {
            WebImage(url: pokemon.imageUrl)
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading) {
                Text("#\(pokemon.id)")
                    .foregroundColor(.gray)
                
                Text(pokemon.name.capitalized)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(16)
    }
}
