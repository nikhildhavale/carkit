//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation
struct HomeViewConstant
{
    static let topHeightTableView = CGFloat(112)
    static let calendarHeight = CGFloat(200)
}
class HomeViewController: UIViewController, AlertDisplayer {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    var location:CLLocation?
    private let cellID = "HomeTableViewCell"
    let cleanerModel = CleanerListViewModel<CarWashItem>()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.delegate = self
        }
    }

    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarTappedOutside))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        getSelectedDate(Date())

    }

    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        showOrHideCalendar(show: true)
    }
    @objc func calendarTappedOutside() {
        showOrHideCalendar(show: false)
    }
    func showOrHideCalendar(show:Bool)
    {
        UIView.animate(withDuration: 0.5){
            self.calendarHeightConstraint.constant = show ? HomeViewConstant.calendarHeight : 0
            self.topTableViewConstraint.constant = show ? HomeViewConstant.topHeightTableView : 0
            self.view.layoutIfNeeded()
        }
    }
}
extension HomeViewController:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //prevent calendar view click to hide
        if touch.view?.isDescendant(of: self.calendarView) == true {
            return false
        }
        return true
    }
}
//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cleanerModel.numberOfItems()
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
        if let item = cleanerModel.getItemAt(index: indexPath.row)
        {
            cell.updateItem(carwashItem: item, previous: location)
            if let latitude = item.houseOwnerLatitude , let longitude = item.houseOwnerLongitude
            {
                location = CLLocation(latitude: latitude, longitude: longitude)
            }

        }
        return cell
    }
    
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    
    func getSelectedDate(_ date: Date) {
        cleanerModel.selectedDate = date
        let dateFormatter = DateFormatter()
        if Calendar.current.isDateInToday(date)
        {
            dateFormatter.dateFormat  = nil
            dateFormatter.dateStyle = .medium

            dateFormatter.doesRelativeDateFormatting = true
            titleLabel.text = dateFormatter.string(from: date)
          
        }
        else
        {
            dateFormatter.dateStyle = .none

            dateFormatter.dateFormat = "MM-dd-yyyy"
            titleLabel.text = dateFormatter.string(from: date)
        }
        workOrderTableView.reloadData()
    }
    
}
