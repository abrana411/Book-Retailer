import 'package:flutter/material.dart';

import '../services/admin_services.dart';
import '../../../models/product_model.dart';
import '../../account/widgets/single_product.dart';
import '../../../constants/screen_loader.dart';
import '../../account/screens/add_products_screen.dart';

class ProdsScreen extends StatefulWidget {
  const ProdsScreen({super.key});

  @override
  State<ProdsScreen> createState() => _ProdsScreenState();
}

class _ProdsScreenState extends State<ProdsScreen> {
  AdminServices adminServices = AdminServices();
  List<Product>?
      allProducts; //here not doing [] initially and for loading not checking if the allProducts list is empty or not , because initially for the very first time when the admin logs in then this list will be empty too even afetr fetching , so that why this will be null initially so using ? for that purpose , for stating that this can be null too
  @override
  void initState() {
    super.initState();
    getTheProds();
  }

  //Function to invoke the get products :-
  void getTheProds() async {
    allProducts = await adminServices.getAllProds(context);
    setState(() {});
  }

  //Function to invoke the delete product function:-
  void deleteProduct(Product prodToDelete, int index) {
    adminServices.deleteAProduct(
        context: context,
        product: prodToDelete,
        ondeletion: () {
          allProducts!.removeAt(index);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return allProducts == null
        ? const ScreenLoader()
        : Scaffold(
            body: GridView.builder(
                itemCount: allProducts!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  Product currProduct = allProducts![index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: SingleProduct(
                            imageSrc: currProduct.images[
                                0]), //only the 0th image (as all the details of products are not shown here just a single image is shown)
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              currProduct.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => deleteProduct(currProduct, index),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AddProductScreen.routeName);
                //not creating a seperate function for this as this is a single line
              },
              tooltip:
                  "Add a new Product", //when the user taps on this button then this will show
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
