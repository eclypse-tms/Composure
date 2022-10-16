//
//  Composure
//  Copyright © 2022 Eclypse Software, LLC. All rights reserved.
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

extension UIViewController {
    open func generateComposionalLayout(with layoutSections: [DefinesCompositionalLayout]) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let strongSelf = self else { return nil }
            let eachSection: DefinesCompositionalLayout = layoutSections[section]
            
            //get the container width from the layout environment
            let availableWidth: CGFloat = layoutEnvironment.container.effectiveContentSize.width
            
            //get the compositional layout option from the enum
            let compositionalLayout = eachSection.layoutInfo(using: layoutEnvironment)
            
            //we'll start by figuring out the size of each cell
            let cellLayoutSize: NSCollectionLayoutSize
            
            //if cell has minimum width requirements, then we need to calculate the available space and distribute the cells accordingly
            switch compositionalLayout {
            case .minWidthDynamicHeight(let minWidth, let estimatedHeight):
                cellLayoutSize = strongSelf.determineCellLayoutSize(availableContentWidth: availableWidth,
                                                                    minimumAllowedCellWidth: minWidth,
                                                                    estimatedOrFixedCellHeight: estimatedHeight,
                                                                    usesDynamicHeight: true,
                                                    layoutEnvironment: layoutEnvironment,
                                                    compositionalSection: eachSection)
                
            case .minWidthFixedHeight(let minWidth, let fixedHeight):
                cellLayoutSize = strongSelf.determineCellLayoutSize(availableContentWidth: availableWidth,
                                                                    minimumAllowedCellWidth: minWidth,
                                                                    estimatedOrFixedCellHeight: fixedHeight,
                                                                    usesDynamicHeight: false,
                                                    layoutEnvironment: layoutEnvironment,
                                                    compositionalSection: eachSection)
            default:
                cellLayoutSize = NSCollectionLayoutSize(with: compositionalLayout)
            }
            
            //assumes that each group is going to take the entire screen horizontally
            let groupLayoutSize = NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0), heightDimension: cellLayoutSize.heightDimension)
            
            let groupLayout: NSCollectionLayoutGroup
            
            if cellLayoutSize.widthDimension.isFractionalWidth {
                //if we are using fractional width, we need to specify number of items per row because
                //according to the doc, group layout uses this logic to lay the items out
                //Specifies a group that will have N items equally sized along the horizontal axis.
                //use interItemSpacing to insert space between items
                let numberOfItemsPerGroup = Int(round(CGFloat(1) / cellLayoutSize.widthDimension.dimension))
                
                
                let subItemInGroup = NSCollectionLayoutItem(layoutSize: cellLayoutSize)
                groupLayout = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize,
                                                                     subitem: subItemInGroup,
                                                                     count: numberOfItemsPerGroup)
            } else {
                //if we are using absolute or estimate width, then we can use this instead
                // Specifies a group that will repeat items until available horizontal space is exhausted.
                // note: any remaining space after laying out items can be apportioned among flexible interItemSpacing definitions
                groupLayout = NSCollectionLayoutGroup.horizontal (
                    layoutSize: groupLayoutSize,
                    subitems: [.init(layoutSize: cellLayoutSize)]
                )
            }
            
            //assumes that spacing in each section will be identical for each cell within that section
            groupLayout.interItemSpacing = .fixed(eachSection.interItemSpacing)
            
            let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
            sectionLayout.contentInsets = strongSelf.finalSectionInsets(availableContentWidth: availableWidth,
                                                                 sectionContentInsets: eachSection.sectionInsets(layoutEnvironment: layoutEnvironment),
                                                                 cellLayout: compositionalLayout)
            
            sectionLayout.interGroupSpacing = eachSection.interGroupSpacing
            
            strongSelf.addHeaderIfNecessary(eachSection: eachSection,
                                 layoutEnvironment: layoutEnvironment,
                                 sectionLayout: sectionLayout)
            
            strongSelf.addFooterIfNecessary(eachSection: eachSection,
                                 layoutEnvironment: layoutEnvironment,
                                 sectionLayout: sectionLayout)
            
            return sectionLayout
        }
    }
    
    private func addHeaderIfNecessary(eachSection: DefinesCompositionalLayout,
                                      layoutEnvironment: NSCollectionLayoutEnvironment,
                                      sectionLayout: NSCollectionLayoutSection) {
        if let providedHeaderInfo = eachSection.headerInfo(using: layoutEnvironment) {
            
            let headerLayoutSize = NSCollectionLayoutSize(with: providedHeaderInfo)
            
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: headerLayoutSize,
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top)
            
            sectionLayout.boundarySupplementaryItems.append(headerItem)
        }
    }
    
    private func addFooterIfNecessary(eachSection: DefinesCompositionalLayout,
                                      layoutEnvironment: NSCollectionLayoutEnvironment,
                                      sectionLayout: NSCollectionLayoutSection) {
        
        if let providedFooterInfo = eachSection.footerInfo(using: layoutEnvironment) {
        
            let footerLayoutSize = NSCollectionLayoutSize(with: providedFooterInfo)
            
            let footerItem = NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: footerLayoutSize,
                            elementKind: UICollectionView.elementKindSectionFooter,
                            alignment: .bottom)
            
            sectionLayout.boundarySupplementaryItems.append(footerItem)
        }
    }
    
    private func finalSectionInsets(availableContentWidth: CGFloat,
                                    sectionContentInsets: NSDirectionalEdgeInsets,
                                    cellLayout: CompositionalLayoutOption) -> NSDirectionalEdgeInsets {
        
        func calculateInsets(basedOn maxAllowedWidth: CGFloat) -> NSDirectionalEdgeInsets {
            let usableWidthForCellLayout = availableContentWidth - (sectionContentInsets.leading + sectionContentInsets.trailing)
            if usableWidthForCellLayout > maxAllowedWidth {
                //content width is greater than the maximum allowed cell width
                //in order to center it, we need to bump up the section content insets
                let amountWeNeedToIncreaseSectionContentInsetsForEachSide = (usableWidthForCellLayout - maxAllowedWidth) / 2.0
                return NSDirectionalEdgeInsets(top: sectionContentInsets.top,
                                               leading: sectionContentInsets.leading + amountWeNeedToIncreaseSectionContentInsetsForEachSide,
                                               bottom: sectionContentInsets.bottom,
                                               trailing: sectionContentInsets.trailing + amountWeNeedToIncreaseSectionContentInsetsForEachSide)
            } else {
                return sectionContentInsets
            }
        }
        
        switch cellLayout {
        case .centeredFixedHeight(let maxWidth, _):
            return calculateInsets(basedOn: maxWidth)
        case .centeredDynamicHeight(let maxWidth, _):
            return calculateInsets(basedOn: maxWidth)
        case .multipleCenteredFixedHeight(_, let totalMaxWidthOfAllCells, _):
            return calculateInsets(basedOn: totalMaxWidthOfAllCells)
        case .multipleCenteredDynamicHeight(_, let totalMaxWidthOfAllCells, _):
            return calculateInsets(basedOn: totalMaxWidthOfAllCells)
        default:
            return sectionContentInsets
        }
    }
    
    /// determines the layout size of each cell heuristically if there is minimum width requirements
    private func determineCellLayoutSize(availableContentWidth: CGFloat,
                                         minimumAllowedCellWidth: CGFloat,
                                         estimatedOrFixedCellHeight: CGFloat,
                                         usesDynamicHeight: Bool,
                                         layoutEnvironment: NSCollectionLayoutEnvironment,
                                         compositionalSection: DefinesCompositionalLayout) -> NSCollectionLayoutSize {
        
        //this logic is using heuristics. In reality, interitem spacing is only needed n-1 times.
        //in other words, if you place n cells in a row, then you only need interitem spacing for n-1 times.
        //however, that makes the calculations complicated because you will have to perform at least 2 passes to figure out the exact
        //placement of each cell.
        
        //we simply calculate the available space that can be used for cell placement and determine how many cells can fit
        let cellWidthInterItemSpacingIncluded = Int(minimumAllowedCellWidth + compositionalSection.interItemSpacing)
        let sectionContentInset = compositionalSection.sectionInsets(layoutEnvironment: layoutEnvironment)
        let usableWidthForCellLayout = availableContentWidth - (sectionContentInset.leading + sectionContentInset.trailing)
        
        let numberOfCellsThatWouldFitTheScreen = CGFloat(Int(usableWidthForCellLayout) / cellWidthInterItemSpacingIncluded)
        
        if Int(numberOfCellsThatWouldFitTheScreen) <= 1 {
            //if we end up with zero cells, then make the cell take the entire space
            if usesDynamicHeight {
                return NSCollectionLayoutSize(with: .fullWidthDynamicHeight(estimatedHeight: estimatedOrFixedCellHeight))
            } else {
                return NSCollectionLayoutSize(with: .fullWidthFixedHeight(fixedHeight: estimatedOrFixedCellHeight))
            }
        } else {
            //if we can fit more than one cell, then divide the available space evenly for each cell
            let fractionOfScreen = CGFloat(1) / numberOfCellsThatWouldFitTheScreen
            if usesDynamicHeight {
                return NSCollectionLayoutSize(with: .fractionalWidthDynamicHeight(widthFraction: fractionOfScreen, estimatedHeight: estimatedOrFixedCellHeight))
            } else {
                return NSCollectionLayoutSize(with: .fractionalWidthFixedHeight(widthFraction: fractionOfScreen, fixedHeight: estimatedOrFixedCellHeight))
            }
        }
    }
}
