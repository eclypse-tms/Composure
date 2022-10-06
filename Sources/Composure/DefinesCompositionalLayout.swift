//
//  ComposeForm
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

/// You use this protocol to provide information on how the UICollectionView should layout its cells, groups and sections
public protocol DefinesCompositionalLayout {
    /// Required. Provides the meta data needed to layout the cells
    func layoutInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> CompositionalLayoutOption
    
    /// Optional. Provides the layout information needed to layout the header view in each section.
    func headerInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> CompositionalLayoutOption?
    
    /// Optional. Provides the layout information needed to layout the footer view in each section.
    func footerInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> CompositionalLayoutOption?
    
    /// Optional. Override only if you want to provide additional insets (spacing) around each section
    func sectionInsets(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSDirectionalEdgeInsets
    
    /// Optional. Override only if you want to provide additional spacing around each cell
    var interItemSpacing: CGFloat { get }
    
    /// Optional. Override only if you want to provide additional spacing around each groups
    var interGroupSpacing: CGFloat { get }
}

extension DefinesCompositionalLayout {
    public func headerInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> CompositionalLayoutOption? {
        return nil
    }

    public func footerInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> CompositionalLayoutOption? {
        return nil
    }
    
    public var interItemSpacing: CGFloat {
        return CGFloat.zero
    }
    
    public var interGroupSpacing: CGFloat {
        return CGFloat.zero
    }
    
    public func sectionInsets(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets.zero
    }
}
