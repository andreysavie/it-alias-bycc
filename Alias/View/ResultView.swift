//
//  ResultView.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 29.11.2022.
//

import UIKit

class ResultView: UIView {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    
}

class ScoreView: UIView {
    
    var teamName: String?
    var score: Int?
    
    var tapAction: (() -> Void)?
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private lazy var resultView: ResultView = {
        guard let resultView = Bundle.main.loadNibNamed("ResultView", owner: nil, options: nil)?.first as? ResultView else { return ResultView() }
        resultView.translatesAutoresizingMaskIntoConstraints = false
        let desc = self.score == 1 ? "word" : "words"
        resultView.scoreLabel?.text = String(format: "Score: %d %@", self.score ?? 0, desc)
        return resultView
    }()
    
    private lazy var continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = .white.withAlphaComponent(0.7)
        continueButton.cornerRadius = 16
        continueButton.setTitleColor(.systemYellow, for: .normal)
        continueButton.isUserInteractionEnabled = true
        continueButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return continueButton
    }()
    
    override init(frame: CGRect) {
//        self.team = team
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(blurEffectView)
        self.addSubview(resultView)
        self.addSubview(continueButton)
        
        setupLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonPressed() {
        self.tapAction?()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            resultView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            resultView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            resultView.widthAnchor.constraint(equalToConstant: 300),
            resultView.heightAnchor.constraint(equalToConstant: 300),

            continueButton.centerYAnchor.constraint(equalTo: resultView.centerYAnchor),
            continueButton.widthAnchor.constraint(equalTo: resultView.widthAnchor),
            continueButton.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 16),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        
        ])
    }
}
