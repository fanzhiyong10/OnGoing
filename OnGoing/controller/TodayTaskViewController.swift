//
//  ViewController.swift
//  OnGoing
//
//  Created by 范志勇 on 2022/8/7.
//

import UIKit

class TodayTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var allTasks: [MelfTask]?
    func createAllTasks() {
        self.allTasks = MelfTask.creatTasksForDemo()
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
        cell.textLabel!.text = self.allTasks![indexPath.row].name
        cell.textLabel!.textColor = .darkGray
        
        cell.separatorInset = UIEdgeInsets.zero
        
//        cell.textLabel!.text = self.allProducts[indexPath.row].localizedTitle
        
        cell.accessoryType = .none
        cell.backgroundColor = UIColor.white
        /*
        let y_center = CGFloat(25)
        if cell.viewWithTag(200) == nil {
            let font = UIFont.systemFont(ofSize: 20)
            var aRect = CGRect(x: 20, y: 15, width: 120, height: 30)
            
            let gap: CGFloat = 30
            
//            aRect.size.width = 400
            
            do {
                let lab2 = UILabel(frame: aRect)
                lab2.tag = 200
                lab2.font = font
                lab2.backgroundColor = .clear
                lab2.text = "声音名称"
                lab2.textColor = UIColor.darkGray
//                lab2.textAlignment = .center
//                lab2.center.x = aRect.center.x
                lab2.center.y = y_center
                cell.contentView.addSubview(lab2)
            }
            
            do {
                aRect.origin.x += aRect.width + gap
                aRect.size.width = 100
                let lab6 = UILabel(frame: aRect)
                lab6.tag = 201
                lab6.font = font
                lab6.backgroundColor = .clear
                lab6.text = "文件大小"
                lab6.textColor = UIColor.darkGray
//                lab6.textAlignment = .center
                lab6.center.y = y_center
                cell.contentView.addSubview(lab6)
            }
        }
        
        do {
            let lab = cell.contentView.viewWithTag(200) as! UILabel
            lab.text = self.allSounds![indexPath.row].name
        }
        
        do {
            let lab = cell.contentView.viewWithTag(201) as! UILabel
            lab.text = "\(self.allSounds![indexPath.row].size!)"
        }
*/
        //背景颜色：相邻的两行颜色不同（奇偶不同）
        if indexPath.row % 2 == 0 {
//            cell.backgroundColor = ConfigureOfColor.evenRowBackgroundColorV2 // iPad OK，iPhone 不行
            cell.contentView.backgroundColor = ConfigureOfColor.evenRowBackgroundColorV2
        }
        else {
//            cell.backgroundColor = ConfigureOfColor.oddRowBackgroundColorV2
            cell.contentView.backgroundColor = ConfigureOfColor.oddRowBackgroundColorV2
        }
        
        if self.selected == indexPath.row {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor.yellow // accessory
            cell.contentView.backgroundColor = UIColor.yellow // contentView
        }
        
        return cell
    }
    
    var selected = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = indexPath.row
        
        tableView.reloadData()
    }
}

