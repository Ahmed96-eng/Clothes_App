import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  String hintDecoration;
  String initialValue;
  Function validator;
  Function onSumbit;
  Function onSave;
  FocusNode focusNode;
  TextInputType keyboardType;
  TextInputAction textInputAction;

  TextFormFieldWidget({
    this.hintDecoration,
    this.initialValue,
    this.validator,
    this.onSumbit,
    this.onSave,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[300],
            border: Border.all(color: Colors.redAccent.withOpacity(0.4))),
        child: TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hintDecoration,
            border: InputBorder.none,
            labelStyle: TextStyle(color: Colors.black),
          ),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          validator: validator,
          onFieldSubmitted: onSumbit,
          onSaved: onSave,
        ),
      ),
    );
  }
}
