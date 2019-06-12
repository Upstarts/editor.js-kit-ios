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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupViews()
        performNetworkTask()
    }
    
    
    private func setupViews() {
        collectionView.backgroundColor = .white
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
        guard let url = Bundle.main.url(forResource: "EditorJSMock", withExtension: "json") else { return }
        guard let dataD = try? Data(contentsOf: url) else { return }
        let object = try! JSONSerialization.jsonObject(with: dataD, options: [])
        let data = try! JSONSerialization.data(withJSONObject: object, options: [])
        let editorJSResponse = try! JSONDecoder().decode(EditorJSResponse.self, from: data)
        print("success")
    }

}

