//
//  SettingsViewController.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/16/23.
//

import UIKit

// MARK: - SettingsViewController
class SettingsViewController: UIViewController, ChangedColorProtocol {
    
    
    // MARK: - Variables
    /// scrollView for three buttons in the top of the screen
    /// scrollView contains tabStackView with buttons
    private let scrollView = UIScrollView()
    private let tabStackView = UIStackView()
    
    /// setting button for showing the setting view
    private let settingsBtn = UIButton()
    /// color buttonn for showing the colorScheme view
    private let colorSchemeBtn = UIButton()
    /// howToPlay button for showing HowToPlay view
    private let howToPlayBtn = UIButton()
    
    /// View with settings
    private let settingsView = UIView()
    /// View with color scheme / theme
    private let colorSchemeView = UIView()
    /// how to play ?
    private let howToPlayView = UIView()
    
    private let isOpenedfromTheGame: Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsModel.appendTo(content: self)
        setupUI()
    }
    
    init(isOpenedFromTheGame: Bool) {
        self.isOpenedfromTheGame = isOpenedFromTheGame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// protocol function for changing theme after tapping the button
    internal func changeColor() {
        view.backgroundColor = SettingsModel.getMainBackgroundColor()
        for itemBtn in navigationItem.leftBarButtonItems! {
            itemBtn.tintColor = SettingsModel.getMainColor()
        }
        settingsView.backgroundColor = SettingsModel.getSecondaryBackgroundColor()
        colorSchemeView.backgroundColor = SettingsModel.getSecondaryBackgroundColor()
        colorSchemeBtn.setTitleColor(SettingsModel.getMainColor(), for: .normal)
        settingsBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
        howToPlayBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
        
        for view in settingsView.subviews {
            view.subviews[0].backgroundColor = SettingsModel.getMainBackgroundColor()
            (view.subviews[0].subviews[1] as! UILabel).textColor = SettingsModel.isDarkMode() ? .white : .label
            (view.subviews[1] as! UILabel).textColor = SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel
        }
        
        colorSchemeView.subviews[1].subviews[0].backgroundColor = SettingsModel.getMainBackgroundColor()
        (colorSchemeView.subviews[1].subviews[0].subviews[1] as! UILabel).textColor = SettingsModel.isDarkMode() ? .white : .label
        (colorSchemeView.subviews[1].subviews[1] as! UILabel).textColor = SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel
        
        (colorSchemeView.subviews[0].subviews[1] as! UILabel).textColor = SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel
        colorSchemeView.subviews[0].subviews[0].backgroundColor = SettingsModel.getMainBackgroundColor()
        (colorSchemeView.subviews[0].subviews[0].subviews[0] as! UILabel).textColor = SettingsModel.isDarkMode() ? .white : .label
        
    }
    
    // MARK: - setup UI
    private func setupUI() {
        view.backgroundColor = SettingsModel.getMainBackgroundColor()
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
    
    /// Set back button to previous screen
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
    
    /// Set buttons on the top of the screen
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
        colorSchemeBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
        colorSchemeBtn.backgroundColor = .none
        colorSchemeBtn.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        tabStackView.addArrangedSubview(colorSchemeBtn)
        colorSchemeBtn.setWidth(114)
        colorSchemeBtn.pinHeight(to: scrollView.heightAnchor)
        
        
        howToPlayBtn.tag = 2
        howToPlayBtn.setTitle("How to play?", for: .normal)
        howToPlayBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
        howToPlayBtn.backgroundColor = .none
        howToPlayBtn.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        tabStackView.addArrangedSubview(howToPlayBtn)
        howToPlayBtn.setWidth(104)
        howToPlayBtn.pinHeight(to: scrollView.heightAnchor)
        
        tabStackView.axis = .horizontal
        tabStackView.spacing = 32
        
    }
    
    /// Set settings View
    private func setupSettingView() {
        view.addSubview(settingsView)
        settingsView.backgroundColor = SettingsModel.getSecondaryBackgroundColor()
        
        let mistakesLimit = UIView.makeLabelwithSwitcher(title: "Mistakes Limit", description: "set a limit on the number of mistakes to 3. After exeeding the limit, the game ends", target: self, selector: #selector(switcherMistakesLimitTapped(_:)), value: SettingsModel.isMistakesLimitSet())
        settingsView.addSubview(mistakesLimit)
        if (isOpenedfromTheGame) {
            (mistakesLimit.subviews[0].subviews[0] as! UISwitch).isEnabled = false
        }
        mistakesLimit.pin(to: settingsView, [.top: 16, .right: 0, .left: 0])
        
        let indicateMistakes = UIView.makeLabelwithSwitcher(title: "Indicate mistakes", description: "indicates wether you made a mistake or not. if disabled, the mistakes will be shown after the game is over.", target: self, selector: #selector(switcherMistakesIndicateTapped(_:)), value: SettingsModel.isMistakesIndicates())
        settingsView.addSubview(indicateMistakes)
        if (SettingsModel.isMistakesLimitSet()){
            (indicateMistakes.subviews[0].subviews[0] as! UISwitch).isEnabled = false
        }
        if (isOpenedfromTheGame) {
            (indicateMistakes.subviews[0].subviews[0] as! UISwitch).isEnabled = false
        }
        indicateMistakes.pin(to: settingsView, [.right: 0, .left: 0])
        indicateMistakes.pinTop(to: mistakesLimit.bottomAnchor, 16)
        
        let autoRemoveNotes = UIView.makeLabelwithSwitcher(title: "Auto remove notes", description: "deletes notes if the numbers crossed", target: self, selector: #selector(switcherAutoRemoveNoteTapped(_:)), value: SettingsModel.isAutoRemoveNoteOn())
        settingsView.addSubview(autoRemoveNotes)
        autoRemoveNotes.pin(to: settingsView, [.right: 0, .left: 0])
        autoRemoveNotes.pinTop(to: indicateMistakes.bottomAnchor, 16)
        
        let highlightNumbers = UIView.makeLabelwithSwitcher(title: "Highlight the same numbers", description: "Highlight the smae numbers and makes rows from them visible", target: self, selector: #selector(switcherHighlightingSameNumberTapped(_:)), value: SettingsModel.isHighlightingOn())
        settingsView.addSubview(highlightNumbers)
        highlightNumbers.pin(to: settingsView, [.right: 0, .left: 0])
        highlightNumbers.pinTop(to: autoRemoveNotes.bottomAnchor, 16)
        
        settingsView.pin(to: view, [.bottom, .right, .left])
        settingsView.pinTop(to: tabStackView.bottomAnchor, 16)
    }
    
    /// Set colorScheme View
    private func setupColorSchemeView() {
        view.addSubview(colorSchemeView)
        colorSchemeView.isHidden = true
        colorSchemeView.backgroundColor = SettingsModel.getSecondaryBackgroundColor()
        
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
    
    /// Set HowToPlay View
    private func setupHowToPlayView() {
        view.addSubview(howToPlayView)
        howToPlayView.isHidden = true
    }
    
    
    // MARK: - Control functions
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
    
    
    // MARK: - @objc function
    @objc private func tappedButtonBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func switcherMistakesLimitTapped(_ sender: UISwitch) {
        SettingsModel.switchMistakesLimit()
        print("\(SettingsModel.isMistakesLimitSet()) \(SettingsModel.isMistakesIndicates())")
        if (SettingsModel.isMistakesLimitSet() && !SettingsModel.isMistakesIndicates()) {
            (settingsView.subviews[1].subviews[0].subviews[0] as! UISwitch).setOn(true, animated: true)
            (settingsView.subviews[1].subviews[0].subviews[0] as! UISwitch).isOn = true
            SettingsModel.switchMistakesIndicate()
        }
        if (SettingsModel.isMistakesLimitSet() && SettingsModel.isMistakesIndicates()) {
            (settingsView.subviews[1].subviews[0].subviews[0] as! UISwitch).isEnabled = false
        }
        
        if (!SettingsModel.isMistakesLimitSet() && SettingsModel.isMistakesIndicates()) {
            (settingsView.subviews[1].subviews[0].subviews[0] as! UISwitch).isEnabled = true
        }
    }
    
    @objc private func switcherMistakesIndicateTapped(_ sender: UISwitch) {
        SettingsModel.switchMistakesIndicate()
    }
    
    @objc private func switcherAutoRemoveNoteTapped(_ sender: UISwitch) {
        SettingsModel.switchAutoRemoveNote()
    }
    
    @objc private func switcherHighlightingSameNumberTapped(_ sender: UISwitch) {
        SettingsModel.switchHighlighting()
    }
    
    @objc private func switcherDarkModeTapped(_ sender: UISwitch) {
        SettingsModel.switchDarkMode()
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            settingsBtn.setTitleColor(SettingsModel.getMainColor(), for: .normal)
            colorSchemeBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
            howToPlayBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
            navigationItem.title = "Settings"
            showSettings()
        case 1:
            settingsBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
            colorSchemeBtn.setTitleColor(SettingsModel.getMainColor(), for: .normal)
            howToPlayBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
            navigationItem.title = "Scheme"
            showColorScheme()
        default:
            settingsBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
            colorSchemeBtn.setTitleColor(SettingsModel.isDarkMode() ? .lightGray : .secondaryLabel, for: .normal)
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
