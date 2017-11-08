//
//  ProfileCell.swift
//  Circle
//
//  Created by Kerby Jean on 11/7/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

final class ProfileCell: UICollectionViewCell {
    
    var user: User?
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let button: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = true
        view.setTitle("Edit Profile", for: .normal)
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        contentView.addSubview(imageView)
        contentView.addSubview(button)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfile)))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @objc func editProfile() {
        print("EDIT")
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditAccountVC") as! EditAccountVC
        vc.user = user
        self.viewController?.present(vc, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 150, y: 50, width: 60, height: 60)
        imageView.layer.cornerRadius = self.imageView.frame.height/2
        imageView.backgroundColor = UIColor.red
        button.frame = CGRect(x: 150, y: 100 + 50, width: 80, height: 20)
        button.cornerRadius = 5
    }
    
    func setImage(url: String?) {
        guard let url = url  else {
            return
        }
        imageView.sd_setImage(with: URL(string: url))
    }
}
