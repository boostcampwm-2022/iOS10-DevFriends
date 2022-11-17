//
//  PostReportViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//

import UIKit
import SnapKit

final class PostReportViewController: UIViewController {
    private lazy var reportView: ReportView = {
        let reportView = ReportView()
        reportView.setTitleText(title: "게시글을 신고하려는 이유가 무엇인가요?")
        return reportView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        view.addSubview(reportView)
        reportView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(14)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-14)
        }
    }
}
