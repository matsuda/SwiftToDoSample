//
//  AppDefines.swift
//  AsahiAd
//
//  Created by Kosuke Matsuda on 2015/04/30.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import Foundation

func APPLOG(_ body: AnyObject! = "", function: String = __FUNCTION__, line: Int = __LINE__) {
#if DEBUG
    println("[\(function):\(line)] \(body)")
#endif
}
