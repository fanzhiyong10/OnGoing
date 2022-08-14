//
//  ViewController.swift
//  OnGoing
//
//  Created by 范志勇 on 2022/8/7.
//

import UIKit

/// 今日任务
///
/// 包括四个部分
/// - 抬头：添加新任务
/// - 任务详细
/// - 任务统计
/// - 任务列表
///
/// 旋转
/// - 仅允许竖版，不旋转
class TodayTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var allTasks: [MelfTask]?
    var allTasks_backup: [MelfTask]?
    func createAllTasks() {
        self.allTasks = MelfTask.createAllTasks()
        self.allTasks_backup = self.allTasks
    }
    
    var statisticView: UIView!
    
    var todayTaskTitleLabel: UILabel! // 今日任务
    
    var newTaskButton: UIButton! // 新增任务
    
    var tableView: UITableView!
    
    
    /// 设置界面
    ///
    /// 设置顺序：自上而下
    /// - 顶部区域
    /// - 任务详细
    /// - 统计
    /// - 表单
    func createInterface() {
        // 1. 顶部区域
        self.createTopBlock()
        
        // 2. 任务详细
        self.createTaskView()

        // 3. 统计
        self.createStatisticView()

        // 4. 创建表单
        self.createTableView()
    }
    

    
    /// 顶部区域
    ///
    /// 两项：
    /// - 今日任务：UILabel
    /// - 新增任务：UIButton
    ///
    ///
    /// 显示注意项：
    /// - 左右边距，相等
    func createTopBlock() {
        // 今日任务：UILabel
        let aRect = CGRect(x: 0, y: 0, width: 150, height: 31)
        self.todayTaskTitleLabel = UILabel(frame: aRect)
        self.todayTaskTitleLabel.text = "今日任务"
        self.view.addSubview(self.todayTaskTitleLabel)
        
        let safe = self.view.safeAreaLayoutGuide
        self.todayTaskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.todayTaskTitleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            self.todayTaskTitleLabel.heightAnchor.constraint(equalToConstant: 31),
            self.todayTaskTitleLabel.widthAnchor.constraint(equalToConstant: 150),
            self.todayTaskTitleLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
        ])
        
        // 新增任务：UIButton
        self.newTaskButton = UIButton(frame: aRect)
        let image = UIImage(systemName: "plus")
        self.newTaskButton.setImage(image, for: .normal)
        self.view.addSubview(self.newTaskButton)
        
        self.newTaskButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        
        self.newTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.newTaskButton.centerYAnchor.constraint(equalTo: self.todayTaskTitleLabel.centerYAnchor),
            self.newTaskButton.heightAnchor.constraint(equalToConstant: 31),
            self.newTaskButton.widthAnchor.constraint(equalToConstant: 44),
            self.newTaskButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
        ])
    }
    
    /// 新增任务
    @objc func addNewTask() {
        let vc = NewTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var taskView: TaskView!
    func createTaskView() {
        // 定位task
        let task = self.allTasks![self.selected_indexPath!.row]
        
        // ===== 1. 滚动视图
        let aRect = CGRect(x: 0, y: 0, width: 414, height: 334)
        self.taskView = TaskView(frame: aRect, task: task)
        self.view.addSubview(self.taskView)
        self.taskView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.9)
        
        self.taskView.translatesAutoresizingMaskIntoConstraints = false
        
        // 1.1 heightAnchor可以再优化
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.taskView.topAnchor.constraint(equalTo: self.todayTaskTitleLabel.bottomAnchor, constant: 8),
            self.taskView.heightAnchor.constraint(equalToConstant: 334),
            self.taskView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 0),
            self.taskView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 0),
        ])
    }
    
    /// 统计区域
    ///
    /// 顺序如下
    /// - 正在办理
    /// - 待办任务
    /// - 已办任务
    func createStatisticView() {
        let aRect = CGRect(x: 0, y: 0, width: 414, height: 123)
        self.statisticView = UIView(frame: aRect)
        self.view.addSubview(self.statisticView)
        
        self.statisticView.translatesAutoresizingMaskIntoConstraints = false
        
        // 1.1 heightAnchor可以再优化
        var safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.statisticView.topAnchor.constraint(equalTo: self.taskView.bottomAnchor, constant: 8),
            self.statisticView.heightAnchor.constraint(equalToConstant: 123),
            self.statisticView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 0),
            self.statisticView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 0),
        ])
        
        // 统计项
        // 1. 正在办理
        // 1.1 button
        let rect_button = CGRect(x: 0, y: 0, width: 133, height: 31)
        let rect_Label = CGRect(x: 0, y: 0, width: 50, height: 21)
        self.going_button = UIButton(frame: rect_button)
        let image = UIImage(systemName: "circle")
        self.going_button.setImage(image, for: .normal)
        self.going_button.setTitle("正在办理", for: .normal)
        self.going_button.setTitleColor(UIColor.systemBlue, for: .normal)
        self.statisticView.addSubview(self.going_button)
        
        self.going_button.translatesAutoresizingMaskIntoConstraints = false
        
        safe = self.statisticView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.going_button.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            self.going_button.heightAnchor.constraint(equalToConstant: 31),
            self.going_button.widthAnchor.constraint(equalToConstant: 123),
            self.going_button.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
        ])

        // 1.2 label
        self.going_Label = UILabel(frame: rect_Label)
        self.going_Label.text = "99"
        self.statisticView.addSubview(self.going_Label)
        
        self.going_Label.translatesAutoresizingMaskIntoConstraints = false
        
        safe = self.going_button.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.going_Label.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            self.going_Label.heightAnchor.constraint(equalToConstant: 21),
            self.going_Label.widthAnchor.constraint(equalToConstant: 50),
            self.going_Label.leadingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 30),
        ])
        
        // 2. 待办任务
        // 2.1 button
        self.notBegin_button = UIButton(frame: rect_button)
//        let image = UIImage(systemName: "circle")
        self.notBegin_button.setImage(image, for: .normal)
        self.notBegin_button.setTitle("待办任务", for: .normal)
        self.notBegin_button.setTitleColor(UIColor.systemBlue, for: .normal)
        self.statisticView.addSubview(self.notBegin_button)
        
        self.notBegin_button.translatesAutoresizingMaskIntoConstraints = false
        
        safe = self.going_button.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.notBegin_button.topAnchor.constraint(equalTo: safe.bottomAnchor, constant: 8),
            self.notBegin_button.heightAnchor.constraint(equalTo: safe.heightAnchor),
            self.notBegin_button.widthAnchor.constraint(equalTo: safe.widthAnchor),
            self.notBegin_button.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
        ])

        // 2.2 label
        self.notBegin_Label = UILabel(frame: rect_Label)
        self.notBegin_Label.text = "199"
        self.statisticView.addSubview(self.notBegin_Label)
        
        self.notBegin_Label.translatesAutoresizingMaskIntoConstraints = false
        
        safe = self.notBegin_button.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.notBegin_Label.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            self.notBegin_Label.heightAnchor.constraint(equalTo: self.going_Label.heightAnchor),
            self.notBegin_Label.widthAnchor.constraint(equalTo: self.going_Label.widthAnchor),
            self.notBegin_Label.leadingAnchor.constraint(equalTo: self.going_Label.leadingAnchor),
        ])
        
        // 3. 已办任务
        // 3.1 button
        self.closed_button = UIButton(frame: rect_button)
//        let image = UIImage(systemName: "circle")
        self.closed_button.setImage(image, for: .normal)
        self.closed_button.setTitle("已办任务", for: .normal)
        self.closed_button.setTitleColor(UIColor.systemBlue, for: .normal)
        self.statisticView.addSubview(self.closed_button)
        
        self.closed_button.translatesAutoresizingMaskIntoConstraints = false
        
        safe = self.notBegin_button.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.closed_button.topAnchor.constraint(equalTo: safe.bottomAnchor, constant: 8),
            self.closed_button.heightAnchor.constraint(equalTo: safe.heightAnchor),
            self.closed_button.widthAnchor.constraint(equalTo: safe.widthAnchor),
            self.closed_button.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
        ])

        // 3.2 label
        self.closed_Label = UILabel(frame: rect_Label)
        self.closed_Label.text = "199"
        self.statisticView.addSubview(self.closed_Label)
        
        self.closed_Label.translatesAutoresizingMaskIntoConstraints = false
        
        safe = self.closed_button.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.closed_Label.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            self.closed_Label.heightAnchor.constraint(equalTo: self.going_Label.heightAnchor),
            self.closed_Label.widthAnchor.constraint(equalTo: self.going_Label.widthAnchor),
            self.closed_Label.leadingAnchor.constraint(equalTo: self.going_Label.leadingAnchor),
        ])
    }
    
    var going_button: UIButton! // 正在办理
    var going_Label: UILabel! // 正在办理
    var notBegin_button: UIButton! // 待办任务
    var notBegin_Label: UILabel! // 待办任务
    var closed_button: UIButton! // 已办任务
    var closed_Label: UILabel! // 已办任务
    
    /// 创建表单
    func createTableView() {
        let aRect = CGRect(x: 0, y: 0, width: 414, height: 342)
        self.tableView = UITableView(frame: aRect)
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // 1.1 heightAnchor可以再优化
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.statisticView.bottomAnchor, constant: 8),
            self.tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8),
            self.tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 0),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "任务台"
        
        self.createAllTasks()
        
        // 界面，手工配置
        self.createInterface()
        
        // Do any additional setup after loading the view.
        // 设置tableView
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerID)

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    /// 控制器：仅支持portrait
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {return UIInterfaceOrientationMask.portrait}
    

    
    func changeScrollView() {
        let task = self.allTasks![self.selected_indexPath!.row]
        self.taskView.changeTask(task: task)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.allTasks != nil else {
            return 0
        }
        return self.allTasks!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 行高动态变化
        return 44
    }

    let cellID = "cellID"
    let headerID = "Header"

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView( withIdentifier: self.headerID)!
        // section：背景色
        headerView.backgroundView = UIView()
//        headerView.backgroundView?.backgroundColor = ConfigureOfColor.sectionBackgroundColorV2
        headerView.backgroundView?.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.8)

        let y_center = CGFloat(25)
        if headerView.viewWithTag(1000) == nil {
            var width: CGFloat = 150
            let font = UIFont.systemFont(ofSize: 17)
            var aRect = CGRect(x: 20, y: 15, width: width, height: 30)
            let gap: CGFloat = 15
            
            let lab = UILabel(frame: aRect)
            lab.tag = 1000
            lab.font = font
            lab.backgroundColor = .clear
            
            var s0 = "任务"
            lab.text = NSLocalizedString(s0, tableName: "settingsPart2", value: s0, comment: s0)
            lab.textAlignment = .left
            lab.center.y = y_center
//            lab.center.x = aRect.center.x
            headerView.contentView.addSubview(lab)

            aRect.origin.x += width + gap
            width = 180
            aRect.size.width = width
            let lab1 = UILabel(frame: aRect)
            lab1.tag = 1001
            lab1.font = font
            lab1.backgroundColor = .clear
            
            s0 = "状态"
            lab1.text = NSLocalizedString(s0, tableName: "settingsPart2", value: s0, comment: s0)
            lab1.textAlignment = .center
            lab1.center.y = y_center
//            lab1.center.x = aRect.center.x
            headerView.contentView.addSubview(lab1)

            aRect.origin.x += width + gap
            let lab2 = UILabel(frame: aRect)
            lab2.tag = 202
            lab2.font = font
            lab2.backgroundColor = .clear
            
            s0 = "开始时间"
            lab2.text = NSLocalizedString(s0, tableName: "settingsPart2", value: s0, comment: s0)
            lab2.textAlignment = .center
            lab2.center.y = y_center
//            lab2.center.x = aRect.center.x
            headerView.contentView.addSubview(lab2)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
        
        cell.separatorInset = UIEdgeInsets.zero
        
//        cell.textLabel!.text = self.allProducts[indexPath.row].localizedTitle
        
        cell.accessoryType = .none
        
        let y_center = CGFloat(25)
        if cell.viewWithTag(200) == nil {
            let font = UIFont.systemFont(ofSize: 17)
            var aRect = CGRect(x: 8, y: 15, width: 120, height: 30)
            
            let gap: CGFloat = 8
            
            do {
                aRect.size.width = 30
                aRect.size.height = 20
                let button = MarkButton(frame: aRect)
                button.tag = 200
                
                button.center.y = y_center
                cell.contentView.addSubview(button)
            }
            
            do {
                aRect.origin.x += aRect.width + gap
                aRect.size.width = 300
                aRect.size.height = 30
                let lab6 = UILabel(frame: aRect)
                lab6.tag = 201
                lab6.font = font
                lab6.backgroundColor = .clear
                lab6.text = "任务名称"
                lab6.textColor = UIColor.darkGray
                lab6.center.y = y_center
                cell.contentView.addSubview(lab6)
            }
        }
        
        let task = self.allTasks![indexPath.row]
        
        var image = UIImage(systemName: "circle.fill")
        if task.childIDs != nil {
            // 子任务显示
            // arrowtriangle.down.fill
            image = UIImage(systemName: "arrowtriangle.down.fill")
            
            if task.children?.first?.isHidden == true {
                // 子任务隐藏
                // arrowtriangle.right.fill
                image = UIImage(systemName: "arrowtriangle.right.fill")
            }
        }
        
        let button = cell.contentView.viewWithTag(200) as! MarkButton
        button.setImage(image, for: .normal)
        button.indexPath = indexPath
        button.addTarget(self, action: #selector(tapMark), for: .touchUpInside)
        
        let x_level = CGFloat(task.level) * 32 + 8
        button.frame.origin.x = x_level
        
        let safe = cell.contentView.safeAreaLayoutGuide
        /*
         // NSLayoutConstraint存在问题，当点击行时，显示会乱，会报定位leadingAnchor冲突
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let x_level = CGFloat(task.level) * 32 + 8
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.centerYAnchor.constraint(equalTo: safe.centerYAnchor, constant: 0),
            button.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: x_level),
        ])
        */

        do {
            let lab = cell.contentView.viewWithTag(201) as! UILabel
            lab.text = task.name
            
            lab.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                lab.heightAnchor.constraint(equalToConstant: 30),
                lab.centerYAnchor.constraint(equalTo: safe.centerYAnchor, constant: 0),
                lab.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 12),
                lab.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            ])
        }
        
        //背景颜色：相邻的两行颜色不同（奇偶不同）
        if indexPath.row % 2 == 0 {
//            cell.contentView.backgroundColor = ConfigureOfColor.evenRowBackgroundColorV2
        }
        else {
//            cell.contentView.backgroundColor = ConfigureOfColor.oddRowBackgroundColorV2
        }
        
        if self.selected_indexPath == indexPath {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor.yellow // accessory
            cell.contentView.backgroundColor = UIColor.yellow // contentView
        } else {
            cell.accessoryType = .none
            cell.backgroundColor = UIColor.clear // accessory
            cell.contentView.backgroundColor = UIColor.clear // contentView
        }
        
        return cell
    }
    
    var selected_indexPath: IndexPath? = IndexPath(row: 0, section: 0)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected_indexPath = indexPath
        
        tableView.reloadData()
        
        // 任务详细信息
        self.changeScrollView()
    }
    
    @objc func tapMark(_ markButton: MarkButton) {
        guard let indexPath = markButton.indexPath else { return}
        
        // 选中行
        self.selected_indexPath = indexPath
        
        let task = self.allTasks![indexPath.row]
        
        guard task.childIDs != nil else { return }
        
        if task.children?.first?.isHidden == true {
            // 关闭，则打开
            showChildren(markButton)
        } else {
            // 打开，则关闭
            hideChildren(markButton)
        }
    }
    
    func showChildren(_ markButton: MarkButton) {
        guard let indexPath = markButton.indexPath else { return}
        
        let task = self.allTasks![indexPath.row]
        
        guard task.childIDs != nil else { return }
        
        // 递归找出 需要 隐藏的 子任务
        recurseTask(task, isHidden: false)
        
        self.allTasks = [MelfTask]()
        for task in self.allTasks_backup! {
            if task.isHidden == false {
                self.allTasks?.append(task)
            }
        }
        
        tableView.reloadData()
    }
    
    /// 任务的子任务打标识：是否显示
    func recurseTask(_ task: MelfTask, isHidden: Bool=true) {
        // 递归找出 需要 隐藏的 子任务
        let task_cal = task
        var end = false
        while end == false {
            if let tmps = task_cal.children {
                for tmp in tmps {
                    tmp.isHidden = isHidden
                    
                    if tmp.childIDs == nil {
                        // 没有
                        continue
                    }
                    
                    // 递归
                    recurseTask(tmp, isHidden: isHidden)
                }
            }
            
            end = true
        }
    }
    
    func hideChildren(_ markButton: MarkButton) {
        guard let indexPath = markButton.indexPath else { return}
        let task = self.allTasks![indexPath.row]
        
        guard task.childIDs != nil else { return }
        
        // 递归找出 需要 隐藏的 子任务
        recurseTask(task, isHidden: true)
        
        self.allTasks = [MelfTask]()
        for task in self.allTasks_backup! {
            if task.isHidden == false {
                self.allTasks?.append(task)
            }
        }
        tableView.reloadData()
    }
}

class MarkButton: UIButton {
    var indexPath: IndexPath?
    var isOpen = true
}
