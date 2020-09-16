//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    func updateItem(carwashItem:CarWashItem,previous:CLLocation?)
    {
        var name = carwashItem.houseOwnerFirstName ?? ""
        name += " "
        name += carwashItem.houseOwnerLastName ?? ""
        customer.text = name
        if let state = carwashItem.visitState
        {
            status.setState(state: state)

        }
        var address = carwashItem.houseOwnerAddress ?? ""
        address += " "
        address += carwashItem.houseOwnerZip ?? ""
        address += " "
        address += carwashItem.houseOwnerCity ?? ""
        destination.text = address
        if let task = carwashItem.tasks?.first
        {
            tasks.text = task.title
            
        }
        var totalTime = 0
        if let taskItems = carwashItem.tasks
        {
            for task in taskItems
            {
                totalTime += task.timesInMinutes ?? 0
            }
        }
        timeRequired.text = "\(totalTime) min"
        arrivalTime.text = carwashItem.expectedTime
        if let currentLatitude = carwashItem.houseOwnerLatitude , let currentLongitude = carwashItem.houseOwnerLongitude  , let previousLocation = previous
        {
            let currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
            distance.text = "\( currentLocation.distance(from: previousLocation)) mtr"

            
        }
    }
}
extension UILabel
{
    func setState(state:CarWashState)
    {
        switch state {
            
        case .todo:
            self.backgroundColor = UIColor.todoOption
        case .done:
            self.backgroundColor = UIColor.doneOption
            
        case .inProgress:
            self.backgroundColor = UIColor.inProgressOption
            
        case .rejected:
            self.backgroundColor = UIColor.rejectedOption
            
        }
        self.text = state.rawValue
    }
}
