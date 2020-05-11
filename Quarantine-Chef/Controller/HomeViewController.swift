//
//  HomeViewController.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-30.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var startScanningButton: UIButton!
    @IBOutlet weak var addIngredientsManuallyButton: UIButton!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // Onboarding collection view content
    let images: [String] = ["bored", "search", "cook", "eat"]
    let titles: [String] = ["You're Bored.", "Find Recipes.", "Cook.", "Enjoy."]
    let descriptions: [String] = ["Are you bored during quarantine? Are all your friends baking bread? Well, why not pass the time while learning how to cook!", "Using this app, use the limited ingredients you have (you don't want to go and buy stuff right now, do you?) and find out what you can make with it!", "Get in the kitchen! Follow the recipes and make something amazing.", "Eat your creation. If you didn't undercook, overcook, or drop the food, it should be great! If it was a fail, tweet about it and you'll go trending. Win win!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }

    // MARK: - Setup Views
    /// Setups constraints and relavent design aspects
    func setupViews() {
        startScanningButton.layer.cornerRadius = 8
        
        addIngredientsManuallyButton.layer.cornerRadius = 8
        addIngredientsManuallyButton.layer.borderWidth = 2.0
        addIngredientsManuallyButton.layer.borderColor = UIColor.black.cgColor
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero

        onboardingCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        onboardingCollectionView.collectionViewLayout = flowLayout
        
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
    }
    
    // MARK: - Start Button
    /// Takes user to scanning view
    /// - Parameter sender: source that invoked the action (e.g. button)
    @IBAction func startScanningButtonWasPressed(_ sender: Any) {
        #if targetEnvironment(simulator)
            let errorAlert = UIAlertController(title: "App must be used on a real device", message: "Since this app makes use of the built-in camera on an iPhone, it must be run on a real device and not in the simulator.\n\nAlso, in the case that this is a Shopify engineer using this, 👋.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            errorAlert.addAction(dismissAction)
            present(errorAlert, animated: true, completion: nil)
        #else
            self.performSegue(withIdentifier: "goToScanView", sender: self)
        #endif
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cells for onboarding on the main view
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        
        cell.onboardingImageView.image = UIImage(named: images[indexPath.row])
        cell.titleLabel.text = titles[indexPath.row]
        cell.descriptionTextView.text = descriptions[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

