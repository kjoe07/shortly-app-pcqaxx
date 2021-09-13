//
//  welcomeView.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/8/21.
//

import UIKit

class WelcomeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let logoImage = UIImageView(image: UIImage(named: "logo"))
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImage)
        logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 84).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        let devImage = UIImageView(image: UIImage(named: "illustration"))
        devImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(devImage)
        let welcomeDescription = UILabel(frame: .zero)
        welcomeDescription.translatesAutoresizingMaskIntoConstraints = false
        welcomeDescription.font = UIFont(name: "Poppins-Medium", size: 17)
        welcomeDescription.numberOfLines = 0
        welcomeDescription.lineBreakMode = .byWordWrapping
        welcomeDescription.text = "Paste your first link into the field to shorten it"
        welcomeDescription.textAlignment = .center
        addSubview(welcomeDescription)
        welcomeDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -74).isActive = true
        welcomeDescription.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        welcomeDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 85).isActive = true
        welcomeDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -85).isActive = true
        let welcomeTitle = UILabel(frame: .zero)
        welcomeTitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(welcomeTitle)
        welcomeTitle.bottomAnchor.constraint(equalTo: welcomeDescription.topAnchor, constant: -7).isActive = true
        welcomeTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        welcomeTitle.text = "let's get started!"
        welcomeTitle.font = UIFont(name: "Poppins-Bold", size: 20)
        welcomeTitle.textAlignment = .center
        welcomeTitle.font = UIFont.boldSystemFont(ofSize: 24)
        devImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        devImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        devImage.bottomAnchor.constraint(equalTo: welcomeTitle.topAnchor, constant: -13).isActive = true
        
    }

}
