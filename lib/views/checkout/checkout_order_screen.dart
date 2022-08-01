import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/views/checkout/checkout_payment_screen.dart';

class CheckoutOrderScreen extends StatefulWidget {
  const CheckoutOrderScreen({Key? key}) : super(key: key);

  @override
  _CheckoutOrderScreenState createState() => _CheckoutOrderScreenState();
}

class _CheckoutOrderScreenState extends State<CheckoutOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        title: const Text('Orders'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(),
              Icon(Icons.location_on, color: MyColors.primary,),
              Text('--------------',
                style: TextStyle(
                    color: MyColors.primary
                ),
              ),
              Icon(Icons.wallet_giftcard, color: MyColors.primary,),
              Text('--------------',
                style: TextStyle(
                    color: MyColors.inactive
                ),),
              Icon(Icons.payment, color: MyColors.inactive,),
              const SizedBox(),
            ],
          ),
          const SizedBox(height: 20,),
          Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  itemCount: 2,
                  itemBuilder: (_, i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          //image
                          Container(
                            child: const Center(
                              child: Image(
                                image: AssetImage(
                                    'assets/images/aahar_market_apple-1-removebg-preview.png'),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 1,
                                  ),
                                ],
                                color: Colors.white),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10),
                            height: 60,
                          ),
                          //title
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Fresh Apple",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                "1 X 125",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "৳125",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                    );
                  }),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
        child: ElevatedButton(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const CheckoutPaymentScreen())),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: const StadiumBorder()
            ),
            child: const Text("Continue")
        ),
      ),
    );
  }
}
