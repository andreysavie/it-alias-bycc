import Foundation

struct Joke: Codable {
    let id: Int
    let type, setup, punchline: String
}
