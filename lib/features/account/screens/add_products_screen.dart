import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../services/account_services.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/other_utils.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_textformfield.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = "/Add-product";
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController prodNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  AccountServices accountServices = AccountServices();
  GlobalKey<FormState> _addNewProdFormKey = GlobalKey<FormState>();

  //The initial value of the dropDown (for categories):-
  String currCategory = "Bio Technology";

  //All images seleceted by the admin
  List<File> selectedImages = [];

  //Disposing the text fields:-
  @override
  void dispose() {
    super.dispose();
    prodNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    descController.dispose();
  }

  //All the categories list:-
  List<String> allCategories = [
    'Bio Tech',
    'Civil',
    'Chemical',
    'CS & IT',
    'Electrical',
    'Electronics',
    'Mechanical',
  ];

  //Function to select the images:-
  void selectImages() async {
    var allSelected = await pickProductImages();
    setState(() {
      selectedImages =
          allSelected; //setting the selected umages list them with the returned value
    });
  }

  //function to add new product for selling:-
  void addProduct() {
    //Validate the fields and for image check it should not be empty ie at least a single image should be chosen for the product to add:
    if (_addNewProdFormKey.currentState!.validate() ||
        selectedImages.isNotEmpty) {
      accountServices.listProduct(
        prodName: prodNameController.text,
        description: descController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        prodImages: selectedImages,
        category: currCategory,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Admin',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addNewProdFormKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                selectedImages.isNotEmpty
                    //If the admin has seleceted some images then we will show those images using a carousel slider similar to what we have used in the home screen , and if not selecetd then we will show the gesture detector to select the images
                    ? CarouselSlider(
                        items: selectedImages.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) => Image.file(
                                i,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap:
                            selectImages, //whenever the admin clicks in this containee then then this method will run to select the images
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [
                            10,
                            4
                          ], //describe the pattern distance and how dottest will be formed , their length too
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //a folder icon and below it a text showing select an image
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(
                                  height: 17,
                                ),
                                Text(
                                  "Select images for Product",
                                  style: TextStyle(color: Colors.grey.shade400),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 33,
                ),
                //Shwoing the text fields now (we can use the cutom text field only which we have created already)
                CustomTextFormField(
                  mycontroller: prodNameController,
                  hinttxt: "Product Name",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  mycontroller: descController,
                  hinttxt: "Description",
                  maxLines: 6,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  mycontroller: priceController,
                  hinttxt: "Price",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  mycontroller: quantityController,
                  hinttxt: "Quantity",
                ),
                const SizedBox(
                  height: 10,
                ),

                //Now we have to show all the categories from which the admin can choose , (in a dropdown fashion)
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: currCategory,
                    // ignore: non_constant_identifier_names
                    items: allCategories.map((String Cat) {
                      return DropdownMenuItem(
                        value: Cat,
                        child: Text(Cat),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_downward_rounded),
                    onChanged: (String? clickedCategory) {
                      setState(() {
                        currCategory = clickedCategory!;
                      });
                    },
                  ),
                ),

                //Now the button to add this product to sell:-
                const SizedBox(
                  height: 10,
                ),
                CustomButton(toShow: "Add to Sell", onTap: addProduct)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
