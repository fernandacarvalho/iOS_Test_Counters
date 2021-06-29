//
//  CounterExampleTableViewCell.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 29/06/21.
//

import UIKit

private enum CellReuseIdentifiers: String {
    case labelCell = "labelCell"
}

class CounterExampleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exampleTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureCollectionView()
    }
    
    func configureCollectionView() {
        self.collectionView.register(UINib(nibName: "CounterLabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CellReuseIdentifiers.labelCell.rawValue)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
}

//MARK: - COLLECTION VIEW DELEGATE AND DATA SOURCE
extension CounterExampleTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseIdentifiers.labelCell.rawValue, for: indexPath) as? CounterLabelCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = "Label"
        let font = UIFont.systemFont(ofSize: 14.0)
        let textSize: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let margins : CGFloat = 40
        let size = CGSize(width: textSize.width + margins, height: 50.0)
        return size
    }
}

