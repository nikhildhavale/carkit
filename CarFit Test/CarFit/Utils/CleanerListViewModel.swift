//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by Nikhil on 07/09/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
protocol DateProtocol {
    func getDate() -> Date?
}
class CleanerListViewModel<T:DateProtocol>
{
    private var array:[T] = [T]()
    private var filteredArray:[T] = [T]()
    var selectedDate = Date()
    {
        didSet{
            self.generateFilteredArray()
        }
    }
    func generateFilteredArray()  {
        self.filteredArray = array.filter{ if let date = $0.getDate()
            {
               return Calendar.current.compare(date, to: selectedDate, toGranularity: .day) == .orderedSame &&
                Calendar.current.compare(date, to: selectedDate, toGranularity: .month)  == .orderedSame &&
                    Calendar.current.compare(date, to: selectedDate, toGranularity: .year) == .orderedSame
            }
            return false
        }
    }
    init()
    {
        do
        {
            if let path =  Bundle.main.path(forResource: "carfit", ofType: "json")
            {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let carWashDataModel = try JSONDecoder().decode(Carwash.self, from: data)
                if let arrayItems = carWashDataModel.data as? [T]
                {
                    self.array = arrayItems
                    self.selectedDate = Date()
                    self.generateFilteredArray()
                }
            }
        }
        catch
        {
            
        }
        
    }
    func numberOfItems() -> Int
    {
        return filteredArray.count
    }
    func getItemAt(index:Int) -> T?
    {
        if filteredArray.count > index
        {
            return filteredArray[index]
        }
        return nil
    }
}
