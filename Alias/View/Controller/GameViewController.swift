//
//  GameViewController.swift
//  Alias
//
//  Created by Maxim Vagin on 02.05.2022.
//

import UIKit

enum Status: CaseIterable {
    case correct, incorrect, elapsed, waiting, skip
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - PROPERTIES
    
    private let feedback = UINotificationFeedbackGenerator()

    private var sound = SoundBrain()
    private var randomAction = RandomAction()
    public var topic = "russian_words_nouns" { didSet {  WordStore.shared.setWords(by: topic) } }
    
    private var teams = [Team]()
    
    private var currentTeam: Team?
    private var winner: Team? = nil
    
    public var roundDuration = 60
    
    public var winScore = SettingsManager.shared.numOfWords
    
    private var status: Status = .waiting { didSet { statusUpdater() } }
    
    private var score: Int = 0 { didSet { scoreLabel.text = "Score: \(score)" } }
    private var timeRemaining = 60 { didSet { self.updateTimeRemainingLabel()  } }
    private var timer: Timer?

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedback.prepare()
        
        restartGame()
        
        teams.append(Team(type: .teamOne, name: SettingsManager.shared.teamOneName))
        teams.append(Team(type: .teamTwo, name: SettingsManager.shared.teamTwoName))
        
        self.currentTeam = teams.first
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        status = .waiting
    }
    
    
    // MARK: - METHODS

    private func statusUpdater() {

        switch self.status {
            
        case .correct:
            disableAnswerButtons()
            animateBackgroundChanged(for: correctButton, to: .systemGreen.withAlphaComponent(0.5), with: .white)
            
        case .incorrect:
            disableAnswerButtons()
            animateBackgroundChanged(for: incorrectButton, to: .systemRed.withAlphaComponent(0.5), with: .white)
            
        case .skip:
            disableAnswerButtons()
            animateBackgroundChanged(for: skipButton, to: .white.withAlphaComponent(0.5), with: .white)
            
        case .waiting:
            self.teamNameLabel.text = self.currentTeam?.name
            
        case .elapsed:
            disableAnswerButtons()
            timeRemainingLabel.text = "Time elapsed"
            correctButton.alpha = 0.5
            incorrectButton.alpha = 0.5
            skipButton.alpha = 0.5
            
//            view.addSubview(resultView)
            view.bringSubviewToFront(closeButton)

            let desc = score == 1 ? "word" : "words"
            currentTeam?.score = self.score
            currentTeam?.rounds += 1
            
            
            if let team = currentTeam {
                
                let scoreView = ScoreView(frame: self.view.frame, team: team)
                
                scoreView.tapAction = { [weak self] in
                    scoreView.removeFromSuperview()
                    self?.restartGame()
                }
                
                    view.addSubview(scoreView)
            }
            
            let index = teams.firstIndex(where: { $0.type == currentTeam?.type })
            teams[index ?? 0] = currentTeam!
                        
            if let winner = teams.first(where: { $0.score >= self.winScore }) {
                self.winner = winner
            }
            
            let looser = teams.first(where: { $0.type != winner?.type })
            
            guard let winner, let looser else { return }
            CoreDataManager.shared.saveRecord(winner: winner, looser: looser)
            
            
        }
    }
    
    @objc private func restartGame() {
        
        guard self.winner == nil else { self.dismiss(animated: true); return }
        
         progress.progress = 1
         WordStore.shared.setWords(by: topic)
         showWord()
         timeRemaining = roundDuration // pausedTimeRemaining
         restartTimer()
        
        currentTeam = currentTeam?.type == .teamOne
        ? teams.first(where: {$0.type == .teamTwo} )
        : teams.first(where: {$0.type == .teamOne} )
        
        self.status = .waiting
        self.score = currentTeam?.score ?? 0
        
        self.enableAnswerButtons()
        
     }

    @IBAction func correctPressed(sender: UIButton) {
        status = .correct
        score += 1
        sound.answerRightSound()
        
        feedback.notificationOccurred(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.getNext()
        }
    }
    
    @IBAction func incorrectPressed() {
        status = .incorrect
        score -= 1
        sound.skipWordSound()
        
        feedback.notificationOccurred(.warning)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.getNext()
        }

    }
    @IBAction func skipPressed(_ sender: Any) {
        status = .skip
        score -= 1
        sound.skipWordSound()
        
        feedback.notificationOccurred(.error)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.getNext()
        }
    }
    
    func getNext() {
//        let random = randomAction.action()
//        let num = 4
//        let randNum = Int.random(in: 1...10)
//        if randNum == num {
//            let alert = UIAlertController(title: "ACTION",
//                                          message: random, //need random
//                                          preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Nope",
//                                          style: UIAlertAction.Style.default,
//                                          handler: {_ in self.score -= 1 }))
//            alert.addAction(UIAlertAction(title: "Do It!",
//                                          style: UIAlertAction.Style.cancel,
//                                          handler: {_ in self.score += 3 }))
//            self.present(alert, animated: true, completion: nil)
//        }

        if case .elapsed = status {
            // TODO: refactor to function
            score = 0
            // pausedTimeRemaining = 60
            wordLabel.text = ""
            timeRemaining = roundDuration
            restartTimer()
        }
        status = .waiting
        showWord()
        enableAnswerButtons()

    }
    
    @IBAction func closePressed() {
        presentingViewController?.dismiss(animated: true)
    }
    
    private func restartTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in

            if self.timeRemaining < 1 {
                timer.invalidate()
                self.status = .elapsed
            }
            self.timeRemaining -= 1
            self.progress.progress = (Float(self.timeRemaining) / Float(self.roundDuration))
        }
        timer?.tolerance = 0.2
    }
    
    private func updateTimeRemainingLabel() {
        self.timeRemainingLabel.text = "Time remaining: \(self.timeRemaining)"
    }
    
    
    private func disableAnswerButtons() {
        correctButton.isEnabled = false
        incorrectButton.isEnabled = false
        skipButton.isEnabled = false
    }
    
    private func enableAnswerButtons() {
        correctButton.isEnabled = true
        correctButton.alpha = 1
        incorrectButton.isEnabled = true
        incorrectButton.alpha = 1
        skipButton.isEnabled = true
        skipButton.alpha = 1
    }
    
    private func animateBackgroundChanged(for view: UIView, to color: UIColor, with flash: UIColor = .white.withAlphaComponent(0.5)) {
            UIView.animate(withDuration: 0.2) {
                view.backgroundColor = color
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    view.backgroundColor = flash
                }
            }
    }
    
    private func updateJokeLabel(with joke: Joke) {
        wordLabel.text = joke.setup + "\n" + joke.punchline
    }
    
    private func showWord() {
        wordLabel.text = WordStore.shared.randomWord()
    }
}
