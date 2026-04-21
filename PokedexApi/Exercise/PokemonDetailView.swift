//
//  PokemonDetails.swift
//  PokedexApi
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonDetails: View {
    let id: Int
    
    @State private var pokemon: ApiNetwork.PokemonDetail? = nil
    @State private var isLoading: Bool = true
    @State private var hasError: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if isLoading {
                ProgressView("Buscando Pokémon...")
                    .tint(.white)
                    .foregroundColor(.white)
                    .controlSize(.large)
                
            } else if hasError {
                VStack(spacing: 16) {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    Text("Error de conexión")
                        .font(.title2).bold()
                        .foregroundColor(.white)
                    
                    Text("No se pudo cargar el Pokémon. Comprueba tu conexión a internet.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        Task { await loadPokemon() }
                    }) {
                        Text("Reintentar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 200)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                }
                
            } else if let pokemon = pokemon {
                VStack(spacing: 24) {
                    
                    if let spriteUrl = pokemon.sprites.front_default {
                        WebImage(url: URL(string: spriteUrl))
                            .resizable()
                            .indicator(.activity)
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .background(Circle().fill(Color.gray.opacity(0.2)))
                            .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    
                    VStack(spacing: 8) {
                        Text("#\(pokemon.id)")
                            .font(.title2).bold()
                            .foregroundColor(.gray)
                        
                        Text(pokemon.name.capitalized)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 12) {
                        ForEach(pokemon.types, id: \.type.name) { typeSlot in
                            Text(typeSlot.type.name.capitalized)
                                .font(.headline)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.purple.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                    
                    HStack(spacing: 60) {
                        VStack(spacing: 4) {
                            Text("Altura")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(pokemon.height) dm")
                                .font(.title3).bold()
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Peso")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(pokemon.weight) hg")
                                .font(.title3).bold()
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .task {
            await loadPokemon()
        }
    }
    
    // MARK: - Función de llamada con manejo de errores
    func loadPokemon() async {
        isLoading = true
        hasError = false
        
        do {
            pokemon = try await ApiNetwork().getPokemonDetail(id: id)
            isLoading = false
        } catch {
            print("Error al cargar el detalle: \(error)")
            isLoading = false
            hasError = true
        }
    }
}

#Preview {
    PokemonDetails(id: 1)
}
