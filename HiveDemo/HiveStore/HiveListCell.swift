//
//  HiveListCell.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/9.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class HiveListCell: UITableViewCell {
    var icon: UIImageView?
    var nameLable: UILabel?
    var row: UIImageView?
    var longPress: UILongPressGestureRecognizer!
    var model: HiveItemInfo? {
        didSet{
            nameLable?.text = model?.getValue(HiveItemInfo.name)
            if (model?.getValue(HiveItemInfo.type) == "file" || model?.getValue(HiveItemInfo.type) == "1") {
                icon?.image = UIImage.init(named: "files")
                row?.isHidden = true
            }
            else {
                icon?.image = UIImage.init(named: "directory")
                row?.isHidden = false
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        creatUI()
        addLongPressGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addLongPressGesture() {
        longPress = UILongPressGestureRecognizer()
    self.addGestureRecognizer(longPress)
    }

    func creatUI() -> Void {

        icon = UIImageView.init(image: UIImage(named: "directory")!)
        self.contentView.addSubview(icon!)

        nameLable = UILabel()
        nameLable?.backgroundColor = UIColor.clear
        nameLable?.text = ""
        nameLable?.textAlignment = .left
        nameLable!.sizeToFit()
        self.contentView.addSubview(nameLable!)

        row = UIImageView.init(image: UIImage(named: "row")!)
        self.contentView.addSubview(row!)

        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(line)

        icon?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(33)
            make.centerY.equalToSuperview()
        })

        nameLable?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon!.snp_right).offset(12)
            make.right.equalToSuperview().offset(-44)
            make.height.equalToSuperview()
        })

        row?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(22)
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
