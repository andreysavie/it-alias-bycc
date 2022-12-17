//
//  RulesViewController.swift
//  Alias
//
//  Created by Maxim Vagin on 02.05.2022.
//

import UIKit

final class RulesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButton(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }

}
