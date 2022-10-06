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
import LoremIpsum
import Composure

class CompositeViewController: UIViewController {
    @IBOutlet private weak var mainCollectionView: UICollectionView!

    private var randomImageGenerator: RandomImageGenerator!
    private var dataSource: UICollectionViewDiffableDataSource<CompositeViewSection, AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        randomImageGenerator = RandomImageGeneratorImpl()
        
        mainCollectionView.register(ImageAndLabelCell.nib, forCellWithReuseIdentifier: ImageAndLabelCell.nibName)
        mainCollectionView.register(ImageLabelSliderCell.nib, forCellWithReuseIdentifier: ImageLabelSliderCell.nibName)
        mainCollectionView.register(HeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.nibName)
        
        mainCollectionView.dataSource = configureDataSource()
        mainCollectionView.collectionViewLayout = generateComposionalLayout(with: CompositeViewSection.allCases)
        
        mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
                
        populateCollectionView()
        
        title = "Multiple Layouts"
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<CompositeViewSection, AnyHashable> {
        let configuredDataSource = UICollectionViewDiffableDataSource<CompositeViewSection, AnyHashable>(collectionView: mainCollectionView) { (collectionView, indexPath, cellPayload) -> UICollectionViewCell? in
            let viewSection = CompositeViewSection(rawValue: indexPath.section)!
            switch viewSection {
            case .section1:
                if let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageAndLabelCell.nibName, for: indexPath) as? ImageAndLabelCell,
                   let viewModel = cellPayload as? ImageAndLabelViewModel {
                    collectionCell.configureCell(with: viewModel)
                    return collectionCell
                } else {
                    return nil
                }
            case .section2:
                if let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageLabelSliderCell.nibName, for: indexPath) as? ImageLabelSliderCell,
                   let viewModel = cellPayload as? ImageLabelSliderViewModel {
                    collectionCell.configureCell(with: viewModel)
                    return collectionCell
                 } else {
                     return nil
                 }
            }
        }
        
        
        configuredDataSource.supplementaryViewProvider = { (collectionView, supplementaryViewKind, indexPath) -> UICollectionReusableView? in
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.nibName, for: indexPath) as? HeaderView
            switch indexPath.section {
            case 0:
                headerView?.configure(title: "Section 1")
            default:
                headerView?.configure(title: "Section 2")
            }
            return headerView
        }
        
        self.dataSource = configuredDataSource
        return configuredDataSource
    }
    
    private func populateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<CompositeViewSection, AnyHashable>()
        snapshot.appendSections(CompositeViewSection.allCases)
        
        CompositeViewSection.allCases.forEach { eachSection in
            switch eachSection {
            case .section1:
                let content = generateContent(contentLength: .extraExtraLong)
                snapshot.appendItems(content, toSection: eachSection)
            case .section2:
                let content = generateContent2(contentLength: .medium)
                snapshot.appendItems(content, toSection: eachSection)
            }
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    private func randomNumber(contentLength: ContentLength) -> UInt {
        let distribution: UInt32
        switch contentLength {
        case .short:
            distribution = 2
        case .medium:
            distribution = 6
        case .long:
            distribution = 12
        case .extraLong:
            distribution = 24
        case .extraExtraLong:
            distribution = 48
        }
        let randomNumber = arc4random_uniform(distribution) + UInt32(1)
        return UInt(randomNumber)
    }
    
    private func generateContent(contentLength: ContentLength) -> [ImageAndLabelViewModel] {
        var content = [ImageAndLabelViewModel]()
        
        for _ in 0..<3 {
            let title = LoremIpsum.words(withNumber: randomNumber(contentLength: contentLength))
            let vm = ImageAndLabelViewModel(title: title,
                                         image: randomImageGenerator.generate(for: CGSize(width: 60, height: 60)))
            content.append(vm)
        }
        
        return content
    }
    
    private func generateContent2(contentLength: ContentLength) -> [ImageLabelSliderViewModel] {
        var content = [ImageLabelSliderViewModel]()
        
        for _ in 0..<18 {
            let title = LoremIpsum.words(withNumber: randomNumber(contentLength: contentLength))
            let vm = ImageLabelSliderViewModel(title: title,
                                         image: randomImageGenerator.generate(for: CGSize(width: 36, height: 36)),
            progressValue: randomSliderValue())
            content.append(vm)
        }
        
        return content
    }
    
    private func randomSliderValue() -> Float {
        let randomNominator: Float = Float(arc4random_uniform(100))
        let denominator = Float(100)
        return randomNominator/denominator
    }
}

private enum ContentLength {
    case short
    case medium
    case long
    case extraLong
    case extraExtraLong
}
