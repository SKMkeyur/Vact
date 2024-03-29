import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ourvoice/screens/loginpage.dart';
import 'package:ourvoice/widgets/submit.dart';

class SingnUpOtpScreen extends StatefulWidget {

  final String email;
  const SingnUpOtpScreen(this.email);

  @override
  _SingnUpOtpScreenState createState() => _SingnUpOtpScreenState();
}

class _SingnUpOtpScreenState extends State<SingnUpOtpScreen> {

  bool loadingButton = false;
  bool showMessage = false;
  String message = '';
  final _otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verification',
          style: TextStyle(
              fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context, false),
          /* onPressed: () => exit(0), */
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          child:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                new Image(
                  image: new AssetImage('assets/images/forget_password.png'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "Verification",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
                TextFormField(
                  controller: _otp,
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      color: Colors.black),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter Verification Code',
                    hintStyle: TextStyle(color: Colors.black12),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black45,width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        BorderSide(color: Color(0xFFff862e), width: 2.0)),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                  (value.isEmpty) ? 'OTP is required' : null,
                ),
                SizedBox(
                  height: 10,
                ),
                showMessage
                    ? Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                )
                    : Center(),
                SizedBox(
                  height: 10,
                ),
                loadingButton
                    ? SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator())
                    : Center(),
                SizedBox(
                  height: 10,
                ),
                new RaisedButton(
                  color: loadingButton ? Colors.grey : Color(0xFFff862e),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: ()  {
                    !loadingButton
                        ? setState(() {
                          print(_otp.text.toString());
                          if(_otp.text.toString() != null && _otp.text.toString() != ''){
                            callVerifyLoginOtpApi(widget.email,_otp.text);
                          }else{
                            setState(() {
                              showMessage=true;
                              message="Invalid verification code";
                            });

                          }
                      }
                    )
                        : {};
                  },
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    //'Reset Password',
                    'Verify Code',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffffffff)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> callVerifyLoginOtpApi(String email, String otp) async {
    try {
      setState(() {
        loadingButton = true;
        showMessage = false;
      });
      //String userId = tempObject;
      //vact.tech/wp-json/wp/v2/verify_login_otp?email=abc@gmail.com&otp=6008
      //vact.tech/wp-json/wp/v2/verify_login_otp?email=abc@gmail.com&otp=6008
      var uri =
          'https://vact.tech/wp-json/wp/v2/verify_login_otp?email=${email}&&otp=${otp}';
      print(uri);
      var response = await post(Uri.parse(uri));
      print('response :' + response.body);
      Map data = json.decode(response.body) as Map;
       message = data['message'] as String;
      if(data['success'] == true ){
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new SubmitScreen()
          ),
        );
      }else{
        setState(() {
          loadingButton = false;
          showMessage = true;
          message = data['message'] as String;
        });
      }
    } catch (e) {
      Timer(Duration(seconds: 1), () {
        setState(() {
          loadingButton = false;
        });
      });
      print(e);
    }
  }



}
