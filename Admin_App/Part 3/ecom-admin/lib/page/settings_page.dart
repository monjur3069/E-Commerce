import 'package:ecom_admin_batch06/models/order_constants_model.dart';
import 'package:ecom_admin_batch06/providers/order_provider.dart';
import 'package:ecom_admin_batch06/utils/constants.dart';
import 'package:ecom_admin_batch06/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late OrderProvider orderProvider;
  double deliveryChargeSliderValue = 0;
  double discountSliderValue = 0;
  double vatSliderValue = 0;
  bool needUpdate = false;

  @override
  void didChangeDependencies() {
    orderProvider = Provider.of(context, listen: false);
    orderProvider.getOrderConstants2().then((_) {
      setState(() {
        deliveryChargeSliderValue = orderProvider.orderConstantsModel.deliveryCharge.toDouble();
        discountSliderValue = orderProvider.orderConstantsModel.discount.toDouble();
        vatSliderValue = orderProvider.orderConstantsModel.vat.toDouble();
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Card(
            elevation: 10,
            child: Column(
              children: [
                ListTile(
                  title: Text('Delivery Charge'),
                  trailing: Text('$currencySymbol${deliveryChargeSliderValue.round()}'),
                  subtitle: Slider(
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                      min: 0,
                      max: 500,
                      divisions: 50,
                      label: deliveryChargeSliderValue.toStringAsFixed(0),
                      value: deliveryChargeSliderValue.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          deliveryChargeSliderValue = value;
                          _checkUpdate();
                        });
                      }),
                ),
                ListTile(
                  title: Text('Discount'),
                  trailing: Text('${discountSliderValue.round()}%'),
                  subtitle: Slider(
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: discountSliderValue.toStringAsFixed(0),
                      value: discountSliderValue.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          discountSliderValue = value;
                          _checkUpdate();
                        });
                      }),
                ),
                ListTile(
                  title: Text('VAT'),
                  trailing: Text('${vatSliderValue.round()}%'),
                  subtitle: Slider(
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                      min: 0,
                      max: 300,
                      divisions: 300,
                      label: vatSliderValue.toStringAsFixed(0),
                      value: vatSliderValue.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          vatSliderValue = value;
                          _checkUpdate();
                        });
                      }),
                ),
                ElevatedButton(
                  onPressed: needUpdate ? () {
                    EasyLoading.show(status: 'Updating...', dismissOnTap: false);
                    final model = OrderConstantsModel(
                      deliveryCharge: deliveryChargeSliderValue,
                      discount: discountSliderValue,
                      vat: vatSliderValue
                    );
                    orderProvider.addOrderConstants(model).then((value) {
                      setState(() {
                        needUpdate = false;
                      });
                      EasyLoading.dismiss();
                    }).catchError((error) {
                      showMsg(context, 'Could not update');
                      EasyLoading.dismiss();
                      throw error;
                    });
                  } : null,
                  child: const Text('UPDATE'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _checkUpdate() {
    needUpdate = orderProvider.orderConstantsModel.deliveryCharge.toDouble() !=
    deliveryChargeSliderValue ||
        orderProvider.orderConstantsModel.discount.toDouble() !=
            discountSliderValue ||
        orderProvider.orderConstantsModel.vat.toDouble() !=
            vatSliderValue;
  }
}
