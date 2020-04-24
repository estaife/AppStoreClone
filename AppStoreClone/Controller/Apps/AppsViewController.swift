//
//  AppsViewController.swift
//  AppStoreClone
//
//  Created by Marcos Kilmer on 17/04/20.
//  Copyright © 2020 mkilmer. All rights reserved.
//

import UIKit

class AppsViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    let collectionID = "collectionID"
    let headerID = "headerID"
    var featuredApps:[FeaturedAppsModel] = []
    var appsGroupsArray:[AppsGroup] = []
  
 
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AppHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.register(AppsGroupCell.self,forCellWithReuseIdentifier: collectionID)
        
      
        fetchGroups(type: "top-apps-pagos")
        fetchGroups(type: "apps-que-amamos")
        fetchGroups(type: "top-apps-gratis")
    }
    
}

extension AppsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! AppHeader
      
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return .init(top: 20, left: 0, bottom: 0, right: 0)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.bounds.width, height: view.bounds.width * 0.8)
    }
    
  
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appsGroupsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:collectionID , for: indexPath) as! AppsGroupCell
        cell.appsGroup = self.appsGroupsArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.bounds.width, height: 250)
    }
   
}



extension AppsViewController{
    func fetchGroups(type:String){
        AppsGroupService.shared.fetchGroups(type: type) { (apps, error) in
            if error != nil {
                return
            }
            
            if let apps = apps {
                DispatchQueue.main.async {
                    self.appsGroupsArray.append(apps)
                    self.collectionView.reloadData()
                     print(self.appsGroupsArray.count)
                }
            }
        }
    }
}
