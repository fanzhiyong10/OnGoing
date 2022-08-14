//
//  TaskView.swift
//  OnGoing
//
//  Created by 范志勇 on 2022/8/14.
//

import UIKit

/// 任务详细视图
///
/// 特点
/// - 滚动
///
/// 用法，多处使用
/// - 任务台
/// - 任务查看
/// - 任务编辑
/// - 新任务：发出通知
class TaskView: UIView {
    var openMode: Int = 0 // 0:查看（不能修改任何信息），1：编辑（可修改任何信息）
    var task: MelfTask!
    var taskDetailScrollView: UIScrollView!
    var cv: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 创建滚动
        task = MelfTask(taskID: "NewTaskID000", name: "新任务")
        self.createTaskDetailScrollView()
        self.openMode = 1
    }
    
    /// 初始化
    ///
    /// 参数
    /// - parameter openmode: 缺省为0，仅可查看
    /// - parameter task: 任务
    init(frame: CGRect, task: MelfTask, openMode: Int = 0) {
        super.init(frame: frame)
        self.task = task
        self.openMode = openMode
        self.createTaskDetailScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 更换任务
    func changeTask(task: MelfTask) {
        self.task = task
        self.cv.isHidden = true
        self.cv.removeFromSuperview()
        self.createTaskDetail()
    }
    
    /// 任务详细
    ///
    /// 创建顺序
    /// - 滚动视图
    /// - 内容视图
    /// - 收缩按钮
    func createTaskDetailScrollView() {
        // ===== 1. 滚动视图
        let aRect = CGRect(x: 0, y: 0, width: 414, height: 334)
        self.taskDetailScrollView = UIScrollView(frame: aRect)
        self.addSubview(self.taskDetailScrollView)
        self.taskDetailScrollView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.9)
        
        self.taskDetailScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // 1.1 heightAnchor可以再优化
        let safe = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.taskDetailScrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.taskDetailScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.taskDetailScrollView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 0),
            self.taskDetailScrollView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 0),
        ])
        
        // ===== 2. 加载内容视图
        self.createTaskDetail()
    }
    
    /// 任务详细信息
    ///
    /// 操作
    /// - 修改内容
    /// - 添加音频
    ///
    /// 任务加载
    /// - 初始为：今日正在办理的第一条任务（可操作），若正在办理没有，则选择待办
    /// - 点击表单中的任务后，则显示选中的任务
    func createTaskDetail() {
        switch self.openMode {
        case 0:
            self.createTaskDetailWithoutEdit()
        case 1:
            self.createTaskDetailWithEdit()
        default:
            self.createTaskDetailWithoutEdit()
        }
    }
    func createTaskDetailWithoutEdit() {
        // 滚动视图中添加内容视图
        self.cv = UIView()
        self.taskDetailScrollView.addSubview(cv)
        cv.isHidden = true

        let gap: CGFloat = 8 // 8
        let origin = CGPoint(x: 12, y: 8)
        let size = CGSize(width: self.taskDetailScrollView.bounds.size.width, height: 40) // 87

        var rect = CGRect(origin: origin, size: size)
        
        var aboveView: UIView?
        do {
            rect.size.height = 50
            rect.origin.x = 0

            let lm = NSLayoutManager()
            let ts = NSTextStorage()
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:CGSize(width: rect.width, height: .greatestFiniteMagnitude))
            lm.addTextContainer(tc)
            let nameTV = UITextView(frame:rect, textContainer:tc)
            nameTV.text = "\(task.name)"
            nameTV.font = UIFont.systemFont(ofSize: 17)
            cv.addSubview(nameTV)
            
            rect.origin.y += nameTV.bounds.height + gap
            
            aboveView = nameTV
        }
        
        if task.description != nil {
            rect.size.height = 100
            rect.origin.x = 0

            let lm = NSLayoutManager()
            let ts = NSTextStorage()
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:CGSize(width: rect.width, height: .greatestFiniteMagnitude))
            lm.addTextContainer(tc)
            let descriptionTV = UITextView(frame:rect, textContainer:tc)
            descriptionTV.text = "\(task.description!)"
            descriptionTV.font = UIFont.systemFont(ofSize: 17)
            cv.addSubview(descriptionTV)
            
            rect.origin.y += descriptionTV.bounds.height + gap
            
            aboveView = descriptionTV
        }
        
        
        if task.resource_required != nil {
            rect.size.height = 50
            rect.origin.x = 0

            let lm = NSLayoutManager()
            let ts = NSTextStorage()
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:CGSize(width: rect.width, height: .greatestFiniteMagnitude))
            lm.addTextContainer(tc)
            let nameTV = UITextView(frame:rect, textContainer:tc)
            nameTV.text = "\(task.resource_required!)"
            nameTV.font = UIFont.systemFont(ofSize: 17)
            cv.addSubview(nameTV)
            
            rect.origin.y += nameTV.bounds.height + gap
            
            aboveView = nameTV
        }
         
        do {
            // 时间：开始 实际 结束
            var aRect = rect
            aRect.size.height = 30
            aRect.size.width = 60
            aRect.origin.x = 50
            let beginLabel = UILabel(frame: aRect)
            beginLabel.text = "开始"
            cv.addSubview(beginLabel)
            
//            let safe = cv.safeAreaLayoutGuide
//            beginLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                beginLabel.heightAnchor.constraint(equalToConstant: 30),
//                beginLabel.widthAnchor.constraint(equalToConstant: 60),
//                beginLabel.topAnchor.constraint(equalTo: aboveView!.bottomAnchor, constant: 8),
//                beginLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 50),
//            ])
            
            aRect.origin.x += 120
            let realLabel = UILabel(frame: aRect)
            realLabel.text = "实际"
//            realLabel.center.x = cv.center.x
            cv.addSubview(realLabel)
            
//            realLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                realLabel.heightAnchor.constraint(equalToConstant: 30),
//                realLabel.widthAnchor.constraint(equalToConstant: 60),
//                realLabel.topAnchor.constraint(equalTo: aboveView!.bottomAnchor, constant: 8),
//                realLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor, constant: 0),
//            ])

            aRect.origin.x += 60
            let endLabel = UILabel(frame: aRect)
            endLabel.text = "结束"
            cv.addSubview(endLabel)
            
//            endLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                endLabel.heightAnchor.constraint(equalToConstant: 30),
//                endLabel.widthAnchor.constraint(equalToConstant: 60),
//                endLabel.topAnchor.constraint(equalTo: aboveView!.bottomAnchor, constant: 8),
//                endLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -80),
//            ])

            // 时间
            rect.origin.y += aRect.size.height + 8
            aRect.origin.y = rect.origin.y
            aRect.origin.x = 8
            aRect.size.width = 180
            let beginTF = UITextField(frame: aRect)
            beginTF.borderStyle = .line
            beginTF.placeholder = "2022/2/21 08:00"
            cv.addSubview(beginTF)
            
            aRect.origin.y = rect.origin.y
            aRect.origin.x = 8 + 180 + 30
//            aRect.size.width = 150
            let endTF = UITextField(frame: aRect)
            endTF.borderStyle = .line
            endTF.placeholder = "2022/2/21 08:00"
            cv.addSubview(endTF)

        }
        

        var sz = self.taskDetailScrollView.bounds.size
        sz.height = rect.origin.y
        
        // content view的须设定，否则，内部的按钮将不能响应点击事件
        cv.frame = CGRect(origin: .zero, size: sz)
        cv.isHidden = false

        // scroll view的须设定
        self.taskDetailScrollView.contentSize = sz
        
        self.taskDetailScrollView.setNeedsDisplay()
    }
    
    func createTaskDetailWithEdit() {
        // 滚动视图中添加内容视图
        self.cv = UIView()
        self.taskDetailScrollView.addSubview(cv)
        cv.isHidden = true

        let gap: CGFloat = 8 // 8
        let origin = CGPoint(x: 12, y: 8)
        let size = CGSize(width: self.taskDetailScrollView.bounds.size.width, height: 40) // 87

        var rect = CGRect(origin: origin, size: size)
        
        var aboveView: UIView?
        do {
            rect.size.height = 50
            rect.origin.x = 0

            let lm = NSLayoutManager()
            let ts = NSTextStorage()
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:CGSize(width: rect.width, height: .greatestFiniteMagnitude))
            lm.addTextContainer(tc)
            let nameTV = UITextView(frame:rect, textContainer:tc)
            nameTV.text = "\(task.name)"
            nameTV.font = UIFont.systemFont(ofSize: 17)
            cv.addSubview(nameTV)
            
            rect.origin.y += nameTV.bounds.height + gap
            
            aboveView = nameTV
        }
        
        let description = task.description ?? "任务描述"
        do {
            rect.size.height = 100
            rect.origin.x = 0

            let lm = NSLayoutManager()
            let ts = NSTextStorage()
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:CGSize(width: rect.width, height: .greatestFiniteMagnitude))
            lm.addTextContainer(tc)
            let descriptionTV = UITextView(frame:rect, textContainer:tc)
            descriptionTV.text = "\(description)"
            descriptionTV.font = UIFont.systemFont(ofSize: 17)
            cv.addSubview(descriptionTV)
            
            rect.origin.y += descriptionTV.bounds.height + gap
            
            aboveView = descriptionTV
        }
        
        let resource_required = task.resource_required ?? "资源需求"
        do {
            rect.size.height = 50
            rect.origin.x = 0

            let lm = NSLayoutManager()
            let ts = NSTextStorage()
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:CGSize(width: rect.width, height: .greatestFiniteMagnitude))
            lm.addTextContainer(tc)
            let nameTV = UITextView(frame:rect, textContainer:tc)
            nameTV.text = "\(resource_required)"
            nameTV.font = UIFont.systemFont(ofSize: 17)
            cv.addSubview(nameTV)
            
            rect.origin.y += nameTV.bounds.height + gap
            
            aboveView = nameTV
        }
         
        do {
            // 时间：开始 实际 结束
            var aRect = rect
            aRect.size.height = 30
            aRect.size.width = 60
            aRect.origin.x = 50
            let beginLabel = UILabel(frame: aRect)
            beginLabel.text = "开始"
            cv.addSubview(beginLabel)
            
//            let safe = cv.safeAreaLayoutGuide
//            beginLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                beginLabel.heightAnchor.constraint(equalToConstant: 30),
//                beginLabel.widthAnchor.constraint(equalToConstant: 60),
//                beginLabel.topAnchor.constraint(equalTo: aboveView!.bottomAnchor, constant: 8),
//                beginLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 50),
//            ])
            
            aRect.origin.x += 120
            let realLabel = UILabel(frame: aRect)
            realLabel.text = "实际"
//            realLabel.center.x = cv.center.x
            cv.addSubview(realLabel)
            
//            realLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                realLabel.heightAnchor.constraint(equalToConstant: 30),
//                realLabel.widthAnchor.constraint(equalToConstant: 60),
//                realLabel.topAnchor.constraint(equalTo: aboveView!.bottomAnchor, constant: 8),
//                realLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor, constant: 0),
//            ])

            aRect.origin.x += 60
            let endLabel = UILabel(frame: aRect)
            endLabel.text = "结束"
            cv.addSubview(endLabel)
            
//            endLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                endLabel.heightAnchor.constraint(equalToConstant: 30),
//                endLabel.widthAnchor.constraint(equalToConstant: 60),
//                endLabel.topAnchor.constraint(equalTo: aboveView!.bottomAnchor, constant: 8),
//                endLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -80),
//            ])

            // 时间
            rect.origin.y += aRect.size.height + 8
            aRect.origin.y = rect.origin.y
            aRect.origin.x = 8
            aRect.size.width = 180
            let beginTF = UITextField(frame: aRect)
            beginTF.borderStyle = .line
            beginTF.placeholder = "2022/2/21 08:00"
            cv.addSubview(beginTF)
            
            aRect.origin.y = rect.origin.y
            aRect.origin.x = 8 + 180 + 30
//            aRect.size.width = 150
            let endTF = UITextField(frame: aRect)
            endTF.borderStyle = .line
            endTF.placeholder = "2022/2/21 08:00"
            cv.addSubview(endTF)

        }
        

        var sz = self.taskDetailScrollView.bounds.size
        sz.height = rect.origin.y
        
        // content view的须设定，否则，内部的按钮将不能响应点击事件
        cv.frame = CGRect(origin: .zero, size: sz)
        cv.isHidden = false

        // scroll view的须设定
        self.taskDetailScrollView.contentSize = sz
        
        self.taskDetailScrollView.setNeedsDisplay()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
