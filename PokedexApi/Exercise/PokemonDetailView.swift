//
//  PokemonDetails.swift
//  PokedexApi
//

import SwiftUI
import SDWebImageSwiftUI

/// Vista encargada de mostrar el detalle completo de un Pokémon.
/// Gestiona estados de carga, error y contenido.
struct PokemonDetails: View {
    
    /// Identificador del Pokémon seleccionado.
    let id: Int
    
    /// Modelo detallado cargado desde la API.
    @State private var pokemon: ApiNetwork.PokemonDetail? = nil
    
    /// Indica si se está realizando la carga.
    @State private var isLoading: Bool = true
    
    /// Indica si ocurrió un error durante la carga.
    @State private var hasError: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // MARK: Estado Loading
            
            if isLoading {
                ProgressView("Buscando Pokémon...")
                    .tint(.white)
                    .foregroundColor(.white)
                    .controlSize(.large)
            
            // MARK: Estado Error
            
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
                    
                    Button("Reintentar") {
                        Task { await loadPokemon() }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
            
            // MARK: Estado Contenido
            
            } else if let pokemon = pokemon {
                
                VStack(spacing: 24) {
                    
                    // Imagen
                    if let spriteUrl = pokemon.sprites.front_default {
                        WebImage(url: URL(string: spriteUrl))
                            .resizable()
                            .indicator(.activity)
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                    }
                    
                    // Nombre e ID
                    VStack(spacing: 8) {
                        Text("#\(pokemon.id)")
                            .font(.title2).bold()
                            .foregroundColor(.gray)
                        
                        Text(pokemon.name.capitalized)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    // Tipos
                    HStack {
                        ForEach(pokemon.types, id: \.type.name) { typeSlot in
                            Text(typeSlot.type.name.capitalized)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.purple.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .task {
            await loadPokemon()
        }
    }
    
    /// Carga el detalle del Pokémon desde la API.
    /// Gestiona estados de carga y error.
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
