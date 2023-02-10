//
//  MainViewController.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/16/23.
//

import UIKit

// MARK: - MainViewController
class MainViewController: UIViewController, ChangedColorProtocol {
    
    
    // MARK: - Variables
    let continueGameButton = UIButton.makeNewButton(title: "Continue")
    let newGameButton = UIButton.makeNewButton(title: "New Game")
    let levelGameButtons = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (newGameButton.isHidden){
            tappedNewGameButton(newGameButton)
        }
    }
    
    //MARK: - Setup UI functions
    private func setupUI() {
        view.backgroundColor = SettingsModel.getMainBackgroundColor()
        SettingsModel.appendTo(content: self)
        
        // Set tool bars (button profile and settings)
        setupToolBar()
        // Set button "Continue" with all functionality
        setupButtonContinue()
        // Set button "new Game" with all functionality
        setupButtonNewGame()
        // Set stackView buttons with all functionality
        setupLevelGameButtons()
    }
    
    /// Set the profile and setting button and title
    private func setupToolBar() {
        let settingButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(tappedButtonSettings(_:))
        )
        settingButton.tintColor = SettingsModel.getMainColor()
        
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.fill"),
            style: .plain,
            target: self,
            action: #selector(tappedButtonProfile(_:))
        )
        profileButton.tintColor = SettingsModel.getMainColor()
        navigationItem.leftBarButtonItems = [profileButton]
        navigationItem.rightBarButtonItems = [settingButton]
        navigationItem.title = "Valid Sudoku"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SettingsModel.isDarkMode() ? UIColor.white : UIColor.darkText]
    }
    
    /// Set the "new game" button
    private func setupButtonNewGame() {
        view.addSubview(newGameButton)
        newGameButton.pin(to: view, [.left: 16, .right: 16])
        newGameButton.pinBottom(to: continueGameButton.topAnchor, 12)
        newGameButton.addTarget(self, action: #selector(tappedNewGameButton(_:)), for: .touchUpInside)
    }
    
    /// Set the levels buttons that apears after "new game" button tapped
    private func setupLevelGameButtons() {
        view.addSubview(levelGameButtons)
        let easyButton = UIButton.makeNewButton(title: "Easy")
        easyButton.addTarget(self, action: #selector(tappedCreateGameButtons(_:)), for: .touchUpInside)
        let mediumButton = UIButton.makeNewButton(title: "Medium")
        mediumButton.addTarget(self, action: #selector(tappedCreateGameButtons(_:)), for: .touchUpInside)
        let hardButton = UIButton.makeNewButton(title: "Hard")
        hardButton.addTarget(self, action: #selector(tappedCreateGameButtons(_:)), for: .touchUpInside)
        let expertButton = UIButton.makeNewButton(title: "Expert")
        expertButton.addTarget(self, action: #selector(tappedCreateGameButtons(_:)), for: .touchUpInside)
        levelGameButtons.addArrangedSubview(easyButton)
        levelGameButtons.addArrangedSubview(mediumButton)
        levelGameButtons.addArrangedSubview(hardButton)
        levelGameButtons.addArrangedSubview(expertButton)
        levelGameButtons.axis = .vertical
        levelGameButtons.isHidden = true
        levelGameButtons.pinBottom(to: newGameButton.bottomAnchor)
        levelGameButtons.pin(to: view, [.left: 16, .right: 16])
        levelGameButtons.spacing = 16
    }
    
    /// Set the "continue" button
    private func setupButtonContinue() {
        view.addSubview(continueGameButton)
        continueGameButton.pin(to: view, [.left: 16, .right: 16])
        continueGameButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16)
    }
    
    
    //MARK: - Objc func (buttons actions)
    @objc private func tappedButtonSettings(_ sender: UIBarButtonItem) {
        let settings = SettingsViewController()
        navigationController?.pushViewController(settings, animated: true)
    }
    
    @objc private func tappedButtonProfile(_ sender: UIBarButtonItem) {
        let profile = ProfileViewController()
        navigationController?.pushViewController(profile, animated: true)
    }
    
    @objc private func tappedNewGameButton(_ sender: UIButton) {
        //TODO: make animation to stackView
        levelGameButtons.isHidden.toggle()
        newGameButton.isHidden.toggle()
    }
    
    @objc private func tappedCreateGameButtons(_ sender: UIButton) {
        let game = GameViewController(levelGame: sender.titleLabel?.text ?? "Ban")
        navigationController?.pushViewController(game, animated: true)
    }
    
    internal func changeColor() {
        continueGameButton.backgroundColor = SettingsModel.getMainColor()
        newGameButton.backgroundColor = SettingsModel.getMainColor()
        for subView in levelGameButtons.subviews {
            subView.backgroundColor = SettingsModel.getMainColor()
        }
        for navItem in navigationItem.leftBarButtonItems! {
            navItem.tintColor = SettingsModel.getMainColor()
        }
        for navItem in navigationItem.rightBarButtonItems! {
            navItem.tintColor = SettingsModel.getMainColor()
        }
    }
}

