//
//  GameViewController.swift
//  Alias
//
//  Created by Maxim Vagin on 02.05.2022.
//

import UIKit

enum Status: CaseIterable {
    case correct, incorrect, elapsed, waiting
}

class GameViewController: UIViewController {

    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progress: UIProgressView!

    var sound = SoundBrain()
    var randomAction = RandomAction()
    var topic = "russian_words_nouns" {
        didSet {
            WordStore.shared.setWords(by: topic)
        }
    }

    var roundDuration = 60

    var status: Status = .waiting {
        didSet {
            if case .waiting = status {
                // nothing
            } else {
                // timer?.invalidate()
                statusUpdater(status)
            }
        }
    }

    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var timeRemaining = 60
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

    private func statusUpdater(_ status: Status) {
        // pausedTimeRemaining = timeRemaining
        switch status {
        case .correct:
            disableAnswerButtons()
            animateBackgroundChanged(for: correctButton, to: .systemGreen.withAlphaComponent(0.8))
            timeRemainingLabel.text = "Correct"
        case .incorrect:
            disableAnswerButtons()
            animateBackgroundChanged(for: incorrectButton, to: .systemRed.withAlphaComponent(0.8))
            timeRemainingLabel.text = "Incorrect"
        case .waiting:
            timeRemainingLabel.text = "Time remaining: \(timeRemaining)"
        case .elapsed:
            disableAnswerButtons()
            timeRemainingLabel.text = "Time elapsed"
            nextButton.setTitle("Reset", for: .normal)
            Task {
                if let joke = await JokeStore.shared.fetchJoke(from: JokeEndpoint.random) {
                    updateJokeLabel(with: joke)
                }
            }
        }
    }

    @IBAction func correctPressed(sender: UIButton) {
        status = .correct
        score += 1
        sound.answerRightSound()
    }

    @IBAction func incorrectPressed() {
        status = .incorrect
        score -= 1
        sound.skipWordSound()
    }

    @IBAction func nextPressed() {
        let random = randomAction.action()
        let num = 4
        let randNum = Int.random(in: 1...10)
        if randNum == num {
            let alert = UIAlertController(title: "ACTION",
                                          message: random, // need random
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Nope",
                                          style: UIAlertAction.Style.default,
                                          handler: {_ in self.score -= 1 }))
            alert.addAction(UIAlertAction(title: "Do It!",
                                          style: UIAlertAction.Style.cancel,
                                          handler: {_ in self.score += 3 }))
            self.present(alert, animated: true, completion: nil)
        }

        if case .elapsed = status {
            // TODO: refactor to function
            nextButton.setTitle("Next", for: .normal)
            score = 0
            // pausedTimeRemaining = 60
            wordLabel.text = ""
            timeRemaining = roundDuration
            restartTimer()
        }
        status = .waiting
        showWord()
        enableAnswerButtons()
        animateBackgroundChanged(for: correctButton, to: .clear)
        animateBackgroundChanged(for: incorrectButton, to: .clear)
    }

    @IBAction func closePressed() {
        presentingViewController?.dismiss(animated: true)
    }

    private func restartTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.statusUpdater(self.status)
            if self.timeRemaining == 0 {
                timer.invalidate()
                self.status = .elapsed
            }
            self.timeRemaining -= 1
            self.progress.progress = (Float(self.timeRemaining) / Float(self.roundDuration))
        }
        timer?.tolerance = 0.2
    }

    private func disableAnswerButtons() {
        correctButton.isEnabled = false
        incorrectButton.isEnabled = false
    }

    private func enableAnswerButtons() {
        correctButton.isEnabled = true
        incorrectButton.isEnabled = true
    }

    private func animateBackgroundChanged(for view: UIView, to color: UIColor, with flash: UIColor = .white.withAlphaComponent(0.5)) {
            UIView.animate(withDuration: 0.05) {
                view.backgroundColor = flash
            } completion: { _ in
                UIView.animate(withDuration: 0.4, delay: 0) {
                    view.backgroundColor = color
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
