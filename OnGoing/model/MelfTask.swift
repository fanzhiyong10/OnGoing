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

struct MelfTask {
    var taskID: String // 任务ID，唯一，不重复
    var name: String // 任务名称
    
    var isAtom: TaskAtom? //任务的原子化属性，原子化则不可分割
    
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
    
    static func creatTasksForDemo() -> [MelfTask] {
        var result = [MelfTask]()
        
        do {
            let taskID = "taskID1"
            let name = "声音分析算法"
            var task = MelfTask(taskID: taskID, name: name)
            let description = "算法包括：音量、频谱等。\n分两步走：\n1）使用MatLab工具，进行分析。\n2）使用Swift实现"
            task.description = description
            task.childIDs = ["taskID2", "taskID4"]
            result.append(task)
        }
        
        do {
            let taskID = "taskID2"
            let name = "使用MatLab工具，分析声音，包括音量、频谱等"
            var task = MelfTask(taskID: taskID, name: name)
            let description = "分以下几步：\n1）基本掌握MatLab工具，包括开发环境、语言、调试运行等。\n2）声音分析"
            task.description = description
            task.childIDs = ["taskID3", "taskID5"]
            task.parentTaskID = "taskID1"
            result.append(task)
        }
        
        do {
            let taskID = "taskID3"
            let name = "基本掌握MatLab工具，包括开发环境、语言、调试运行等。"
            var task = MelfTask(taskID: taskID, name: name)
            let description = "精读以下参考书并做练习：\n1）参考书1：《MATLAB程序设计》，[美]斯蒂芬·J·查普曼著。\n2）参考书2：《MATLAB程序设计》，薛定宇教授著"
            task.description = description
            task.parentTaskID = "taskID2"
            result.append(task)
        }
        
        do {
            let taskID = "taskID5"
            let name = "MatLab的声音分析"
            var task = MelfTask(taskID: taskID, name: name)
            let description = "三种方法：\n1）google查找。\n2）MatLab参考文档。\n3)相关的数学及薛定宇教授的书"
            task.description = description
            task.parentTaskID = "taskID2"
            task.dependentTaskIDs = ["taskID3"]
            result.append(task)
        }
        
        do {
            let taskID = "taskID4"
            let name = "使用Swift实现，分析声音，包括音量、频谱等"
            var task = MelfTask(taskID: taskID, name: name)
            let description = "参考刘的算法，详细内容，暂时不清楚"
            task.description = description
            task.parentTaskID = "taskID1"
            task.dependentTaskIDs = ["taskID2"]
            result.append(task)
        }

        return result
    }
}
