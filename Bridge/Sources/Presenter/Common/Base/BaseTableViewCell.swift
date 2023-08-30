//
//  BaseTableViewCell.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
