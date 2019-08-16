//
//  FilePathView.swift
//  HyPort
//
//  Created by 李爱红 on 2019/8/10.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class FilePathView: UIView, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var icon: UIImageView!
    var containLable: UILabel!

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

        icon = UIImageView()
        icon.image = UIImage(named: "folder")
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        containLable = UILabel()
        containLable.text = "/"
        containLable.font = UIFont.systemFont(ofSize: 15)
        stackView.addArrangedSubview(containLable)

        scrollView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(34)
        }

        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}
