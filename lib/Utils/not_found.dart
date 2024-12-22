import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          const Icon(
            Icons.search_off,
            color: Colors.redAccent,  
            size: 100,  
          ),

          const SizedBox(height: 20), 

          
          Text(
            "No Results Found",
            style: TextStyle(
              fontSize: 26,  
              color: Colors.black87, 
              fontWeight: FontWeight.bold, 
            ),
          ),

          const SizedBox(height: 10), 

          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), 
            child: Text(
              "Try refining your search or check your internet connection.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, 
                color: Colors.grey, 
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 30), 

         
        ],
      ),
    );

  }
}
