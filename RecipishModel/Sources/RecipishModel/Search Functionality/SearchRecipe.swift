//
//  SearchRecipe.swift
//  
//
//  Created by Azarya Bernard on 13.10.21.
//
import Foundation
import Combine
import SwiftUI


public class SearchRecipe {
    // internal error message, used by ResultListViewModel
    public internal(set) var errorMessage: String? = nil
    
    /// public initializer
    public init() {}
    
    
    /// the main search function
    public func search(directLink: String?, toSearch: String?, queries: [(name: String, value: String)?]) -> AnyPublisher<Response, Never>? {
        do {
            let url = try linkBuilder(directLink, toSearch, queries)
            print("Success")
            return getResponse(for: url)
            
        } catch ErrorUtility.InvalidURL {
            self.errorMessage = "ERROR: Invalid URL!"
        } catch ErrorUtility.NoSearchWords {
            self.errorMessage = "ERROR: No Search Word!"
        } catch {
            self.errorMessage = "ERROR: Unknown!"
        }
        print(self.errorMessage ?? "ERROR")
        return nil
    }
    
    
    //  MARK: API CALL USING COMBINE
    /// return publisher to be used in the main search function,
    /// with a sink subscriber processing the data
    private func getResponse(for url: URL) -> AnyPublisher<Response, Never> {
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder()).eraseToAnyPublisher()
            .mapError({ er -> ErrorUtility in
                print("ERROR: Session / Decoder Error! \(er)")
                return ErrorUtility.DecoderError
            })
            .replaceError(with: emptyResponse())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    
    /// try to build a valid link from either direct link or search and filter queries
    private func linkBuilder(_ directLink: String?, _ toSearch: String?, _ queries: [(name: String, value: String)?]) throws -> URL {
        let urlString = directLink ?? {
            /// Query items for the URLComponents
            /// API can be configurable in Config
            var queryItems = [URLQueryItem(name: "app_id", value: Config.API_ID),
                              URLQueryItem(name: "app_key", value: Config.API_KEY),
                              URLQueryItem(name: "q", value: toSearch),
                              URLQueryItem(name: "type", value: "public")]
            /// Adding query items
            queries.forEach {
                if let query = $0 {
                    queryItems.append(URLQueryItem(name: query.name, value: query.value))
                }
            }
            /// The URL Components with the website's access point, adding the query items
            var urlComps = URLComponents(string: Config.ACCESS_POINT)
            urlComps?.queryItems = queryItems
            
            return urlComps?.string ?? ""
        }()
        
        print("Trying to load: \(urlString)")
        /// throw error for invalid link
        guard let url = URL(string: urlString) else {
            throw ErrorUtility.InvalidURL
        }
        
        return url
    }
}
