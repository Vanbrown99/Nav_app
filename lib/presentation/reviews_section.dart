import 'package:flutter/material.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/domain/review.dart';
import 'package:nyetam/presentation/reviews_controller.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({
    super.key,
    required this.place,
    required this.controller,
  });

  final Place place;
  final ReviewsController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final reviews = controller.reviewsFor(place.id);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Traveler reviews',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => showReviewComposer(
                    context,
                    place: place,
                    controller: controller,
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Write a review'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (reviews.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No written reviews yet. Share practical details from your visit.',
                  style: TextStyle(color: AppColors.muted),
                ),
              )
            else
              ...reviews
                  .take(3)
                  .map(
                    (review) =>
                        _ReviewTile(review: review, controller: controller),
                  ),
          ],
        );
      },
    );
  }
}

Future<void> showReviewComposer(
  BuildContext context, {
  required Place place,
  required ReviewsController controller,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.cream,
    builder: (_) => _ReviewComposer(place: place, controller: controller),
  );
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review, required this.controller});

  final Review review;
  final ReviewsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: AppColors.moss,
                foregroundColor: AppColors.forest,
                child: Text(
                  review.authorName.characters.first.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            review.authorName,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (review.isVerifiedVisit) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_outlined,
                            size: 16,
                            color: AppColors.forest,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      review.dateLabel,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Review options',
                onSelected: (_) async {
                  await controller.report(review);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Review reported for moderation.'),
                    ),
                  );
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'report',
                    enabled: !controller.isReported(review),
                    child: Text(
                      controller.isReported(review)
                          ? 'Reported'
                          : 'Report review',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                size: 17,
                color: AppColors.gold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: const TextStyle(height: 1.45)),
          const SizedBox(height: 7),
          Text(
            '${review.helpfulCount} travelers found this helpful',
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const Divider(height: 28),
        ],
      ),
    );
  }
}

class _ReviewComposer extends StatefulWidget {
  const _ReviewComposer({required this.place, required this.controller});

  final Place place;
  final ReviewsController controller;

  @override
  State<_ReviewComposer> createState() => _ReviewComposerState();
}

class _ReviewComposerState extends State<_ReviewComposer> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  String? _error;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _isSubmitting = true;
    });
    try {
      await widget.controller.submit(
        place: widget.place,
        rating: _rating,
        comment: _commentController.text,
      );
      if (mounted) Navigator.pop(context);
    } on ArgumentError catch (error) {
      setState(() {
        _error = error.message.toString();
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.moss,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Review ${widget.place.name}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Focus on practical, first-hand details that help another traveler.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 20),
            Semantics(
              label: 'Rating from 1 to 5',
              child: Row(
                children: List.generate(
                  5,
                  (index) => IconButton(
                    tooltip: '${index + 1} stars',
                    onPressed: () => setState(() => _rating = index + 1),
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: AppColors.gold,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              minLines: 4,
              maxLines: 6,
              maxLength: 600,
              decoration: const InputDecoration(
                hintText: 'What should travelers know before visiting?',
              ),
            ),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(
                  color: AppColors.clay,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: Text(
                  _isSubmitting ? 'Publishing review' : 'Publish review',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
