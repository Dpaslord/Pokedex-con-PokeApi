//
//  ApiNetwork.swift
//  PokedexApi
//

import Foundation

/// Clase responsable de gestionar las llamadas a la API pública PokeAPI.
/// Contiene los modelos necesarios para decodificar las respuestas
/// y los métodos para obtener listado y detalle de Pokémon.
class ApiNetwork {
    
    // MARK: - Modelos de Respuesta
    
    /// Respuesta paginada del endpoint `/pokemon`
    struct PokemonListResponse: Codable {
        /// Número total de Pokémon disponibles en la API
        let count: Int
        
        /// URL de la siguiente página (si existe)
        let next: String?
        
        /// URL de la página anterior (si existe)
        let previous: String?
        
        /// Lista de resultados básicos (nombre + url)
        let results: [PokemonListItem]
    }
    
    /// Representa un Pokémon dentro del listado.
    /// Incluye lógica para extraer el ID desde la URL.
    struct PokemonListItem: Codable, Identifiable {
        let name: String
        let url: String
        
        /// Identificador único extraído del último componente de la URL.
        var id: Int {
            if let urlObject = URL(string: url) {
                return Int(urlObject.lastPathComponent) ?? 0
            }
            return 0
        }
        
        /// URL de la imagen oficial del Pokémon (sprite).
        var imageUrl: URL? {
            URL(string:
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
            )
        }
    }
    
    /// Modelo detallado de un Pokémon.
    struct PokemonDetail: Codable {
        let id: Int
        let name: String
        let height: Int
        let weight: Int
        let sprites: Sprites
        let types: [TypeSlot]
    }
    
    /// Información de sprites del Pokémon.
    struct Sprites: Codable {
        let front_default: String?
    }
    
    /// Representa un slot de tipo del Pokémon.
    struct TypeSlot: Codable {
        let type: TypeDetail
    }
    
    /// Detalle del tipo del Pokémon (ej: fire, water, grass).
    struct TypeDetail: Codable {
        let name: String
    }
    
    // MARK: - Peticiones de Red
    
    /// Obtiene una lista paginada de Pokémon.
    ///
    /// - Parameters:
    ///   - limit: Número de elementos por página.
    ///   - offset: Posición inicial para paginación.
    /// - Returns: Array de `PokemonListItem`.
    /// - Throws: Error de red o decodificación.
    func getPokemons(limit: Int = 20, offset: Int = 0) async throws -> [PokemonListItem] {
        
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        
        return response.results
    }
    
    /// Obtiene el detalle completo de un Pokémon por ID.
    ///
    /// - Parameter id: Identificador del Pokémon.
    /// - Returns: `PokemonDetail` con información ampliada.
    /// - Throws: Error de red o decodificación.
    func getPokemonDetail(id: Int) async throws -> PokemonDetail {
        
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDetail.self, from: data)
    }
}
