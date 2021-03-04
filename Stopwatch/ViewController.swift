//
//  ViewController.swift
//  Stopwatch
//
//  Created by 이현호 on 2020/05/28.
//  Copyright © 2020 tempYsoup. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    private var laps: [String] = []
    private var lapsDiff: [String] = []
    private let mainStopwatch: Stopwatch = Stopwatch()
    private let labStopwatch: Stopwatch = Stopwatch()
    private var isPlaying: Bool = false

    private let timeInterval: Double = 0.035
    private let minute: Double = 60

    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var lapResetButton: UIButton!
    @IBOutlet weak var mainTimerLabel: UILabel!
    @IBOutlet weak var labTimerLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    
    
    let initCircleButton: (UIButton) -> Void = { button in
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = UIColor.white
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCircleButton(playPauseButton)
        initCircleButton(lapResetButton)
        initalizeButtons()
        
        lapsTableView.delegate = self;
        lapsTableView.dataSource = self;
    }
    

    @IBAction func playPauseTimer(_ sender: AnyObject) {
        lapResetButton.isEnabled = true
        if isPlaying {
            pauseTimer()
        } else {
            playTimer()
        }
    }
    
    
    @IBAction func lapResetTimer(_ sender: AnyObject) {
        if isPlaying {
            if let timerLabelText = mainTimerLabel.text {
                laps.append(timerLabelText)
            }
            if let labLabelText = labTimerLabel.text {
                lapsDiff.append(labLabelText)
            }
            
            labStopwatch.counter = 0.0
            labTimerLabel.text = "00:00:00"
            
            lapsTableView.reloadData()
        } else {
            initalizeButtons()
        }
    }
    
    
    @objc func updateMainTimer() {
        updateTimer(mainStopwatch, label: mainTimerLabel)
    }
    
    
    @objc func updateLabTimer() {
        updateTimer(labStopwatch, label: labTimerLabel)
    }
    
    
    private func pauseTimer() {
        mainStopwatch.timer.invalidate()
        labStopwatch.timer.invalidate()
        
        self.isPlaying = false
        
        changeButton(button: lapResetButton, title: "START", titleColor: .black)
        changeButton(button: playPauseButton, title: "RESUME", titleColor: .green)
    }
    
    
    private func playTimer() {
        mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
        labStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(updateLabTimer), userInfo: nil, repeats: true)
        
        RunLoop.current.add(mainStopwatch.timer, forMode: RunLoop.Mode.common)
        RunLoop.current.add(labStopwatch.timer, forMode: RunLoop.Mode.common)
        
        self.isPlaying = true

        changeButton(button: lapResetButton, title: "LAB", titleColor: .black)
        changeButton(button: playPauseButton, title: "STOP", titleColor: .red)
    }
    
    
    private func changeButton(button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
    }
    
    
    private func resetTimer(stopWatch: Stopwatch, label: UILabel) {
        stopWatch.timer.invalidate()
        stopWatch.counter = 0.0
        label.text = "00:00:00"
    }
    
    
    private func initalizeButtons() {
        lapResetButton.isEnabled = false
        changeButton(button: lapResetButton, title: "LAB", titleColor: .gray)
        changeButton(button: playPauseButton, title: "START", titleColor: .green)
        
        resetTimer(stopWatch: mainStopwatch, label: mainTimerLabel)
        resetTimer(stopWatch: labStopwatch, label: labTimerLabel)
        
        laps.removeAll()
        lapsTableView.reloadData()
    }

    
    private func updateTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.counter = stopwatch.counter + timeInterval
        
        var minutes: String = String(Int(stopwatch.counter / minute))
        if Int(stopwatch.counter / minute) < 10 {
            minutes = "0" + minutes
        }
        
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: minute)))
        if stopwatch.counter.truncatingRemainder(dividingBy: minute) < 10 {
            seconds = "0" + seconds
        }
        
        label.text = minutes + ":" + seconds
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        
        if let labelNum = cell.viewWithTag(11) as? UILabel {
            labelNum.text = "Lap \(laps.count - (indexPath as NSIndexPath).row)"
        }
        if let mainLabelTimer = cell.viewWithTag(12) as? UILabel {
            mainLabelTimer.text = laps[laps.count - (indexPath as NSIndexPath).row - 1]
        }
        if let labLabelTimer = cell.viewWithTag(13) as? UILabel {
            labLabelTimer.text = "+" + lapsDiff[laps.count - (indexPath as NSIndexPath).row - 1]
        }
        
        return cell
    }
    
    
}
