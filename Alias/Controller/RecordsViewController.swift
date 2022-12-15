//
//  RecordsViewController.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 04.12.2022.
//

import UIKit

class RecordsViewController: UIViewController {

    @IBOutlet weak var recordsTableVIew: UITableView!

    private var fetchedResultsController = CoreDataManager.shared.fetchedResultsController

    override func viewDidLoad() {
        super.viewDidLoad()

        recordsTableVIew.delegate = self
        recordsTableVIew.dataSource = self
        recordsTableVIew.separatorStyle = .none

        recordsTableVIew.register(UINib(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: "RecordCell")

    }

    @IBAction func closePressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
}

extension RecordsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordTableViewCell
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear

        let record = fetchedResultsController.object(at: indexPath)

        cell.configure(record: record)

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
