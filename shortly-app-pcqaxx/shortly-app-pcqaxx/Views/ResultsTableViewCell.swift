//
//  ResultsTableViewCell.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/8/21.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    var originalLink: UILabel!
    var shortenLink: UILabel!
    var deleteButton: UIButton!
    var copyButton: UIButton!
    var code: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        originalLink = UILabel(frame: .zero)
        shortenLink = UILabel(frame: .zero)
        deleteButton = UIButton(frame: .zero)
        copyButton = UIButton(frame: .zero)
        
        originalLink.translatesAutoresizingMaskIntoConstraints = false
        shortenLink.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.isUserInteractionEnabled = true
        copyButton.isUserInteractionEnabled = true
        
        let cardView = UIView(frame: .zero)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
        cardView.backgroundColor = .systemBackground
        addSubview(cardView)
        cardView.topAnchor.constraint(equalTo: topAnchor, constant: 9).isActive = true
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9).isActive = true
        cardView.layer.borderWidth = 1.0
        cardView.layer.borderColor = UIColor(named: "LightGray")?.cgColor
        cardView.isUserInteractionEnabled = true        
        let separatorView = UIView(frame: .zero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(separatorView)
        cardView.addSubview(originalLink)
        cardView.addSubview(shortenLink)
        cardView.addSubview(deleteButton)
        cardView.addSubview(copyButton)
        separatorView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.topAnchor.constraint(equalTo: originalLink.bottomAnchor, constant: 7).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: shortenLink.topAnchor, constant: -7).isActive = true
        separatorView.backgroundColor = UIColor(named: "LightGray")
        
        originalLink.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 19).isActive = true
        originalLink.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 21).isActive = true
        originalLink.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor,constant: -7).isActive = true
       // originalLink.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: 7).isActive = true
        originalLink.heightAnchor.constraint(equalToConstant: 32).isActive = true
        originalLink.font =  UIFont(name: "Poppins-Medium", size: 17)
        originalLink.textColor = UIColor(named: "GrayishViolet")
        
        deleteButton.setImage(UIImage(named: "del"), for: .normal)
        deleteButton.topAnchor.constraint(equalTo: originalLink.topAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: originalLink.bottomAnchor).isActive = true
        //deleteButton.leadingAnchor.constraint(equalTo: originalLink.trailingAnchor, constant: 7).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -25).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        deleteButton.tintColor = UIColor(named: "GrayishViolet")
        
        shortenLink.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 9).isActive = true
        shortenLink.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 21).isActive = true
        shortenLink.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -21).isActive = true
        //shortenLink.bottomAnchor.constraint(equalTo: copyButton.topAnchor, constant: 17).isActive = true
        shortenLink.heightAnchor.constraint(equalToConstant: 32).isActive = true
        shortenLink.textColor = UIColor(named: "Cyan")
        shortenLink.font = UIFont(name: "Poppins-Medium", size: 17)
        
        copyButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24).isActive = true
        copyButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24).isActive = true
        copyButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -25).isActive = true
        copyButton.topAnchor.constraint(equalTo: shortenLink.bottomAnchor, constant: 17).isActive = true
        copyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        copyButton.setTitle("COPY", for: .normal)
        copyButton.setTitleColor(.white, for: .normal)
        copyButton.backgroundColor = UIColor(named: "Cyan")
        copyButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 17)
        copyButton.layer.cornerRadius = 4
        copyButton.clipsToBounds = true
        copyButton.addTarget(self, action: #selector(self.copyShortLink(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteLink(_:)), for: .touchUpInside)
    }
    
    func configureCell(original: String, shorten: String, code: Int) {
        originalLink.text = original
        shortenLink.text = shorten
        deleteButton.tag = code
    }
    
    @IBAction func copyShortLink(_ sender: UIButton) {
        UIPasteboard.general.string = shortenLink.text
        sender.setTitle("COPIED!", for: .normal)
        sender.backgroundColor = UIColor(named: "GrayishViolet")
    }
    
    @IBAction func deleteLink(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.init("Delete"), object: sender.tag)
    }

}
