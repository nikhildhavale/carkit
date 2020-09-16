//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDate(_ date: Date)
}
struct CalendarConstant
{
    static let jan = 1
    static let dec = 12
}
class CalendarView: UIView {

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    var currentMonth = 0
    var currentYear = 0
    var currentDay = 1
    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate?
    var date = Date()

    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        let currentDate = Date()
        if let day = setDateComponents(date: currentDate)
        {
            currentDay = day
            self.daysCollectionView.scrollToItem(at: IndexPath(row: currentDay - 1, section: 0), at: .left, animated: true)
        }
    }
    @discardableResult func setDateComponents(date:Date) -> Int?
    {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day,.month,.year], from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        monthAndYear.text = dateFormatter.string(from: date)
        currentMonth = dateComponents.month ?? 1
        currentYear = dateComponents.year ?? 2020
        daysCollectionView.reloadData()
        self.date = date
        return dateComponents.day
    }
   
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
        if sender == leftBtn
        {
            
          date =  Calendar.current.date(byAdding: .month, value: -1, to: date) ?? date

        }
        else if sender == rightBtn
        {
          date =  Calendar.current.date(byAdding: .month, value: 1, to: date) ?? date


        }
        setDateComponents(date: date)
        
    }

    
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        return range?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell
        let component = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        if component.day == indexPath.row + 1 , component.month == currentMonth,component.year == currentYear
        {
            cell.dayView.backgroundColor = UIColor.daySelected
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
        else
        {
            cell.dayView.backgroundColor = UIColor.normalColor

        }
        cell.updateWithDate(day: indexPath.row + 1, month: currentMonth, year: currentYear)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.row + 1
        let dateComponents = DateComponents(calendar: Calendar.current,
        year: currentYear,
        month: currentMonth,
        day: day)
        if let date = Calendar.current.date(from: dateComponents)
        {
            delegate?.getSelectedDate(date)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell
        {
            cell.dayView.backgroundColor = UIColor.daySelected
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell
        {
            cell.dayView.backgroundColor = UIColor.normalColor

        }

    }
    
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}
