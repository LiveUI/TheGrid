//
//  ViewController.swift
//  Hagrid
//
//  Created by Ondrej Rafaj on 29/05/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import UIKit
import TheGrid
import Modular


class ViewController: GridViewController {

    // MARK: Example app
    
    let albumCover = UIImageView()

    let albumTitleLabel = UILabel()
    let artistLabel = UILabel()
    let yearLabel = UILabel()
    let purchaseButton = UIButton()
    let ratingLabel = UILabel()
    
    let separator = UIView()

    /// Create album cover
    func configureAlbumCover() {
        albumCover.backgroundColor = .random
        albumCover.image = UIImage(named: "TestData/AlbumCover")
        albumCover.contentMode = .scaleAspectFill
        albumCover.clipsToBounds = true
        albumCover.layer.cornerRadius = 3
        
        gridView.add(subview: albumCover, from: 0, space: 5) { make in
            make.height.equalTo(self.albumCover.snp.width)
        }
    }

    /// Create album labels
    func configureAlbumLabels() {
        let albumCoverRelation = Position.relation(albumCover, margin: 0)
        albumTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        albumTitleLabel.text = "Ten"
        albumTitleLabel.textColor = .darkText
        gridView.add(subview: albumTitleLabel, from: albumCoverRelation, space: Position.last, padding: .left(12))
        
        artistLabel.font = UIFont.systemFont(ofSize: 15)
        artistLabel.text = "Pearl Jam"
        artistLabel.textColor = .gray
        gridView.add(subview: artistLabel, .below(albumTitleLabel, margin: 2), from: albumCoverRelation, space: Position.reversed(2), padding: .horizontal(left: 12, right: 6))

        yearLabel.font = UIFont.systemFont(ofSize: 12)
        yearLabel.text = "Released: 1991"
        yearLabel.textColor = .gray
        gridView.add(subview: yearLabel, .below(artistLabel, margin: 2), from: albumCoverRelation, space: Position.reversed(2), padding: .horizontal(left: 12, right: 6))
        
        
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 34)
        ratingLabel.text = "* * * * *"
        ratingLabel.textColor = .orange
        gridView.add(subview: ratingLabel, .above(separator, margin: 12), from: Position.dynamic, space: Position.last) { make in
            make.height.equalTo(28)
        }
        
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        gridView.add(subview: separator, .row([albumCover, yearLabel], margin: 12)) { make in
            make.height.equalTo(1)
        }
        
        let aboutLabel = UILabel()
        aboutLabel.font = UIFont.systemFont(ofSize: 12)
        aboutLabel.numberOfLines = 0
        aboutLabel.text = """
        Ten is the debut studio album by American rock band Pearl Jam, released on August 27, 1991 through Epic Records. Following the disbanding of bassist Jeff Ament and guitarist Stone Gossard's previous group Mother Love Bone, the two recruited vocalist Eddie Vedder, guitarist Mike McCready, and drummer Dave Krusen to form Pearl Jam in 1990. Most of the songs began as instrumental jams, to which Vedder added lyrics about topics such as depression, homelessness, and abuse.
        
        Ten was not an immediate success, but by late 1992 it had reached number two on the Billboard 200 chart. The album produced three hit singles: "Alive", "Even Flow", and "Jeremy". While Pearl Jam was accused of jumping on the grunge bandwagon at the time—despite the fact that Ten had been both recorded and released before Nirvana's Nevermind — Ten was instrumental in popularizing alternative rock in the mainstream. In February 2013, the album crossed the 10 million mark in sales, becoming the 22nd one to do so in the Nielsen SoundScan era and has been certified 13× platinum by the RIAA. It remains Pearl Jam's most commercially successful album.
        """
        aboutLabel.textColor = .darkText
        gridView.add(subview: aboutLabel, .below(separator, margin: 12))
    }
    
    /// Configure purchase button
    func configurePurchaseButton() {
        purchaseButton.layer.borderWidth = 1
        purchaseButton.layer.borderColor = purchaseButton.tintColor.cgColor
        purchaseButton.layer.cornerRadius = 4
        purchaseButton.setTitle("Buy £", for: .normal)
        purchaseButton.setTitleColor(purchaseButton.tintColor, for: .normal)
        purchaseButton.setTitleColor(.lightGray, for: .highlighted)
        purchaseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        gridView.add(subview: purchaseButton, from: Position.relation(artistLabel, margin: 6), space: Position.last) { make in
            make.top.equalTo(self.artistLabel)
            make.height.equalTo(28)
        }
    }

    /// Add all subviews on the canvas
    func addSubviews() {
        configureAlbumCover()
        configureAlbumLabels()
        configurePurchaseButton()
    }
    
    // MARK: Other interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupGridView()
        
        navigationController?.navigationBar.isTranslucent = false
        gridView.backgroundColor = .white
    }
    
    func setupNavBar() {
        title = "HaGrid"
        
        let columns = UISegmentedControl(items: ["12", "15", "18"])
        columns.addTarget(self, action: #selector(selectColumns(_:)), for: .valueChanged)
        columns.selectedSegmentIndex = 0
        let columnsItem = UIBarButtonItem(customView: columns)
        navigationItem.leftBarButtonItem = columnsItem
        
        let toggle = UIBarButtonItem(title: "Debug", style: .plain, target: self, action: #selector(toggleGrid))
        navigationItem.rightBarButtonItem = toggle
    }
    
    func setupGridView() {
        toggleGrid()
        
        gridView.config.padding = .full(top: 6, left: 12, right: 12)
        
        addSubviews()
    }
    
    // MARK: Actions
    
    @objc func selectColumns(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
            if sender.selectedSegmentIndex == 0 {
                self.gridView.config.numberOfColumns = 12
            } else if sender.selectedSegmentIndex == 1 {
                self.gridView.config.numberOfColumns = 15
            } else {
                self.gridView.config.numberOfColumns = 18
            }
        })
    }
    
    @objc func toggleGrid() {
        gridView.config.displayGrid = !gridView.config.displayGrid
        
        let debugColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        albumTitleLabel.backgroundColor = gridView.config.displayGrid ? debugColor : .clear
        artistLabel.backgroundColor = gridView.config.displayGrid ? debugColor : .clear
        yearLabel.backgroundColor = gridView.config.displayGrid ? debugColor : .clear
        ratingLabel.backgroundColor = gridView.config.displayGrid ? debugColor : .clear
    }

}
