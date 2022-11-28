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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var progress: UIProgressView!

    var sound = SoundBrain()
    var randomAction = RandomAction()
    var topic = "russian_words_nouns" {
        didSet {
            WordStore.shared.setWords(by: topic)
        }
    }
    
    var roundDuration = 60
    
    var status: Status = .waiting { didSet { statusUpdater() } }
    
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var timeRemaining = 60 { didSet { self.updateTimeRemainingLabel()  } }
    // private var pausedTimeRemaining = 60
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 1
        WordStore.shared.setWords(by: topic)
        showWord()
        timeRemaining = roundDuration // pausedTimeRemaining
        restartTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        status = .waiting
    }
    
    private func statusUpdater() {
        // pausedTimeRemaining = timeRemaining
        switch self.status {
        case .correct:
            disableAnswerButtons()
            animateBackgroundChanged(for: correctButton, to: .systemGreen.withAlphaComponent(0.5), with: UIColor(named: "MainColor") ?? .white)
            statusLabel.text = "Correct"
        case .incorrect:
            disableAnswerButtons()
            animateBackgroundChanged(for: incorrectButton, to: .systemRed.withAlphaComponent(0.5), with: UIColor(named: "MainColor") ?? .white)
            statusLabel.text = "Incorrect"
        case .skip:
            disableAnswerButtons()
            animateBackgroundChanged(for: skipButton, to: .white.withAlphaComponent(0.5), with: UIColor(named: "MainColor") ?? .white)
            statusLabel.text = "Skiped"
        case .waiting:
            statusLabel.text = " "
//            timeRemainingLabel.text = "Time remaining: \(timeRemaining)"
        case .elapsed:
            disableAnswerButtons()
            timeRemainingLabel.text = "Time elapsed"
            correctButton.alpha = 0.5
            incorrectButton.alpha = 0.5
            skipButton.alpha = 0.5
        }
    }

    @IBAction func correctPressed(sender: UIButton) {
        status = .correct
        score += 1
        sound.answerRightSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.getNext()
        }
    }
    
    @IBAction func incorrectPressed() {
        status = .incorrect
        score -= 1
        sound.skipWordSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.getNext()
        }

    }
    @IBAction func skipPressed(_ sender: Any) {
        status = .skip
        score -= 1
        sound.skipWordSound()
        
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
//        animateBackgroundChanged(for: correctButton, to: UIColor(named: "MainColor") ?? .white)
//        animateBackgroundChanged(for: incorrectButton, to: UIColor(named: "MainColor") ?? .white)
    }
    
    @IBAction func closePressed() {
        presentingViewController?.dismiss(animated: true)
    }
    
    private func restartTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            self.statusUpdater(self.status)
            if self.timeRemaining == 0 {
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
