//
//  RecipeJSON.swift
//  For JSON Dump
//
//  Created by Azarya Bernard on 13.10.21.
//

import Foundation


// MARK: - Response
public struct Response: Codable {
    public let from, to, count: Int?,
               _links: Links?,
               hits: [Hit]?
}

// MARK: - Hit
public struct Hit: Codable, Identifiable, Equatable  {
    public let recipe: Recipe?
    public let _links: HitLinks?

    
    public var id: String { recipe?.url ?? "" }
}

// MARK: - HitLinks
public struct HitLinks: Codable, Equatable {
    public static func == (lhs: HitLinks, rhs: HitLinks) -> Bool {
        lhs.linksSelf?.href == rhs.linksSelf?.href
    }
    
    public let linksSelf: NextLink?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Links
public struct Links: Codable {
    public let next: NextLink?
}

// MARK: - Next
public struct NextLink: Codable {
    public let href: String?
    let title: String?
}

// MARK: - Recipe
public struct Recipe: Codable, Equatable {
    public static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.url == rhs.url
    }
    let uri: String?
    
    public let label: String?,
               image: String?,
               source: String?,
               url: String?,
               shareAs: String?,
               yield: Int?,
               dietLabels, healthLabels: [String]?,
               cautions: [String]?,
               ingredientLines: [String]?,
               ingredients: [Ingredient]?,
               calories, totalWeight: Double?,
               totalTime: Int?,
               cuisineType: [String]?,
               mealType: [String]?,
               dishType: [String]?,
               totalNutrients, totalDaily: [String: Total]?,
               digest: [Digest]?
}

// MARK: - Digest
public struct Digest: Codable {
    public let label: String?,
               tag: String?,
               schemaOrgTag: String?,
               total: Double?,
               hasRDI: Bool?,
               daily: Double?,
               unit: String?,
               sub: [Digest]?
}

// MARK: - Ingredient
public struct Ingredient: Codable, Identifiable {
    public let text: String?,
               quantity: Double?,
               measure: String?,
               food: String?,
               weight: Double?,
               foodCategory: String?,
               foodId: String?,
               image: String?
    
    public var id: String { foodId ?? "" }
}

// MARK: - Total
public struct Total: Codable {
    public let label: String?,
               quantity: Double?,
               unit: String?
}

// MARK: - Helper function to return empty response
public func emptyResponse() -> Response {
    return Response(from: 0, to: 0, count: 0, _links: Links(next: NextLink(href: "", title: "")), hits: [])
}
