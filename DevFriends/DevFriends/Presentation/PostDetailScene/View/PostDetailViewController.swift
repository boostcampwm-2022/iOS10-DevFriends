//
//  PostDetailViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import Combine
import SnapKit
import UIKit

final class PostDetailViewController: UIViewController {
    private let backBarButton = BackBarButtonItem()
    
    private let settingButton = SettingBarButtonItem()
    
    private lazy var commentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .devFriendsReverseBase
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.register(cellType: CommentTableViewCell.self)
        tableView.sectionHeaderTopPadding = 10.0
        return tableView
    }()
    private lazy var tableViewDataSource = UITableViewDiffableDataSource<Int, CommentInfo>(
        tableView: self.commentTableView
    ) { commentTableView, indexPath, data in
        guard let cell = commentTableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CommentTableViewCell
        else {
            return UITableViewCell()
        }
        cell.set(info: data)

        return cell
    }
    private lazy var footerView: UIView = {
        let view = UIView()
        
        view.addSubview(self.spinner)
        spinner.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        return view
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .darkGray
        spinner.hidesWhenStopped = true
        return spinner
    }()
    private let commentTextField: CommonTextField = {
        let textField = CommonTextField(placeHolder: "댓글을 입력해주세요")
        return textField
    }()
    private let commentPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("↑", for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    private let postDetailInfoView = PostDetailInfoView()
    
    private let postRequestButton = CommonButton(text: "모임 신청")
    
    private let postAttentionView = PostAttentionView()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: PostDetailViewModel
    
    // MARK: - Init & Life Cycles
    
    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.layout()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    // MARK: - Setting
    
    private func configureUI() {
        self.setupViews()
        self.setupNavigation()
    }
    
    private func layout() {
        view.addSubview(commentTableView)
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }
        
        view.addSubview(commentTextField)
        commentTextField.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        view.addSubview(commentPostButton)
        commentPostButton.snp.makeConstraints { make in
            make.left.equalTo(commentTextField.snp.right).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(commentTextField)
            make.height.equalTo(commentTextField).multipliedBy(0.8)
            make.width.equalTo(commentPostButton.snp.height)
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = .devFriendsReverseBase
        postDetailInfoView.set(
            postWriterInfo: viewModel.postWriterInfoSubject.value,
            postDetailContents: viewModel.postDetailContentsSubject.value
        )
    
        viewModel.didLoadGroup()
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItems = [backBarButton]
        self.navigationItem.rightBarButtonItems = [settingButton]
    }
    
    private func bind() {
        settingButton.publisher
            .sink { [weak self] _ in
                self?.didTapSettingButton()
            }
            .store(in: &cancellables)
        
        backBarButton.publisher
            .sink { [weak self] _ in
                self?.didTouchedBackButton()
            }
            .store(in: &cancellables)
        
        hideKeyboardWhenTappedAround()
            .store(in: &cancellables)
        
        viewModel.postWriterInfoSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] postWriterInfo in
                self?.postDetailInfoView.set(postWriterInfo: postWriterInfo)
            }
            .store(in: &cancellables)
        
        viewModel.postDetailContentsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] postDetailContents in
                self?.postDetailInfoView.set(postDetailContents: postDetailContents)
            }
            .store(in: &cancellables)
        
        viewModel.postAttentionInfoSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                self?.postAttentionView.set(info: info)
            }
            .store(in: &cancellables)
         
        viewModel.commentsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] comments in
                var snapshot = NSDiffableDataSourceSnapshot<Int, CommentInfo>()
                snapshot.appendSections([0])
                snapshot.appendItems(comments)
                self?.tableViewDataSource.apply(snapshot)
            }
            .store(in: &cancellables)
        
        viewModel.groupApplyButtonStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateGroupApplyButton(state: state)
            }
            .store(in: &cancellables)
        
        self.postRequestButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.didTapApplyButton()
            }
            .store(in: &cancellables)
        
        self.postAttentionView.likeButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.didTapLikeButton()
            }
            .store(in: &cancellables)
        
        self.commentPostButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard
                    let comment = self?.commentTextField.text,
                    !comment.isEmpty else { return }
                
                self?.commentTextField.text = ""
                self?.viewModel.didTapCommentPostButton(content: comment)
                
                if self?.commentTableView.numberOfRows(inSection: 0) ?? 0 > 0 {
                    self?.commentTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func createHeaderView() -> UIView {
        let contentsView = UIView()
        var padding = 15
        
        contentsView.addSubview(postDetailInfoView)
        postDetailInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        contentsView.addSubview(postRequestButton)
        postRequestButton.snp.makeConstraints { make in
            make.top.equalTo(postDetailInfoView.snp.bottom).offset(padding)
            make.leading.trailing.equalTo(postDetailInfoView)
        }
        
        let divider1 = DividerView()
        contentsView.addSubview(divider1)
        divider1.snp.makeConstraints { make in
            make.top.equalTo(postRequestButton.snp.bottom).offset(padding)
            make.leading.trailing.equalTo(postDetailInfoView)
        }
        
        contentsView.addSubview(postAttentionView)
        postAttentionView.snp.makeConstraints { make in
            make.top.equalTo(divider1.snp.bottom).offset(8)
            make.leading.trailing.equalTo(postDetailInfoView)
            make.height.equalTo(20)
        }
        
        let divider2 = DividerView()
        contentsView.addSubview(divider2)
        
        divider2.snp.makeConstraints { make in
            make.top.equalTo(postAttentionView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(postDetailInfoView)
            make.bottom.equalToSuperview().offset(-padding)
        }
        
        return contentsView
    }
    
    private func updateGroupApplyButton(state: GroupApplyButtonState) {
        switch state {
        case .available:
            self.postRequestButton.set(title: "모임 신청", state: .activated)
            self.postRequestButton.isHidden = false
        case .applied:
            self.postRequestButton.set(title: "신청된 모임입니다", state: .disabled)
            self.postRequestButton.isHidden = false
        case .joined, .manager:
            self.postRequestButton.isHidden = true
            self.postRequestButton.snp.makeConstraints { make in
                make.height.equalTo(0)
            }
        case .closed:
            self.postRequestButton.set(title: "마감된 모임입니다", state: .disabled)
            self.postRequestButton.isHidden = false
        }
    }
}

// MARK: - Keyboard Methods

extension PostDetailViewController {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(doKeyboardUp),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(doKeyboardDown),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func doKeyboardUp(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            if self.view.frame.origin.y == 0.0 {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y -= keyboardRectangle.height
                }
            }
        }
    }
    
    @objc func doKeyboardDown(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            if self.view.frame.origin.y == -1 * keyboardRectangle.height {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = 0
                }
            }
        }
    }
}

// MARK: - UITableView

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footerView
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if viewModel.commentsSubject.value.count == viewModel.expectedCommentsCount && maximumOffset < currentOffset {
            viewModel.didScrollToBottom()
            spinner.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.spinner.stopAnimating()
            }
        }
    }
}

// MARK: - Actions

extension PostDetailViewController {
    private func didTapSettingButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "신고", style: .default) { [weak self] _ in
            self?.viewModel.didTouchedReportButton()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func didTouchedBackButton() {
        viewModel.didTouchedBackButton()
    }
}
