//
//  GameViewController.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/16/23.
//

import UIKit

// MARK: - GameViewController
class GameViewController: UIViewController, ChangedColorProtocol, SelectionProtocol {
    
    
    // MARK: - Variables
    /// decription on the top of the game field
    private let descriptionStackView = UIStackView()
    private var timer: Timer?
    private var seconds: Int = 0
    private var levelGame: String
    private var mistakes: Int = 0
    
    /// Game field view
    private var gameField: GameFieldView
    
    /// StackView with buttons for tools
    private let toolsStackView = UIStackView()
    // StackView with buttons for digits
    private let lineDigitsStackView = UIStackView()
    private var digitsCount: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    /// Selected states
    private var selectedRow: Int = 0
    private var selectedCol: Int = 0
    private var selectedSquare: GameFieldSquare? = nil
    private var selectedPreFilled: Bool = true
    
    // MARK: - init()
    init(levelGame: String?) {
        self.levelGame = levelGame ?? ""
        gameField = GameFieldView(levelGame: self.levelGame)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsModel.appendTo(content: self)
        setupUI()
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
        for navItem in navigationItem.leftBarButtonItems! {
            navItem.tintColor = SettingsModel.getMainColor()
        }
        for navItem in navigationItem.rightBarButtonItems! {
            navItem.tintColor = SettingsModel.getMainColor()
        }
        for numBtn in lineDigitsStackView.subviews {
            (numBtn as! UIButton).setTitleColor(SettingsModel.getMainColor(), for: .normal)
        }
        gameField.refreshFromSelection()
    }
    
    
    // MARK: - Setup UI functions
    private func setupUI() {
        view.backgroundColor = .white
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
        levelLabel.font = .systemFont(ofSize: view.frame.width / 20)
        levelLabel.textAlignment = .left
        descriptionStackView.addArrangedSubview(levelLabel)
        levelLabel.setWidth(60)
        
        let mistakesCount = UILabel()
        mistakesCount.text = "Mistakes: 999"
        mistakesCount.font = .systemFont(ofSize: view.frame.width / 20)
        mistakesCount.textAlignment = .center
        descriptionStackView.addArrangedSubview(mistakesCount)
        mistakesCount.setWidth(150)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        let timerLabel = UILabel()
        timerLabel.text = "time:  0:00"
        timerLabel.font = .systemFont(ofSize: view.frame.width / 20)
        timerLabel.textAlignment = .right
        descriptionStackView.addArrangedSubview(timerLabel)
        timerLabel.setWidth(120)
        
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
            
            button.backgroundColor = .white
            button.setBackgroundImage(tool, for: .normal)
            button.tag = i
            button.tintColor = .label
            
            if i == 0 {
                toolLabel.text = "undo"
            } else if i == 1 {
                toolLabel.text = "erase"
                button.addTarget(self, action: #selector(eraseButtonTapped(_:)), for: .touchUpInside)
            } else if i == 2 {
                toolLabel.text = "note"
            } else {
                toolLabel.text = "hint"
            }
            i += 1
            toolLabel.textAlignment = .center
            
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
        view.addSubview(lineDigitsStackView)
        for i in 0..<9 {
            let button = UIButton()
            button.backgroundColor = .white
            button.setTitle(String(i + 1), for: .normal)
            button.tag = i + 1
            button.setTitleColor(SettingsModel.getMainColor(), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 32)
            button.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
            lineDigitsStackView.addArrangedSubview(button)
        }
        lineDigitsStackView.axis    = .horizontal
        lineDigitsStackView.alignment    = .center
        lineDigitsStackView.distribution = .equalSpacing
        lineDigitsStackView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16)
        lineDigitsStackView.pin(to: view, [.left: 16, .right: 16])
        lineDigitsStackView.setHeight(60)
    }
    
    
    // MARK: - @objc functions
    @objc private func updateTimeLabel() {
        seconds += 1
        let label = descriptionStackView.subviews[2] as! UILabel
        let minutes: Int = seconds / 60
        let sec = seconds % 60
        label.text = "time:  " + String(minutes) + (seconds % 2 == 1 ? ":" : " ") + (sec / 10 == 0 ? "0" + String(sec) : String(sec))
    }
    
    @objc private func eraseButtonTapped(_ sender: UIButton) {
        if(!selectedPreFilled) {
            let cellWithNumber = selectedSquare!.collectionViewCells.cellForItem(at: IndexPath(row: selectedCol % 3, section: selectedRow % 3)) as! cellWithNumber
            let index = Int(cellWithNumber.getNumber()) ?? -1
            if (index != -1) {
                digitsCount[index - 1] -= 1
                (lineDigitsStackView.subviews[index - 1] as! UIButton).isEnabled = true
                (lineDigitsStackView.subviews[index - 1] as! UIButton).setTitleColor(SettingsModel.getMainColor(), for: .normal)
            }
            gameField.setFieldMatrix(gameSquare: selectedSquare!, row: selectedRow, col: selectedCol, num: 0)
        }
    }
    
    @objc private func numberTapped(_ sender: UIButton) {
        if (!selectedPreFilled){
            digitsCount[sender.tag - 1] += 1
            gameField.setFieldMatrix(gameSquare: selectedSquare!, row: selectedRow, col: selectedCol, num: sender.tag)
            if (digitsCount[sender.tag - 1] == 9) {
                sender.isEnabled = false
                sender.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @objc private func tappedButtonSettings(_ sender: UIBarButtonItem) {
        let settings = SettingsViewController()
        navigationController?.pushViewController(settings, animated: true)
    }
    
    @objc private func tappedButtonBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}
