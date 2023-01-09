//
//  RulesViewController.swift
//  CourceWork3year
//
//  Created by Алексей on 09.01.2023.
//

import UIKit

class RulesViewController: MenuViewController {

    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var rulesTableView: UITableView!
    
    private let cellTag = "tokenCell"
    private let emptyCellTag = "emptyCell"
    
    private var rules:[Rule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rulesTableView.delegate = self
        rulesTableView.dataSource = self
        uiKit.setTableViewHeader(tableView: rulesTableView)
        
        setBGView(view: bgView)
    }
    
    override func loadInfo() {
        requests.getAllRules(callback: setRules)
    }
    
    func setRules(rules:[Rule]){
        self.rules = rules
        DispatchQueue.main.async { [self] in
            rulesTableView.reloadData()
        }
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension RulesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rules.isEmpty{
            return 1
        }
        
        return rules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if rules.isEmpty{
            let tableCell = tableView.dequeueReusableCell(withIdentifier: emptyCellTag, for: indexPath) as! EmptyWalletCell
            tableCell.setShadowAndCorners(shadowLayer: tableCell.shadowLayer)
            return tableCell
        }
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: cellTag, for: indexPath) as! RuleCell
        tableCell.setShadowAndCorners(shadowLayer: tableCell.shadowLayer)
        tableCell.contentView.layer.masksToBounds = false
        tableCell.layer.masksToBounds = false

        let rule = rules[indexPath.row]

        tableCell.nameOfRule.text = rule.title
        tableCell.numOfRule.text = rule.fineCategoryID
        tableCell.secondNameOfRule.text = rule.description

        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if rules.isEmpty{return}
        
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.row).")
    }
}

class RuleCell: ShadowedTableViewCell{
    
    @IBOutlet weak var shadowLayer: UIView!
    
    @IBOutlet weak var imageOfRule: UIImageView!
    @IBOutlet weak var nameOfRule: UILabel!
    @IBOutlet weak var numOfRule: UILabel!
    @IBOutlet weak var secondNameOfRule: UILabel!
}

