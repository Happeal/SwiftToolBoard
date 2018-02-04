# SwiftToolBoard
<p align="center">
<img src="https://travis-ci.org/Happeal/SwiftToolBoard.svg?branch=master" />
<img src="https://img.shields.io/badge/platform-iOS-blue.svg" />
<img src="https://img.shields.io/badge/language-Swift-orange.svg" />
<img src="https://img.shields.io/badge/License-GPL%20v3-blue.svg" />
</p>


Swift framework to add a toolbar above the keyboard

<h2> How to install </h2>

Add this line into your Podfile
```
pod 'SwiftToolBoard', :git => 'https://github.com/Happeal/SwiftToolBoard.git'
```
then run `pod install`

After that go in your project and launch `Product -> Build` to add the framework into your project

<h2> How to use </h2>

start by adding `import SwiftToolBoard`

then, you can instantiate the `ToolBoard`

Use exemple :

```
import UIKit
import SwiftToolBoard

class ViewController : UIViewController {
  
  @IBOutlet weak var myTextBox : UITextField!
  
  overrid func viewDidLoad() {
    super.viewDidLoad()
    let tB = ToolBoard()
    tB.changeItemNumber(number: 20)
    
    myTextBox.inputAccessoryView = tB
  }


}
```

There is 3 constructor :
```
//Instantiate without item and with all default param
let tB = ToolBoard()

//Instantiate with 20 item
let tB = ToolBoard(itemNumber : 20)

//Instantiate the toolboard with 20 item and a specific cell create by you
let tB = ToolBoard(itemNumber : 20, cellNibName: "MyCellView", reuseCellIdentifier: "myCellReuseId")
```

You can use many function to change the toolboard you can create whatever you want ( even a form into the keyboard like an option menu with button into cells )


<h2> How to implement delegate methods </h2>

There is two delegate method to implement : ( Exemple )
before you need to tell that the controller is the delegate
```
override func viewDidLoad() {
//viewDidLoad code
let tB = ToolBoard()

tB.delegate = self
//viewDidLoad code
}
```

when its done you need to extend your controller like this :
```
extension ViewController:  ToolBoardDelegate {
  
  func toolBoard(_ toolBoard: ToolBoard, cellForItem cell: UICollectionViewCell, indexPath : IndexPath) {
  //Put here you're code ( this method will be call every time the collectionView into the toolboard iterate on these cell )
  }
  
  func toolBoard(_ toolBoard: ToolBoard, didSelectObject index : Int){
  //Put here you're code ( this method will be call every time the user touch a cell )
  }

}
```

Enjoy !! :)
