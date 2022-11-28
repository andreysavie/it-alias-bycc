import Foundation

final class WordStore {
    
    static let shared = WordStore()
    
    var wordsByTopics = [String : [String]]()
    var currentWordSet = [String]()
    var recentWords = [String : Int]()
    var preventRepetitionRounds = 4
    
    private init() {}
    
    func randomWord() -> String {
//        guard let randomIndex = currentWordSet.indices.randomElement() else { return "" }
//        let word = currentWordSet.remove(at: randomIndex)
        guard let word = currentWordSet.randomElement()  else { return "" }
        if recentWords[word] != nil {
            return randomWord()
        }
        recentWords[word] = preventRepetitionRounds + 1
        for (key, value) in recentWords {
            let newValue = value - 1
            if newValue == 0 {
                recentWords.removeValue(forKey: key)
            } else {
                recentWords[key] = newValue
            }
        }
        return word
    }
    
    func setWords(by topic: String) {
        if let words = wordsByTopics[topic] {
            currentWordSet = words
        } else {
            let words = load(by: topic)
            wordsByTopics[topic] = words
            currentWordSet = words
        }
    }
    
    func load(by topic: String) -> [String] {
        guard let url = Bundle.main.url(forResource: topic, withExtension: "csv"),
              let wordString = try? String(contentsOf: url)
        else { return [] }
        let words = wordString.split(separator: ",").map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        return words
    }
    
}
