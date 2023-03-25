//
//  TranscriptionViewController.swift
//  StudyShare
//
//  - simulator catch for the moment: you need to press several times
//    start/stop transcription before it works
//  - 60seconds apple limit patch does not work in simulator!
//  - line 97 contains the final result to save
//
//  Created by CGi on 12/08/22.
//
import UIKit
import Speech
import AVKit
/**
 Allows the user to create a transcription from audio and save it locally
 */
class TranscriptionViewController: UIViewController, SFSpeechRecognizerDelegate {
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var fileNameField: UITextField!
    @IBOutlet weak var transcriptionText: UITextView!
    @IBOutlet weak var beginButton: UIButton!
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-EN"))
    var recognitionTask: SFSpeechRecognitionTask?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    let audioEngine = AVAudioEngine()

    func setupSpeech() {
        self.beginButton?.isEnabled = true
        self.speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
            case .notDetermined:
                isButtonEnabled = false
            case .restricted:
                isButtonEnabled = false
            @unknown default:
                fatalError()
            }
            OperationQueue.main.addOperation {
                self.beginButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        if #available(iOS 13, *) { // patch around the 60seconds apple limit, does not work in simulator!
            self.recognitionRequest?.requiresOnDeviceRecognition = true
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
        }
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if result != nil {
                self.transcriptionText.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                //self.transcriptionText.text! << this final to save!
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine encountered an error.")
        }
        self.transcriptionText.text = "Start speaking"
        self.beginButton?.setTitle("Stop", for: .normal)
    }
    
    override func viewDidLoad() {
        self.beginButton?.isEnabled = true
        super.viewDidLoad()
        self.setupSpeech()
        self.feedbackLabel.alpha = 0
        User.currentScreen = "transcription"
        // make the keyboard disappear, when click outside fields
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func beginButtonTapped(_ sender: UIButton) {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.beginButton?.setTitle("Start Transcription", for: .normal)
        } else {
            self.startRecording()
            self.beginButton?.setTitle("Recording in progress... Tap to stop", for: .normal)
        }
    }

    @IBAction func saveTapped(_ sender: UIButton) {
        let saveFileName = fileNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "_")
        let saveError = saveValidate(fileName: saveFileName)
        if saveError != nil {
            showLabel(saveError!, true)
        } else {
            let saveData = transcriptionText.text!.data(using: .utf8)
            let manager = FileManager.default
            guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let transDir = url.appendingPathComponent("Transcriptions")
            print(transDir)
            let filePath = transDir.appendingPathComponent(saveFileName)
            do {
                try manager.createDirectory(at: transDir, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
            manager.createFile(atPath: filePath.path + ".txt", contents: saveData)
            showLabel("Successfully created file " + saveFileName + ".txt", false)
        }
    }

    /**
    Sets label to the given String
     - Parameters:
            - message: String: The message to display
            - error: Bool True if this is an error, False if feedback
    */
    func showLabel(_ message: String, _ error: Bool) {
        if error {
            feedbackLabel.textColor = UIColor.red
        } else {
            feedbackLabel.textColor = UIColor.green
        }
        feedbackLabel.text = message
        feedbackLabel.alpha = 1
    }

    func saveValidate(fileName: String) -> String? {
        if !transcriptionText.hasText {
            return "No text to save"
        } else if fileName.isEmpty {
            return "Please specify a filename"
        }
        return nil
    }

    @IBAction func backTapped(_ sender: Any) {
        User.currentScreen = "home"
        self.dismiss(animated: true, completion: nil)
    }
}
