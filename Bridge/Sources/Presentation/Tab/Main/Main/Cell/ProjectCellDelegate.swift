//
//  ProjectCellDelegate.swift
//  Bridge
//
//  Created by 엄지호 on 2023/12/03.
//

protocol ProjectCellDelegate: AnyObject {
    func bookmarkButtonTapped(projectID: Int)
    func itemSelected(projectID: Int)
}
