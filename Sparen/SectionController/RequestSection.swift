//
//  RequestSection.swift
//  Sparen
//
//  Created by Kerby Jean on 2/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//


import IGListKit
import Cartography
import FirebaseAuth
import SwipeCellKit

class RequestSection: ListSectionController {
    
    private var request: Request?

    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override init() {
        super.init()
        
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: RequestCell.self, for: self, at: index) as? RequestCell else {
            fatalError()
        }

        cell.configure(request!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        request = object as? Request
    }
}


class ActivationSection: ListSectionController {
    
    private var insight: Insight?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    
    override init() {
        super.init()
        
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ActivationCell.self, for: self, at: index) as? ActivationCell else {
            fatalError()
        }
        
        cell.configure(insight!)
        
    
        return cell
    }
    
    override func didUpdate(to object: Any) {
        insight = object as? Insight
    }
}



class ActivationCell: UICollectionViewCell {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UICreator.create.label(nil, 16, .darkText, .natural, .regular, contentView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(label, contentView) { (label, contentView) in
            label.left == contentView.left + 15
            label.right == contentView.right - 15
            label.height == contentView.height
        }
    }
    
    func configure(_ insight: Insight) {
        
        let time = convertDate(postDate: insight.time ?? 0)
        
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedStringKey.foregroundColor : UIColor.darkText]
        
        let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedStringKey.foregroundColor : UIColor.darkText]
        
        let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13, weight: .regular), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string:"🎊🎉 Circle Activated, round 1 ", attributes: attrs)
        
        let attributedString1 = NSMutableAttributedString(string:"has started. ", attributes: attrs1)
        let attributedString2 = NSMutableAttributedString(string: time, attributes: attrs2)
        
        myMutableString.append(attributedString1)
        myMutableString.append(attributedString2)
        
        label.attributedText = myMutableString
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class NewUserSection: ListSectionController {
    
    private var user: User?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    
    override init() {
        super.init()
        
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: NewUserCell.self, for: self, at: index) as? NewUserCell else {
            fatalError()
        }
        
        cell.configure(user!)
        
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
}

class NewUserCell: UICollectionViewCell {
    
    
    var imageView: UIImageView!
    var label: UILabel!
    var timeLabel: UILabel!
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UICreator.create.imageView(nil, contentView)
        label = UICreator.create.label("", 13, .darkText, .left, .regular, contentView)
        label.sizeToFit()
        timeLabel = UICreator.create.label("", 16, .lightGray, .natural, .light, contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(imageView, label, timeLabel, contentView) { (imageView, label, timeLabel, contentView) in
            
            imageView.left == contentView.left + 15
            imageView.centerY == contentView.centerY
            imageView.width == 40
            imageView.height == 40
            
            label.left == imageView.right + 15
            label.centerY == contentView.centerY
            
            timeLabel.left == label.right + 5
        }
        
        dispatch.async {
            self.imageView.cornerRadius = self.imageView.frame.height/2
        }
    }
    
    
    func configure(_ user: User) {
        
        let time = convertDate(postDate: user.joinTime ?? 0)
    
        imageView.sd_setImage(with: URL(string: user.imageUrl ?? ""))
        
        var name = ""
        
        if user.userId == Auth.auth().currentUser!.uid {
             name = "You"
        } else {
             name = user.firstName ?? ""
        }
        
        
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedStringKey.foregroundColor : UIColor.darkText]
        
        let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedStringKey.foregroundColor : UIColor.darkText]
        
          let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13, weight: .regular), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: name ?? "", attributes: attrs)
        
        let attributedString1 = NSMutableAttributedString(string:" joined the Circle ", attributes: attrs1)
        let attributedString2 = NSMutableAttributedString(string: time, attributes: attrs2)
        
        myMutableString.append(attributedString1)
        myMutableString.append(attributedString2)
        
        label.attributedText = myMutableString
    }
}


import UIKit

class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}

enum ActionDescriptor {
    case read, unread, more, flag, trash
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .read: return "Read"
        case .unread: return "Unread"
        case .more: return "More"
        case .flag: return "Flag"
        case .trash: return "Trash"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .read: name = "Read"
        case .unread: name = "Unread"
        case .more: name = "More"
        case .flag: name = "Flag"
        case .trash: name = "Trash"
        }
        
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .read, .unread: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        case .more: return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        case .flag: return #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        case .trash: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    }
}
enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}
