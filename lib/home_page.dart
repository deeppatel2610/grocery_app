// import 'package:flutter/material.dart';
// import 'package:grocery_app/home_provider.dart';
// import 'package:grocery_app/profile_page.dart';
// import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// import 'cart_page.dart';
// import 'components/product_box.dart';
// import 'components/product_detail_dialog.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// late stt.SpeechToText _speech;
// bool _isListening = false;
//
// class _HomePageState extends State<HomePage> {
//   final TextEditingController _controller = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//     context.read<HomeProvider>().jsonParsing();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<HomeProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         title: const Text(
//           'Grocery App',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 PageRouteBuilder(
//                   pageBuilder:
//                       (context, animation, secondaryAnimation) =>
//                           const CartPage(),
//                   transitionsBuilder: (
//                     context,
//                     animation,
//                     secondaryAnimation,
//                     child,
//                   ) {
//                     const begin = Offset(1.0, 0.0);
//                     const end = Offset.zero;
//                     const curve = Curves.ease;
//
//                     final tween = Tween(
//                       begin: begin,
//                       end: end,
//                     ).chain(CurveTween(curve: curve));
//
//                     return SlideTransition(
//                       position: animation.drive(tween),
//                       child: child,
//                     );
//                   },
//                 ),
//               );
//             },
//             icon: const Icon(Icons.shopping_cart, color: Colors.black87),
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 PageRouteBuilder(
//                   pageBuilder:
//                       (context, animation, secondaryAnimation) =>
//                           const ProfilePage(),
//                   transitionsBuilder: (
//                     context,
//                     animation,
//                     secondaryAnimation,
//                     child,
//                   ) {
//                     const begin = Offset(1.0, 0.0);
//                     const end = Offset.zero;
//                     const curve = Curves.ease;
//
//                     final tween = Tween(
//                       begin: begin,
//                       end: end,
//                     ).chain(CurveTween(curve: curve));
//
//                     return SlideTransition(
//                       position: animation.drive(tween),
//                       child: child,
//                     );
//                   },
//                 ),
//               );
//             },
//             icon: const Icon(Icons.person, color: Colors.black87),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 12.0,
//               vertical: 8.0,
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: TextField(
//                 controller: _controller,
//                 onChanged: (value) {
//                   provider.filterProducts(value);
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Search for items...',
//                   prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                   suffixIcon:
//                       _controller.text.isNotEmpty
//                           ? IconButton(
//                             icon: const Icon(Icons.clear, color: Colors.grey),
//                             onPressed: () {
//                               _controller.clear();
//                               provider.filterProducts('');
//                             },
//                           )
//                           : null,
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     vertical: 14,
//                     horizontal: 16,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//
//       body: SafeArea(
//         child: Column(
//           children: [
//             // You can add a search/filter bar here if needed
//             Expanded(
//               child:
//                   context.watch<HomeProvider>().filteredList.isEmpty
//                       ? const Center(
//                         child: Text(
//                           'No products found!',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       )
//                       : ListView.separated(
//                         itemCount:
//                             context.watch<HomeProvider>().filteredList.length,
//                         separatorBuilder: (_, __) => const SizedBox(height: 12),
//                         /*itemBuilder: (context, index) {
//                           return ProductBox(
//                             data:
//                                 context
//                                     .watch<HomeProvider>()
//                                     .filteredList[index],
//                             index: index,
//                           );
//                         },*/
//                         itemBuilder: (context, index) {
//                           final product =
//                               context.watch<HomeProvider>().filteredList[index];
//                           return GestureDetector(
//                             onTap: () {
//                               showDialog(
//                                 context: context,
//                                 builder:
//                                     (context) =>
//                                         ProductDetailDialog(product: product),
//                               );
//                             },
//                             child: ProductBox(data: product, index: index),
//                           );
//                         },
//                       ),
//             ),
//           ],
//         ),
//       ),
//
//       // Floating Mic Button
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: GestureDetector(
//         onTap: () async {
//           if (!_isListening) {
//             bool available = await _speech.initialize(
//               onStatus: (val) {
//                 if (val == 'done') {
//                   setState(() => _isListening = false);
//                   _speech.stop();
//                 }
//               },
//               onError: (val) {
//                 setState(() => _isListening = false);
//               },
//             );
//
//             if (available) {
//               setState(() => _isListening = true);
//               _speech.listen(
//                 onResult: (val) {
//                   if (val.recognizedWords.isNotEmpty) {
//                     _controller.text = val.recognizedWords;
//                     context.read<HomeProvider>().filterProducts(
//                       val.recognizedWords,
//                     );
//                   }
//                 },
//               );
//             }
//           } else {
//             setState(() => _isListening = false);
//             _speech.stop();
//           }
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             color: _isListening ? Colors.redAccent : Colors.green,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: (_isListening ? Colors.red : Colors.green).withOpacity(
//                   0.6,
//                 ),
//                 blurRadius: 12,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Center(
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               child: Icon(
//                 _isListening ? Icons.mic : Icons.mic_none,
//                 key: ValueKey<bool>(_isListening),
//                 color: Colors.white,
//                 size: 32,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _categories = [
    'All',
    'instant food',
    'dairy',
    'spices & condiments',
    'cooking essentials',
    'grains & flour',
    'personal care',
    'snacks',
    'beverages',
    'laundry',
    'home cleaning',
    'grains & pulses',
  ];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    context.read<HomeProvider>().jsonParsing();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done') {
            setState(() => _isListening = false);
            _pulseController.stop();
            _speech.stop();
          }
        },
        onError: (val) {
          setState(() => _isListening = false);
          _pulseController.stop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Voice search error. Please try again.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _pulseController.repeat(reverse: true);
        _speech.listen(
          onResult: (val) {
            if (val.recognizedWords.isNotEmpty) {
              _controller.text = val.recognizedWords;
              context.read<HomeProvider>().filterProducts(val.recognizedWords);
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _pulseController.stop();
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildSearchSection(),
                  _buildCategoriesSection(),
                  // _buildPromoBanner(),
                ],
              ),
            ),
          ),
          _buildProductGrid(provider),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildVoiceSearchButton(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.teal,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'FreshMart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal, Color(0xFF00695C)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        _buildAppBarAction(
          icon: Icons.shopping_cart_outlined,
          onPressed: () => _navigateToPage(const CartPage()),
        ),
        _buildAppBarAction(
          icon: Icons.person_outline,
          onPressed: () => _navigateToPage(const ProfilePage()),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildAppBarAction({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged:
            (value) => context.read<HomeProvider>().filterProducts(value),
        decoration: InputDecoration(
          hintText: 'Search for fresh groceries...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          suffixIcon:
              _controller.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[400]),
                    onPressed: () {
                      _controller.clear();
                      context.read<HomeProvider>().filterProducts('');
                    },
                  )
                  : Icon(Icons.mic, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
              // Add category filtering logic here
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.teal : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.teal : Colors.grey[300]!,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _buildPromoBanner() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 '🎉 Special Offer!',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 'Get 20% off on fresh fruits',
  //                 style: TextStyle(
  //                   color: Colors.white.withOpacity(0.9),
  //                   fontSize: 14,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: const Text(
  //             'Shop Now',
  //             style: TextStyle(
  //               color: Color(0xFF4CAF50),
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildProductGrid(HomeProvider provider) {
    if (provider.filteredList.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No products found!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching with different keywords',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = provider.filteredList[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ProductDetailDialog(product: product),
              );
            },
            child: Hero(
              tag: '',
              child: productBox(data: product, index: index),
            ),
          );
        }, childCount: provider.filteredList.length),
      ),
    );
  }

  Widget _buildVoiceSearchButton() {
    return GestureDetector(
      onTap: _startListening,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      _isListening
                          ? [Colors.red, Colors.redAccent]
                          : [Colors.teal, Color(0xFF00695C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : Colors.teal)
                        .withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
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
                    size: 28,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
