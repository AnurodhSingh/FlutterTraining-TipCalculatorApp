import 'package:flutter/material.dart';
import 'package:tip_calculator_app/utils/constants.dart';

/// Tip calculator screen
class TipCalculator extends StatefulWidget {
  @override
  _TipCalculatorWidgetState createState() => _TipCalculatorWidgetState();
}

/// Tip calculator widget state
class _TipCalculatorWidgetState extends State<TipCalculator> {
  double _billAmount = 0.0;
  int _tipPercentage = 0;
  int _numberOfSplitter = 1;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip Calculator App'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            _showTotalAmount(),
            _showTipInputView()
          ],
        ),
      ),
    );
  }
  Container _showTotalAmount() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(
        top: 30,
      ),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0)
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total Per Person',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15.0,
              color: darkPurple
            ) 
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              // ignore: lines_longer_than_80_chars
              '\$${calculateAmountPerPerson(_billAmount, _numberOfSplitter, _tipPercentage)}',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: darkPurple
              ) 
            )
          )
        ],
      ),
    );
  }

  Container _showTipInputView() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(
        top: 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0)
        )
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 10
        ),
        child: Column(
          children: [
            _tipInputView(),
            _splitCounterView(),
            _tipAmountView(),
            _tipSliderView()
          ]
        )
      )
    );
  }

  TextField _tipInputView() {
    return TextField(
      keyboardType:
          TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        color: darkPurple
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.attach_money),
      ),
      onChanged: (String value) {
        try {
          setState(() {
            _billAmount = double.parse(value);
          });
        } catch (exception) {
          setState(() {
          _billAmount = 0.0;
          });
        }
      },
    );
  }

  Row _splitCounterView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Split',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 15.0,
            color: darkPurple
          ) 
        ),
        _counterView()
      ],
    );
  }

  Row _counterView() {
    return (
      Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (_numberOfSplitter > 1) {
                  _numberOfSplitter--;
                }
              });
            },
            child: Container(
              width: 30.0,
              height: 30.0,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: lightPurple
              ),
              child: Center(
                child: Text(
                  '-',
                  style: TextStyle(
                    color: darkPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40.0,
            height: 30.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$_numberOfSplitter',
                style: TextStyle(
                  color: darkPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0
                ),
                textAlign: TextAlign.center,
              )
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _numberOfSplitter++;
              });
            },
            child: Container(
              width: 30.0,
              height: 30.0,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: lightPurple
              ),
              child: Center(
                child: Text(
                  '+',
                  style: TextStyle(
                    color: darkPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                  ),
                ),
              ),
            ),
          ),
        ]
      )
    );
  }

  Row _tipAmountView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tip Amount',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 15.0,
            color: darkPurple
          ) 
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: 8.0
          ),
          child: Container(
            width: MediaQuery.of(context).size.height * 0.13,
            alignment: Alignment.centerLeft,
            child: Text(
              '\$  ${calculateTip(_billAmount, _tipPercentage)}',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15.0,
                color: darkPurple,
              ) 
            )
          )
        )
      ],
    );
  }

  Column _tipSliderView() {
    return Column(
      children: <Widget>[
        Text(
          '$_tipPercentage%',
          style: TextStyle(
              color: darkPurple,
              fontSize: 17.0,
              fontWeight: FontWeight.bold),
        ),
        Slider(
          min: 0,
          max: 100,
          activeColor: darkPurple,
          inactiveColor: Colors.grey,
          divisions: 10,
          //optional
          value: _tipPercentage.toDouble(),
          onChanged: (double newValue) {
            setState(() {
              _tipPercentage = newValue.round();
            });
          })
      ],
    );
  }

  double calculateTip(double billAmount, int tipPercentage) {
    double totalTip = 0.0;

    if (billAmount!=null && billAmount>0 && billAmount.toString().isNotEmpty) {
      totalTip = (billAmount * tipPercentage) / 100;
    }

    return double.parse(totalTip.toStringAsFixed(3));
  }

  String calculateAmountPerPerson(
    double billAmount, int numberOfSplitter, int tipPercentage
  ) {
    final double totalPerPerson =
        (calculateTip(billAmount, tipPercentage) + billAmount) 
        / numberOfSplitter;

    return totalPerPerson.toStringAsFixed(3);
  }
}
