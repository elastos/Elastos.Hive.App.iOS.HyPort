//
//  FriendCell.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/9.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    var icon: UIImageView!
    var nameLable: UILabel!
    var describeLable: UILabel!
    var switchButton: UISwitch!
    var model: CarrierFriendInfo! {
        didSet {
            nameLable.text = model.name
            if model.name == "" {
            nameLable.text = model.userId
            }
            if model.status == .Connected {
                switchButton.isOn = true
            }else {
                switchButton.isOn = false
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        creatUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatUI() -> Void {

        icon = UIImageView.init(image: UIImage(named: "remote")!)
        self.contentView.addSubview(icon!)

        nameLable = UILabel()
        nameLable.backgroundColor = UIColor.clear
        nameLable.text = ""
        nameLable.textAlignment = .left
        nameLable.sizeToFit()
        self.contentView.addSubview(nameLable)

        describeLable = UILabel()
        describeLable.backgroundColor = UIColor.clear
        describeLable.font = UIFont.systemFont(ofSize: 13)
        describeLable.text = "接收文件"
        describeLable.textAlignment = .right
        describeLable.sizeToFit()
        self.contentView.addSubview(describeLable)

        switchButton = UISwitch()
        switchButton.isOn = true
        self.contentView.addSubview(switchButton)

        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(line)

        icon.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(33)
            make.centerY.equalToSuperview()
        })

        nameLable.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon!.snp_right).offset(12)
            make.right.equalTo(describeLable.snp_left).offset(-5)
            make.height.equalToSuperview()
        })

        describeLable.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(switchButton.snp_left).offset(-12)
            make.width.equalTo(66)
            make.height.equalToSuperview()
        })

        switchButton.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(31.0)
            make.width.equalTo(51.0)
            make.right.equalToSuperview().offset(-12)
        })

        line.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview()
        }
    }

}
