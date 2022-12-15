//
//  SettingsViewController.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 01.12.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var teamOne: UILabel!
    @IBOutlet weak var teamTwo: UILabel!

    @IBOutlet weak var numberOfWords: UILabel!
    @IBOutlet weak var numberOfRound: UILabel!

    @IBOutlet weak var tasksCheckmark: UIImageView!
    @IBOutlet weak var penaltyCheckmark: UIImageView!
    @IBOutlet weak var soundsCheckmark: UIImageView!

    @IBOutlet weak var wordsSliderOutlet: UISlider!
    @IBOutlet weak var roundSliderOutlet: UISlider!

    public var topic = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        wordsSliderOutlet.value = Float(SettingsManager.shared.numOfWords)
        roundSliderOutlet.value = Float(SettingsManager.shared.timeOfRound)

        let taskGesture = UITapGestureRecognizer()
        taskGesture.addTarget(self, action: #selector(tasksCheckmarkAction))
        tasksCheckmark.addGestureRecognizer(taskGesture)

        let penaltyGesture = UITapGestureRecognizer()
        penaltyGesture.addTarget(self, action: #selector(penaltyCheckmarkAction))
        penaltyCheckmark.addGestureRecognizer(penaltyGesture)

        let soundsGesture = UITapGestureRecognizer()
        soundsGesture.addTarget(self, action: #selector(soundsCheckmarkAction))
        soundsCheckmark.addGestureRecognizer(soundsGesture)

        let teamOneGesture = UILongPressGestureRecognizer()
        teamOneGesture.addTarget(self, action: #selector(teamOneAction))
        teamOne.addGestureRecognizer(teamOneGesture)

        let teamTwoGesture = UILongPressGestureRecognizer()
        teamTwoGesture.addTarget(self, action: #selector(teamTwoAction))
        teamTwo.addGestureRecognizer(teamTwoGesture)

        tasksCheckmark.isUserInteractionEnabled = true
        penaltyCheckmark.isUserInteractionEnabled = true
        soundsCheckmark.isUserInteractionEnabled = true
        teamOne.isUserInteractionEnabled = true
        teamTwo.isUserInteractionEnabled = true

        reloadValues()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameVC = segue.destination as? GameViewController else { return }
        gameVC.topic = topic
        gameVC.winScore = Int(wordsSliderOutlet.value)
        gameVC.roundDuration = Int(roundSliderOutlet.value)
    }

    @IBAction func closeButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }

    @IBAction func wordsSlider(_ sender: UISlider) {
        numberOfWords.text = String(format: "%d", Int(sender.value))
    }

    @IBAction func roundsSlider(_ sender: UISlider) {
        numberOfRound.text = String(format: "%d", Int(sender.value))
    }

    @IBAction func startButton(_ sender: UIButton) {

        SettingsManager.shared.numOfWords = Int(self.wordsSliderOutlet.value)
        SettingsManager.shared.timeOfRound = Int(self.roundSliderOutlet.value)
    }

    func reloadValues() {

        teamOne.text = SettingsManager.shared.teamOneName
        teamTwo.text = SettingsManager.shared.teamTwoName

        self.numberOfWords.text = String(format: "%d", Int(wordsSliderOutlet.value))
        self.numberOfRound.text = String(format: "%d", Int(roundSliderOutlet.value))

        self.tasksCheckmark.image = UIImage(systemName: SettingsManager.shared.isTasksEnabled
                                            ? "checkmark.square.fill"
                                            : "checkmark.square" )
        self.penaltyCheckmark.image = UIImage(systemName: SettingsManager.shared.isPenaltyEnabled
                                            ? "checkmark.square.fill"
                                            : "checkmark.square" )
        self.soundsCheckmark.image = UIImage(systemName: SettingsManager.shared.isSoundsEnabled
                                            ? "checkmark.square.fill"
                                            : "checkmark.square" )
    }

    @objc func tasksCheckmarkAction() {
        let bool = SettingsManager.shared.isTasksEnabled
        SettingsManager.shared.isTasksEnabled = bool ? false : true
        reloadValues()
    }

    @objc func penaltyCheckmarkAction() {
        let bool = SettingsManager.shared.isPenaltyEnabled
        SettingsManager.shared.isPenaltyEnabled = bool ? false : true
        reloadValues()
    }

    @objc func soundsCheckmarkAction() {
        let bool = SettingsManager.shared.isSoundsEnabled
        SettingsManager.shared.isSoundsEnabled = bool ? false : true
        reloadValues()
    }

    @objc func teamOneAction() {
        let alert = UIAlertController(title: "Name of first team",
                                      message: "enter the name of first team",
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "First team name"
        }
        let action = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            let text = alert.textFields?.first?.text
            guard text != "" else { return }
            SettingsManager.shared.teamOneName = text ?? ""
            self?.reloadValues()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }

    @objc func teamTwoAction() {
        let alert = UIAlertController(title: "Name of second team",
                                      message: "enter the name of second team",
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Second team name"
        }
        let action = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            let text = alert.textFields?.first?.text
            guard text != "" else { return }
            SettingsManager.shared.teamTwoName = text ?? ""
            self?.reloadValues()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }

}
