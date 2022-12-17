import Foundation

protocol Endpoint {

    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {

    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        return components
    }

    func generateURL() throws -> URL {
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        return url
    }

}
