//
//  ViewController.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-27.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class ViewController: CameraViewController {
    
    // MARK: - Outlets
    var ingredientsCollectionView: UICollectionView!
    var finishButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        // Finish button
        finishButton = UIButton(frame: .zero)
        
        finishButton.backgroundColor = UIColor.Theme.eucalpytus
        finishButton.titleLabel?.textColor = .white
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        finishButton.setTitle("Continue", for: .normal)
        finishButton.layer.cornerRadius = 8
        finishButton.disable()
        
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(finishButton)
        
        finishButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        finishButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        finishButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        finishButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Ingredients Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        ingredientsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ingredientsCollectionView.backgroundColor = .clear
        
//        ingredientsCollectionView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellWithReuseIdentifier: "messageCell")
        
        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.delegate = self
        
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ingredientsCollectionView)
        
        // Constraints for Ingredients Collection View
        ingredientsCollectionView.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -20).isActive = true
        ingredientsCollectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        ingredientsCollectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        ingredientsCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        ingredientsCollectionView.layer.borderWidth = 1.0
        ingredientsCollectionView.layer.borderColor = UIColor.red.cgColor
        
        // TODO: - Top Collection View and Basket Icon

    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
