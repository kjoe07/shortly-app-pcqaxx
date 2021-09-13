//
//  ViewController.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/8/21.
//

import UIKit

class ViewController: UIViewController {
    var backgroundView: UIView!
    var inputTextField: UITextField!
    var mainButton: UIButton!
    var welcomeView: WelcomeView!
    var viewModel: ResultViewModel!
    var resultView: ResultView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 205))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundView)
      
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 205).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.backgroundColor = UIColor(named: "DarkViolet") ?? .darkGray
        let image = UIImageView(image: UIImage(named: "shape"))
        image.translatesAutoresizingMaskIntoConstraints = false
        backgroundView?.addSubview(image)
        image.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 137).isActive = true
        image.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -74).isActive = true
        inputTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 280, height: 50))
        inputTextField.backgroundColor = .white
        inputTextField.layer.cornerRadius = 5.0
        inputTextField.clipsToBounds = true
        inputTextField.placeholder = "Shorten a link here ..."
        inputTextField.textAlignment = .center
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        mainButton = UIButton(frame: CGRect(x: 0, y: 0, width: 280, height: 50))
        mainButton.backgroundColor = UIColor(named: "Cyan")
        mainButton.layer.cornerRadius = 5.0
        mainButton.clipsToBounds = true
        mainButton.setTitle("SHORTEN IT!", for: .normal)
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(inputTextField)
        backgroundView.addSubview(mainButton)
        inputTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 47).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 47).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -47).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: mainButton.heightAnchor).isActive = true
        inputTextField.layer.cornerRadius = 5
        inputTextField.clipsToBounds = true
        mainButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 9).isActive = true
        mainButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 47).isActive = true
        mainButton.trailingAnchor.constraint(equalTo: inputTextField.trailingAnchor).isActive = true
        mainButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50).isActive = true
        welcomeView = WelcomeView(frame: .zero)
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeView)
        welcomeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        welcomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        welcomeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        welcomeView.bottomAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        welcomeView.setup()
        setupResultView()
        viewModel = ResultViewModel(networkLoader: NetworkLoader(session: URLSession.shared))
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateResultView) , name: Notification.Name.init("DataUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.invalidCall(notification:)) , name: Notification.Name.init("InvalidCall"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NetworkError) , name: Notification.Name.init("NetworkError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.urlRequestError) , name: Notification.Name.init("invalidURL"), object: nil)
    }

    @objc func mainButtonAction(_ sender: UIButton) {
        let urlString = inputTextField.text
        if viewModel.validateUrl(urlString: urlString) {
            viewModel.shortURL(string: urlString ?? "")
        }else {
            showAlert(message: "invalid Url string")
        }
    }
    
    func setupResultView() {
        welcomeView = nil
        resultView = ResultView(frame: .zero)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultView)
        resultView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        resultView.bottomAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        resultView.setup()
        resultView.tableView.dataSource = self
        resultView.isHidden = true
    }
    
    @objc func updateResultView() {
        resultView.isHidden = false
        resultView.tableView.reloadData()
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @objc func NetworkError() {
        showAlert(message: "Network error")
    }
    @objc func urlRequestError() {
        showAlert(message: "Failed to create urlRequest")
    }
    @objc func invalidCall(notification: Notification) {
        let object = notification.object as! ShortenResponse
        showAlert(message: object.error ?? "")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResultsTableViewCell
        let options = viewModel.cellData(index: indexPath.row)
        cell.configureCell(original: options[0], shorten: options[1], index: indexPath)
        return cell
    }
    
    
}

