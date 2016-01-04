//
//  ViewController.swift
//  MagicEdit
//
//  Created by 板谷晃良 on 2015/11/29.
//  Copyright © 2015年 AkkeyLab. All rights reserved.
//

import UIKit
import CoreBluetooth

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        let red = CGFloat(Double(r & 0xFF) / 255.0)
        let green = CGFloat(Double(g & 0xFF) / 255.0)
        let blue = CGFloat(Double(b & 0xFF) / 255.0)
        let alpha = CGFloat(Double(a & 0xFF) / 255.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

class ViewController: UIViewController, UITextViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private var buttons: [[UIButton]] = [[UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()],
                                         [UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()],
                                         [UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()],
                                         [UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()],
                                         [UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()]]
    
    private let viewText: [[String]] = [["あ","か","さ","た","な","゛","は","ま","や","ら","わ","ん"],
                                        ["い","き","し","ち","に","゜","ひ","み","い","り","ゐ","消"],
                                        ["う","く","す","つ","ぬ","。","ふ","む","ゆ","る","う","消"],
                                        ["え","け","せ","て","ね","、","へ","め","え","れ","ゑ","消"],
                                        ["お","こ","そ","と","の","小","ほ","も","よ","ろ","を","消"]]
    
    //Value
    private var displaySize_width:    CGFloat!
    private var displaySize_height:   CGFloat!
    //Text
    //private var mainLabel:    UILabel!
    private var contentText:  UITextView!
    private var nowPointa:    [Int] = [0, 0]
    
    //private var mainViewText: String!
    private var notesView:    String = ""
    
    //Define
    private let UUID_VSP: [CBUUID] = [CBUUID(string: "bd011f22-7d3c-0db6-e441-55873d44ef40")]
    private let UUID_TX:   CBUUID  =  CBUUID(string: "2a750d7d-bd9a-928f-b744-7d5a70cef1f9")
    private let UUID_RX:   CBUUID  =  CBUUID(string: "0503b819-c75b-ba9b-3641-6a7f338dd9bd")
    //BLE
    private var ble_Uuids: NSMutableArray = NSMutableArray()
    private var ble_Names: NSMutableArray = NSMutableArray()
    private var ble_Peripheral: NSMutableArray = NSMutableArray()
    
    private var ble_CentralManager: CBCentralManager!
    private var ble_TargetPeripheral: CBPeripheral!
    
    private let indicator = ActivityIndicator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialization++++++++++
        //self.view.backgroundColor = UIColor(r: 160, g: 216, b: 239)
        self.view.backgroundColor = UIColor.grayColor()
        
        displaySize_width  = self.view.frame.width
        displaySize_height = self.view.frame.height
        //++++++++++++++++++++++++
        
        let leftLabelBK: UILabel = UILabel(frame: CGRectMake(0, 0, 250, 250))
        leftLabelBK.backgroundColor = UIColor.whiteColor()
        leftLabelBK.layer.masksToBounds = true
        leftLabelBK.layer.cornerRadius = 10.0
        leftLabelBK.layer.position = CGPoint(x: 150, y: 150)
        self.view.addSubview(leftLabelBK)
        
        let rightLabelBK: UILabel = UILabel(frame: CGRectMake(0, 0, 250, 250))
        rightLabelBK.backgroundColor = UIColor.whiteColor()
        rightLabelBK.layer.masksToBounds = true
        rightLabelBK.layer.cornerRadius = 10.0
        rightLabelBK.layer.position = CGPoint(x: 450, y: 150)
        self.view.addSubview(rightLabelBK)
        
        let rightLabelBK2: UILabel = UILabel(frame: CGRectMake(0, 0, 50, 50))
        rightLabelBK2.backgroundColor = UIColor.whiteColor()
        rightLabelBK2.layer.masksToBounds = true
        rightLabelBK2.layer.cornerRadius = 10.0
        rightLabelBK2.layer.position = CGPoint(x: 600, y: 50)
        self.view.addSubview(rightLabelBK2)
        
        let leftLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 250, 250))
        leftLabel.backgroundColor = UIColor.orangeColor()
        leftLabel.layer.masksToBounds = true
        leftLabel.layer.cornerRadius = 10.0
        leftLabel.layer.position = CGPoint(x: 150, y: 150)
        leftLabel.alpha = 0.5
        self.view.addSubview(leftLabel)
        
        let rightLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 250, 250))
        rightLabel.backgroundColor = UIColor.blueColor()
        rightLabel.layer.masksToBounds = true
        rightLabel.layer.cornerRadius = 10.0
        rightLabel.layer.position = CGPoint(x: 450, y: 150)
        rightLabel.alpha = 0.5
        self.view.addSubview(rightLabel)
        
        let rightLabel2: UILabel = UILabel(frame: CGRectMake(0, 0, 50, 50))
        rightLabel2.backgroundColor = UIColor.blueColor()
        rightLabel2.layer.masksToBounds = true
        rightLabel2.layer.cornerRadius = 10.0
        rightLabel2.layer.position = CGPoint(x: 600, y: 50)
        rightLabel2.alpha = 0.5
        self.view.addSubview(rightLabel2)
        
        for var y = 0; y < 5; y++ {
            for var x = 0; x < 12; x++ {
                buttons[y][x].frame = CGRectMake(0,0,40,40)
                buttons[y][x].backgroundColor = UIColor.whiteColor()
                buttons[y][x].layer.masksToBounds = true
                buttons[y][x].setTitle(viewText[y][x], forState: UIControlState.Normal)
                buttons[y][x].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                buttons[y][x].setTitle(viewText[y][x], forState: UIControlState.Highlighted)
                buttons[y][x].setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
                buttons[y][x].layer.cornerRadius = 10.0
                buttons[y][x].layer.position = CGPoint(x: 50 * (x + 1), y: 50 * (y + 1))
                buttons[y][x].tag = 1
                buttons[y][x].alpha = 0.7
                buttons[y][x].addTarget(self, action: "onClickButton:", forControlEvents: .TouchUpInside)
                self.view.addSubview(buttons[y][x])
            }
        }
        
        contentText = UITextView(frame: CGRectMake(0, 0, displaySize_width - 100, displaySize_height - 300))
        contentText.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        contentText.text = notesView
        contentText.layer.masksToBounds = true
        contentText.layer.cornerRadius = 10.0
        contentText.layer.borderWidth = 1
        contentText.layer.borderColor = UIColor.whiteColor().CGColor
        contentText.font = UIFont.systemFontOfSize(CGFloat(15))
        contentText.textColor = UIColor.blackColor()
        contentText.textAlignment = NSTextAlignment.Left
        contentText.dataDetectorTypes = UIDataDetectorTypes.All
        contentText.layer.shadowOpacity = 0
        contentText.editable = true
        contentText.delegate = self
        contentText.alpha = 0.7
        contentText.layer.position = CGPoint(x: displaySize_width / 2, y: 325)
        self.view.addSubview(contentText)
        
        //BLE START
        ble_CentralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        //Indicator
        indicator.start(self)
        
        stringHighlight()
    }
    
    func onClickButton(sender: UIButton) {
        
        if(sender == buttons[1][1]){

        }
    }
    
    func stringHighlight(){
        buttons[nowPointa[1]][nowPointa[0]].backgroundColor = UIColor(r: 255, g: 20, b: 147)
        buttons[nowPointa[1]][nowPointa[0]].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttons[nowPointa[1]][nowPointa[0]].alpha = 1.0
    }
    
    func backHighlight(){
        buttons[nowPointa[1]][nowPointa[0]].backgroundColor = UIColor.whiteColor()
        buttons[nowPointa[1]][nowPointa[0]].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttons[nowPointa[1]][nowPointa[0]].alpha = 0.7
    }
    
    func rightMove(){
        backHighlight()
        
        if nowPointa[0] == 11 {
            nowPointa[0] = 0
        }else{
            nowPointa[0]++
        }
        stringHighlight()
    }
    
    func leftMove(){
        backHighlight()
        
        if nowPointa[0] == 0 {
            nowPointa[0] = 11
        }else{
            nowPointa[0]--
        }
        stringHighlight()
    }
    
    func upMove(){
        backHighlight()
        
        if nowPointa[1] == 0 {
            nowPointa[1] = 4
        }else{
            nowPointa[1]--
        }
        stringHighlight()
    }
    
    func downMove(){
        backHighlight()
        
        if nowPointa[1] == 4 {
            nowPointa[1] = 0
        }else{
            nowPointa[1]++
        }
        stringHighlight()
    }
    //Decision
    func stringDecision(){
        notesView += viewText[nowPointa[1]][nowPointa[0]]
        contentText.text = notesView
    }
    
    //TextView
    func textViewDidChange(textView: UITextView) {
        print("textViewDidChange : \(textView.text)");
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing : \(textView.text)");
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        print("textViewShouldEndEditing : \(textView.text)");
        return true
    }

    //BLE setting start. ++++++++++++++++++++++++++
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch(central.state){
        case .PoweredOff:
            alert("Bluetooth OFF",messageString: "設定でBluetoothをオンにしてください", buttonString: "OK")
            //Setting open
            let url = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(url!)
        case .PoweredOn:
            //BLE Start
            ble_CentralManager.scanForPeripheralsWithServices(UUID_VSP, options: nil)
        case .Resetting:
            alert("Resetting",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unauthorized:
            alert("Unauthorized",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unknown:
            alert("Unknown",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unsupported:
            alert("Unsupported",messageString: "お使いの端末はBluetooth非対応です", buttonString: "OK")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral,
        advertisementData: [String: AnyObject], RSSI: NSNumber) {
            
            var name:NSString? = advertisementData["kCBAdvDataLocalName"] as? NSString
            if(name == nil){
                name = "No name"
            }
            ble_Names.addObject(name!)
            ble_Peripheral.addObject(peripheral)
            ble_Uuids.addObject(peripheral.identifier.UUIDString)
            
            if name == "BLESerial2" {
                //Indicator stop
                indicator.activityIndicator.stopAnimating()
                
                //let remove = RemoveSubviews()
                //View remove
                //remove.removeAllSubviews(self.view, kind: "ble_start")
                
                //Start connect
                self.ble_TargetPeripheral = peripheral
                ble_CentralManager.connectPeripheral(self.ble_TargetPeripheral, options: nil)
            }
    }
    
    //*** Swift 2 worning ***//
    //func centralManager(central: CBCentralManager, var didConnectPeripheral peripheral: CBPeripheral) {
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        //showNotification("MysticSDとの接続に成功しました！")//MapCoreViewController class
        ble_CentralManager.stopScan()
        
        //Find characteristics -> Go to "Find "Service" !"
        peripheral.delegate = self;
        peripheral.discoverServices(nil)
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        //let notification = Notification()
        //notification.showNotification("MysticSDとの接続に失敗しました！")//MapCoreViewController class
    }
    
    //Find "Service" !
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        NSLog("Find service!")
        
        let services: NSArray = peripheral.services!
        
        for obj in services{
            if let service = obj as? CBService{
                //Find characteristics -> Go to "Find "Characteristics" !"
                peripheral.discoverCharacteristics(nil, forService: service)
                
            }
        }
    }
    
    //Find "Characteristics" !
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        NSLog("Find characteristics!")
        
        let characteristics: NSArray = service.characteristics!
        
        for obj in characteristics{
            if let characteristic = obj as? CBCharacteristic{
                //First write successful -> Go to "First write result"
                
                let value: [UInt8] = [2];
                let data: NSData = NSData(bytes: value, length: sizeof(Int))
                
                /*
                var value: CUnsignedChar = 0x01
                let data: NSData = NSData(bytes: &value, length: 1)
                */
                peripheral.writeValue(data, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithoutResponse)
                
                // move to "First write result"
                //peripheral.readValueForCharacteristic(characteristic) // Read only once
                peripheral.setNotifyValue(true, forCharacteristic: characteristic) // Notify
                
            }
        }
    }
    
    //When call notify start and end
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil{
            NSLog("Notify error")
        }else{
            NSLog("Notify success")
        }
    }
    
    //When call get data
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if characteristic.UUID.isEqual(UUID_TX){
            //NSLog("Read success!!")
            let data = characteristic.value
            let ptr = UnsafePointer<UInt8>(characteristic.value!.bytes)
            let bytes = UnsafeBufferPointer<UInt8>(start:ptr, count:data!.length)
            NSLog("Read value: \(bytes[0])")
            
            if bytes[0] == 1 {
                rightMove()
            }else
            if bytes[0] == 2 {
                leftMove()
            }else
            if bytes[0] == 3 {
                upMove()
            }else
            if bytes[0] == 4 {
                downMove()
            }else
            if bytes[0] == 5 {
                stringDecision()
            }
        }
        
    }
    
    //First write result
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharactertistic characteristic: CBCharacteristic!, error: NSError!){
        NSLog("First write result")
        //peripheral.readValueForCharacteristic(characteristic) // Read only once
        //peripheral.setNotifyValue(true, forCharacteristic: characteristic) // Notify
    }
    //BLE setting end. ++++++++++++++++++++++++++++
    
    func alert(titleString: String, messageString: String, buttonString: String){
        //Create UIAlertController
        let alert: UIAlertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .Alert)
        //Create action
        let action = UIAlertAction(title: buttonString, style: .Default) { action in
            NSLog("\(titleString):Push button!")
        }
        //Add action
        alert.addAction(action)
        //Start
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

