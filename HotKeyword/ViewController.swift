//
//  ViewController.swift
//  HotKeyword
//
//  Created by Nhan NLT on 3/29/19.
//  Copyright © 2019 Nhan NLT. All rights reserved.
//

import UIKit
import CoreImage
class ViewController: UIViewController {
    let jsonURL = "https://tiki-mobile.s3-ap-southeast-1.amazonaws.com/ios/keywords.json"

    let pendingOperations = PendingOperations()
    let bgTextColor = [hexStringToUIColor(hex: "#16702e"),
                       hexStringToUIColor(hex: "#005a51"),
                       hexStringToUIColor(hex: "#996c00"),
                       hexStringToUIColor(hex: "#5c0a6b"),
                       hexStringToUIColor(hex: "#006d90"),
                       hexStringToUIColor(hex: "#974e06"),
                       hexStringToUIColor(hex: "#99272e"),
                       hexStringToUIColor(hex: "#89221f"),
                       hexStringToUIColor(hex: "#00345d")
    ]
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var items: Array<KeywordItem> = {
        let items : Array<KeywordItem> = Array()
        return items
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        NetworkManager.sharedInstance.getListKeyword(kw: jsonURL, onSuccess: { (keyword) in
            
            for model in keyword.keywords {
                let item : KeywordItem = KeywordItem(keywordModel: model)
                item.calculateItem()
                self.items.append(item)
            }
            var collectionH: Double = 0
            for item in self.items {
                if (Double(item.itemSize?.height ?? 0) > collectionH) {
                    collectionH = Double(item.itemSize?.height ?? 0)
                }
            }
            
            self.collectionView.frame = CGRect(x: 0, y: 100, width: Double(self.view.bounds.width), height: collectionH)
            
            self.collectionView.reloadData()
        }) { (error) in
            
        }
    }

    func initUI() {
        self.collectionView.register(KeywordCell.self, forCellWithReuseIdentifier: "KeywordCell")
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: CGFloat(Constants.kCellSpacing), bottom: 0, right: CGFloat(Constants.kCellSpacing))
        
    }
    
 
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < self.items.count {
            let item = self.items[indexPath.row]
            return item.itemSize ?? CGSize.zero
        }
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: KeywordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCell", for: indexPath) as! KeywordCell
        if indexPath.row < self.items.count {
            let item = self.items[indexPath.row]
            let indexColor = indexPath.row % self.bgTextColor.count
            cell.keywordLabel.backgroundColor = self.bgTextColor[indexColor]
            cell.setObject(obj: item)
            
            switch (item.state) {
            case .new, .downloaded:
                if !collectionView.isDragging && !collectionView.isDecelerating {
                    startOperations(for: item, at: indexPath)
                }
            case .failed: break
                
            }
        }
        return cell;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // MARK: - scrollview delegate methods

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //1
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 3
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    // MARK: - operation management
    
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells() {
        //1
        let pathsArray: [IndexPath] = self.collectionView.indexPathsForVisibleItems
            //2
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            //3
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            //4
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            // 5
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            }
            
            // 6
            for indexPath in toBeStarted {
                let recordToProcess = self.items[indexPath.row]
                startOperations(for: recordToProcess, at: indexPath)
            }
    }
    
    func startOperations(for item: KeywordItem, at indexPath: IndexPath) {
        switch (item.state) {
        case .new:
            startDownload(for: item, at: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    func startDownload(for item: KeywordItem, at indexPath: IndexPath) {
        //1
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        //2
        let downloader = ImageDownloader(item)
        //3
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        //4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

