//
//  NewTaskViewController.swift
//  OnGoing
//
//  Created by 范志勇 on 2022/8/14.
//

import UIKit

class NewTaskViewController: UIViewController {
    /// 控制器：仅支持portrait
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {return UIInterfaceOrientationMask.portrait}

    // id使用时间，精确到秒
    var task = MelfTask(taskID: "NewTask000", name: "新任务")
    
    var todayTaskTitleLabel: UILabel! // 今日任务
    
    var newTaskButton: UIButton! // 新增任务
    
    var taskView: TaskView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "新增任务"
        
        // 导航栏菜单
        self.setupMenu()
        
        // 界面，手工配置
        self.createTaskView()
    }
    
    private func setupMenu() {
        var image = UIImage(systemName: "doc.text.image.fill")
        let saveItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(saveTask))
        
        image = UIImage(systemName: "trash")
        let deleteItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(deleteTask))
        
        // 加大间距
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 30 // adjust as needed
        let space_80 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space_80.width = 80 // adjust as needed

        // 右侧：菜单项
        self.navigationItem.rightBarButtonItems = [saveItem, space, deleteItem]
    }
    
    @objc func saveTask() {
        
    }
    
    @objc func deleteTask() {
        
    }
    
    /// 新任务：编辑界面
    ///
    /// 设置顺序：自上而下
    /// - 任务详细
    func createTaskView() {
        // ===== 1. 滚动视图
        let aRect = CGRect(x: 0, y: 0, width: 414, height: 334)
        self.taskView = TaskView(frame: aRect, task: task, openMode: 1)
        self.view.addSubview(self.taskView)
        self.taskView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.9)
        
        self.taskView.translatesAutoresizingMaskIntoConstraints = false
        
        // 1.1 heightAnchor可以再优化
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.taskView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            self.taskView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8),
            self.taskView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 0),
            self.taskView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 0),
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
