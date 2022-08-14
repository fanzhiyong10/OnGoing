//
//  MelfTask.swift
//  OnGoing
//
//  Created by 范志勇 on 2022/8/7.
//

import Foundation

/// 任务是否里程碑
///
/// 任务类型
/// - 里程碑，标志性，影响整个进程
/// - 普通
enum TaskType {
    case mileStone // 里程碑
    case normal // 普通
}

/// 任务状态
///
/// 任务状态
/// - 尚未开始
/// - 已经开始，正在进行
/// - 已经结束
enum TaskStatus {
    case notBegin // 尚未开始
    case going // 已经开始，正在进行
    case closed // 已经结束
}

/// 任务的原子化属性
///
/// 种类
/// - 原子化，不可拆解，容易衡量
/// - 非原子化，可拆解，不易衡量
///
/// 使用方法
/// - 评估自己的能力，充分利用好碎片时间
/// - 比如：读书，可以分成章节，继而再细分为第几章读多少页，每页的阅读时间，基本可以测量。当然不同书籍会不同，自己的精力不同（比如累了）也会不同。这恰恰是评估自己能力
/// - 比如：编写代码
enum TaskAtom {
    case atomic // 原子化
    case nonAtomic // 非原子化，可拆解
}

/// 精力集中度
///
/// 精力集中度类型
/// - 高度集中
/// - 普通
/// - 低集中
/// - 不能集中
enum FocusType {
    case high // 里程碑
    case normal // 普通
    case low // 低集中
    case cannot // 不能集中
}


/// 任务的频次类型，是否经常做，还是仅做1次
///
/// 频次类型
/// - 天天做，必须精通且熟练，这样可以大大提高效率
/// - 常做，必须熟练，这样可以提高效率
/// - 偶尔做，不太熟练，但知道如何去做
/// - 仅1次，经过分析知道如何去做
enum FrequencyType {
    case dayByDay // 天天做
    case often // 常做
    case occasionally // 偶尔做
    case onlyOneTime // 仅1次
}

class MelfTask {
    init(taskID: String, name: String) {
        self.taskID = taskID
        self.name = name
    }
    var taskID: String // 任务ID，唯一，不重复
    var name: String // 任务名称
    
    var isAtom: TaskAtom? //任务的原子化属性，原子化则不可分割
    
    var children: [MelfTask]? // 可能有多个孩子
    var parent: MelfTask? // 一个父亲
    var childIDs: [String]? // 孩子们
    var parentTaskID: String? // 父亲
    var dependentTaskIDs: [String]? // 依赖
    var relationTaskIDs: [String]? // 具有相关性
    
    var time_begin_plan : TimeInterval? // 计划的开始时间
    var time_begin_actual : TimeInterval? // 实际的开始时间
    
    var time_end_plan : TimeInterval? // 计划的结束时间
    var time_end_actual : TimeInterval? // 实际的结束时间

    var description: String? // 描述，可能没有
    
    var target: String? // 目标，可能没有
    
    var resource_required: String? // 需要的资源，可能没有
    
    var focus_required: FocusType? // 精力集中度
    
    var frequency_required: FrequencyType? // 任务的频次类型，是否经常做，还是仅做1次
    
    var level = 0
    
    /// 辅助
    var isHidden = false
    
    static func creatTasksForDemo() -> [MelfTask] {
        var result = [MelfTask]()
        
        do {
            let taskID = "taskID1"
            let name = "声音分析算法"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "算法包括：音量、频谱等。\n分两步走：\n1）使用MatLab工具，进行分析。\n2）使用Swift实现"
            task.description = description
            task.childIDs = ["taskID2", "taskID4"]
            task.level = 0
            result.append(task)
        }
        
        do {
            let taskID = "taskID2"
            let name = "使用MatLab工具，分析声音，包括音量、频谱等"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "分以下几步：\n1）基本掌握MatLab工具，包括开发环境、语言、调试运行等。\n2）声音分析"
            task.description = description
            task.childIDs = ["taskID3", "taskID5"]
            task.parentTaskID = "taskID1"
            task.level = 1
            result.append(task)
        }
        
        do {
            let taskID = "taskID3"
            let name = "基本掌握MatLab工具，包括开发环境、语言、调试运行等。"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "精读以下参考书并做练习：\n1）参考书1：《MATLAB程序设计》，[美]斯蒂芬·J·查普曼著。\n2）参考书2：《MATLAB程序设计》，薛定宇教授著"
            task.description = description
            task.parentTaskID = "taskID2"
            task.level = 2
            result.append(task)
        }
        
        do {
            let taskID = "taskID5"
            let name = "MatLab的声音分析"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "三种方法：\n1）google查找。\n2）MatLab参考文档。\n3)相关的数学及薛定宇教授的书"
            task.description = description
            task.parentTaskID = "taskID2"
            task.dependentTaskIDs = ["taskID3"]
            task.level = 2
            result.append(task)
        }
        
        do {
            let taskID = "taskID4"
            let name = "使用Swift实现，分析声音，包括音量、频谱等"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "参考刘的算法，详细内容，暂时不清楚"
            task.description = description
            task.parentTaskID = "taskID1"
            task.dependentTaskIDs = ["taskID2"]
            task.level = 1
            result.append(task)
        }
        
        
        
        for task in result {
            if let childIDs = task.childIDs {
                task.children = [MelfTask]()
                for childID in childIDs {
                    if let tmp = searchByTaskID(childID, tasks: result) {
                        task.children?.append(tmp)
                    }
                }
            }
        }

        return result
    }
    
    static func creatTasksForViolin() -> [MelfTask] {
        var result = [MelfTask]()
        
        do {
            let taskID = "taskID1001"
            let name = "小提琴"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "小提琴练习包括：音阶、练习曲、乐曲等。目标提升小提琴演奏水平。难点是音准。\n练习依曲目分类，包括：\n1）音阶练习。\n2）练习曲。\n3）乐曲，包括中国乐曲、外国乐曲。\n4）其他提升兴趣的音乐，比如动漫名曲、电影名曲、流行音乐等。"
            task.description = description
            task.childIDs = ["taskID1002", "taskID1004"]
            task.level = 0
            result.append(task)
        }
        
        do {
            let taskID = "taskID1002"
            let name = "音阶练习"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "分以下几步：\n1）新的音阶练习。\n2）复习原来的音阶"
            task.description = description
            task.childIDs = ["taskID1003", "taskID1005"]
            task.parentTaskID = "taskID1001"
            task.level = 1
            result.append(task)
        }
        
        do {
            let taskID = "taskID1003"
            let name = "新的音阶练习"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "包括以下音阶：\n1）上音.启蒙级.G大调。\n2）赵惟俭，音阶初级，G大调"
            task.description = description
            task.childIDs = ["taskID1006"]
            task.parentTaskID = "taskID1002"
            task.level = 2
            result.append(task)
        }
        
        do {
            let taskID = "taskID1006"
            let name = "新的音阶练习：上音.启蒙级.G大调"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "先慢后快，\n流程：示范、视唱、找音、演奏，\n整个乐谱"
            task.description = description
            task.parentTaskID = "taskID1003"
            task.level = 3
            task.resource_required = "乐谱：上音.启蒙级.G大调" // 关联乐精灵
            result.append(task)
        }
        
        do {
            let taskID = "taskID1005"
            let name = "复习原来的音阶"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "三种方法：\n1）google查找。\n2）MatLab参考文档。\n3)相关的数学及薛定宇教授的书"
            task.description = description
            task.parentTaskID = "taskID1002"
            task.dependentTaskIDs = ["taskID1003"]
            task.level = 2
            result.append(task)
        }
        
        do {
            let taskID = "taskID1004"
            let name = "使用Swift实现，分析声音，包括音量、频谱等"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "参考刘的算法，详细内容，暂时不清楚"
            task.description = description
            task.parentTaskID = "taskID1001"
            task.dependentTaskIDs = ["taskID1002"]
            task.level = 1
            result.append(task)
        }
        
        for task in result {
            if let childIDs = task.childIDs {
                task.children = [MelfTask]()
                for childID in childIDs {
                    if let tmp = searchByTaskID(childID, tasks: result) {
                        task.children?.append(tmp)
                    }
                }
            }
        }

        return result
    }
    
    /// OnGoing的程序设计列表
    static func creatTasksForOnGoing() -> [MelfTask] {
        var result = [MelfTask]()
        
        do {
            let taskID = "taskID2001"
            let name = "OnGoing的程序设计"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "OnGoing的程序设计，卖点：充分发挥自己的工作效率。原则如下：\n1）充分利用好碎片时间，解决想做却没有做，随着时间的流逝，回头看浪费了很多光阴。\n2）将任务分解为马上可执行，与碎片时间匹配，\n3）了解自己的精力集中度的分布及适合做的事项。\n4）能力的培养，提升软实力。"
            task.description = description
            task.childIDs = ["taskID2002", "taskID2004"]
            task.level = 0
            result.append(task)
        }
        
        do {
            let taskID = "taskID2002"
            let name = "场景界面规划"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "以简洁为原则，包括以下界面：\n1）当下关注的任务，可以前后翻。\n2）任务台，分配任务，可以进入任务的操作：编辑、删除、新增。\n3）新增任务。\n4）编辑任务。\n5）删除任务。"
            task.description = description
            task.childIDs = ["taskID2003", "taskID2005", "taskID2007"]
            task.parentTaskID = "taskID2001"
            task.level = 1
            result.append(task)
        }
        
        do {
            let taskID = "taskID2003"
            let name = "新增任务"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "载入任务视图，权限为编辑，任务为新任务。操作说明：\n1）导航栏菜单，包括：存储、删除。\n2）当任务保存后，删除按钮方才出现"
            task.description = description
            task.childIDs = ["taskID2006"]
            task.parentTaskID = "taskID2002"
            task.level = 2
            result.append(task)
        }
        
        do {
            let taskID = "taskID2006"
            let name = "任务视图"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "通用，可以用在多个场景，比如关注的任务、任务台、新增任务、编辑任务。\n1）可以滚动。\n2）大小可以调整，更好地匹配场景"
            task.description = description
            task.parentTaskID = "taskID2003"
            task.level = 3
            task.resource_required = "苹果的UIKit"
            result.append(task)
        }
        
        do {
            let taskID = "taskID2007"
            let name = "关注的任务"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "如果有关注的任务，则在首页显示，如果没有则首页显示任务台。设计要点：\n1）关注任务的存储，存储在本地，直接读取。\n2）从故事版调取首页，需要研究。"
            task.description = description
            task.childIDs = ["taskID2008"]
            task.parentTaskID = "taskID2002"
            task.level = 2
            task.resource_required = "阅读文档，查找解决方案"
            result.append(task)
        }
        
        do {
            let taskID = "taskID2008"
            let name = "关注任务的本地存储"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "既然本地存储，必须可以删除，遵循先进先出的原则，不能太多（小于3），否则失去意义。"
            task.description = description
            task.parentTaskID = "taskID2007"
            task.level = 3
            task.resource_required = "苹果的UIKit"
            result.append(task)
        }
        
        
        do {
            let taskID = "taskID2005"
            let name = "任务台"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "三个区域：\n1）任务详细描述，可以滚动。\n2）统计。\n3)任务列表，可以滚动。\n难点：任务排序及显示"
            task.description = description
            task.parentTaskID = "taskID2002"
            task.dependentTaskIDs = ["taskID2003"]
            task.level = 2
            result.append(task)
        }
        
        do {
            let taskID = "taskID2004"
            let name = "开发技术"
            let task = MelfTask(taskID: taskID, name: name)
            let description = "1）表单技术。\n2）图片image。\n3）存储技术：Core Data、SQLite。\n4）导航栏菜单。\n5）场景切换。\n6）颜色。\n7）事件触发。"
            task.description = description
            task.parentTaskID = "taskID2001"
            task.dependentTaskIDs = ["taskID2002"]
            task.level = 1
            result.append(task)
        }
        
        for task in result {
            if let childIDs = task.childIDs {
                task.children = [MelfTask]()
                for childID in childIDs {
                    if let tmp = searchByTaskID(childID, tasks: result) {
                        task.children?.append(tmp)
                    }
                }
            }
        }

        return result
    }
    
    static func createAllTasks() -> [MelfTask] {
        let result = MelfTask.creatTasksForDemo()
        let result2 = MelfTask.creatTasksForViolin()
        let result3 = MelfTask.creatTasksForOnGoing()
        
        return result + result2 + result3
    }
    
    static func searchByTaskID(_ taskID: String, tasks: [MelfTask]) -> MelfTask? {
        for task in tasks {
            if task.taskID == taskID {
                return task
            }
        }
        
        return nil
    }
}
