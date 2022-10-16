//
//  IntToLayoutConverter.swift
//  
//  Created by Turker Nessa Kucuk on 10/6/22.
//  Copyright © 2022 Eclypse Software, LLC. All rights reserved.
//  

import Foundation
import Composure

/// used to map indexpath.item to a corresponding layout option
open class IntToLayoutConverter {
    open func convert(intValue: Int) -> CompositionalLayoutOption {
        let layoutResult: CompositionalLayoutOption
        switch intValue {
        case 0:
            layoutResult = .dynamicWidthFixedHeight(estimatedWidth: 0, fixedHeight: 0)
        case 1:
            layoutResult = .dynamicWidthDynamicHeight(estimatedWidth: 0, estimatedHeight: 0)
        case 2:
            layoutResult = .fixedWidthFixedHeight(fixedWidth: 0, fixedHeight: 0)
        case 3:
            layoutResult = .fixedWidthDynamicHeight(fixedWidth: 0, estimatedHeight: 0)
        case 4:
            layoutResult = .fractionalWidthFixedHeight(widthFraction: 0, fixedHeight: 0)
        case 5:
            layoutResult = .fractionalWidthDynamicHeight(widthFraction: 0, estimatedHeight: 0)
        case 6:
            layoutResult = .fullWidthFixedHeight(fixedHeight: 0)
        case 7:
            layoutResult = .fullWidthDynamicHeight(estimatedHeight: 0)
        case 8:
            layoutResult = .centeredFixedHeight(maxWidth: 0, fixedHeight: 0)
        case 9:
            layoutResult = .centeredDynamicHeight(maxWidth: 0, estimatedHeight: 0)
        case 10:
            layoutResult = .minWidthFixedHeight(minWidth: 0, fixedHeight: 0)
        case 11:
            layoutResult = .minWidthDynamicHeight(minWidth: 0, estimatedHeight: 0)
        case 12:
            layoutResult = .multipleCenteredFixedHeight(numberOfCells: 0, totalMaxWidthOfAllCells: 0, fixedHeight: 0)
        case 13:
            layoutResult = .multipleCenteredDynamicHeight(numberOfCells: 0, totalMaxWidthOfAllCells: 0, estimatedHeight: 0)
        default:
            layoutResult = .fullWidthFixedHeight(fixedHeight: 0)
        }
        
        return layoutResult
    }
    
    open func convert(layoutValue: CompositionalLayoutOption) -> Int {
        switch layoutValue {
        case .dynamicWidthFixedHeight(_, _):
            return 0
        case .dynamicWidthDynamicHeight(_, _):
            return 1
        case .fixedWidthFixedHeight(_, _):
            return 2
        case .fixedWidthDynamicHeight(_, _):
            return 3
        case .fractionalWidthFixedHeight(_, _):
            return 4
        case .fractionalWidthDynamicHeight(_, _):
            return 5
        case .fullWidthFixedHeight(_):
            return 6
        case .fullWidthDynamicHeight(_):
            return 7
        case .centeredFixedHeight(_, _):
            return 8
        case .centeredDynamicHeight(_, _):
            return 9
        case .minWidthFixedHeight(_, _):
            return 10
        case .minWidthDynamicHeight(_, _):
            return 11
        case .multipleCenteredFixedHeight(_, _, _):
            return 12
        case .multipleCenteredDynamicHeight(_, _, _):
            return 13
        }
    }
    
    open var allCases: [CompositionalLayoutOption] {
        var result = [CompositionalLayoutOption]()
        for index in 0..<14 {
            let layoutOption = convert(intValue: index)
            result.append(layoutOption)
        }
        return result
    }
}
