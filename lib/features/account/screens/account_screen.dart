import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swappp/constants/global_variables.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile",
            style: TextStyle(fontWeight: FontWeight.w900)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: GlobalVariables.backgroundColor,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: GlobalVariables.secondaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.0)),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.settings,
                  color: GlobalVariables.backgroundColor,
                ),
              ),
            ),
          )
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(border: Border.all(width: 0.0), shape: BoxShape.circle),
                    child: ClipOval(
                    child: Image.network(
                      "https://i.pinimg.com/736x/5e/3d/8c/5e3d8c6897f627e4a194d6cfbb8d8878.jpg",
                      fit: BoxFit.cover,
                      width: 100.0,
                      height: 100.0,
                    ),
                    ),
                ), 
               Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("WorthEveryPenny", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25), overflow: TextOverflow.ellipsis,),
                    const Text("wey@app.com", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.grey),),
                  ],
                )
               ),
               GestureDetector(
                 child: Container(
                   decoration: BoxDecoration(
                     color: GlobalVariables.secondaryColor,
                     border: Border.all(width: 3.0, color: GlobalVariables.backgroundColor),
                     borderRadius: BorderRadius.circular(15.0),
                   ),
                   padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                   child: Text("Edit", style: TextStyle(color: GlobalVariables.backgroundColor, fontWeight: FontWeight.w700),),
                 ),
               )
              ],
            
            ), 
            const SizedBox(height: 30,),
            Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("User ID", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),), 
                        const Text("237468723", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey),)
                      ],
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Phone Number", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),), 
                        const Text("08158407425", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey),)
                      ],
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Account for Payment", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),), 
                        const Text("103012330146", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey),)
                      ],
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("My Wallet", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),), 
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),),
      ),
    );
  }
}
