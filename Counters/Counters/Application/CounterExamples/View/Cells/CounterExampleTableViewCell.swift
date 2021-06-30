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
    private var example: CounterExample?
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        exampleTitle.text = ""
    }
    
    private func configureCollectionView() {
        self.collectionView.register(UINib(nibName: "CounterLabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CellReuseIdentifiers.labelCell.rawValue)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func configureCellWith(example: CounterExample) {
        exampleTitle.text = example.type.uppercased()
        self.example = example
    }
}

//MARK: - COLLECTION VIEW DELEGATE AND DATA SOURCE
extension CounterExampleTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let list = example?.list else { return 0 }
        return list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseIdentifiers.labelCell.rawValue, for: indexPath) as? CounterLabelCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let list = example?.list, list.count > 0 {
            cell.setLabel(withText: list[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let list = example?.list, list.count > 0 else {
            return CGSize(width: 0, height: 0)
        }
        let text = list[indexPath.item]
        let font = UIFont.systemFont(ofSize: 14.0)
        let textSize: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let margins : CGFloat = 40
        let size = CGSize(width: textSize.width + margins, height: 50.0)
        return size
    }
}

