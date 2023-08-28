import 'package:flutter/material.dart';

List<Review> dummyReviews = [
  Review(
    companyName: 'ABC Corporation',
    reviewText: 'Great communication skills!',
  ),
  Review(
    companyName: 'XYZ Tech',
    reviewText: 'Strong problem-solving abilities.',
  ),
  // Add more dummy reviews
];

class Review {
  final String companyName;
  final String reviewText;

  Review({required this.companyName, required this.reviewText});
}

class ReviewPage extends StatelessWidget {
  final List<Review> reviews;

  const ReviewPage({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reviews'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 2,
              child: ListTile(
                title: Text(reviews[index].companyName),
                subtitle: Text(reviews[index].reviewText),
                trailing: const Icon(Icons.star),
                onTap: () {
                  // Implement any action you want when tapping a review
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
