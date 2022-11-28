import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    private init() {}
    
    /// regular JSON decoding with modern concurensy
    func fetchAndDecode<D: Decodable>(url: URL) async throws -> D {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try jsonDecoder.decode(D.self, from: data)
        return decodedData
    }
    
    /// regular JSON decoding with completion and `Result` datatype
    func fetchAndDecode<D: Decodable>(url: URL, completion: @escaping (Result<D, Error>) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode,
                      let data = data else {
                    // TODO: Process `httpResponse.statusCode`
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bad HTTP Response"])))
                    return
                }
                
                do {
                    let decodedData = try self.jsonDecoder.decode(D.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    /// fetch `Data` with completion
    func fetchData(url: URL, completion: @escaping (Data) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url) else { return }
            // DispatchQueue.main.async {
                completion(data)
            // }
        }
    }
    
}
