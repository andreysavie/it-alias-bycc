//
//  RecordsViewController.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 04.12.2022.
//

import UIKit

class RecordModel {
    
    var winnerTeam: Team
    var looserTeam: Team
    
    init(winnerTeam: Team, looserTeam: Team) {
        self.winnerTeam = winnerTeam
        self.looserTeam = looserTeam
    }
    
}

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var recordsTableVIew: UITableView!
    
    @IBAction func closePressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    // TODO: temp mock data
    
    var records: [RecordModel] =
    
    [RecordModel(
        winnerTeam: Team(type: .teamOne, name: "Winners", score: 15),
        looserTeam: Team(type: .teamTwo, name: "Loosers", score: 13)),
     
     RecordModel(
        winnerTeam: Team(type: .teamOne, name: "Suckers", score: 25),
        looserTeam: Team(type: .teamTwo, name: "Fuckers", score: 12)
     )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordsTableVIew.delegate = self
        recordsTableVIew.dataSource = self
        
        recordsTableVIew.register(UINib(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: "RecordCell")
    
    }
    // Do any additional setup after loading the view.
    
}

extension RecordsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return records.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordTableViewCell
        
        let winnerScore = records[indexPath.section].winnerTeam.score
        let looserScore = records[indexPath.section].looserTeam.score

        cell.winnerNameLabel.text = records[indexPath.section].winnerTeam.name
        cell.loosnerNameLabel.text = records[indexPath.section].looserTeam.name
        
        cell.winnerScoreLabel.text = String(format: "Score: %d", winnerScore)
        cell.looserScoreLabel.text = String(format: "Score: %d", looserScore)
        
        cell.winnerAvatar.image = UIImage(systemName: records[indexPath.section].winnerTeam.avatar)
        cell.looserAvatar.image = UIImage(systemName: records[indexPath.section].looserTeam.avatar)

        
        return cell

    }
    
    
}

extension RecordsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
}
