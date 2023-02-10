//
//  SettingsViewController.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/16/23.
//

import UIKit

class SettingsViewController: UIViewController, ChangedColorProtocol {
    
    private let scrollView = UIScrollView()
    private let settingsBtn = UIButton()
    private let colorSchemeBtn = UIButton()
    private let howToPlayBtn = UIButton()
    private let tabStackView = UIStackView()
    
    private let settingsView = UIView()
    private let colorSchemeView = UIView()
    private let howToPlayView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsModel.appendTo(content: self)
        setupUI()
    }
    
    internal func changeColor() {
        for itemBtn in navigationItem.leftBarButtonItems! {
            itemBtn.tintColor = SettingsModel.getMainColor()
        }
        colorSchemeBtn.setTitleColor(SettingsModel.getMainColor(), for: .normal)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Settings"
        setupBarButton()
        // Switch between settings
        setupTabStackView()
        // settings of the game
        setupSettingView()
        // settings of the color scheme
        setupColorSchemeView()
        // description of how to play
        setupHowToPlayView()
    }
    
    private func setupBarButton() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            style: .plain,
            target: self,
            action: #selector(tappedButtonBack(_:))
        )
        backButton.tintColor = SettingsModel.getMainColor()
        navigationItem.leftBarButtonItems = [backButton]
    }
    
    private func setupTabStackView() {
        view.addSubview(scrollView)
        scrollView.addSubview(tabStackView)
        scrollView.setHeight(25)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        tabStackView.pinHeight(to: scrollView.heightAnchor)
        scrollView.delegate = self
        scrollView.bounces = false
        
        tabStackView.pin(to: scrollView, [.right, .left, .top, .bottom])
        
        
        scrollView.pin(to: view, [.left: 16, .right: 16])
        scrollView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        
        settingsBtn.tag = 0
        settingsBtn.setTitle("Settings", for: .normal)
        settingsBtn.setTitleColor(SettingsModel.getMainColor(), for: .normal)
        settingsBtn.backgroundColor = .none
        settingsBtn.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        tabStackView.addArrangedSubview(settingsBtn)
        settingsBtn.setWidth(70)
        settingsBtn.pinHeight(to: scrollView.heightAnchor)
        
        
        colorSchemeBtn.tag = 1
        colorSchemeBtn.setTitle("Color Shceme", for: .normal)
        colorSchemeBtn.setTitleColor(.secondaryLabel, for: .normal)
        colorSchemeBtn.backgroundColor = .none
        colorSchemeBtn.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        tabStackView.addArrangedSubview(colorSchemeBtn)
        colorSchemeBtn.setWidth(114)
        colorSchemeBtn.pinHeight(to: scrollView.heightAnchor)
        
        
        howToPlayBtn.tag = 2
        howToPlayBtn.setTitle("How to play?", for: .normal)
        howToPlayBtn.setTitleColor(.secondaryLabel, for: .normal)
        howToPlayBtn.backgroundColor = .none
        howToPlayBtn.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        tabStackView.addArrangedSubview(howToPlayBtn)
        howToPlayBtn.setWidth(104)
        howToPlayBtn.pinHeight(to: scrollView.heightAnchor)
        
        tabStackView.axis = .horizontal
        tabStackView.spacing = 32
        
    }
    
    private func setupSettingView() {
        view.addSubview(settingsView)
        settingsView.backgroundColor = .secondarySystemBackground
        
        let mistakesLimit = UIView.makeLabelwithSwitcher(title: "Mistakes Limit", description: "set a limit on the number of mistakes to 3. After exeeding the limit, the game ends", target: self, selector: #selector(switcherMistakesTapped(_:)), value: false)
        settingsView.addSubview(mistakesLimit)
        mistakesLimit.pin(to: settingsView, [.top: 16, .right: 0, .left: 0])
        
        let indicateMistakes = UIView.makeLabelwithSwitcher(title: "Indicate mistakes", description: "indicates wether you made a mistake or not. if disabled, the mistakes will be shown after the game is over.", target: self, selector: #selector(switcherMistakesTapped(_:)), value: false)
        settingsView.addSubview(indicateMistakes)
        indicateMistakes.pin(to: settingsView, [.right: 0, .left: 0])
        indicateMistakes.pinTop(to: mistakesLimit.bottomAnchor, 16)
        
        let autoRemoveNotes = UIView.makeLabelwithSwitcher(title: "Auto remove notes", description: "deletes notes if the numbers crossed", target: self, selector: #selector(switcherMistakesTapped(_:)), value: false)
        settingsView.addSubview(autoRemoveNotes)
        autoRemoveNotes.pin(to: settingsView, [.right: 0, .left: 0])
        autoRemoveNotes.pinTop(to: indicateMistakes.bottomAnchor, 16)
        
        let highlightNumbers = UIView.makeLabelwithSwitcher(title: "Highlight the same numbers", description: "Highlight the smae numbers and makes rows from them visible", target: self, selector: #selector(switcherMistakesTapped(_:)), value: false)
        settingsView.addSubview(highlightNumbers)
        highlightNumbers.pin(to: settingsView, [.right: 0, .left: 0])
        highlightNumbers.pinTop(to: autoRemoveNotes.bottomAnchor, 16)
        
        settingsView.pin(to: view, [.bottom, .right, .left])
        settingsView.pinTop(to: tabStackView.bottomAnchor, 16)
    }
    
    private func setupColorSchemeView() {
        view.addSubview(colorSchemeView)
        colorSchemeView.isHidden = true
        
        colorSchemeView.backgroundColor = .secondarySystemBackground
        
        let colorPallete = UIView.makeColorView(target: self, selector: #selector(colorButtonTapped(_:)))
        colorSchemeView.addSubview(colorPallete)
        colorPallete.pin(to: colorSchemeView, [.left: 0, .right: 0, .top: 16])
        
        let darkMode = UIView.makeLabelwithSwitcher(title: "Dark mode", description: "Switch to the dark mode if switcher is on, otherwise light mode", target: self, selector: #selector(switcherDarkModeTapped(_:)), value: SettingsModel.isDarkMode())
        colorSchemeView.addSubview(darkMode)
        darkMode.pin(to: colorSchemeView, [.right, .left])
        darkMode.pinTop(to: colorPallete.bottomAnchor, 16)
        
        colorSchemeView.pin(to: view, [.bottom, .right, .left])
        colorSchemeView.pinTop(to: tabStackView.bottomAnchor, 16)
    }
    
    private func setupHowToPlayView() {
        view.addSubview(howToPlayView)
        howToPlayView.isHidden = true
    }
    
    private func showSettings() {
        settingsView.isHidden = false
        colorSchemeView.isHidden = true
        howToPlayView.isHidden = true
    }
    
    private func showColorScheme() {
        settingsView.isHidden = true
        colorSchemeView.isHidden = false
        howToPlayView.isHidden = true
    }
    
    private func showHowToPlaye() {
        settingsView.isHidden = true
        colorSchemeView.isHidden = true
        howToPlayView.isHidden = false
    }
    
    @objc private func tappedButtonBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func switcherMistakesTapped(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @objc private func switcherDarkModeTapped(_ sender: UISwitch) {
        SettingsModel.switchDarkMode()
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            settingsBtn.setTitleColor(SettingsModel.getMainColor(), for: .normal)
            colorSchemeBtn.setTitleColor(.secondaryLabel, for: .normal)
            howToPlayBtn.setTitleColor(.secondaryLabel, for: .normal)
            navigationItem.title = "Settings"
            showSettings()
        case 1:
            settingsBtn.setTitleColor(.secondaryLabel, for: .normal)
            colorSchemeBtn.setTitleColor(SettingsModel.getMainColor(), for: .normal)
            howToPlayBtn.setTitleColor(.secondaryLabel, for: .normal)
            navigationItem.title = "Scheme"
            showColorScheme()
        default:
            settingsBtn.setTitleColor(.secondaryLabel, for: .normal)
            colorSchemeBtn.setTitleColor(.secondaryLabel, for: .normal)
            howToPlayBtn.setTitleColor(SettingsModel.getMainColor(), for: .normal)
            navigationItem.title = "How to play?"
            showHowToPlaye()
        }
     }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        SettingsModel.setMainColor(color: sender.backgroundColor ?? .systemBlue)
    }
}

extension SettingsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0.0
    }
}
