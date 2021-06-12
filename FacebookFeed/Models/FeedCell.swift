//
//  FeedCell.swift
//  FacebookFeed
//
//  Created by Abraham Gonzalez on 11/16/18.
//  Copyright © 2018 Abraham Gonzalez. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell{
    
    var cellViewController: FeedController!
    
    static var imageCache = [String: UIImage]()
    var builtInImageCache = NSCache<AnyObject, AnyObject>()
    
    var post: Post?{
        didSet{
            if let name = post?.name{
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
                attributedText.append(NSAttributedString(string: "\nDecember 18 \u{2022} San Francisco \u{2022} ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.count))
                
                // Include images in your text
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_small")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributedText.append(NSAttributedString(attachment: attachment))
                
                nameLabel.attributedText = attributedText
            }
            if let statusText = post?.statusText{
                statusTextView.text = statusText
            }
            
            if let imageName = post?.imageName{
                profileImageView.image = UIImage(named: imageName)
            }
            
            if let statusImageURL = post?.statusImageURL{
                
                /*  naive dictionary for building a cache
                 */
                
                //                if let image = FeedCell.imageCache[statusImageURL]{
                //                    statusImageView.image = image
                //                }
                
                /*  if image has been previously cached then fetch it from the cache
                    else, download it off the internet
//                 */
                if let image = builtInImageCache.object(forKey: statusImageURL as AnyObject) as? UIImage{
                    statusImageView.image = image
                }
                else{
                    downloadImage(url: URL(string: statusImageURL))
                }
            }
            
            if let numLikes = post?.numLikes{
                likesCommentslabel.text = "\(numLikes) Likes  "
            }
            
            if let numComments = post?.numComments{
                likesCommentslabel.text?.append("\(numComments) Comments")
            }
        }
    }
    
    private func downloadImage(url: URL?){
        guard let url = url else {return}
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                (error)
                return
            }
            
            if let data = data{
                if let image = UIImage(data: data){
                DispatchQueue.main.async(execute: {
                    self.statusImageView.image = image
                    self.activityIndicator.stopAnimating()
                    self.builtInImageCache.setObject(image, forKey: url.absoluteString as AnyObject)   // caching the image in built-in NSCache
                    FeedCell.imageCache[url.absoluteString] = image                                     // caching the image in imageCache
                   // print(url.absoluteString)
                })
                }
            }
            }.resume()
        
    }
    
    @objc private func likeButtonHit(){
        let likedImage = UIImage(named: "blue_like_1x")
        let dislikedImage = UIImage(named: "like")
        
        if likeButton.image(for: .normal) == dislikedImage{
            likeButton.setImage(likedImage, for: .normal)
        }
        else{
            likeButton.setImage(dislikedImage, for: .normal)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        backgroundColor = .white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentslabel)
        addSubview(dividerLineView)
        addSubview(buttonStackView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        statusImageView.addSubview(activityIndicator)
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        statusImageView.isUserInteractionEnabled = true
        
        likeButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressedGesture)))
        likeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeButtonHit)))
        
        let containers = [UIColor.yellow, .blue, .green].map { (color) -> UIView in
            let view = UIView()
            buttonStackView.addArrangedSubview(view)
            return view
        }
        
        let padding = ((frame.width) / 3 - 65) / 2
        let buttonsArray = [likeButton, commentButton, shareButton]
        
        for (index, button) in buttonsArray.enumerated(){
            var actualPadding = padding
            if button == commentButton{
                actualPadding = padding - CGFloat(15)
            }
            
            button.anchor(top: containers[index].topAnchor, leading: containers[index].leadingAnchor, bottom: containers[index].bottomAnchor, trailing: containers[index].trailingAnchor, padding: UIEdgeInsets(top: 8, left: actualPadding, bottom: 8, right: actualPadding))
        }
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.5)][v5(40)]|", views: profileImageView, statusTextView, statusImageView, likesCommentslabel, dividerLineView, buttonStackView)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        addConstraintsWithFormat(format: "H:|-12-[v0]", views: likesCommentslabel)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: buttonStackView)
 
        activityIndicator.anchor(top: statusImageView.topAnchor, leading: statusImageView.leadingAnchor, bottom: statusImageView.bottomAnchor, trailing: statusImageView.trailingAnchor, padding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let likesCommentslabel: UILabel = {
        let label = UILabel()
        label.text = "488 Likes  10.7K Comments"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Meanwhile, the beast turned into the dark side"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let image = UIImage(named: "zuckdog")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckprofile")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    
    let likeButton = FeedCell.buttonForTitle(title: "Like", imageName: "like")
    let commentButton = FeedCell.buttonForTitle(title: "Comment", imageName: "comment")
    let shareButton = FeedCell.buttonForTitle(title: "Share", imageName: "share")
    
    let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    let emojisContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        
        let iconHeight: CGFloat = 38
        let padding: CGFloat = 8
        let numberOfIcons: CGFloat = 6
        
        container.frame = CGRect(x: 0, y: 0, width: numberOfIcons * iconHeight + padding * (numberOfIcons + 1), height: iconHeight + padding * 2)
        container.layer.cornerRadius = container.frame.height / 2
        
        // Introducing shadow
        container.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        container.layer.shadowRadius = 8
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        let imageNames = ["blue_like", "cry_laugh", "cry", "red_heart", "surprised", "angry"]
        
        let arrangedViews = imageNames.map({ (imageName) -> UIImageView in
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        let iconsStackView: UIStackView = {
            
            let stack = UIStackView(arrangedSubviews: arrangedViews)
            stack.distribution = .fillEqually
            
            stack.spacing = padding
            stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            stack.isLayoutMarginsRelativeArrangement = true
            return stack
        }()
        
        container.addSubview(iconsStackView)
        iconsStackView.frame = container.frame
        return container
    }()
    
    @objc func animate(){
        cellViewController.animate(statusImageView: statusImageView)
    }
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton{
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.customDarkGray, for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        return button
    }
    
    @objc func handleLongPressedGesture(gesture: UILongPressGestureRecognizer){
        let pressedLocation = gesture.location(in: self)
        if gesture.state == .began{
            
            addSubview(emojisContainerView)
            emojisContainerView.alpha = 0
            emojisContainerView.transform = CGAffineTransform(translationX: likeButton.frame.minX, y: likeButton.frame.minY)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.emojisContainerView.alpha = 1
                self.emojisContainerView.transform = self.emojisContainerView.transform.translatedBy(x: 0, y: -self.emojisContainerView.frame.height)
            })
        }
        else if gesture.state == .ended{
            UIView.animate(withDuration: 0.2, animations: {
                let emojisStack = self.emojisContainerView.subviews.first
                emojisStack?.subviews.forEach({ (emoji) in
                    emoji.transform = .identity
                })
                self.emojisContainerView.alpha = 0
                self.emojisContainerView.transform = self.emojisContainerView.transform.translatedBy(x: 0, y: self.emojisContainerView.frame.height)
            }) { (_) in
                self.emojisContainerView.removeFromSuperview()
            }
        }
        else if gesture.state == .changed{
            let pressedLocation = gesture.location(in: emojisContainerView)
            let hitTestView = emojisContainerView.hitTest(pressedLocation, with: nil)
            
            if hitTestView is UIImageView{
                UIView.animate(withDuration: 0.3) {
                    
                    let emojisStack = self.emojisContainerView.subviews.first
                    emojisStack?.subviews.forEach({ (emoji) in
                        emoji.transform = .identity
                    })
                    
                    hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor{
    static let customDarkGray = UIColor(red: 143/255, green: 150/255, blue: 163/255, alpha: 1)
}
