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
        topicOne.setTitle("Swift Terms", for: .normal)
        topicTwo.setTitle("IT Terms", for: .normal)
        topicThree.setTitle("Any Words", for: .normal)
        topicFour.setTitle("Random Words", for: .normal)
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 0: selectedFilePath = "swift_words_nouns"
        case 1: selectedFilePath = "russian_words_nouns"
        case 2: selectedFilePath = "sport_words_nouns"
        case 3: selectedFilePath = "random_words_nouns"
        default:
            return
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? SettingsViewController else { return }
        vc.topic = selectedFilePath
    }
    @IBAction func closePressed(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
    
}
