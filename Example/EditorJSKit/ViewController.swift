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
    private lazy var adapter = EJCollectionViewAdapter(collectionView: collectionView)
    
    //
    private var blockList: EJBlocksList!

    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.dataSource = self
        setupViews()
        prepareBlocks()
    }
    
    
    private func setupViews() {
        view.backgroundColor = .white
        
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
    
    private func prepareBlocks() {
        guard let path = Bundle.main.path(forResource: "EditorJSMock", ofType: "json") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return }
        blockList = try! JSONDecoder().decode(EJBlocksList.self, from: data)
        collectionView.reloadData()
    }

}

///
extension ViewController: EJCollectionDataSource {
    var data: EJBlocksList? { blockList }
}
