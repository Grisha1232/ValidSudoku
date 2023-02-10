//
//  UIView+pins.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/16/23.
//

import UIKit

extension UIView {
    enum PinSide {
        case top, bottom, left, right
    }
    
    func pin(to superview: UIView, _ sides: [PinSide]) {
        for side in sides {
            switch side {
                case .top:
                    pinTop(to: superview)
                case .bottom:
                    pinBottom(to: superview)
                case .left:
                    pinLeft(to: superview)
                case .right:
                    pinRight(to: superview)
            }
        }
    }
    
    func pin(to superview: UIView, _ sides: [PinSide: Int]) {
        for side in sides {
            switch side.key {
                case .top:
                    pinTop(to: superview, side.value)
                case .bottom:
                    pinBottom(to: superview, side.value)
                case .left:
                    pinLeft(to: superview, side.value)
                case .right:
                    pinRight(to: superview, side.value)
            }
        }
    }
    
    @discardableResult
    func pinLeft(to superview: UIView,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: superview.leadingAnchor,
            constant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinLeft(to side: NSLayoutXAxisAnchor,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinRight(to superview: UIView,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: superview.trailingAnchor,
            constant: CGFloat(const * -1))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinRight(to side: NSLayoutXAxisAnchor,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const * -1))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinTop(to superview: UIView,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: superview.topAnchor,
            constant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinTop(to side: NSLayoutYAxisAnchor,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinBottom(to superview: UIView,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: superview.bottomAnchor,
            constant: CGFloat(const * -1))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinBottom(to side: NSLayoutYAxisAnchor,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const * -1))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinCenterX(to superview: UIView,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(
            equalTo: superview.centerXAnchor,
            constant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinCenterX(to center: NSLayoutXAxisAnchor,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(
            equalTo: center,
            constant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinCenterY(to superview: UIView,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(
            equalTo: superview.centerYAnchor,
            constant: CGFloat(const * -1))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinCenterY(to side: NSLayoutYAxisAnchor,_ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const * -1))
        constraint.isActive = true
        
        return constraint
    }
    
    func pinCenter(to superview: UIView, _ const: Int = 0) {
        pinCenterX(to: superview)
        pinCenterY(to: superview)
    }
    
    @discardableResult
    func pinHeight(to superview: UIView,_ mult: Int = 1) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(
            equalTo: superview.heightAnchor,
            constant: CGFloat(mult))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinHeight(to side: NSLayoutDimension,_ mult: Int = 1) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(
            equalTo: side,
            constant: CGFloat(mult))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinWidth(to superview: UIView,_ mult: Int = 1) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(
            equalTo: superview.widthAnchor, constant:
            CGFloat(mult))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func pinWidth(to side: NSLayoutDimension,_ mult: Int = 1) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(
            equalTo: side, constant:
                CGFloat(mult))
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func setHeight(_ const: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func setWidth(_ const: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        return constraint
    }
}

