//
//  Entry.swift
//  TestToDo
//
//  Created by Kosuke Matsuda on 2015/05/14.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

enum EntryProperty {
    case Title, Priority, CreatedAt, Memo
    func toString() -> String {
        switch self {
        case .Title:
            return "タイトル"
        case .Priority:
            return "優先度"
        case .CreatedAt:
            return "作成日"
        case .Memo:
            return "内容"
        }
    }
    static func all() -> [EntryProperty] {
        return [.Title, .Priority, .CreatedAt, .Memo]
    }
}

class Entry: NSObject {

    enum Priority: Int {
        case Row = -1
        case Normal
        case High
        func toString() -> String {
            switch self {
            case .Row:
                return "高"
            case .Normal:
                return "中"
            case .High:
                return "低"
            }
        }
    }

    static var dateFormatter = NSDateFormatter()

    var title: String?
    var memo: String?
    var createdAt: NSDate
    var priority: Priority = .Normal
//    var category: String?

    var createdAtAsString: String {
        get {
            var formatter = Entry.dateFormatter
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            return formatter.stringFromDate(self.createdAt)
        }
    }
    override init() {
        self.createdAt = NSDate()
        super.init()
    }
}

extension Entry {
    class func mocks(count: Int) -> [Entry] {
        var objs: [Entry] = []
        for var i = 0; i < count; i++ {
            objs.append(mock(i))
        }
        return objs
    }

    class func mock(idx: Int) -> Self {
        var obj = mock()
        obj.assignDataForMock(idx)
        return obj
    }

    class func mock() -> Self {
        var obj = self.init()
        obj.assignDataForMock(0)
        return obj
    }

    func assignDataForMock(idx: Int) {
        self.title = "title : \(idx)"
        self.memo = ""
        for i in 0...(idx+1) {
            self.memo! += "memo : \(i)"
        }
        switch idx % 5  {
        case 0:
            self.priority = .High
        case 2:
            self.priority = .Row
        default:
            break
        }
    }
}
