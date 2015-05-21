//
//  AppConstants.swift
//  TestToDo
//
//  Created by Kosuke Matsuda on 2015/05/21.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import Foundation

struct AppConstants {
    struct StoryboardIdentifier {
        static let Picker = "PickerController"
        static let DatePicker = "DatePickerController"
    }
    struct SegueIdentifier {
        static let ShowDetail = "showDetail"
        static let CreateData = "createData"
        static let EditData = "editData"
    }
    struct PageTitle {
        static let ToDoList = "ToDo一覧"
        static let ToDoCreate = "TODO作成"
        static let ToDoEdit = "TODO編集"
    }
}
