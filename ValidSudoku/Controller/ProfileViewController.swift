//
//  ProfileViewController.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/16/23.
//

import UIKit

// MARK: - ProfileViewController
class ProfileViewController: UIViewController {
    
    
    // MARK: - Variables
    /// ScrollView for scrolling the stats
    /// ScrollView contains the statsStackView
    private let scrollView = UIScrollView()
    private let statsStackView = UIStackView()
    /// StackView on the top of the screen
    private let SVFilterButtons = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupToolBar()
        setupSVFilterButtons()
        setupStatsView()
    }
    
    /// Set the back button
    private func setupToolBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            style: .plain,
            target: self,
            action: #selector(tappedButtonBack(_:))
        )
        backButton.tintColor = SettingsModel.getMainColor()
        navigationItem.leftBarButtonItems = [backButton]
        navigationItem.title = "Profile"
    }
    
    /// Set the buttons filters on the top of the screen
    private func setupSVFilterButtons() {
        view.addSubview(SVFilterButtons)
        let easyButtonFilter = UIButton.makeStackViewButton(levelFilter: "easy")
        let mediumButtonFilter = UIButton.makeStackViewButton(levelFilter: "medium")
        let hardButtonFilter = UIButton.makeStackViewButton(levelFilter: "hard")
        let expertButtonFilter = UIButton.makeStackViewButton(levelFilter: "expert")
        
        SVFilterButtons.addArrangedSubview(easyButtonFilter)
        SVFilterButtons.addArrangedSubview(mediumButtonFilter)
        SVFilterButtons.addArrangedSubview(hardButtonFilter)
        SVFilterButtons.addArrangedSubview(expertButtonFilter)
        
        SVFilterButtons.axis = .horizontal
        SVFilterButtons.distribution = .equalSpacing
        SVFilterButtons.alignment = .leading
        SVFilterButtons.pin(to: view, [.right: 32, .left: 32])
        SVFilterButtons.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
    }
    
    /// Set stats view
    private func setupStatsView() {
        view.backgroundColor = SettingsModel.getMainBackgroundColor()
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.bounces = false
        
        scrollView.pinTop(to: SVFilterButtons.bottomAnchor, 16)
        scrollView.pin(to: view, [.left, .right])
        scrollView.pinBottom(to: view.bottomAnchor)
        scrollView.backgroundColor = SettingsModel.getSecondaryBackgroundColor()
        
        scrollView.addSubview(statsStackView)
        statsStackView.backgroundColor = SettingsModel.getSecondaryBackgroundColor()
        statsStackView.axis = .vertical
        statsStackView.pin(to: scrollView, [.right: 0, .left: 0, .top: 16, .bottom: 32])
        statsStackView.pinWidth(to: scrollView.widthAnchor)
        
        let gamesStat = UIView.makeStatView(title: "Games", subTitles: ["Games started", "Games won", "Win rate", "Wins with no mistakes"])
        statsStackView.addArrangedSubview(gamesStat)
        gamesStat.pinWidth(to: scrollView.widthAnchor)
        gamesStat.setHeight(290)
        
        let streakStat = UIView.makeStatView(title: "Streak", subTitles: ["Current win streak", "Best win streak"])
        statsStackView.addArrangedSubview(streakStat)
        streakStat.pinWidth(to: scrollView.widthAnchor)
        streakStat.setHeight(190)
        
        let timeStat = UIView.makeStatView(title: "Time", subTitles: ["Averange time", "Best time"])
        statsStackView.addArrangedSubview(timeStat)
        timeStat.pinWidth(to: scrollView.widthAnchor)
        timeStat.setHeight(200)
        
        
        let resetButton = UIButton.makeStackViewButton(levelFilter: "Reset statistics")
        statsStackView.addArrangedSubview(resetButton)
        resetButton.pinWidth(to: scrollView.widthAnchor)
        
    }
    
    
    // MARK: - @objc functions
    @objc private func easyButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func mediumButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func hardButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func expertButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func tappedButtonBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}


extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0.0
    }
}
