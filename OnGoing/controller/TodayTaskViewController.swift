//
//  ViewController.swift
//  OnGoing
//
//  Created by 范志勇 on 2022/8/7.
//

import UIKit

class TodayTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var allTasks: [MelfTask]?
    var allTasks_backup: [MelfTask]?
    func createAllTasks() {
        self.allTasks = MelfTask.creatTasksForDemo()
        self.allTasks_backup = allTasks
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createAllTasks()
        
        // Do any additional setup after loading the view.
        // 设置tableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerID)

        self.tableView.dataSource = self
        self.tableView.delegate = self

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
        headerView.backgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
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
            let font = UIFont.systemFont(ofSize: 20)
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
//            cell.backgroundColor = ConfigureOfColor.evenRowBackgroundColorV2 // iPad OK，iPhone 不行
            cell.contentView.backgroundColor = ConfigureOfColor.evenRowBackgroundColorV2
        }
        else {
//            cell.backgroundColor = ConfigureOfColor.oddRowBackgroundColorV2
            cell.contentView.backgroundColor = ConfigureOfColor.oddRowBackgroundColorV2
        }
        
        if self.selected_indexPath == indexPath {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor.yellow // accessory
            cell.contentView.backgroundColor = UIColor.yellow // contentView
        }
        
        return cell
    }
    
    var selected_indexPath: IndexPath?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected_indexPath = indexPath
        
        tableView.reloadData()
    }
    
    @objc func tapMark(_ markButton: MarkButton) {
        guard let indexPath = markButton.indexPath else { return}
        
        // 选中行
        self.selected_indexPath = indexPath
        
        let task = self.allTasks![indexPath.row]
        
        guard let childIDs = task.childIDs else { return }
        
        var isClosed = true
        for task in self.allTasks! {
            if childIDs.contains(task.taskID) {
                // 有
                isClosed = false
            }
        }
        
        if isClosed {
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
//        let image = UIImage(systemName: "arrowtriangle.right.fill")
//        markButton.setImage(image, for: .normal)
        
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
