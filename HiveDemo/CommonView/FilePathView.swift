//
//  FilePathView.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/10.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class FilePathView: UIView, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var containLable: UILabel!
    var button: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatUI() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        scrollView.addSubview(stackView)

        containLable = UILabel()
        containLable.text = "/"
        containLable.font = UIFont.systemFont(ofSize: 15)
        stackView.addArrangedSubview(containLable)

        button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitle("new", for: .normal)
        button.titleShadowColor(for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        self.addSubview(button)

        scrollView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(button.snp_left).offset(-12)
        }

        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }

        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(40)
            make.right.equalToSuperview()
        }
    }
}
