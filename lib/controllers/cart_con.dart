import 'package:get/get.dart';
import 'package:grocery/locals/database/db_helper.dart';


class CartController extends GetxController{
   var carts          = [].obs;
   var deliveryCharge = 19.0.obs;

   @override
   void onInit() {
      super.onInit();
      refreshCarts();
   }

   @override
   void dispose(){
      CartDatabase.instance.close();
      super.dispose();
   }

   Future refreshCarts() async{
      carts.value = await CartDatabase.instance.viewCart();
   }

   totalPrice(){
      RxDouble sum = 0.0.obs;
      for (var i = 0; i < carts.length; i++){
            sum.value = (sum + (carts[i].sale_price - carts[i].discount_amount) * carts[i].quantity).toDouble();
      }
      return sum.toStringAsFixed(2);
   }

   subTotalPrice(){
      RxDouble sum = 0.0.obs;
      for (var i = 0; i < carts.length; i++){
         sum.value = (sum + (carts[i].sale_price * carts[i].quantity)).toDouble();
      }
      return sum.toStringAsFixed(2);
   }

   totalDiscount(){
      RxDouble discountSum = 0.0.obs;
      for (var i = 0; i < carts.length; i++){
         discountSum.value = (discountSum + (carts[i].discount_amount * carts[i].quantity)).toDouble();
      }
      return discountSum;
   }

   totalVat(){
      RxDouble vatSum = 0.0.obs;
      for (var i = 0; i < carts.length; i++){
         vatSum.value = (vatSum + ((carts[i].sale_price * (carts[i].vat_amount / 100)) * carts[i].quantity)).toDouble();
      }
      return vatSum;
   }

   totalWeight(){
      RxDouble weightSum = 0.0.obs;
      for (var i = 0; i < carts.length; i++){
         weightSum.value = (weightSum + (carts[i].weight * carts[i].quantity)).toDouble();
      }
      return weightSum;
   }

   totalQuantity(){
      RxInt sumQuantity = 0.obs;
      for (var i = 0; i < carts.length; i++){
         sumQuantity.value = (sumQuantity + carts[i].quantity).toInt();
      }
      return sumQuantity;
   }

   productId(){
      RxList product_id = [].obs;
      for (var i = 0; i < carts.length; i++){
         product_id.value.add(carts[i].product_id);
      }
      return product_id;
   }

   localId(){
      RxList id = [].obs;
      for (var i = 0; i < carts.length; i++){
         id.value.add(carts[i].id);
      }
      return id;
   }

   purchasePrice(){
      RxList purchase_price = [].obs;
      for (var i = 0; i < carts.length; i++){
         purchase_price.value.add(carts[i].purchase_price);
      }
      return purchase_price;
   }

   salePrice(){
      RxList sale_price = [].obs;
      for (var i = 0; i < carts.length; i++){
         sale_price.value.add(carts[i].sale_price);
      }
      return sale_price;
   }

   quantitys(){
      RxList quantity = [].obs;
      for (var i = 0; i < carts.length; i++){
         quantity.value.add(carts[i].quantity);
      }
      return quantity;
   }

   vatPercent(){
      RxList vat = [].obs;
      for (var i = 0; i < carts.length; i++){
         vat.value.add(((carts[i].sale_price * (carts[i].vat_amount / 100)) * carts[i].quantity));
      }
      return vat;
   }

   weightIndividual(){
      RxList weights = [].obs;
      for (var i = 0; i < carts.length; i++){
         weights.value.add((carts[i].weight * carts[i].quantity));
      }
      return weights;
   }

   discountAmount(){
      RxList discount = [].obs;
      for (var i = 0; i < carts.length; i++){
         discount.value.add( carts[i].discount_amount > 0 ? carts[i].discount_amount : 0);
         // discount.value.add( carts[i].discount_amount > 0 ? carts[i].sale_price - carts[i].discount_amount : 0);
      }
      return discount;
   }

   discountPercent(){
      RxList discountPer = [].obs;
      for (var i = 0; i < carts.length; i++){
         discountPer.value.add((carts[i].sale_price / carts[i].discount_amount != 0.0 ? carts[i].discount_amount : 1));
      }
      return discountPer;
   }

   measurementSku(){
      RxList measureSku = [].obs;
      for (var i = 0; i < carts.length; i++){
         measureSku.value.add((carts[i].measurement_sku));
      }
      return measureSku;
   }

   measurementTitle(){
      RxList measureTitle = [].obs;
      for (var i = 0; i < carts.length; i++){
         measureTitle.value.add(carts[i].measurement_title != '' && carts[i].measurement_title != '0' && carts[i].measurement_title != '1.0' ? carts[i].measurement_title : '${carts[i].view_quantity} ${carts[i].unit_tag}' );
         // measureTitle.value.add((carts[i].measurement_title));
      }
      return measureTitle;
   }

   measurementValue(){
      RxList measureValue = [].obs;
      for (var i = 0; i < carts.length; i++){
         measureValue.value.add((carts[i].measurement_value));
      }
      return measureValue;
   }
}