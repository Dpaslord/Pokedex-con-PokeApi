//
//  ApiNetwork.swift
//  PokedexApi
//

import Foundation

class ApiNetwork {
    
    struct PokemonListResponse: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [PokemonListItem]
    }
    
    struct PokemonListItem: Codable, Identifiable {
        let name: String
        let url: String
        
        var id: Int {
            if let urlObject = URL(string: url) {
                return Int(urlObject.lastPathComponent) ?? 0
            }
            return 0
        }
        
        var imageUrl: URL? {
            return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
        }
    }
    
    
    struct PokemonDetail: Codable {
            let id: Int
            let name: String
            let height: Int
            let weight: Int
            let sprites: Sprites
            let types: [TypeSlot]
        }
        
        struct Sprites: Codable {
            let front_default: String?
        }
        
        struct TypeSlot: Codable {
            let type: TypeDetail
        }
        
        struct TypeDetail: Codable {
            let name: String
        }
    
    
    func getPokemons(limit: Int = 20, offset: Int = 0) async throws -> [PokemonListItem] {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        
        return response.results
    }
    
    func getPokemonDetail(id: Int) async throws -> PokemonDetail {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDetail.self, from: data)
    }
}
