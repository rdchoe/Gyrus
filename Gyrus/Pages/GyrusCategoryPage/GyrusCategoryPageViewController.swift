//
//  GyrusCategoryPage.swift
//  Gyrus
//
//  Created by Robert Choe on 6/25/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class GyrusCategoryPageViewController: UIViewController {
   
    /// categories.json file
    private let categories: JSON = {
        if let path = Bundle.main.url(forResource: "categories", withExtension: ".json") {
            do {
                let pathAsData = try Data(contentsOf: path, options: .dataReadingMapped)
                let json = try JSON(data: pathAsData)
                return json
            } catch {
                fatalError("Could not find categories file")
            }
        }
        return JSON()
    }()
    
    private let relatedDreamsTableView: UITableView = {
        let relatedDreamsTableView = UITableView()
        relatedDreamsTableView.translatesAutoresizingMaskIntoConstraints = false
        relatedDreamsTableView.backgroundColor = UIColor.clear
        return relatedDreamsTableView
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: StretchyHeaderLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var relatedDreams: [Dream] = []
    
    fileprivate var kHeaderReferenceSize: CGFloat = 200
    
    fileprivate var relatedDreamsTableViewTopAnchor: NSLayoutConstraint!
    fileprivate let padding: CGFloat = 16
    fileprivate var categoryJSON: JSON!
    fileprivate var documentation: Array<JSON>?
    fileprivate var inBottomHalf: Bool = false
    fileprivate var category: Category!
    
    init(category: Category) {
        super.init(nibName: nil, bundle: nil)
        if let relatedDreams = category.relatedDreams {
            print(relatedDreams.count)
            self.relatedDreams = Array(relatedDreams) as! [Dream]
        }
        self.category = category
        self.categoryJSON = categories[category.name!]
        
        self.documentation = self.categoryJSON["documentation"].arrayValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            gyrusTabBarController.showTabBar()
        }
        if self.inBottomHalf {
            self.navigationController?.navigationBar.alpha = 1.0
            self.navigationController?.navigationBar.makeTransparent()
        }
    }
    
    private func setupViewController() {
        self.view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        setupCollectionView()
        customizeLayout()
        setupNavBar()
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            gyrusTabBarController.hideTabBar()
        }
        
        layoutConstraints()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        //collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(DocumentationCell.self, forCellWithReuseIdentifier: "documentationCell")
        collectionView.register(DreamCollectionViewCell.self, forCellWithReuseIdentifier: DreamCollectionViewCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(DreamsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DreamsHeaderView.identifier)
        view.addSubview(collectionView)
    }
    
    private func customizeLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    fileprivate func setupNavBar() {
        self.title = ""
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    fileprivate func layoutConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: Collection View Delegate
extension GyrusCategoryPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 :
            if let documentation = self.documentation {
                return documentation.count
            } else {
                return 0
            }
        case 1:
            print("what")
            return self.relatedDreams.count
        default:
            fatalError("Should only be two sections")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let documentation = self.documentation else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "documentationCell", for: indexPath) as! DocumentationCell
            cell.label.text = documentation[indexPath.row].string
            if indexPath.row == 0 { // we are on the first header
                cell.label.font = UIFont(name: Constants.font.futura, size: Constants.font.h3)
            } else if indexPath.row % 2 == 0 { // we are on a subheader
                cell.label.font = UIFont(name: Constants.font.futura, size: Constants.font.h6)
            } else { // on a paragraph
                cell.label.font = UIFont(name: Constants.font.futura_light, size: Constants.font.body)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DreamCollectionViewCell.identifier, for: indexPath) as! DreamCollectionViewCell
            cell.dream = self.relatedDreams[indexPath.row]
            
            return cell
        default:
            fatalError("should only be two sections")
        }
    }
}

// MARK: Collection View Flow Delegate
extension GyrusCategoryPageViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            guard let documentation = self.documentation  else { return CGSize.zero }
            let text = documentation[indexPath.row].string!
            var font: UIFont!
            if indexPath.row == 0 { // we are on the first header
                font = UIFont(name: Constants.font.futura, size: Constants.font.h3)
            } else if indexPath.row % 2 == 0 { // we are on a subheader
                font = UIFont(name: Constants.font.futura, size: Constants.font.h6)
            } else { // on a paragraph
                font = UIFont(name: Constants.font.futura_light, size: Constants.font.body)
            }
            
            let size = CGSize(width: view.frame.width - 2 * padding, height: 1000)
            let attributes = [NSAttributedString.Key.font: font]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            return CGSize(width: view.frame.width - 2 * padding, height: estimatedFrame.height + 8)
        case 1:
            return CGSize(width: view.frame.width - 2 * padding, height: 70)
        default:
            fatalError("Should only have two sections")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0 :
            return .init(width: view.frame.width, height: kHeaderReferenceSize)
        default:
            return .init(width: view.frame.width, height: 66)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch indexPath.section {
        case 0:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderView
            if let asset_name = categoryJSON["asset"].string {
                header.imageView.image = UIImage(named: asset_name)
            } else { // asset does not exist
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: kHeaderReferenceSize))
                label.numberOfLines = 0
                label.textAlignment = .center
                label.backgroundColor = .clear
                label.font = UIFont(name: Constants.font.futura, size: 100)
                label.text = self.category.emoji
                //label.sizeToFit()
                header.imageView.image = UIImage.imageWithLabel(label: label)

            }
            return header
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DreamsHeaderView.identifier, for: indexPath) as! DreamsHeaderView
            if self.relatedDreams.count > 1 {
                header.dreamCountLabel.text = "\(self.relatedDreams.count) Dreams"
            } else {
                header.dreamCountLabel.text = "\(self.relatedDreams.count) Dream"
            }
            return header
        default:
            fatalError("Should only be two sections")
        }
    }
}

// MARK: Scroll View Delegate
extension GyrusCategoryPageViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Handle table view top anchor constant
        if collectionView.contentOffset.y >= kHeaderReferenceSize {
            if !self.inBottomHalf { // first time coming from top half
                self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationController?.navigationBar.shadowImage = nil
                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09719891101, green: 0.1209237799, blue: 0.1548948586, alpha: 1)
                self.navigationController?.navigationBar.isTranslucent = false
                self.navigationController?.navigationBar.alpha = 0.0
                self.title = self.documentation?[0].string
                UIView.animate(withDuration: 0.25, animations: {
                    self.navigationController?.navigationBar.alpha = 1.0
                })
                self.inBottomHalf = true
            }
        } else {
            if self.inBottomHalf {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.navigationController?.navigationBar.alpha = 0.0
                }, completion: { _ in
                    self.navigationController?.navigationBar.alpha = 1.0
                    self.navigationController?.navigationBar.makeTransparent()
                    self.title = ""
                })
            }
            self.inBottomHalf = false
        }
    }
}
