//
//  resultView.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/8/21.
//

import UIKit

class ResultView: UIView {
    var tableView: UITableView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setup() {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor, constant: 74).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.text = "Your Link History"
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 9).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant:42).isActive = true
        tableView.separatorStyle = .none
        tableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    

}
