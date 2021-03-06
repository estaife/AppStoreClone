//
//  TodayModal.swift
//  AppStoreClone
//
//  Created by Marcos Kilmer on 30/04/20.
//  Copyright © 2020 mkilmer. All rights reserved.
//

import UIKit

class TodayModal: UIViewController {
    
    var todayApp:TodayApp?{
        didSet{
            if let todayApp = todayApp {
                if todayApp.apps == nil {
                    self.buildAppTodayDetail()
                }else {
                    self.addTodayTable()
                }
                
                
            }
        }
    }
    let todayMultipleTable = TodayMultipleViewController()
    let todayDetail = TodayDetail()
    let closeButton:UIButton = .setupCloseButton()
    var callback:(() -> ())?
    var uiview:UIView?
    var frame:CGRect?
    var topAnchor:NSLayoutConstraint?
    var leadingAnchor:NSLayoutConstraint?
    var heightAnchor:NSLayoutConstraint?
    var widthAnchor:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        self.uiview = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func animation(){
        guard let uiview = self.uiview else{return}
        guard let frame = self.frame else{return}
        
        uiview.layer.cornerRadius = 16
        uiview.clipsToBounds = true
        
        view.addSubview(uiview)
        self.addCloseButton()
        
        insertAutoLayoutProperties(uiview, frame)
        uiViewAnimate()
        
    }
    
    
    func insertAutoLayoutProperties(_ uiview:UIView, _ frame:CGRect){
        uiview.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor = uiview.topAnchor.constraint(equalTo: view.topAnchor, constant: frame.origin.y)
        self.leadingAnchor  = uiview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: frame.origin.x)
        self.heightAnchor = uiview.heightAnchor.constraint(equalToConstant: frame.height)
        self.widthAnchor = uiview.widthAnchor.constraint(equalToConstant: frame.width)
        
        self.topAnchor?.isActive = true
        self.leadingAnchor?.isActive = true
        self.heightAnchor?.isActive = true
        self.widthAnchor?.isActive = true
        
        view.layoutIfNeeded()
        
        
    }
    
    func uiViewAnimate(){
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .overrideInheritedCurve, animations: {
            self.topAnchor?.constant = 0
            self.leadingAnchor?.constant = 0
            self.heightAnchor?.constant = self.view.frame.height
            self.widthAnchor?.constant = self.view.frame.width
            self.uiview?.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func buildAppTodayDetail(){
        
        todayDetail.todayApp = self.todayApp
       
        self.uiview = todayDetail.view
        self.animation()
    }
    
    func addTodayTable(){
        todayMultipleTable.todayApp = self.todayApp
        todayMultipleTable.handleClick = { app in
            let detail = AppsDetail()
            detail.title = app.nome
            detail.appID = app.id
            detail.app = app
            self.navigationController?.pushViewController(detail, animated: true)
        }
        self.uiview = todayMultipleTable.view
        self.animation()
    }
    
    func addCloseButton(){
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        closeButton.alpha = 0
        closeButton.setAutoLayoutProperties(top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, bottom: nil, leading: nil, padding: .init(top: 18, left: 0, bottom: 0, right: 24), size: .init(width: 32, height: 32))
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .showHideTransitionViews, animations: {
            self.closeButton.alpha = 1
        }, completion: nil)
    }
    
    @objc func handleCloseButton(){
        self.callback?()
        self.closeAnimation()
    }
    
    func closeAnimation(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .showHideTransitionViews, animations: {
            
            if let frame = self.frame{
                self.topAnchor?.constant = frame.origin.y
                self.leadingAnchor?.constant = frame.origin.x
                self.heightAnchor?.constant = frame.size.height
                self.widthAnchor?.constant = frame.size.width
                
                self.view.layoutIfNeeded()
                
            }
            
        }) { (true) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}
