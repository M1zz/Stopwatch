//
//  ViewController.swift
//  Stopwatch
//
//  Created by 이현호 on 2020/05/28.
//  Copyright © 2020 tempYsoup. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var lapResetButton: UIButton!
    @IBOutlet weak var mainTimerLabel: UILabel!
    @IBOutlet weak var labTimerLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    
    private var laps: [String] = []
    private var lapsDiff: [String] = []
    
    private let mainStopwatch: Stopwatch = Stopwatch()
    private let labStopwatch: Stopwatch = Stopwatch()
    
    private var isPlaying: Bool = false
    
    let initCircleButton: (UIButton) -> Void = { button in
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCircleButton(playPauseButton)
        initCircleButton(lapResetButton)
        buttonInitalize()
        
        lapsTableView.delegate = self;
        lapsTableView.dataSource = self;
        
    }
    
    private func buttonInitalize() {
        lapResetButton.isEnabled = false
        lapResetButton.setTitle("LAB", for: .normal)
        lapResetButton.setTitleColor(.gray, for: .normal)
        
        mainStopwatch.timer.invalidate()
        mainStopwatch.counter = 0.0
        mainTimerLabel.text = "00:00:00"
        
        labStopwatch.timer.invalidate()
        labStopwatch.counter = 0.0
        labTimerLabel.text = "00:00:00"
        
        laps.removeAll()
        lapsTableView.reloadData()
    }
    
    @IBAction func playPauseTimer(_ sender: AnyObject) {
        if isPlaying {
            // stop
            self.isPlaying = false
            
            lapResetButton.isEnabled = true
            lapResetButton.setTitle("RESET", for: .normal)
            lapResetButton.setTitleColor(.black, for: .normal)
            
            playPauseButton.setTitle("START", for: .normal)
            playPauseButton.setTitleColor(.green, for: .normal)
            
            mainStopwatch.timer.invalidate()
            labStopwatch.timer.invalidate()
            
        } else {
            // start
            self.isPlaying = true
            
            lapResetButton.isEnabled = true
            lapResetButton.setTitle("LAB", for: .normal)
            lapResetButton.setTitleColor(.black, for: .normal)
            
            playPauseButton.setTitle("STOP", for: .normal)
            playPauseButton.setTitleColor(.red, for: .normal)
            
            unowned let weakSelf = self
            
            mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
            labStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: #selector(updateLabTimer), userInfo: nil, repeats: true)
            
            RunLoop.current.add(mainStopwatch.timer, forMode: RunLoop.Mode.common)
            RunLoop.current.add(labStopwatch.timer, forMode: RunLoop.Mode.common)
        }
        
    }
    
    @IBAction func lapResetTimer(_ sender: AnyObject) {
        if isPlaying {
            // Lab
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
            // Reset
            buttonInitalize()
        }
    }
    
    @objc func updateMainTimer() {
        updateTimer(mainStopwatch, label: mainTimerLabel)
    }
    @objc func updateLabTimer() {
        updateTimer(labStopwatch, label: labTimerLabel)
    }
    
    func updateTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.counter = stopwatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
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
        let identifier: String = "lapCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
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
