import 'package:flutter/material.dart';
import 'package:grocery_app/home_provider.dart';
import 'package:grocery_app/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'cart_page.dart';
import 'components/product_box.dart';
import 'components/product_detail_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

late stt.SpeechToText _speech;
bool _isListening = false;

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    context.read<HomeProvider>().jsonParsing();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Grocery App',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const CartPage(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    final tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.black87),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const ProfilePage(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    final tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.person, color: Colors.black87),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  provider.filterProducts(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search for items...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon:
                      _controller.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _controller.clear();
                              provider.filterProducts('');
                            },
                          )
                          : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // You can add a search/filter bar here if needed
            Expanded(
              child:
                  context.watch<HomeProvider>().filteredList.isEmpty
                      ? const Center(
                        child: Text(
                          'No products found!',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                      : ListView.separated(
                        itemCount:
                            context.watch<HomeProvider>().filteredList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        /*itemBuilder: (context, index) {
                          return ProductBox(
                            data:
                                context
                                    .watch<HomeProvider>()
                                    .filteredList[index],
                            index: index,
                          );
                        },*/
                        itemBuilder: (context, index) {
                          final product =
                              context.watch<HomeProvider>().filteredList[index];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) =>
                                        ProductDetailDialog(product: product),
                              );
                            },
                            child: ProductBox(data: product, index: index),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),

      // Floating Mic Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () async {
          if (!_isListening) {
            bool available = await _speech.initialize(
              onStatus: (val) {
                if (val == 'done') {
                  setState(() => _isListening = false);
                  _speech.stop();
                }
              },
              onError: (val) {
                setState(() => _isListening = false);
              },
            );

            if (available) {
              setState(() => _isListening = true);
              _speech.listen(
                onResult: (val) {
                  if (val.recognizedWords.isNotEmpty) {
                    _controller.text = val.recognizedWords;
                    context.read<HomeProvider>().filterProducts(
                      val.recognizedWords,
                    );
                  }
                },
              );
            }
          } else {
            setState(() => _isListening = false);
            _speech.stop();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _isListening ? Colors.redAccent : Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (_isListening ? Colors.red : Colors.green).withOpacity(
                  0.6,
                ),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                key: ValueKey<bool>(_isListening),
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
