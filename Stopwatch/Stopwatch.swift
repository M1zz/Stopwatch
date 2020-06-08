//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by 이현호 on 2020/06/06.
//  Copyright © 2020 tempYsoup. All rights reserved.
//

import Foundation

class Stopwatch: NSObject {
  var counter: Double
  var timer: Timer
  
  override init() {
    counter = 0.0
    timer = Timer()
  }
}
