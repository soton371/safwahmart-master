import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_sizes.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  const CheckoutPaymentScreen({Key? key}) : super(key: key);

  @override
  _CheckoutPaymentScreenState createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {

  int? radioSelected;
  bool selectIs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        title: const Text('Payment'),
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
      body: ListView(
        padding: EdgeInsets.all(MySizes.bodyPadding),
        children: [
          const SizedBox(height: 10,),
          //for stepper
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
                    color: MyColors.primary
                ),),
              Icon(Icons.payment, color: MyColors.primary,),
              const SizedBox(),
            ],
          ),
          const SizedBox(height: 20,),



          //for promo code
          Container(
            padding: const EdgeInsets.only(top: 15),
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
            child: Column(
              children: [
                Text(
                  "Have any promo code?",
                  style: TextStyle(
                      color: MyColors.primary, fontWeight: FontWeight.w500),
                ),
                //for promo code
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Promo Code',
                            hintStyle: TextStyle(fontSize: 14),
                            prefixIcon: Icon(Icons.local_offer_outlined),
                            border: InputBorder.none,
                            //contentPadding: EdgeInsets.all(0)
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 0
                          ),
                          child: Text('Apply',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: MyColors.primary,
                          ),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          //for description
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(10),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Sub Total',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    ),
                    Text('250.00',style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('VAT',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Text('0.5',style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Shipping',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Text('50.00',style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Discount',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Text('0.00',style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Grand Total',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Text('৳300.05',style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ],
            ),
          ),
          //for payment option
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                  value: 1,
                  groupValue: radioSelected,
                  onChanged: (v)=>setState(() {
                    radioSelected = v as int?;
                    selectIs = true;
                    //print(radioSelected);
                  }),
              ),
              const Text('Cash on delvery',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              ),
              Radio(
                value: 2,
                groupValue: radioSelected,
                onChanged: (v)=>setState(() {
                  radioSelected = v as int?;
                  selectIs = true;
                  //print(radioSelected);
                }),
              ),
              const Text('Online pay',style: TextStyle(
                fontWeight: FontWeight.w500,
              ),),
            ],
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
        child: ElevatedButton(
            onPressed: () {
              //selectIs?Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const BodyScreen()), (route) => false):null;
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                primary: selectIs?MyColors.primary:MyColors.inactive,
                shape: const StadiumBorder()),
            child: const Text("Continue")),
      ),
    );
  }
}
