//
//  ShowTranscriptionViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 26/08/22.
//

import UIKit
import FirebaseStorage
/**
 Displays a transcription, the source of this transcription can be either local or remote
 */
class ShowTranscriptionViewController: UIViewController {
    var filepath: String?
    var filename: String?
    var remote = true

    @IBOutlet weak var transcriptionTitle: UILabel!
    @IBOutlet weak var transcriptionView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        transcriptionTitle.text = filename
        if remote {
            loadFileToTextRemote()
        } else {
            loadFileToTextLocal()
        }
        // Do any additional setup after loading the view.
    }
    
    /**
     Handles loading of files in the case where they are stored in a remote bucket.
     */
    func loadFileToTextRemote() {
        let storage = Storage.storage()
        let path = filepath! + "/" + filename!
        let pathRef = storage.reference(withPath: path)
        pathRef.getData(maxSize: 4 * 1024 * 1024) {data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.transcriptionView.text = String(decoding: data!, as: UTF8.self)
            }
        }
    }

    /**
     Handles loading of files in the case they are stored locally.
     */
    func loadFileToTextLocal() {
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let currDir = url.appendingPathComponent("Transcriptions/")
        let fullPath = currDir.appendingPathComponent(filename!)
        do {
            let data = try String(contentsOfFile: fullPath.path, encoding: .utf8)
            self.transcriptionView.text = data
        } catch {
            print("An error has occurred in reading file")
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
