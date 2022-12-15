//
//  ChoiceViewController.swift
//  Alias
//
//  Created by Maxim Vagin on 02.05.2022.
//

import UIKit

class ChoiceViewController: UIViewController {

    @IBOutlet private weak var topicOne: UIButton!
    @IBOutlet private weak var topicTwo: UIButton!
    @IBOutlet private weak var topicThree: UIButton!
    @IBOutlet private weak var topicFour: UIButton!

    private var selectedFilePath: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        topicOne.setTitle("English Words", for: .normal)
        topicTwo.setTitle("Russian Words", for: .normal)
        topicThree.setTitle("Sport Words", for: .normal)
        topicFour.setTitle("Random Words", for: .normal)

    }

    @IBAction func buttonPressed(_ sender: UIButton) {

        switch sender.tag {
        case 0: selectedFilePath = "english_words_nouns"
        case 1: selectedFilePath = "russian_words_nouns"
        case 2: selectedFilePath = "sport_words_nouns"
        case 3: selectedFilePath = "random_words_nouns"
        default:
            return
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameVC = segue.destination as? GameViewController else { return }
        gameVC.topic = selectedFilePath
    }
    @IBAction func closePressed(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }

}
