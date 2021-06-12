//
//  RequestsController.swift
//  FacebookFeed
//
//  Created by Abraham Gonzalez on 11/21/18.
//  Copyright © 2018 Abraham Gonzalez. All rights reserved.
//

import UIKit

class RequestsController: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionHeaderHeight = 26
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "HeaderId")
        tableView.register(Cell.self, forCellReuseIdentifier: "CellId")
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderId") as! Header
        if section == 1{
            header.nameLabel.text = "PEOPLE YOU MAY KNOW" 
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! Cell
        if indexPath.item % 3 == 1{
            cell.nameLabel.text = "Steve Jobs"
            cell.profileImageView.image = UIImage(named: "steve_profile")
        }
        if indexPath.item % 3 == 2{
            cell.nameLabel.text = "Mahatma Gandhi"
            cell.profileImageView.image = UIImage(named: "gandhi")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

class Header: UITableViewHeaderFooterView{
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "FRIEND REQUESTS"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        return label
    }()
    
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews(){
        addSubview(nameLabel)
        addSubview(bottomBorderView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: bottomBorderView)
        addConstraintsWithFormat(format: "V:|[v0][v1(0.5)]|", views: nameLabel, bottomBorderView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Cell: UITableViewCell{
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckprofile")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mark Zuckerberg"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 87/255, green: 143/255, blue: 255/255, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews(){
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(confirmButton)
        addSubview(deleteButton)
        
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: profileImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(52)]-8-[v1]", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1(24)]-8-|", views: nameLabel, confirmButton)
        addConstraintsWithFormat(format: "H:|-76-[v0(80)]-8-[v1(80)]", views: confirmButton, deleteButton)
        addConstraintsWithFormat(format: "V:[v0(24)]-8-|", views: deleteButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
