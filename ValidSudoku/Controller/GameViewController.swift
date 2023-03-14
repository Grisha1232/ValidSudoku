//
//  GameViewController.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/16/23.
//

import UIKit
import CoreData

// MARK: - GameViewController
class GameViewController: UIViewController, ChangedColorProtocol, SelectionProtocol, SaveBeforeExitProtocol {
    
    
    // MARK: - Variables
    /// decription on the top of the game field
    private let descriptionStackView = UIStackView()
    private var timer: Timer?
    private var seconds: Double = 0
    private var levelGame: String
    private var mistakes: Int = 0
    
    /// Game field view
    private var gameField: GameFieldView
    
    /// Game saver for "undo" operations and for continuing the prev game
    private let gameSaver: GameSaver
    
    /// StackView with buttons for tools
    private let toolsStackView = UIStackView()
    /// StackView with buttons for digits
    private let lineDigitsStackView = UIStackView()
    private var digitsCount: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    /// Selected states
    private var selectedRow: Int = -1
    private var selectedCol: Int = -1
    private var selectedSquare: GameFieldSquare? = nil
    private var selectedPreFilled: Bool = true
    
    // MARK: - init()
    init(levelGame: String?) {
        self.levelGame = levelGame ?? ""
        gameField = GameFieldView(levelGame: self.levelGame)
        gameSaver = GameSaver(state: GameState(levelString: self.levelGame, mistakesCount: mistakes, timer: seconds, fieldState: gameField.saveGame()))
        super.init(nibName: nil, bundle: nil)
    }
    
    init(gameState: GameState) {
        self.levelGame = gameState.getLevel()
        self.seconds = gameState.getTimer()
        self.mistakes = gameState.getMistakes()
        self.gameField = GameFieldView(fieldState: gameState.getFieldState())
        self.gameSaver = GameSaver(state: gameState)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsModel.appendTo(content: self)
        (UIApplication.shared.delegate as? AppDelegate)?.addDelegate(del: self)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Control functions
    /// Set the state fof the selection
    internal func setRowAndColumnOfSelection(_ gameSquare: GameFieldSquare, _ row: Int, _ col: Int, _ preFilled: Bool) {
        selectedRow = row
        selectedCol = col
        selectedSquare = gameSquare
        selectedPreFilled = preFilled
    }
    
    /// Protocol function for changing color after setting it in "SettingsViewController"
    internal func changeColor() {
        view.window?.changeColor()
        view.backgroundColor = SettingsModel.getSecondaryBackgroundColor()
        for navItem in navigationItem.leftBarButtonItems! {
            navItem.tintColor = SettingsModel.getMainColor()
        }
        for navItem in navigationItem.rightBarButtonItems! {
            navItem.tintColor = SettingsModel.getMainColor()
        }
        var i = 0
        for numBtn in lineDigitsStackView.subviews {
            if (digitsCount[i] != 9) {
                (numBtn as! UIButton).setTitleColor(SettingsModel.getMainColor(), for: .normal)
            } else {
                (numBtn as! UIButton).setTitleColor(SettingsModel.getSecondaryBackgroundColor() , for: .normal)
            }
            i += 1
        }
        gameField.refreshFromSelection()
        gameField.changeColor()
        
        for i in 0...2 {
            (descriptionStackView.subviews[i] as! UILabel).textColor = SettingsModel.getMainLabelColor()
        }
        for i in 0...3 {
            toolsStackView.subviews[i].subviews[0].tintColor = SettingsModel.getMainLabelColor()
            (toolsStackView.subviews[i].subviews[1] as! UILabel).textColor = SettingsModel.getMainLabelColor()
        }
        
    }
    
    internal func countUpMistakes() {
        mistakes += 1
        let label = self.descriptionStackView.subviews[1] as! UILabel
        label.text = "Mistakes: " + String(mistakes) + (SettingsModel.isMistakesLimitSet() ? "/3" : "")
        if (SettingsModel.isMistakesLimitSet() && mistakes == 3) {
            gameOver(isGameWon: false)
        }
    }
    
    internal func saveBeforeExitApp() {
        if (!gameField.isGameOver()) {
            gameSaver.save(state: GameState(levelString: levelGame, mistakesCount: mistakes, timer: seconds, fieldState: gameField.saveGame()))
            SettingsModel.save(gameState: gameSaver.getPrevSave())
            gameField.changeColor()
        }
    }
    
    
    // MARK: - Setup UI functions
    private func setupUI() {
        view.backgroundColor = SettingsModel.getSecondaryBackgroundColor()
        setupBarButtons()
        setupLineDigits()
        setupTools()
        setupGameField()
        setupDescriptions()
        
        
    }
    
    /// Set back and setting buttons and title
    private func setupBarButtons() {
        let settingButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(tappedButtonSettings(_:))
        )
        settingButton.tintColor = SettingsModel.getMainColor()
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            style: .plain,
            target: self,
            action: #selector(tappedButtonBack(_:))
        )
        backButton.tintColor = SettingsModel.getMainColor()
        navigationItem.leftBarButtonItems = [backButton]
        navigationItem.rightBarButtonItems = [settingButton]
        navigationItem.title = "Valid Sudoku"
    }
    
    /// Set description on the top of the game field
    private func setupDescriptions() {
        view.addSubview(descriptionStackView)
        
        descriptionStackView.axis = .horizontal
        descriptionStackView.alignment = .center
        descriptionStackView.distribution = .equalSpacing
        
        let levelLabel = UILabel()
        levelLabel.text = levelGame
        levelLabel.textColor = SettingsModel.getMainLabelColor()
        levelLabel.font = .systemFont(ofSize: view.frame.width / 23)
        levelLabel.textAlignment = .left
        descriptionStackView.addArrangedSubview(levelLabel)
        levelLabel.setWidth((view.frame.width - 34) / 3)
        
        let mistakesCount = UILabel()
        mistakesCount.text = "Mistakes: " + String(mistakes) + (SettingsModel.isMistakesLimitSet() ? "/3" : "")
        mistakesCount.textColor = SettingsModel.getMainLabelColor()
        mistakesCount.font = .systemFont(ofSize: view.frame.width / 23)
        mistakesCount.textAlignment = .center
        descriptionStackView.addArrangedSubview(mistakesCount)
        mistakesCount.setWidth((view.frame.width - 34) / 3)
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        let timerLabel = UILabel()
        timerLabel.text = "time: 0:00"
        timerLabel.textColor = SettingsModel.getMainLabelColor()
        timerLabel.font = .systemFont(ofSize: view.frame.width / 23)
        timerLabel.textAlignment = .right
        descriptionStackView.addArrangedSubview(timerLabel)
        timerLabel.setWidth((view.frame.width - 34) / 3)
        
        descriptionStackView.pin(to: view, [.left: 17, .right: 17])
        descriptionStackView.pinBottom(to: gameField.topAnchor)
        descriptionStackView.setHeight(45)
    }
    
    /// Set game field View
    private func setupGameField() {
        digitsCount = gameField.countDigitInMatrix()
        gameField.delegate = self
        view.addSubview(gameField)
        gameField.pin(to: view, [.left: 16, .right: 16])
        gameField.pinBottom(to: toolsStackView.topAnchor, 16)
        gameField.setHeight(view.frame.height / 2)
    }
    
    /// Set tools for interating with game field
    private func setupTools() {
        view.addSubview(toolsStackView)
        let tools: [UIImage?] = [.init(systemName: "arrow.uturn.left"), .init(systemName: "delete.left"), .init(systemName: "pencil"), .init(systemName: "lightbulb")]
        var i = 0
        for tool in tools {
            let viewTool = UIView()
            let button = UIButton()
            let toolLabel = UILabel()
            
//            button.backgroundColor = SettingsModel.getSecondaryBackgroundColor()
            button.setBackgroundImage(tool, for: .normal)
            button.tag = i
            button.tintColor = SettingsModel.getMainLabelColor()
            
            if i == 0 {
                toolLabel.text = "undo"
                button.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
            } else if i == 1 {
                toolLabel.text = "erase"
                button.addTarget(self, action: #selector(eraseButtonTapped(_:)), for: .touchUpInside)
            } else if i == 2 {
                toolLabel.text = "note"
                button.addTarget(self, action: #selector(noteButtonTapped(_:)), for: .touchUpInside)
            } else {
                toolLabel.text = "hint"
                button.addTarget(self, action: #selector(hintButtonTapped(_:)), for: .touchUpInside)
            }
            i += 1
            toolLabel.textAlignment = .center
            toolLabel.textColor = SettingsModel.getMainLabelColor()
            
            toolLabel.font = .systemFont(ofSize: 14)
            
            viewTool.addSubview(button)
            viewTool.addSubview(toolLabel)
            button.pin(to: viewTool, [.left, .right, .top])
            toolLabel.pin(to: viewTool, [.bottom, .left, .right])
            button.pinBottom(to: toolLabel.topAnchor, 5)
            
            button.setHeight(40)
            viewTool.setWidth(45)
            toolsStackView.addArrangedSubview(viewTool)
        }
        toolsStackView.spacing = 16
        toolsStackView.axis         = .horizontal
        toolsStackView.alignment    = .center
        toolsStackView.distribution = .equalSpacing
        toolsStackView.pinBottom(to: lineDigitsStackView.topAnchor, 16)
        toolsStackView.pin(to: view, [.left: 32, .right: 32])
        toolsStackView.setHeight(60)
    }
    
    /// Set digit buttons for filling the cells in the field
    private func setupLineDigits() {
        digitsCount = gameField.countDigitInMatrix()
        view.addSubview(lineDigitsStackView)
        for i in 0..<9 {
            let button = UIButton()
            button.setTitle(String(i + 1), for: .normal)
            button.tag = i + 1
            button.setTitleColor(SettingsModel.getMainColor(), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 32)
            button.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
            if (digitsCount[i] == 9) {
                button.isEnabled = false
                button.setTitleColor(SettingsModel.getSecondaryBackgroundColor() , for: .normal)
            }
            lineDigitsStackView.addArrangedSubview(button)
        }
        lineDigitsStackView.axis         = .horizontal
        lineDigitsStackView.alignment    = .center
        lineDigitsStackView.distribution = .equalSpacing
        lineDigitsStackView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16)
        lineDigitsStackView.pin(to: view, [.left: 16, .right: 16])
        lineDigitsStackView.setHeight(60)
    }
    
    private func switchLineDigits() {
        if (SettingsModel.isNoteOn()) {
            for numBtn in lineDigitsStackView.subviews {
                let numb = numBtn as! UIButton
                numb.setTitleColor(SettingsModel.getMainLabelColor(), for: .normal)
                numb.isEnabled = true
            }
        } else {
            for numBtn in lineDigitsStackView.subviews {
                (numBtn as! UIButton).setTitleColor(SettingsModel.getMainColor(), for: .normal)
            }
            for i in 0...8 {
                if (digitsCount[i] == 9) {
                    (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = false
                    (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.getSecondaryBackgroundColor(), for: .normal)
                }
            }
        }
    }
    
    private func restartTheGame() {
        let state = gameSaver.getFirstSave()!
        navigationController?.popViewController(animated: true)
        let restartGame = GameViewController(gameState: state)
        navigationController?.pushViewController(restartGame, animated: true)
    }
    
    private func gameOver(isGameWon: Bool) {
        if (isGameWon) {
            gameOverWithWin()
        } else {
            for sub in toolsStackView.subviews {
                (sub.subviews[0] as! UIButton).isEnabled = false
                (sub.subviews[0] as! UIButton).isHidden = true
                (sub.subviews[1] as! UILabel).text = "over"
            }
            gameField.showMistakesAfterGame()
            let alert = UIAlertController(title: "Do you wnat to restart the game?", message: "There are mistakes maden", preferredStyle: .actionSheet)
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: {_ in
                self.restartTheGame()
            })
            let actionNo = UIAlertAction(title: "No", style: .destructive, handler: {_ in
                self.gameOverWithLoose()
            })
            alert.addAction(actionYes)
            alert.addAction(actionNo)
            navigationController?.present(alert, animated: true)
        }
    }
    
    private func gameOverWithWin() {
        timer?.invalidate()
        ProfileModel.countUpGameWon(levelGame)
        ProfileModel.countCurrentWinStreak(true)
        ProfileModel.updateTime(levelGame, seconds)
        SettingsModel.save(gameState: nil)
        if (mistakes == 0) {
            ProfileModel.countUpWinWithMoMistakes(levelGame)
        }
        navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Win!", message: "lol", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        navigationController?.present(alert, animated: true)
    }
    
    private func gameOverWithoutLoose() {
        timer?.invalidate()
        navigationController?.popViewController(animated: true)
        gameSaver.save(state: GameState(levelString: levelGame, mistakesCount: mistakes, timer: seconds, fieldState: gameField.saveGame()))
        SettingsModel.save(gameState: gameSaver.getPrevSave() ?? GameState(levelString: "none", mistakesCount: 0, timer: 0, fieldState: FieldState(field: [], preFilled: [], answerMatrix: [], fieldNote: [])))
        let alert = UIAlertController(title: "Saved", message: "lol", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        navigationController?.present(alert, animated: true)
    }
    
    private func gameOverWithLoose() {
        timer?.invalidate()
        SettingsModel.save(gameState: nil)
        ProfileModel.countCurrentWinStreak(false)
        navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Loose", message: "lol", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        navigationController?.present(alert, animated: true)
    }
    
    
    // MARK: - @objc functions
    @objc private func updateTimeLabel() {
        seconds += 0.5
        if (Double(Int(seconds)) - seconds == 0) {
            let secs = Int(seconds)
            let label = self.descriptionStackView.subviews[2] as! UILabel
            let minutes: Int = secs / 60
            let sec = secs % 60
            label.text = "time: " + String(minutes) + ":" + (sec / 10 == 0 ? "0" + String(sec) : String(sec))
        } else {
            let secs = Int(seconds)
            let label = self.descriptionStackView.subviews[2] as! UILabel
            let minutes: Int = secs / 60
            let sec = secs % 60
            label.text = "time: " + String(minutes) + " " + (sec / 10 == 0 ? "0" + String(sec) : String(sec))
        }
    }
    
    @objc private func undoButtonTapped(_ sender: UIButton) {
        if (gameSaver.canUndo()) {
            let _ = gameSaver.getRemoveLast()
            let save = gameSaver.getPrevSave()
            gameField.undoToState(gameState: save!);
            selectedRow = -1
        } else {
            let alert = UIAlertController(title: "There is no move you can undo", message: "oops", preferredStyle: .actionSheet)
            
            navigationController?.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    alert.dismiss(animated: true)
                })
            })
        }
        
    }
    
    @objc private func eraseButtonTapped(_ sender: UIButton) {
        if(!selectedPreFilled) {
            gameField.setFieldMatrix(gameSquare: selectedSquare!, row: selectedRow, col: selectedCol, num: 0)
            digitsCount = gameField.countDigitInMatrix()
            for i in 0...8 {
                if (digitsCount[i] == 9) {
                    (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = false
                    (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.getSecondaryBackgroundColor(), for: .normal)
                } else {
                    (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = true
                    (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.isNoteOn() ? SettingsModel.getSecondaryLabelColor() : SettingsModel.getMainColor(), for: .normal)
                }
            }
            gameSaver.save(state: GameState(levelString: levelGame, mistakesCount: mistakes, timer: seconds, fieldState: gameField.saveGame()))
        }
    }
    
    @objc private func noteButtonTapped(_ sender: UIButton) {
        SettingsModel.switchNote()
        switchLineDigits()
    }
    
    @objc private func hintButtonTapped(_ sender: UIButton) {
        if (SettingsModel.isNoteOn()) {
            noteButtonTapped(toolsStackView.subviews[2].subviews[0] as! UIButton)
        }
        let answer: (num: Int, row: Int, col: Int)
        if (gameField.isNoMistakesInMatrix()) {
            answer = gameField.getHint()
        } else {
            gameField.getRidOfInccorections()
            answer = gameField.getHint()
        }
        if (answer == (-1, -1, -1)) {
            let alert = UIAlertController(title: "We are not so smart to give you a hint by logic(", message: "But we can fill the note for you", preferredStyle: .actionSheet)
            navigationController?.present(alert, animated: true, completion: {
                self.gameField.fillNotes()
                self.gameSaver.save(state: GameState(levelString: self.levelGame, mistakesCount: self.mistakes, timer: self.seconds, fieldState: self.gameField.saveGame()))
                sleep(1)
                alert.dismiss(animated: true)
            })
            return
        }
        digitsCount = gameField.countDigitInMatrix()
        var count = 0
        for i in 0...8 {
            if (digitsCount[i] == 9) {
                count += 1
                (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = false
                (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.getSecondaryBackgroundColor(), for: .normal)
            } else {
                (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = true
                (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.getMainColor(), for: .normal)
            }
        }
        gameSaver.save(state: GameState(levelString: levelGame, mistakesCount: mistakes, timer: seconds, fieldState: gameField.saveGame()))
        if (gameField.isGameOver() && gameField.isGameOverWithWin()) {
            gameOver(isGameWon: true)
        } else if (gameField.isGameOver() && !gameField.isGameOverWithWin()){
            gameOver(isGameWon: false)
        }
    }
    
    @objc private func numberTapped(_ sender: UIButton) {
        if (!selectedPreFilled && !SettingsModel.isNoteOn() && selectedRow != -1){
            gameField.setFieldMatrix(gameSquare: selectedSquare!, row: selectedRow, col: selectedCol, num: sender.tag)
            digitsCount = gameField.countDigitInMatrix()
            var count = 0
            for i in 0...8 {
                if (digitsCount[i] == 9) {
                    count += 1
                    (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = false
                    (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.getSecondaryBackgroundColor(), for: .normal)
                } else {
                    (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = true
                    (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.getMainColor(), for: .normal)
                }
            }
            gameSaver.save(state: GameState(levelString: levelGame, mistakesCount: mistakes, timer: seconds, fieldState: gameField.saveGame()))
            if (gameField.isGameOver() && gameField.isNoMistakesInMatrix()) {
                gameOver(isGameWon: true)
            } else if (gameField.isGameOver() && !gameField.isNoMistakesInMatrix()){
                gameOver(isGameWon: false)
            }
        } else if (!selectedPreFilled && SettingsModel.isNoteOn() && selectedRow != -1) {
            gameField.setFieldMatrix(gameSquare: selectedSquare!, row: selectedRow, col: selectedCol, num: sender.tag)
            gameSaver.save(state: GameState(levelString: levelGame, mistakesCount: mistakes, timer: seconds, fieldState: gameField.saveGame()))
        }
    }
    
    @objc private func tappedButtonSettings(_ sender: UIBarButtonItem) {
        gameField.refreshFromSelection()
        let settings = SettingsViewController(isOpenedFromTheGame: true)
        if (SettingsModel.isNoteOn()) {
            noteButtonTapped(toolsStackView.subviews[2].subviews[0] as! UIButton)
        }
        navigationController?.pushViewController(settings, animated: true)
    }
    
    @objc private func tappedButtonBack(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Do you wanna continue game in future?", message: "Press \"Yes\" if u wnna save game\n Press \"No\" if you wanna end this game (count as loose)", preferredStyle: .actionSheet)
        let actionYes = UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.gameOverWithoutLoose()
        })
        alert.addAction(actionYes)
        let actionNo = UIAlertAction(title: "No", style: .destructive, handler: {_ in
            self.gameOverWithLoose()
        })
        alert.addAction(actionNo)
        navigationController?.present(alert, animated: true)
    }
    
}
