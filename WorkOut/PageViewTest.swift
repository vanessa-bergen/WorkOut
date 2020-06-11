//
//  PageViewTest.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-09.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct PageViewTest: View {
    @State private var currentPage = 0
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        NavigationView {
        PagerView(pageCount: 3, currentIndex: $currentPage) {
//            PageView1(currentPage: $currentPage)
//            SetTimesView(currentPage: $currentPage)
            Color.blue
            Color.green
        }
        .environment(\.managedObjectContext, self.moc)
        }
    }
}

struct PageViewTest_Previews: PreviewProvider {
    static var previews: some View {
        PageViewTest()
    }
}
