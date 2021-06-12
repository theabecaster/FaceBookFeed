//
//  ViewController.swift
//  FacebookFeed
//
//  Created by Abraham Gonzalez on 11/16/18.
//  Copyright © 2018 Abraham Gonzalez. All rights reserved.
//

import UIKit

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts: [Post] = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // changeDefaultUrlCacheSize()
        
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.alwaysBounceVertical = true
        navigationItem.title = "Facebook Feed"
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "FeedCellId")
        
        let postMark = Post()
        postMark.name = "Mark Zuckerberg"
        postMark.statusText = "Meanwhile, the beast turned to the dark side"
        postMark.imageName = "zuckprofile"
        postMark.statusImageName = "zuckdog"
        postMark.statusImageURL = "https://wallpapercave.com/wp/wp2126146.jpg"
        postMark.numLikes = "488"
        postMark.numComments = "10.7K"
        
        let postJobs = Post()
        postJobs.name = "Steve Jobs"
        postJobs.imageName = "steve_profile"
        postJobs.statusImageName = "steve_status"
        postJobs.statusImageURL = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Steve_Jobs_Headshot_2010-CROP2.jpg/1200px-Steve_Jobs_Headshot_2010-CROP2.jpg"
        postJobs.statusText = "My favorite things in life don’t cost any money. It’s really clear that the most precious resource we all have is time.\n Your work is going to fill a large part of your life, and the only way to be truly satisfied is to do what you believe is great work. And the only way to do great work is to love what you do. If you haven’t found it yet, keep looking. Don’t settle. As with all matters of the heart, you’ll know when you find it."
        postJobs.numLikes = "5K"
        postJobs.numComments = "1.2K"
        
        
        let postGandhi = Post()
        postGandhi.name = "Mahatma Gandhi"
        postGandhi.imageName = "gandhi"
        postGandhi.statusText = "Where there is love there is life.\n Happiness is when what you think, what you say, and what you do are in harmony. \n The weak can never forgive. Forgiveness is the attribute of the strong. \n Strength does not come from physical capacity. It comes from an indomitable will. \n In a gentle way, you can shake the world."
        postGandhi.statusImageName = "gandhi_status"
        postGandhi.statusImageURL = "https://wallpapertag.com/wallpaper/full/1/7/b/832270-mahatma-gandhi-wallpapers-1920x1080-for-ios.jpg"
        postGandhi.numLikes = "1K"
        postGandhi.numComments = "457"
        
        posts = [postMark, postJobs, postGandhi]
    }
    
    /*  If the app receives memory too large warning,
        we flush the image cache
     */
    override func didReceiveMemoryWarning() {
        FeedCell.imageCache = [String: UIImage]()
    }
    
    // change the default URL cache size
    func changeDefaultUrlCacheSize(){
        let capacity = 500 * 1024 * 1024            // 500 MB
        let cache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: nil)
        URLCache.shared = cache
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCellId", for: indexPath) as! FeedCell
        cell.post = posts[indexPath.item]
        cell.cellViewController = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let height = posts[indexPath.item].statusText?.height(withConstrainedWidth: view.frame.width, font: UIFont.systemFont(ofSize: 14)){
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 0.5 + 40
            return CGSize(width: view.frame.width, height: height + knownHeight + 16)
        }
        
        return CGSize(width: view.frame.width, height: 400)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.invalidateLayout()
    }
    
    let blackBackground = UIView()
    let navBarCover = UIView()
    let tabBarCover = UIView()
    var imageView = UIImageView()
    var startFrame: CGRect!
    
    func animate(statusImageView: UIImageView){
        startFrame = statusImageView.superview?.convert(statusImageView.frame, to: self.view)
        
        imageView.image = statusImageView.image
        imageView.frame = startFrame
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        blackBackground.backgroundColor = .black
        blackBackground.frame = view.frame
        blackBackground.alpha = 0
        
        navBarCover.backgroundColor = .black
        navBarCover.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20 + 44)
        navBarCover.alpha = 0
        
        tabBarCover.backgroundColor = .black
        tabBarCover.frame = CGRect(x: 0, y: view.frame.height - 49, width: view.frame.width, height: 49)
        tabBarCover.alpha = 0
        
        view.addSubview(blackBackground)
        view.addSubview(imageView)
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(navBarCover)
        window?.addSubview(tabBarCover)
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissZoom)))
        blackBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissZoom)))
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseOut, animations: {
            let y = self.view.frame.height / 2 - self.imageView.frame.height / 2
            self.imageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.imageView.frame.height)
            self.blackBackground.alpha = 1
            self.navBarCover.alpha = 1
            self.tabBarCover.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc func dismissZoom(){
        UIView.animate(withDuration: 0.4, animations: {
            self.imageView.frame = self.startFrame
            self.blackBackground.alpha = 0
            self.navBarCover.alpha = 0
            self.tabBarCover.alpha = 0
        }) { (_) in
            self.blackBackground.removeFromSuperview()
            self.imageView.removeFromSuperview()
            self.navBarCover.removeFromSuperview()
            self.tabBarCover.removeFromSuperview()
        }
    }
    
}

extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


/*  Extending String object to include height function
 */

extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
}

extension UIView{
    
    func fillSuperView(){
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView){
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize? = nil){
        
        translatesAutoresizingMaskIntoConstraints = false                                               // Activate auto layout
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true         // bottom and trailing constants must be negative
        }
        
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true      // bottom and trailing constants must be negative
        }
        
        if let size = size{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
}
