import Foundation

final class JokeStore {
    
    static let shared = JokeStore()
    
    private init() {}
    
    func fetchJoke(from endpoint: Endpoint) async -> Joke? {
        do {
            let url = try endpoint.generateURL()
            let joke: Joke = try await NetworkManager.shared.fetchAndDecode(url: url)
            return joke
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchJoke(from endpoint: Endpoint, completion: @escaping (Result<Joke, Error>) -> ()) {
        do {
            let url = try endpoint.generateURL()
            NetworkManager.shared.fetchAndDecode(url: url, completion: completion)
        } catch  {
            completion(.failure(error))
        }
    }
    
}

