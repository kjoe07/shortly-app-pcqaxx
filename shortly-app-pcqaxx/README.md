# Shortly-app-pcqaxx

&copy yoel Jimenez del valle 2021

this a sample test to ... interview process, the target of this small app is to demostrate my habilities as developer with pure layut code, network request and data persistence. 
To run the project needed Xcode 12.5.1 or 12 minimum version, ios 14.5 was the version selected but can be reduce to ios 12 without any code change. the request are made using URLSession.shared. 
the arquitecture used was MVVM. there are two swift package managers 
1- IQKeyboardManagerSwift to handle keyboard presentation. 
2- activity inidicator. to show a spinner when loading data.

missing in this repo. not handle the copied estatus in the tableview. dont look for a desicion with persistance among differents app use. 
more unit test to the ResultViewModel.

the binding between model and view where made with notifications. no RXSwift for me and combine either yet. 
there is a subttle difference in the diesing with the view background color. that is in gray color and left the view in systembackgroundColor. I dont know if this is a bug from figma but all figma desing ios view have a little gray color that does not match the default sistem color.


# updated 09-17-2021
update network layer to abstract.
