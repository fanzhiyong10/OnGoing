//
//  CommonFunctions.swift
//  OnGoing
//
//  Created by 范志勇 on 2022/8/14.
//

import Foundation

/**
 # 延时器
 1. 精度：纳秒
 2. 异步处理
 DispatchTime represents a point in time relative to the default clock with nanosecond precision. On Apple platforms, the default clock is based on the Mach absolute time unit.
 */
func delay(_ delay:Double, closure:@escaping ()->()) {
    /**
     # 当前时间 + 延时（以秒为单位）
     1. 当前时间：DispatchTime.now()
     2. 延时数：double，以秒为单位
     */
    let when = DispatchTime.now() + delay
    
    /**
     # 延时到后，启动进程
     1. 线程池，主队列
     2. DispatchWorkItem：closure
     
     DispatchQueue manages the execution of work items. Each work item submitted to a queue is processed on a pool of threads managed by the system.
     DispatchWorkItem encapsulates work that can be performed. A work item can be dispatched onto a DispatchQueue and within a DispatchGroup. A DispatchWorkItem can also be set as a DispatchSource event, registration, or cancel handler.
     */
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
