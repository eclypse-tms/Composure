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

class SimpleViewController: UIViewController {
    @IBOutlet private weak var mainCollectionView: UICollectionView!

    private var randomImageGenerator: RandomImageGenerator!
    private var layoutOption: CompositionalLayoutOption!
    private var dataSource: UICollectionViewDiffableDataSource<SimpleViewSection, ImageAndLabelViewModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        randomImageGenerator = RandomImageGeneratorImpl()
        
        mainCollectionView.register(ImageAndLabelCell.nib, forCellWithReuseIdentifier: ImageAndLabelCell.nibName)
        mainCollectionView.dataSource = configureDataSource()
        
        mainCollectionView.collectionViewLayout = generateCompositionalLayout(with: SimpleViewSection.allCases)
        
        mainCollectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 150, right: 0)
                
        populateCollectionView()
        
        title = layoutOption.title
    }
    
    func register(layoutOption: CompositionalLayoutOption) {
        self.layoutOption = layoutOption
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<SimpleViewSection, ImageAndLabelViewModel> {
        let configuredDataSource = UICollectionViewDiffableDataSource<SimpleViewSection, ImageAndLabelViewModel>(collectionView: mainCollectionView) { (collectionView, indexPath, payload) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageAndLabelCell.nibName, for: indexPath) as? ImageAndLabelCell else { return nil }
            cell.configureCell(with: payload)
            return cell
        }
        self.dataSource = configuredDataSource
        return configuredDataSource
    }
    
    private func populateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<SimpleViewSection, ImageAndLabelViewModel>()
        snapshot.appendSections(SimpleViewSection.allCases)
        switch layoutOption! {
        case .dynamicWidthFixedHeight(estimatedWidth: _, fixedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .short), toSection: .section0)
        case .dynamicWidthDynamicHeight(estimatedWidth: _, estimatedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .extraLong), toSection: .section1)
        case .fixedWidthFixedHeight(fixedWidth: _, fixedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .medium), toSection: .section2)
        case .fixedWidthDynamicHeight(fixedWidth: _, estimatedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .medium), toSection: .section3)
        case .fractionalWidthFixedHeight(widthFraction: _, fixedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .extraLong), toSection: .section4)
        case .fractionalWidthDynamicHeight(widthFraction: _, estimatedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .medium), toSection: .section5)
        case .fullWidthFixedHeight(fixedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .long), toSection: .section6)
        case .fullWidthDynamicHeight(estimatedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .extraExtraLong), toSection: .section7)
        case .centeredFixedHeight(maxWidth: _, fixedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .medium), toSection: .section8)
        case .centeredDynamicHeight(maxWidth: _, estimatedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .long), toSection: .section9)
        case .minWidthFixedHeight(minWidth: _, fixedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .long), toSection: .section10)
        case .minWidthDynamicHeight(minWidth: _, estimatedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .long), toSection: .section11)
        case .multipleCenteredFixedHeight(numberOfCells: _, totalMaxWidthOfAllCells: _, fixedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .extraExtraLong), toSection: .section12)
        case .multipleCenteredDynamicHeight(numberOfCells: _, totalMaxWidthOfAllCells: _, estimatedHeight: _):
            snapshot.appendItems(generateContent(contentLength: .extraExtraLong), toSection: .section13)
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
        
        for _ in 0..<24 {
            let title = LoremIpsum.words(withNumber: randomNumber(contentLength: contentLength))
            let vm = ImageAndLabelViewModel(title: title,
                                         image: randomImageGenerator.generate(for: CGSize(width: 36, height: 36)))
            content.append(vm)
        }
        
        return content
    }
}

private enum ContentLength {
    case short
    case medium
    case long
    case extraLong
    case extraExtraLong
}
