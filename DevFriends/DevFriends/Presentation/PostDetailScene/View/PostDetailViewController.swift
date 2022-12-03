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
    private lazy var backBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            image: .chevronLeft,
            style: .plain,
            target: self,
            action: #selector(didTouchedBackButton)
        )
        barButton.tintColor = .black
        return barButton
    }()
    private lazy var settingButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = .ellipsis
        item.tintColor = .black
        item.target = self
        item.action = #selector(didTapSettingButton)
        return item
    }()
    private lazy var commentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.reuseIdentifier
        )
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
    private let postDetailInfoView: PostDetailInfoView = {
        let postDetailInfoView = PostDetailInfoView()
        return postDetailInfoView
    }()
    private let postRequestButton: CommonButton = {
        let commonButton = CommonButton(text: "모임 신청")
        return commonButton
    }()
    private let postAttentionView: PostAttentionView = {
        let postAttentionView = PostAttentionView()
        return postAttentionView
    }()
    
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
        self.view.backgroundColor = .white
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
                self?.commentTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            .store(in: &cancellables)
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
    
    private func updateGroupApplyButton(state: GroupApplyButtonState) {
        switch state {
        case .available:
            self.postRequestButton.set(title: "모임 신청", state: .activated)
            self.postRequestButton.isHidden = false
        case .applied:
            self.postRequestButton.set(title: "신청된 모임입니다", state: .disabled)
            self.postRequestButton.isHidden = false
        case .joined:
            self.postRequestButton.isHidden = true
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
            
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
            }
        }
    }
    
    @objc func doKeyboardDown() {
        self.view.transform = .identity
    }
}

// MARK: - UITableView

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = createHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footerView
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset < currentOffset {
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
    @objc func didTapSettingButton(_ sender: UIButton) {
        // MARK: 동작을 넣어주세요
    }
    
    @objc func didTouchedBackButton() {
        viewModel.didTouchedBackButton()
    }
}
