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
    private let customButtonFilter = UIButton.makeStackViewButton(levelFilter: "custom")
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
        customButtonFilter.addTarget(self, action: #selector(customButtonTapped(_:)), for: .touchUpInside)
        SVFilterButtons.addArrangedSubview(easyButtonFilter)
        SVFilterButtons.addArrangedSubview(mediumButtonFilter)
        SVFilterButtons.addArrangedSubview(hardButtonFilter)
        SVFilterButtons.addArrangedSubview(customButtonFilter)
        
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
        let gameStat = getGameStats()
        let streak = getStreakStats()
        let time = getTimeStats()
        var i = 0
        for subview in gamesStat.subviews[1].subviews {
            (subview.subviews[1] as! UILabel).text = gameStat[i]
            i += 1
        }
        i = 0
        for subview in streakStat.subviews[1].subviews {
            (subview.subviews[1] as! UILabel).text = streak[i]
            i += 1
        }
        i = 0
        for subview in timeStat.subviews[1].subviews {
            (subview.subviews[1] as! UILabel).text = time[i]
            i += 1
        }

    }
    
    private func getGameStats() -> [String] {
        var mass: [Double] = [0, 0, 0, 0]
        var result: [String] = []
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
        result.append(String(Int(mass[0])))
        result.append(String(Int(mass[1])))
        result.append(String(mass[2]) + " %")
        result.append(String(Int(mass[3])))
        return result
    }
    
    private func getStreakStats() -> [String] {
        return [String(ProfileModel.getCurrentWinStreak()), String(ProfileModel.getBestWinStreak())]
    }
    
    private func getTimeStats() -> [String] {
        var mass: [Double] = [0, 0]
        var result: [String] = []
        var games = 0
        if (filtersSet[0]) {
            games += ProfileModel.getEasyGameWon()
            mass[0] += ProfileModel.getEasyGameAveTime()
            mass[1] = (mass[1] > ProfileModel.getEasyGameBestTime() && ProfileModel.getEasyGameBestTime() != 0) || mass[1] == 0 ? ProfileModel.getEasyGameBestTime() : mass[1]
        }
        if (filtersSet[1]) {
            games += ProfileModel.getMediumGameWon()
            mass[0] += ProfileModel.getMediumGameAveTime()
            mass[1] = (mass[1] > ProfileModel.getMediumGameBestTime() && ProfileModel.getMediumGameBestTime() != 0) || mass[1] == 0 ? ProfileModel.getMediumGameBestTime() : mass[1]
        }
        if (filtersSet[2]) {
            games += ProfileModel.getHardGamesWon()
            mass[0] += ProfileModel.getHardGameAveTime()
            mass[1] = (mass[1] > ProfileModel.getHardGameBestTime() && ProfileModel.getHardGameBestTime() != 0) || mass[1] == 0 ? ProfileModel.getHardGameBestTime() : mass[1]
        }
        if (filtersSet[3]) {
            games += ProfileModel.getCustomGameWon()
            mass[0] += ProfileModel.getCustomGameAveTime()
            mass[1] = (mass[1] > ProfileModel.getCustomGameBestTime() && ProfileModel.getCustomGameBestTime() != 0) || mass[1] == 0 ? ProfileModel.getCustomGameBestTime() : mass[1]
        }
        if (games == 0) {
            mass[0] = 0
        } else {
            mass[0] = mass[0] / Double(games)
        }
        var min = Int(mass[0]) / 60
        var sec = Int(mass[0]) % 60
        result.append(String(min) + ":" + (sec / 10 == 0 ? "0" + String(sec) : String(sec)))
        min = Int(mass[1]) / 60
        sec = Int(mass[1]) % 60
        result.append(String(min) + ":" + (sec / 10 == 0 ? "0" + String(sec) : String(sec)))
        return result
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
    
    @objc private func customButtonTapped(_ sender: UIButton) {
        if (filtersSet[3] && countFiltersIsOnt() != 1) {
            filtersSet[3] = false;
            customButtonFilter.setTitleColor(.secondaryLabel, for: .normal)
        } else {
            filtersSet[3] = true;
            customButtonFilter.setTitleColor(SettingsModel.getMainColor(), for: .normal)
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
