//
//  PostDetailViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit
import SnapKit

final class PostDetailViewController: UIViewController {
    private lazy var commentTableView: UITableView = {
        let commentTableView = UITableView(frame: .zero, style: .grouped)
        commentTableView.backgroundColor = .white
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 150
        commentTableView.allowsSelection = false
        return commentTableView
    }()
    private lazy var commentTextField: CommonTextField = {
        let commentTextField = CommonTextField(placeHolder: "댓글을 입력해주세요")
        return commentTextField
    }()
    private lazy var postDetailInfoView: PostDetailInfoView = {
        let postDetailInfoView = PostDetailInfoView()
        return postDetailInfoView
    }()
    private lazy var postRequestButton: CommonButton = {
        let postRequestButton = CommonButton(text: "모임 신청")
        return postRequestButton
    }()
    private lazy var postAttentionView: PostAttentionView = {
        let postAttentionView = PostAttentionView()
        return postAttentionView
    }()
    
    private let viewModel: PostDetailViewModel
    
    init(postDetailViewModel: PostDetailViewModel) {
        self.viewModel = postDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupViews()
        
        hideKeyboardWhenTappedAround()
        
        setTableViewDelegate()
        registerTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    private func configure() {
        view.addSubview(commentTableView)
        view.addSubview(commentTextField)
        
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }
        commentTextField.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
    }
    
    private func setupViews() {
        postDetailInfoView.set(postWriterInfo: viewModel.postWriterInfo,
                               postDetailContents: viewModel.postDetailContents)
        postAttentionView.set(info: viewModel.postAttentionInfo)
    }
    
    private func setTableViewDelegate() {
        commentTableView.delegate = self
        commentTableView.dataSource = self
    }
    
    private func createHeaderView() -> UIView {
        let contentsView = UIView()
        
        let contentsStackView = UIStackView()
        contentsStackView.axis = .vertical
        contentsStackView.spacing = 0
        
        contentsView.addSubview(contentsStackView)
        contentsStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(20)
        }
        
        contentsStackView.addArrangedSubview(postDetailInfoView)
        
        contentsStackView.addArrangedSubview(postRequestButton)
        contentsStackView.setCustomSpacing(20, after: postDetailInfoView)
        postRequestButton.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        let divider1 = DividerView()
        contentsStackView.addArrangedSubview(divider1)
        contentsStackView.setCustomSpacing(18, after: postRequestButton)
        
        contentsStackView.addArrangedSubview(postAttentionView)
        contentsStackView.setCustomSpacing(5, after: divider1)
        postAttentionView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        let divider2 = DividerView()
        contentsStackView.addArrangedSubview(divider2)
        contentsStackView.setCustomSpacing(5, after: postAttentionView)
        
        return contentsView
    }
}

// MARK: Keyboard Methods
extension PostDetailViewController {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(doKeyboardUp),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(doKeyboardDown),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func doKeyboardUp(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
            })
        }
    }
    
    @objc func doKeyboardDown() {
        self.view.transform = .identity
    }
}

// MARK: UITableView
extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = createHeaderView()
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentTableViewCell",
                                                              for: indexPath) as? CommentTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.set(info: viewModel.comments[indexPath.row])
        
        return cell
    }
    
    private func registerTableView() {
        commentTableView.register(CommentTableViewCell.classForCoder(), forCellReuseIdentifier: "commentTableViewCell")
    }
}
