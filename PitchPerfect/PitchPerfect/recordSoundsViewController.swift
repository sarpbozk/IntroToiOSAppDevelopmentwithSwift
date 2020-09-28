//
//  recordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Bozkurt on 9/26/20.
//  Copyright © 2020 Bozkurt. All rights reserved.
//

import UIKit
import AVFoundation

class recordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    override func viewDidLoad() {
        super.viewDidLoad()
        StopRecording.isEnabled=false
        // Do any additional setup after loading the view.
    }

    @IBAction func redAudio(_ sender: Any) {
        print("rec button was pressed")
        recordingLabel.text = "recording"
        StopRecording.isEnabled=true
        REC.isEnabled=false
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
           let recordingName = "recordedVoice.wav"
           let pathArray = [dirPath, recordingName]
           let filePath = URL(string: pathArray.joined(separator: "/"))
            print(filePath)
           let session = AVAudioSession.sharedInstance()
           try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        print("recordinf stopped")
        REC.isEnabled=true
        StopRecording.isEnabled=false
        recordingLabel.text="tap to record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBOutlet weak var REC: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var StopRecording: UIButton!
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecordingsag", sender: audioRecorder.url)
        
        }
        else{
            print("recording not successfull")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingsag" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

