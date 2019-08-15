//
//  NormonView.swift
//  HyPort
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class NormalView: UIView {

    var icon: UIImageView! 
    var title: UILabel!
    var button: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatUI() {
        icon = UIImageView()
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
        }

        title = UILabel()
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(icon.snp_right).offset(5)
            make.width.equalTo(100)
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
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
