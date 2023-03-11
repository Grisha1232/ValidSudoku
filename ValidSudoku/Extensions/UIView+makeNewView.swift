//
//  UIView+makeLabelsWithSwitcher.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/30/23.
//

import UIKit

extension UIView {
    
    static func makeLabelwithSwitcher(title str: String, description: String, target: Any?, selector: Selector, value: Bool) -> UIView {
        let mainView = UIView()
        let settingView = UIView()
        let switcher = UISwitch()
        let labelSetting = UILabel()
        let descriptionLabel = UILabel()
        
        mainView.addSubview(settingView)
        settingView.addSubview(switcher)
        settingView.addSubview(labelSetting)
        mainView.addSubview(descriptionLabel)
        
        
        settingView.layer.cornerRadius = 15
        
        labelSetting.text = str
        labelSetting.textColor = SettingsModel.getMainLabelColor()
        labelSetting.pin(to: settingView, [.left: 16, .top: 5, .bottom: 5])
        
        SettingsModel.appendTo(content: switcher)
        switcher.isOn = value
        switcher.onTintColor = SettingsModel.getMainColor()
        switcher.pin(to: settingView, [.top: 10, .bottom: 5, .right: 5])
        switcher.setWidth(60)
        switcher.addTarget(target, action: selector, for: .valueChanged)
        
        descriptionLabel.text = description
        descriptionLabel.textColor = SettingsModel.getSecondaryLabelColor()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 12)
        
        settingView.backgroundColor = SettingsModel.getMainBackgroundColor()
        settingView.setHeight(50)
        
        settingView.pin(to: mainView, [.top, .right, .left])
        
        descriptionLabel.pin(to: mainView, [.bottom: 0, .right: 5, .left: 10])
        descriptionLabel.pinTop(to: settingView.bottomAnchor, 5)
        
        return mainView
    }
    
    static func makeColorView(target: Any?, selector: Selector) -> UIView {
        let view = UIView()
        let tileView = UIView()
        let colorsStackView = UIStackView()
        let textLabel = UILabel()
        let descriptionLabel = UILabel()
        
        
        view.addSubview(tileView)
        view.addSubview(descriptionLabel)
        
        tileView.addSubview(textLabel)
        tileView.addSubview(colorsStackView)
        
        tileView.backgroundColor = SettingsModel.getMainBackgroundColor()
        tileView.layer.cornerRadius = 20
        tileView.pin(to: view, [.left, .right, .top])
        
        descriptionLabel.text = "Sets the default color of the app"
        descriptionLabel.textColor = SettingsModel.getSecondaryLabelColor()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.pin(to: view, [.left: 10, .right: 5, .bottom: 0])
        descriptionLabel.pinTop(to: tileView.bottomAnchor, 5)
        
        textLabel.text = "Change main color: "
        textLabel.textColor = SettingsModel.getMainLabelColor()
        textLabel.pin(to: tileView, [.right: 0, .left: 16, .top: 16])
        
        let blueBtn = UIButton.makeNewColorButton(color: .systemBlue)
        blueBtn.addTarget(target, action: selector, for: .touchUpInside)
        let cyanBtn = UIButton.makeNewColorButton(color: .systemCyan)
        cyanBtn.addTarget(target, action: selector, for: .touchUpInside)
        let orangeBtn = UIButton.makeNewColorButton(color: .systemOrange)
        orangeBtn.addTarget(target, action: selector, for: .touchUpInside)
        let purpleBtn = UIButton.makeNewColorButton(color: .systemPurple)
        purpleBtn.addTarget(target, action: selector, for: .touchUpInside)
        let greenBtn = UIButton.makeNewColorButton(color: .systemGreen)
        greenBtn.addTarget(target, action: selector, for: .touchUpInside)
        
        colorsStackView.addArrangedSubview(blueBtn)
        colorsStackView.addArrangedSubview(cyanBtn)
        colorsStackView.addArrangedSubview(orangeBtn)
        colorsStackView.addArrangedSubview(purpleBtn)
        colorsStackView.addArrangedSubview(greenBtn)
        colorsStackView.axis = .horizontal
        colorsStackView.distribution = .equalSpacing
        colorsStackView.alignment = .center
        
        colorsStackView.pin(to: tileView, [.right: 32, .left: 32, .bottom: 16])
        colorsStackView.pinTop(to: textLabel.bottomAnchor, 16)
        colorsStackView.setHeight(30)
        
        
        return view
    }
    
    static func makeStatView(title: String, subTitles: [String], stats: [String]) -> UIView {
        let view = UIView()
        let titleLabel = UILabel()
        let SVStats = UIStackView()
        
        view.addSubview(titleLabel)
        view.addSubview(SVStats)
        
        titleLabel.text = title
        titleLabel.textColor = SettingsModel.getMainLabelColor()
        titleLabel.font = .systemFont(ofSize: 27)
        titleLabel.pin(to: view, [.top: 0, .left: 32, .right: 0])
        
        
        
        SVStats.axis = .vertical
        SVStats.spacing = 6
        SVStats.pin(to: view, [.right: 16, .left: 16])
        SVStats.pinTop(to: titleLabel.bottomAnchor, 16)
        var i = 0
        for subTitle in subTitles {
            let statView = UIView()
            let subTitleLabel = UILabel()
            let statLabel = UILabel()
            
            statView.addSubview(subTitleLabel)
            statView.addSubview(statLabel)
            
            subTitleLabel.text = subTitle
            subTitleLabel.textColor = SettingsModel.getMainLabelColor()
            subTitleLabel.textAlignment = .right
            subTitleLabel.pin(to: statView, [.left: 32, .top: 16, .bottom: 16])
            subTitleLabel.font = .systemFont(ofSize: 16)
            
            statLabel.text = stats[i]
            statLabel.textColor = SettingsModel.getMainLabelColor()
            statLabel.textAlignment = .right
            statLabel.pin(to: statView, [.right: 32, .top: 16, .bottom: 16])
            statLabel.font = .systemFont(ofSize: 20)
            
            statView.layer.cornerRadius = 25
            statView.backgroundColor = SettingsModel.getMainBackgroundColor()
            statView.setHeight(50)
            
            statView.tag = i
            i += 1
            SVStats.addArrangedSubview(statView)
        }
        
        return view
    }
}
