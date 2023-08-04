//
//  Config.swift
//  WechatHome
//
//  Created by 顾钱想 on 2023/1/5.
//

import UIKit

/// 屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height
/// 导航栏高度 固定高度 = 44.0f
let k_Height_NavContentBar: CGFloat = 44.0
/// 状态栏高度
let k_Height_StatusBar: CGFloat = {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let statusBarManager = windowScene.statusBarManager else { return 0 }
        statusBarHeight = statusBarManager.statusBarFrame.height
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}()

let k_safeDistanceBottom: CGFloat = {
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let window = windowScene.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    } else if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    }
    return 0;
}()


/// 底部导航栏高度
let k_tabBarHeight: CGFloat = {
    return 49.0
}()

let k_tabBarFullHeight: CGFloat = {
    return k_tabBarHeight + k_safeDistanceBottom
}()



