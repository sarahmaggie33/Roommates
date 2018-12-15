//
//  FirstViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 10/28/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var todayButton: UIButton!
    var eventsDictionary:[Date:[String]]!
    var dateSelected:Date!
    
    let outsideMonthColor = UIColor.black
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor.black
    let currentDateSelectedViewColor = UIColor.cyan
    
    let formatter = DateFormatter()
    
    let todaysDate = Date()
    
    var eventsFromTheServer: [String: [String]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsTable.backgroundColor = UIColor.black

        // Set the color for the navigation bar
        self.navigationController!.navigationBar.barTintColor = UIColor.blue
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 238/255, green: 173/255, blue: 30/255, alpha: 1)]
        self.navigationController!.navigationBar.tintColor = UIColor(red: 238/255, green: 173/255, blue: 30/255, alpha: 1)
        self.navigationController!.navigationBar.barStyle = .black
        
        // Fetch the data from the server
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let serverObjects = self.getServerEvents()
            self.eventsDictionary = self.getServerEvents()
            for (date, event) in serverObjects {
                let stringDate = self.formatter.string(from: date)
                self.eventsFromTheServer[stringDate] = event
                print(event)
            }
            
            DispatchQueue.main.async {
                self.calendarView.reloadData()
                self.eventsTable.reloadData()
                print("the events are in the calendar")
            }
        }
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        setupCalendarView()
    }
    
    @IBAction func scrollToToday() {
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
    }
    
    func setupCalendarView() {
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let customCell = cell as? CustomCell else { return }
        formatter.dateFormat = "yyyy MM dd"
        handleCellEvents(cell: customCell, cellState: cellState)
    }
    
    func handleCellEvents(cell: CustomCell, cellState: CellState) {
        cell.eventDotView.isHidden = !eventsFromTheServer.contains{$0.key == formatter.string(from: cellState.date)}
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CustomCell else{
            return
        }
        
        formatter.dateFormat = "yyyy MM dd"
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        if todaysDateString == monthDateString {
            validCell.dateLabel.textColor = UIColor.cyan
        } else {
            if cellState.isSelected {
                validCell.dateLabel.textColor = selectedMonthColor
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = monthColor
                } else {
                    validCell.dateLabel.textColor = outsideMonthColor
                }
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ViewController: JTAppleCalendarViewDataSource {
   
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        print("configuring the calendar")
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2020 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }

}

extension ViewController: JTAppleCalendarViewDelegate {
    // Display the cell
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        print("")
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        configureCell(cell: cell, cellState: cellState)
        eventsTable.reloadData()
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        cell?.bounce()
        
        // set up the tableview for the calendar cell that was selected
        dateSelected = date
        eventsTable.reloadData()
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    // UITableViewDataSource protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (eventsDictionary == nil) {
            return 0;
        } else if (!eventsDictionary.keys.contains(dateSelected)) {
            return 0;
        } else {
            let events = eventsDictionary[dateSelected]
            let numEvents = events!.count
            print("events on this day: \(numEvents)")
            return numEvents
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = self.eventsTable.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        if (eventsDictionary != nil) {
            print("index: \(indexPath.row)")
            let eventsOnThisDay = eventsDictionary[dateSelected]
            cell.textLabel?.text = eventsOnThisDay![indexPath.row]
        }
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
}

// Create the bounce animation
extension UIView {
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.beginFromCurrentState, animations: { self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}

extension ViewController {
    func getServerEvents() -> [Date:[String]] {
        formatter.dateFormat = "yyyy MM dd"
        
        var events:[Date:[String]] = [:]
        var fetchResults:[Any] = []
        var presetEvents:[Date:[String]] = [
            formatter.date(from: "2018 06 02")!: ["Happy Birthday"],
            formatter.date(from: "2018 06 30")!: ["Connor's Birthday"],
            formatter.date(from: "2018 01 01")!: ["Happy New Year!"],
            formatter.date(from: "2018 12 25")!: ["Merry Christmas"],
            formatter.date(from: "2018 02 14")!: ["Happy Valentine's Day"],
            formatter.date(from: "2018 03 17")!: ["Happy St. Patrick's Day"],
            formatter.date(from: "2018 12 14")!: ["The last day of classes", "Party"],
            formatter.date(from: "2019 01 01")!: ["Happy New Year!"],
            
            ]
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<ListItem>(entityName: "ListItem")
        let sortByName:NSSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        fetchRequest.sortDescriptors = [sortByName]
        do {
            fetchResults = try moc.fetch(fetchRequest)
                for data in fetchResults as! [NSManagedObject] {
                    if (data.value(forKey: "dueDate") as? Date != nil) { // if the date isn't nil
                        let title:String = data.value(forKey: "title") as! String
                        var date:Date = data.value(forKey: "dueDate") as! Date
                        date = removeTimeStamp(fromDate: date)
                        print("Printing event:  \(data.value(forKey: "title") as! String)")
                        print("Printing date:  \(data.value(forKey: "dueDate") as! Date)")
                        events[date] = [title]
//                        events?.updateValue([title], forKey: date)
                    }
                    
                }
            
//            NSMutableArray(array: fetchResults).
//            events = NSMutableArray(array: fetchResults) as! [ListItem]
        } catch {
            print("Error executing fetch request with request: \(fetchRequest)")
        }
        
        print("There are this many list events: \(events.count)")
        print("Events: \(events.first)")
        
        let eventsAll = presetEvents.merging(events, uniquingKeysWith: { (first, _) in first })
        return eventsAll
    }
    
    public func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
}


