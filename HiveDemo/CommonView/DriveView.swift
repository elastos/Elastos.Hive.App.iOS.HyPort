//
//  DriveView.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class DriveView: UIView {

    var containerView: UIView!
    var nameLable: UILabel!
    var button: UIButton!


    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatUI() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        containerView = UIView()
        self.addSubview(self.containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.width.height.equalToSuperview()
        }

        nameLable = UILabel()
        nameLable.textAlignment = NSTextAlignment.center
        addSubview(self.nameLable)
        nameLable.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(44)
            make.center.equalToSuperview()
        }

        button = UIButton()
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
    }



}

