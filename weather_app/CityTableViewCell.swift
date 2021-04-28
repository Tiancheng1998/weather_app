//
//  CityTableViewCell.swift
//  weather_app
//
//  Created by Tony Wang on 4/24/21.
//  Copyright © 2021 Tony_Wang. All rights reserved.
//

import UIKit
import SnapKit

class CityTableViewCell: UITableViewCell {
    
    static let identifier = "CityTableViewCell"
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemTeal
        v.layer.cornerRadius = 10
        return v
    }()
    
    private var leftContainerStack: UIStackView! // takes care of spacing
    private var sunsetStack: UIStackView!
    private var sunriseStack: UIStackView!
    private let title: UILabel = {
        let t = UILabel()
        t.font = LayoutGuide.stdFonts(for: .stdTitle)
        return t
    }()
    private let sunriseImg: UIImageView = {
        let img = UIImage(named: "sunrise")?.withRenderingMode(.alwaysTemplate)
        let iv = UIImageView(image: img)
        iv.tintColor = .black
        return iv
    }()
    private let sunsetImg: UIImageView = {
        let img = UIImage(named: "sunset")?.withRenderingMode(.alwaysTemplate)
        let iv = UIImageView(image: img)
        iv.tintColor = .black
        return iv
    }()
    private let sunriseTime: UILabel = {
        let l = UILabel()
        l.font = LayoutGuide.stdFonts(for: .stdBody)
        return l
    }()
    private let sunsetTime: UILabel = {
        let l = UILabel()
        l.font = LayoutGuide.stdFonts(for: .stdBody)
        return l
    }()
    
    private var rightContainerStack: UIStackView!
    private let tempLabel: UILabel = {
        let t = UILabel()
        t.font = LayoutGuide.stdFonts(for: .stdBody)
        return t
    }()
    private let weatherIconView = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(cardView)
        setupLeftStack()
        setupRightStack()
        
        
        cardView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
            make.centerY.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLeftStack() {
        sunriseImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
        }
        sunsetImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
        }
        
        sunsetStack = UIStackView(arrangedSubviews: [sunsetImg, sunsetTime])
        sunsetStack.axis = .horizontal
        sunsetStack.alignment = .center
        sunsetStack.spacing = 10
        sunriseStack = UIStackView(arrangedSubviews: [sunriseImg, sunriseTime])
        sunriseStack.axis = .horizontal
        sunriseStack.alignment = .center
        sunriseStack.spacing = 10
        leftContainerStack = UIStackView(arrangedSubviews: [title, sunriseStack, sunsetStack])
        leftContainerStack.axis = .vertical
        leftContainerStack.alignment = .leading
        leftContainerStack.distribution = .equalSpacing
        
        cardView.addSubview(leftContainerStack)
        
        leftContainerStack.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(10)
            make.width.equalTo(200)
        }
    }
    
    private func setupRightStack() {
        weatherIconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
        }
        rightContainerStack = UIStackView(arrangedSubviews: [weatherIconView, tempLabel])
        rightContainerStack.axis = .horizontal
        rightContainerStack.alignment = .center
        rightContainerStack.spacing = 10
        cardView.addSubview(rightContainerStack)
        
        rightContainerStack.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    public func setContent(titleText:String, sunriseTime: String, sunsetTime: String, weather: String, temp: Double?) {
        title.text = titleText
        self.sunsetTime.text = sunsetTime
        self.sunriseTime.text = sunriseTime
        weatherIconView.image = UIImage(named: "sunny")
        if let t = temp {
            self.tempLabel.text = String(t) + "F"
        } else {
            self.tempLabel.text = "__F"
        }
        
    }

}
