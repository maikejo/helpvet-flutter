import 'package:flutter/material.dart';
import './options.dart';

typedef FinishInput = void Function(
    VerifyInput inputer, String verCoder, BuildContext ctx);

abstract class InputProtocol {
  void didFinished(VerifyInput inputer, BuildContext ctx, String verCode);
}

class VerifyInput extends StatefulWidget {
  VerifyInput({
    this.codeLength,
    this.size,
    this.options,
    this.delegate,
  });

  final double gap = 8.0;

  final Options options;

  final Size size;

  final int codeLength;

  final InputProtocol delegate;

  _VerifyInputState myState;

  @override
  _VerifyInputState createState() {
    myState = _VerifyInputState();
    return myState;
  }

  String get verCode {
    return myState.getVerCode();
  }
}

class _VerifyInputState extends State<VerifyInput> {
  List<Widget> tfs;
  List<TextEditingController> tfCtrls;

  @override
  initState() {
    super.initState();
    tfCtrls = List.generate(widget.codeLength, (index) {
      TextEditingController ctrl = TextEditingController();
      ctrl.addListener(() {});
      return ctrl;
    });
  }

  String getVerCode() {
    if (tfCtrls != null) {
      List<String> codeStr = tfCtrls.map((ctrl) {
        String char = ctrl.text == "●" ? "" : ctrl.text;
        return char;
      }).toList();
      return codeStr.join();
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    Options opt = widget.options;
    TextField findTextFieldByIndex(int index) {
      Container tfContainer = tfs[index];
      Padding padding = tfContainer.child;
      Theme theme = padding.child;
      GestureDetector gesture = theme.child;
      Container container = gesture.child;
      TextField tf = container.child;
      return tf;
    }

    void setTextFieldSelectAll(int tfIndex) {
      TextEditingController ctrl = tfCtrls[tfIndex];
      ctrl.selection = TextSelection(baseOffset: 0, extentOffset: 1);
    }

    void setFocusedTextFiled(int tfIndex) {
      if (tfIndex > widget.codeLength - 1 || tfIndex < 0) {
        return;
      }
      TextField tf = findTextFieldByIndex(tfIndex);
      FocusScope.of(context).requestFocus(tf.focusNode);
      setTextFieldSelectAll(tfIndex);
    }

    void setTextFieldValue(String text, int tfIndex) {
      TextEditingController ctrl = tfCtrls[tfIndex];
      ctrl.text = text;
      setTextFieldSelectAll(tfIndex);
      setState(() {});
    }

    bool checkCode() {
      bool flag = true;
      for (TextEditingController tf in tfCtrls) {
        if (tf.text.isEmpty || tf.text == "●") {
          flag = false;
          break;
        }
      }
      return flag;
    }

    void _handleChange(String text, int index) {
      if (text.length == 0) {
        // print('$index 文本框值发生改变,变为空');
        setTextFieldValue('●', index);
        // print('$index 文本框设置为默认值●');
        if (index > 0) {
          // print('${index-1} 设置焦点');
          setFocusedTextFiled(index - 1);
        }
        return;
      } else {
        // print('$index 文本框值发送改变,变为$text');
        setTextFieldValue(text, index);
        // print('${index+1} 设置焦点');
        setFocusedTextFiled(index + 1);
      }

      ///如果验证码全部输入完,调用回调
      if (checkCode()) {
        if (widget.delegate != null) {
          widget.delegate.didFinished(widget, context, getVerCode());
        }
        // widget.finishInput(widget,getVerCode(),context);
      }
    }

    void focused(int index) {
      TextField tf = findTextFieldByIndex(index);
      TextEditingController ctrl = tfCtrls[index];

      if (tf.focusNode.hasFocus) {
        // print('$index 获得焦点');
        if (ctrl.text.isEmpty || ctrl.text == '●') {
          // print('$index 内容为空,设置为默认值');
          ctrl.text = '●';
        }
      }
      // print('$index 设置内容全选');
      setTextFieldSelectAll(index);
    }

    tfs = List.generate(widget.codeLength, (index) {
      ///获取当前皮肤
      final ThemeData base = Theme.of(context);

      TextEditingController ctrl = tfCtrls[index];
      Color borderColor = (ctrl.text.isEmpty || ctrl.text == '●')
          ? opt.emptyUnderLineColor
          : opt.inputedUnderLineColor;
      Color textColor = (ctrl.text.isEmpty || ctrl.text == '●')
          ? Colors.transparent
          : opt.fontColor;

      ThemeData buildDarkTheme() {
        return base.copyWith(
          textSelectionColor: Colors.transparent,
//                    textSelectionHandleColor: Colors.green,
          secondaryHeaderColor: Colors.transparent,
          accentColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            disabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: borderColor)),
          ),
        );
      }

      FocusNode fc = FocusNode();
      fc.addListener(() {
        focused(index);
      });

      return Container(
        width: (widget.size.width / widget.codeLength),
        child: Padding(
          padding: EdgeInsets.all(widget.gap),
          child: Theme(
            data: buildDarkTheme(),
            child: GestureDetector(
              onTap: () {
                setFocusedTextFiled(index);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                child: TextField(
                  controller: ctrl,
                  key: Key(index.toString()),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  cursorColor: Colors.transparent,
                  enabled: false,
                  style: TextStyle(
                    fontSize: opt.fontSize,
                    color: textColor,
                    fontWeight: opt.fontWeight,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                  ),
                  onChanged: (String text) {
                    _handleChange(text, index);
                  },
                  autofocus: index == 0,
                  focusNode: fc,
                ),
              ),
            ),
          ),
        ),
      );
    });

    return SizedBox(
      height: widget.size.height,
      width: widget.size.width,
      child: ListView(
        padding: EdgeInsets.zero,
        children: tfs,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
