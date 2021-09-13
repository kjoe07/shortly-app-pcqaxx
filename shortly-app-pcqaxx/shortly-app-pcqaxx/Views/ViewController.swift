//
//  ViewController.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/8/21.
//

import UIKit
import ActivityIndicator
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
        inputTextField.keyboardType = .URL
        inputTextField.autocorrectionType = .no
        inputTextField.autocapitalizationType = .none
        inputTextField.textContentType = .URL
        mainButton = UIButton(frame: CGRect(x: 0, y: 0, width: 280, height: 50))
        mainButton.backgroundColor = UIColor(named: "Cyan")
        mainButton.layer.cornerRadius = 4   
        mainButton.clipsToBounds = true
        mainButton.setTitle("SHORTEN IT!", for: .normal)
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(inputTextField)
        backgroundView.addSubview(mainButton)
        inputTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 47).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 47).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -47).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: mainButton.heightAnchor).isActive = true
        inputTextField.layer.cornerRadius = 4
        inputTextField.clipsToBounds = true
        inputTextField.font = UIFont(name: "Poppins-Medium", size: 17)
        mainButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 9).isActive = true
        mainButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 47).isActive = true
        mainButton.trailingAnchor.constraint(equalTo: inputTextField.trailingAnchor).isActive = true
        mainButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50).isActive = true
        mainButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
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
        mainButton.addTarget(self, action: #selector(self.mainButtonAction(_:)), for: .touchUpInside)
    }

    @objc func mainButtonAction(_ sender: UIButton) {
        let urlString = inputTextField.text
        if viewModel.validateUrl(urlString: urlString) {
            self.showActivityIndicator(color: UIColor(named: "Cyan") ?? .blue)
            viewModel.shortURL(string: urlString ?? "")
            welcomeView.isHidden = true
        }else {
            inputTextField.text?.removeAll()
            inputTextField.layer.borderWidth = 2.0
            inputTextField.layer.borderColor = UIColor(named: "Red")?.cgColor
            let attributtedPlaceHolderText = NSAttributedString(string: "Please add a link here", attributes:  [NSAttributedString.Key.foregroundColor: UIColor(named: "Red") ?? .red, NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)])
            inputTextField.attributedPlaceholder = attributtedPlaceHolderText
        }
    }
    
    func setupResultView() {
       // welcomeView = nil
        resultView = ResultView(frame: .zero)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultView)
        resultView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        resultView.bottomAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        resultView.setup()
        resultView.tableView.dataSource = self
        resultView.tableView.delegate = self        
        resultView.isHidden = true
    }
    
    @objc func updateResultView() {
        self.hideActivityIndicator()
        resultView.isHidden = false
        resultView.tableView.reloadData()
        inputTextField.text = ""
        inputTextField.layer.borderWidth = 0
        inputTextField.layer.borderColor = UIColor(named: "Red")?.cgColor
        let attributtedPlaceHolderText = NSAttributedString(string: "Shorten a link here ...", attributes:  [NSAttributedString.Key.foregroundColor: UIColor(named: "LightGray") ?? .red, NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)])
        inputTextField.attributedPlaceholder = attributtedPlaceHolderText
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
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResultsTableViewCell
        let options = viewModel.cellData(index: indexPath.row)
        cell.configureCell(original: options[0], shorten: options[1], code: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let oldCell = cell as? ResultsTableViewCell else {return}
        oldCell.copyButton.backgroundColor = UIColor(named: "Cyan")
        oldCell.copyButton.setTitle("COPY", for: .normal)
    }
    
    
}

