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
    
    private var gamesStat = UIView()
    private var streakStat = UIView()
    private var timeStat = UIView()
    
    /// StackView on the top of the screen
    private let SVFilterButtons = UIStackView()
    
    private let easyButtonFilter = UIButton.makeStackViewButton(levelFilter: "easy")
    private let mediumButtonFilter = UIButton.makeStackViewButton(levelFilter: "medium")
    private let hardButtonFilter = UIButton.makeStackViewButton(levelFilter: "hard")
    private let expertButtonFilter = UIButton.makeStackViewButton(levelFilter: "expert")
    private var filtersSet: [Bool] = [true, true, true, true]
    
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
        easyButtonFilter.addTarget(self, action: #selector(easyButtonTapped(_:)), for: .touchUpInside)
        mediumButtonFilter.addTarget(self, action: #selector(mediumButtonTapped(_:)), for: .touchUpInside)
        hardButtonFilter.addTarget(self, action: #selector(hardButtonTapped(_:)), for: .touchUpInside)
        expertButtonFilter.addTarget(self, action: #selector(expertButtonTapped(_:)), for: .touchUpInside)
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
        
        
        gamesStat = UIView.makeStatView(title: "Games", subTitles: ["Games started", "Games won", "Win rate", "Wins with no mistakes"], stats: getGameStats())
        statsStackView.addArrangedSubview(gamesStat)
        gamesStat.pinWidth(to: scrollView.widthAnchor)
        gamesStat.setHeight(290)
        
        
        streakStat = UIView.makeStatView(title: "Streak", subTitles: ["Current win streak", "Best win streak"], stats: getStreakStats())
        statsStackView.addArrangedSubview(streakStat)
        streakStat.pinWidth(to: scrollView.widthAnchor)
        streakStat.setHeight(190)
        
        
        timeStat = UIView.makeStatView(title: "Time", subTitles: ["Averange time", "Best time"], stats: getTimeStats())
        statsStackView.addArrangedSubview(timeStat)
        timeStat.pinWidth(to: scrollView.widthAnchor)
        timeStat.setHeight(200)
        
        
        let resetButton = UIButton.makeStackViewButton(levelFilter: "Reset statistics")
        statsStackView.addArrangedSubview(resetButton)
        resetButton.pinWidth(to: scrollView.widthAnchor)
        
    }
    
    private func countFiltersIsOnt() -> Int {
        var count = 0;
        if (filtersSet[0]) {
            count += 1;
        }
        if (filtersSet[1]) {
            count += 1
        }
        if (filtersSet[2]) {
            count += 1
        }
        if (filtersSet[3]) {
            count += 1
        }
        return count
    }
    
    private func refreshStats() {
        if (countFiltersIsOnt() == 4) {
            let mass = getGameStats()
            var i = 0
            for subview in gamesStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = String(mass[i])
                i += 1
            }
            for subview in streakStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = "4"
            }
            for subview in timeStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = "4"
            }
        }
        
        if (countFiltersIsOnt() == 3) {
            let mass = getGameStats()
            var i = 0
            for subview in gamesStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = String(mass[i])
                i += 1
            }
            for subview in streakStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = "3"
            }
            for subview in timeStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = "3"
            }
        }

        if (countFiltersIsOnt() == 2) {
            let mass = getGameStats()
            var i = 0
            for subview in gamesStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = String(mass[i])
                i += 1
            }
            for subview in streakStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = "2"
            }
            for subview in timeStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = "2"
            }
        }
        
        if (countFiltersIsOnt() == 1) {
            let mass = getGameStats()
            var i = 0
            for subview in gamesStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = String(mass[i])
                i += 1
            }
            for subview in streakStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = "1"
            }
            for subview in timeStat.subviews[1].subviews {
                (subview.subviews[1] as! UILabel).text = "1"
            }
        }


    }
    
    private func getGameStats() -> [Double] {
        var mass: [Double] = [0, 0, 0, 0]
        if (filtersSet[0]) {
            mass[0] += Double(ProfileModel.getEasyGameStarted())
            mass[1] += Double(ProfileModel.getEasyGameWon())
            mass[3] += Double(ProfileModel.getEasyGameWinWithNoMistakes())
        }
        if (filtersSet[1]) {
            mass[0] += Double(ProfileModel.getMediumGameStarted())
            mass[1] += Double(ProfileModel.getMediumGameWon())
            mass[3] += Double(ProfileModel.getMediumGameWinWithNoMistakes())
        }
        if (filtersSet[2]) {
            mass[0] += Double(ProfileModel.getHardGamesStarted())
            mass[1] += Double(ProfileModel.getHardGamesWon())
            mass[3] += Double(ProfileModel.getHardGameWinWithNoMistakes())
        }
        if (filtersSet[3]) {
            mass[0] += Double(ProfileModel.getCustomGameStarted())
            mass[1] += Double(ProfileModel.getCustomGameWon())
            mass[3] += Double(ProfileModel.getCustomGameWinWithNoMistakes())
        }
        mass[2] = ProfileModel.calcWinRate(filters: filtersSet) * 100
        return mass
    }
    
    private func getStreakStats() -> [Double] {
        return [0, 0]
    }
    
    private func getTimeStats() -> [Double] {
        return [0, 0]
    }
 
    
    // MARK: - @objc functions
    @objc private func easyButtonTapped(_ sender: UIButton) {
        if (filtersSet[0] && countFiltersIsOnt() != 1) {
            filtersSet[0] = false;
            easyButtonFilter.setTitleColor(.secondaryLabel, for: .normal)
        } else {
            filtersSet[0] = true;
            easyButtonFilter.setTitleColor(SettingsModel.getMainColor(), for: .normal)
        }
        refreshStats()
    }
    
    @objc private func mediumButtonTapped(_ sender: UIButton) {
        if (filtersSet[1] && countFiltersIsOnt() != 1) {
            filtersSet[1] = false;
            mediumButtonFilter.setTitleColor(.secondaryLabel, for: .normal)
        } else {
            filtersSet[1] = true;
            mediumButtonFilter.setTitleColor(SettingsModel.getMainColor(), for: .normal)
        }
        refreshStats()
    }
    
    @objc private func hardButtonTapped(_ sender: UIButton) {
        if (filtersSet[2] && countFiltersIsOnt() != 1) {
            filtersSet[2] = false;
            hardButtonFilter.setTitleColor(.secondaryLabel, for: .normal)
        } else {
            filtersSet[2] = true;
            hardButtonFilter.setTitleColor(SettingsModel.getMainColor(), for: .normal)
        }
        refreshStats()
    }
    
    @objc private func expertButtonTapped(_ sender: UIButton) {
        if (filtersSet[3] && countFiltersIsOnt() != 1) {
            filtersSet[3] = false;
            expertButtonFilter.setTitleColor(.secondaryLabel, for: .normal)
        } else {
            filtersSet[3] = true;
            expertButtonFilter.setTitleColor(SettingsModel.getMainColor(), for: .normal)
        }
        refreshStats()
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
