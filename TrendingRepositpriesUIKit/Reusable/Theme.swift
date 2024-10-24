//
//  Theme.swift
//  TrendingRepositpriesUIKit
//
//  Created by Zara on 14/06/2023.
//

import Foundation
import UIKit

public protocol ThemeType {
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var secondaryLight: UIColor { get }
    var background: UIColor { get }
    var greenLight: UIColor { get }
}

public class Theme: ThemeType {
    
    public init() {}
    public var primary: UIColor {  UIColor(named: "primary" ) ?? .blue}
    
    public var secondary: UIColor  { UIColor(named: "secondary") ?? .gray }
    
    public var secondaryLight: UIColor  { UIColor(named: "secondary_light") ?? .lightGray}
    
    public var background: UIColor  { UIColor(named: "background") ?? .white }
    
    public var greenLight: UIColor {  UIColor(named: "green") ?? .green }
    
}
