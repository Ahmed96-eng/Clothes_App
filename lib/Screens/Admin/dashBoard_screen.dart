// import 'package:Clothes_App/Models/http_exception.dart';
// import 'package:Clothes_App/Providers/boolProvider.dart';
// import 'package:Clothes_App/Services/DataServices.dart';
// import 'package:Clothes_App/Widgets/shared_widget.dart';
// import 'package:Clothes_App/Widgets/testFormField_widget.dart';
// import 'package:Clothes_App/constants.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DashBoardScreen extends StatefulWidget {
//   static const route = 'dashBoard_screen';

//   @override
//   _DashBoardScreenState createState() => _DashBoardScreenState();
// }

// class _DashBoardScreenState extends State<DashBoardScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _dataServices = DataServices();
//   var valueProperty = '';

//   final _priceFoucsNode = FocusNode();
//   final _stockQuantityFoucsNode = FocusNode();
//   final _descriptionFoucsNode = FocusNode();
//   final _nameFoucsNode = FocusNode();
//   final _categoryFoucsNode = FocusNode();

//   Map<String, String> _productData = {
//     kProductName: '',
//     kProductPrice: '',
//     kProductStockQuantity: '',
//     kProductDescription: '',
//     kProductImage: '',
//     kProductCategory: '',
//   };

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: Colors.red[400].withOpacity(0.4),
//         title: Text(
//           'An Error Occurred!',
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[800],
//               fontSize: 20),
//         ),
//         content: Text(
//           message,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             shape: StadiumBorder(),
//             color: Colors.white,
//             child: new Text(
//               'Okay',
//               style: TextStyle(color: Colors.black54),
//             ),
//             onPressed: () => Navigator.of(ctx).pop(),
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _submit() async {
//     final provider = Provider.of<BoolProvider>(context, listen: false);
//     if (!_formKey.currentState.validate()) {
//       // Invalid!
//       return;
//     }
//     _formKey.currentState.save();
//     provider.changeLoadingValue(true);

//     try {
//       _dataServices.addProduct(
//         name: _productData[kProductName],
//         description: _productData[kProductDescription],
//         price: double.parse(_productData[kProductPrice]),
//         image: _productData[kProductImage],
//         stockQuantity: int.parse(_productData[kProductStockQuantity]),
//         quantity: 1,
//         category: _productData[kProductCategory],
//       );
//     } on HttpException catch (error) {
//       String errorMessage = error.toString();
//       _showErrorDialog(errorMessage);
//     }

//     provider.changeLoadingValue(false);
//   }

//   @override
//   void dispose() {
//     _priceFoucsNode.dispose();
//     _stockQuantityFoucsNode.dispose();
//     _descriptionFoucsNode.dispose();
//     _nameFoucsNode.dispose();
//     _categoryFoucsNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: SharedWidget.dialogDecoration(),
//           ),
//           Form(
//               key: _formKey,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: ListView(
//                   children: [
//                     TextFormFieldWidget(
//                       // initialValue: _initialData[kProductImage],
//                       hintDecoration: 'product image',
//                       keyboardType: TextInputType.name,
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Enter the imageUrl Please!';
//                         }
//                       },
//                       onSumbit: (_) {
//                         FocusScope.of(context).requestFocus(_categoryFoucsNode);
//                       },
//                       onSave: (value) {
//                         _productData[kProductImage] = value;
//                       },
//                     ),
//                     TextFormFieldWidget(
//                       // initialValue: _initialData[kProductCategory],
//                       hintDecoration: 'product category',
//                       keyboardType: TextInputType.name,
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Enter the category Please!';
//                         }
//                       },
//                       focusNode: _categoryFoucsNode,
//                       onSumbit: (_) {
//                         FocusScope.of(context).requestFocus(_nameFoucsNode);
//                       },
//                       onSave: (value) {
//                         _productData[kProductCategory] = value;
//                       },
//                     ),
//                     TextFormFieldWidget(
//                       // initialValue: _initialData[kProductName],
//                       hintDecoration: 'product name',
//                       keyboardType: TextInputType.name,
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Enter the name Please!';
//                         }
//                       },
//                       focusNode: _nameFoucsNode,
//                       onSumbit: (_) {
//                         FocusScope.of(context).requestFocus(_priceFoucsNode);
//                       },
//                       onSave: (value) {
//                         _productData[kProductName] = value;
//                       },
//                     ),
//                     TextFormFieldWidget(
//                       // initialValue: _initialData[kProductPrice].toString(),
//                       hintDecoration: 'product price',
//                       keyboardType: TextInputType.numberWithOptions(),
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Enter the price Please!';
//                         }
//                       },
//                       focusNode: _priceFoucsNode,
//                       onSumbit: (_) {
//                         FocusScope.of(context)
//                             .requestFocus(_stockQuantityFoucsNode);
//                       },
//                       onSave: (value) {
//                         _productData[kProductPrice] = value;
//                       },
//                     ),
//                     TextFormFieldWidget(
//                       // initialValue:
//                       //     _initialData[kProductStockQuantity].toString(),
//                       hintDecoration: 'product quantity',
//                       keyboardType: TextInputType.numberWithOptions(),
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Enter the quantity Please!';
//                         }
//                       },
//                       focusNode: _stockQuantityFoucsNode,
//                       onSumbit: (_) {
//                         FocusScope.of(context)
//                             .requestFocus(_descriptionFoucsNode);
//                       },
//                       onSave: (value) {
//                         _productData[kProductStockQuantity] = value;
//                       },
//                     ),
//                     TextFormFieldWidget(
//                       // initialValue: _initialData[kProductDescription],
//                       hintDecoration: 'product description',
//                       keyboardType: TextInputType.name,
//                       textInputAction: TextInputAction.done,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Enter the description Please!';
//                         }
//                       },
//                       focusNode: _descriptionFoucsNode,
//                       onSave: (value) {
//                         _productData[kProductDescription] = value;
//                       },
//                     ),
//                     SizedBox(height: 50),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         color: Colors.grey.withOpacity(0.6),
//                         border: Border.all(
//                             color: Colors.redAccent.withOpacity(0.4)),
//                       ),
//                       child: FlatButton(
//                         child: Text('Add Product'),
//                         onPressed: () {
//                           _submit();
//                         },
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 30.0, vertical: 8.0),
//                         color: Colors.transparent,
//                         textColor: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:Clothes_App/Models/http_exception.dart';
import 'package:Clothes_App/Providers/boolProvider.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/Widgets/testFormField_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as Img;

class DashBoardScreen extends StatefulWidget {
  static const route = 'dashBoard_screen';

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dataServices = DataServices();
  var valueProperty = '';
  File _file;
  final picker = ImagePicker();
  StorageReference storageReference = FirebaseStorage.instance.ref();

  final _priceFoucsNode = FocusNode();
  final _stockQuantityFoucsNode = FocusNode();
  final _descriptionFoucsNode = FocusNode();
  final _nameFoucsNode = FocusNode();
  final _categoryFoucsNode = FocusNode();

  Map<String, String> _productData = {
    kProductName: '',
    kProductPrice: '',
    kProductStockQuantity: '',
    kProductDescription: '',
    kProductImage: '',
    kProductCategory: '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.red[400].withOpacity(0.4),
        title: Text(
          'An Error Occurred!',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontSize: 20),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            shape: StadiumBorder(),
            color: Colors.white,
            child: new Text(
              'Okay',
              style: TextStyle(color: Colors.black54),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final provider = Provider.of<BoolProvider>(context, listen: false);
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    provider.changeLoadingValue(true);

    try {
      await compressImage();
      final imageUrl = await upLoadImage(_file);
      _dataServices.addProduct(
        name: _productData[kProductName],
        description: _productData[kProductDescription],
        price: double.parse(_productData[kProductPrice]),
        // image: _productData[kProductImage],
        image: imageUrl,
        stockQuantity: int.parse(_productData[kProductStockQuantity]),
        quantity: 1,
        category: _productData[kProductCategory],
      );
    } on HttpException catch (error) {
      String errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }

    provider.changeLoadingValue(false);
  }

  @override
  void dispose() {
    _priceFoucsNode.dispose();
    _stockQuantityFoucsNode.dispose();
    _descriptionFoucsNode.dispose();
    _nameFoucsNode.dispose();
    _categoryFoucsNode.dispose();
    super.dispose();
  }

  compressImage() async {
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    Img.Image imageFile = Img.decodeImage(_file.readAsBytesSync());
    final compressImageFile =
        File('$path/img_${_productData[kProductName]}.jpg')
          ..writeAsBytesSync(Img.encodeJpg(imageFile));
    setState(() {
      _file = compressImageFile;
    });
  }

  upLoadImage(imageFile) async {
    StorageUploadTask uploadTask = storageReference
        .child("imageProduct_${_productData[kProductName]}.jpg")
        .putFile(imageFile);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _showUploadDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("from where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text('Gallery'),
                      onTap: () async {
                        final file =
                            await picker.getImage(source: ImageSource.gallery);
                        setState(() {
                          _file = File(file.path);
                          _productData[kProductImage] = _file.toString();
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text('Camera'),
                      onTap: () async {
                        final file =
                            await picker.getImage(source: ImageSource.camera);
                        setState(() {
                          _file = File(file.path);
                          _productData[kProductImage] = _file.toString();
                        });
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: SharedWidget.dialogDecoration(),
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300],
                          border: Border.all(
                              color: Colors.redAccent.withOpacity(0.4))),
                      child: _file == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: RaisedButton.icon(
                                  icon: Icon(Icons.file_upload),
                                  label: Text(
                                    "Select Image",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  ),
                                  onPressed: () async {
                                    _showUploadDialog(context);
                                  }),
                            )
                          : Container(
                              // decoration: new BoxDecoration(color: Colors.white),
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[300],
                                  border: Border.all(
                                      color:
                                          Colors.redAccent.withOpacity(0.4))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: <Widget>[
                                    Image.file(
                                      _file,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      // fit: BoxFit.contain,
                                    ),
                                    Positioned(
                                      top: 5,
                                      right:
                                          5, //give the values according to your requirement
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey[500],
                                            border: Border.all(
                                                color: Colors.redAccent
                                                    .withOpacity(0.4))),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              size: 25,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _file = null;
                                              });
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    // TextFormFieldWidget(
                    //   // initialValue: _initialData[kProductImage],
                    //   hintDecoration: 'product image',
                    //   keyboardType: TextInputType.name,
                    //   textInputAction: TextInputAction.next,
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Enter the imageUrl Please!';
                    //     }
                    //   },
                    //   onSumbit: (_) {
                    //     FocusScope.of(context).requestFocus(_categoryFoucsNode);
                    //   },
                    //   onSave: (value) {
                    //     _productData[kProductImage] = value;
                    //   },
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300],
                            border: Border.all(
                                color: Colors.redAccent.withOpacity(0.4))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 40),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField(
                            focusNode: _categoryFoucsNode,
                            dropdownColor: Colors.grey[300],

                            items: [
                              DropdownMenuItem(
                                // value: _productData[kProductCategory],
                                value: kTShirts,
                                child: Text(kTShirts),
                              ),
                              DropdownMenuItem(
                                // value: _productData[kProductCategory],
                                value: kShirts,
                                child: Text(kShirts),
                              ),
                              DropdownMenuItem(
                                // value: _productData[kProductCategory],
                                value: kTrousers,
                                child: Text(kTrousers),
                              ),
                              DropdownMenuItem(
                                // value: _productData[kProductCategory],
                                value: kJackets,
                                child: Text(kJackets),
                              ),
                            ],
                            isExpanded: true,
                            decoration: InputDecoration(
                              hintText: 'Category',
                              border: InputBorder.none,
                            ),
                            // value: _productData[kProductCategory],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This Field is Required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _productData[kProductCategory] = value;
                              });
                            },
                            onSaved: (value) {
                              _productData[kProductCategory] = value;
                            },
                          )),
                        ),
                      ),
                    ),

                    // TextFormFieldWidget(
                    //   // initialValue: _initialData[kProductCategory],
                    //   hintDecoration: 'product category',
                    //   keyboardType: TextInputType.name,
                    //   textInputAction: TextInputAction.next,
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Enter the category Please!';
                    //     }
                    //   },
                    //   focusNode: _categoryFoucsNode,
                    //   onSumbit: (_) {
                    //     FocusScope.of(context).requestFocus(_nameFoucsNode);
                    //   },
                    //   onSave: (value) {
                    //     _productData[kProductCategory] = value;
                    //   },
                    // ),
                    TextFormFieldWidget(
                      // initialValue: _initialData[kProductName],
                      hintDecoration: 'product name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter the name Please!';
                        }
                      },
                      focusNode: _nameFoucsNode,
                      onSumbit: (_) {
                        FocusScope.of(context).requestFocus(_priceFoucsNode);
                      },
                      onSave: (value) {
                        _productData[kProductName] = value;
                      },
                    ),
                    TextFormFieldWidget(
                      // initialValue: _initialData[kProductPrice].toString(),
                      hintDecoration: 'product price',
                      keyboardType: TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter the price Please!';
                        }
                      },
                      focusNode: _priceFoucsNode,
                      onSumbit: (_) {
                        FocusScope.of(context)
                            .requestFocus(_stockQuantityFoucsNode);
                      },
                      onSave: (value) {
                        _productData[kProductPrice] = value;
                      },
                    ),
                    TextFormFieldWidget(
                      // initialValue:
                      //     _initialData[kProductStockQuantity].toString(),
                      hintDecoration: 'product quantity',
                      keyboardType: TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter the quantity Please!';
                        }
                      },
                      focusNode: _stockQuantityFoucsNode,
                      onSumbit: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFoucsNode);
                      },
                      onSave: (value) {
                        _productData[kProductStockQuantity] = value;
                      },
                    ),
                    TextFormFieldWidget(
                      // initialValue: _initialData[kProductDescription],
                      hintDecoration: 'product description',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter the description Please!';
                        }
                      },
                      focusNode: _descriptionFoucsNode,
                      onSave: (value) {
                        _productData[kProductDescription] = value;
                      },
                    ),
                    SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.withOpacity(0.6),
                        border: Border.all(
                            color: Colors.redAccent.withOpacity(0.4)),
                      ),
                      child: FlatButton(
                        child: Text('Add Product'),
                        onPressed: () {
                          _submit();
                        },
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        color: Colors.transparent,
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
