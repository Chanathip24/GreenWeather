import 'package:flutter/material.dart';

import 'package:greenweather/providers/province_provider.dart';

import 'package:greenweather/widgets/Appbar.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provinceProvider = Provider.of<ProvinceProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //appbar
            MainAppBar(),

            // Reviews section header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    'รีวิวยอดนิยมใน ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    provinceProvider.selectProvince ?? 'จังหวัด',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Reviews list
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  // Last review has a different style for demonstration
                  final isLastReview = index == 3;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '@user1234',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.favorite_border,
                                size: 20,
                              ),
                              onPressed: () {},
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const Text(
                          'อากาศดีและบริการประทับใจ พระราม 4',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        // Image placeholder for the review
                        if (index == 0)
                          Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Text('IMG'),
                          ),
                        const SizedBox(height: 8),
                        // Rating chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isLastReview
                                ? const Color(0xFFFFE4E1)
                                : const Color(0xFFFFEBCD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'AGI 130',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
