import Foundation

enum JokeEndpoint: Endpoint {
    case random
    
    var base: String { "https://joke.deno.dev" }
    var path: String { "" }
    var queryItems: [URLQueryItem] { [] }
}

