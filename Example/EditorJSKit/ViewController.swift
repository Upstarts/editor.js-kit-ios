//
//  ViewController.swift
//  EditorJSKit
//
//  Created by Ivan Glushko on 06/12/2019.
//  Copyright (c) 2019 Ivan Glushko. All rights reserved.
//

import UIKit
import EditorJSKit

class ViewController: UIViewController {
    
    // MARK: - UI Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var renderer = EJCollectionRenderer(collectionView: collectionView)
    
    //
    private var blockList: EJBlocksList!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        performNetworkTask()
    }
    
    
    private func setupViews() {
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private func performNetworkTask() {
        guard let path = Bundle.main.path(forResource: "EditorJSMock", ofType: "json") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return }
        blockList = try! JSONDecoder().decode(EJBlocksList.self, from: data)

        collectionView.reloadData()
    }

}

///
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return blockList.blocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockList.blocks[section].data.numberOfItems
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        do {
            return try renderer.render(block: blockList.blocks[indexPath.section], itemIndexPath: indexPath)
        }
        catch {
            return UICollectionViewCell()
        }
    }
}

///
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        do {
            return try renderer.size(forBlock: blockList.blocks[indexPath.section], itemIndex: indexPath.item, style: nil, superviewSize: collectionView.frame.size)
        } catch {
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return renderer.spacing(forBlock: blockList.blocks[section])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return renderer.insets(forBlock: blockList.blocks[section])
    }
}
