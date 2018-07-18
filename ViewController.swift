//
//  ViewController.swift
//  VoTest
//
//  Created by Alexei Dudarev on 18/07/2018.
//  Copyright © 2018 Alexei Dudarev. All rights reserved.
//

import UIKit
struct MusicModel {
    var author : String!
    var songs : [String]!
    var choosenSong : Int!
}

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    var songsData : [MusicModel] = []
    var tableData : [MusicModel] = []
    var swipedRow : Int!
    
    @IBOutlet weak var songsTableView: UITableView!
    var numberOfRowsInTable : Int = 0 {
        didSet{
            numberOfRowsInTable = tableData.count
        }
    }
    var choosenSong : Int = 0{
        didSet{
            
            if choosenSong >= songsData.count{
                choosenSong = 0
            }else if choosenSong < 0 {
                choosenSong = songsData.count - 1
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let firstAuthor : MusicModel = MusicModel(author: "Sting", songs: ["song1","song2","song3","song4"], choosenSong: 0)
        let sectAuthor : MusicModel = MusicModel(author: "Modo", songs: ["song1","song2","song3","song4"], choosenSong: 0)
        let thrdtAuthor : MusicModel = MusicModel(author: "Scooter", songs: ["song1","song2","song3","song4"], choosenSong: 0)
        let fourthAuthor : MusicModel = MusicModel(author: "Mozart", songs: ["song1","song2","song3","song4"], choosenSong: 0)
        songsData.append(firstAuthor)
        songsData.append(sectAuthor)
        songsData.append(thrdtAuthor)
        songsData.append(fourthAuthor)
        
        songsTableView.delegate = self
        songsTableView.dataSource = self
     
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInTable
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MusicCell = (self.songsTableView.dequeueReusableCell(withIdentifier: "musicCell") as? MusicCell)!
        cell.backgroundColor = UIColor.brown
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(sender: )))
           swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        let swapRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRigth(sender:)))
            swapRight.direction = UISwipeGestureRecognizerDirection.right
        
        cell.songLbl.addGestureRecognizer(swipeLeft)
        cell.songLbl.addGestureRecognizer(swapRight)
        cell.songLbl.isUserInteractionEnabled = true
        cell.songLbl.textAlignment = .center
        cell.songLbl.tag = indexPath.row
        if swipedRow == indexPath.row{
            var songs = tableData[swipedRow].songs
            cell.songLbl.text = songs?[choosenSong]
            cell.songPageControl.currentPage = choosenSong
            tableData[swipedRow].choosenSong = choosenSong
            cell.authorLbl.text = tableData[swipedRow].author
        }else{
            var songs = tableData[indexPath.row].songs
            print(tableData[indexPath.row].songs)
            cell.songLbl.text = songs?[tableData[indexPath.row].choosenSong]
            cell.songPageControl.currentPage = tableData[indexPath.row].choosenSong
            cell.authorLbl.text = tableData[indexPath.row].author
        }
        
        
        
        return cell
    }
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        print("swiped row : \(swipedRow)")
        swipedRow = (sender.view?.tag)!
        choosenSong = choosenSong - 1
        print("choosen song :\(choosenSong)")
        songsTableView.reloadData()
        
    }
    @objc func swipeRigth(sender: UISwipeGestureRecognizer){
        swipedRow = (sender.view?.tag)!
        print("swiped row : \(swipedRow)")
        choosenSong = choosenSong + 1
        print("choosen song :\(choosenSong)")
        songsTableView.reloadData()
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        
        print("song dtat count:\(songsData.count )")
        print("table data count : \(tableData.count)")
        if numberOfRowsInTable < songsData.count{
            
            for index in tableData.count...numberOfRowsInTable {
               
                tableData.append(songsData[index])
            }
        }
        numberOfRowsInTable = tableData.count
        print("number of rows :\(numberOfRowsInTable)")
      
        songsTableView.reloadData()
        print(tableData.count)
        print(tableData)
        
    }
    
}

