//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }
    func updateWithDate(day:Int,month:Int,year:Int)
    {
        self.day.text = "\(day)"
        let dateComponents = DateComponents(year: year, month: month,day:day)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            weekday.text = dateFormatter.string(from: date)
        }
        
        
    }
}
