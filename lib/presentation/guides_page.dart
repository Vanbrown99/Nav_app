import 'package:flutter/material.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/tour_guide.dart';
import 'package:nyetam/presentation/guides_controller.dart';

class GuidesFeature extends StatelessWidget {
  const GuidesFeature({super.key, required this.controller});

  final GuidesController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Explore with a local',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GuidesPage(controller: controller),
                    ),
                  ),
                  child: const Text('View guides'),
                ),
              ],
            ),
          ),
          if (controller.isLoading)
            const SizedBox(
              height: 118,
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SizedBox(
              height: 118,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: controller.guides.take(3).length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final guide = controller.guides[index];
                  return _CompactGuideCard(
                    guide: guide,
                    onTap: () => _openGuide(context, guide, controller),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class GuidesPage extends StatelessWidget {
  const GuidesPage({super.key, required this.controller});

  final GuidesController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Local tour guides')),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Travel with local knowledge',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Compare verified guides by region, language and experience.',
                      style: TextStyle(color: AppColors.muted, height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            initialValue: controller.region,
                            decoration: const InputDecoration(
                              labelText: 'Region',
                            ),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All regions'),
                              ),
                              ...controller.regions.map(
                                (region) => DropdownMenuItem<String?>(
                                  value: region,
                                  child: Text(region),
                                ),
                              ),
                            ],
                            onChanged: controller.selectRegion,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            initialValue: controller.language,
                            decoration: const InputDecoration(
                              labelText: 'Language',
                            ),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('Any language'),
                              ),
                              ...controller.languages.map(
                                (language) => DropdownMenuItem<String?>(
                                  value: language,
                                  child: Text(language),
                                ),
                              ),
                            ],
                            onChanged: controller.selectLanguage,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              sliver: controller.visibleGuides.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: Text('No guides match these filters.'),
                        ),
                      ),
                    )
                  : SliverList.separated(
                      itemCount: controller.visibleGuides.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final guide = controller.visibleGuides[index];
                        return _GuideCard(
                          guide: guide,
                          onTap: () => _openGuide(context, guide, controller),
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

class _CompactGuideCard extends StatelessWidget {
  const _CompactGuideCard({required this.guide, required this.onTap});

  final TourGuide guide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 230,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _GuideAvatar(guide: guide, size: 70),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              guide.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.forest,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${guide.city} · ${guide.languages.first}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 15,
                            color: AppColors.gold,
                          ),
                          Expanded(
                            child: Text(
                              ' ${guide.rating} · ${guide.yearsExperience} yrs',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.guide, required this.onTap});

  final TourGuide guide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GuideAvatar(guide: guide, size: 88),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            guide.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Icon(
                          Icons.verified,
                          color: AppColors.forest,
                          size: 19,
                        ),
                      ],
                    ),
                    Text(
                      '${guide.city}, ${guide.region}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      guide.services.take(2).join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: AppColors.gold),
                        Text(' ${guide.rating} (${guide.reviewCount})'),
                        const Spacer(),
                        Text(
                          guide.priceLabel,
                          style: const TextStyle(
                            color: AppColors.forest,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuideAvatar extends StatelessWidget {
  const _GuideAvatar({required this.guide, required this.size});

  final TourGuide guide;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'guide-${guide.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.network(
          guide.imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            width: size,
            height: size,
            color: AppColors.moss,
            alignment: Alignment.center,
            child: Text(
              guide.name.characters.first,
              style: const TextStyle(
                color: AppColors.forest,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _openGuide(
  BuildContext context,
  TourGuide guide,
  GuidesController controller,
) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => GuideDetailPage(guide: guide, controller: controller),
    ),
  );
}

class GuideDetailPage extends StatelessWidget {
  const GuideDetailPage({
    super.key,
    required this.guide,
    required this.controller,
  });

  final TourGuide guide;
  final GuidesController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Guide profile')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GuideAvatar(guide: guide, size: 112),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              guide.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.verified, color: AppColors.forest),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${guide.city}, ${guide.region}'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.gold,
                            size: 18,
                          ),
                          Text(
                            ' ${guide.rating} (${guide.reviewCount} reviews)',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE3ECDD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: AppColors.forest),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Identity and professional information verified by Nyetam.',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('About', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              guide.bio,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _GuideInfo(
              icon: Icons.translate,
              title: 'Languages',
              value: guide.languages.join(', '),
            ),
            _GuideInfo(
              icon: Icons.map_outlined,
              title: 'Areas covered',
              value: guide.areasCovered.join(', '),
            ),
            _GuideInfo(
              icon: Icons.workspace_premium_outlined,
              title: 'Experience',
              value: '${guide.yearsExperience} years',
            ),
            const SizedBox(height: 20),
            Text('Services', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: guide.services
                  .map((service) => Chip(label: Text(service)))
                  .toList(),
            ),
            const SizedBox(height: 22),
            Text(
              guide.priceLabel,
              style: const TextStyle(
                color: AppColors.forest,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: FilledButton.icon(
              onPressed: controller.hasRequested(guide)
                  ? null
                  : () => _showGuideRequest(context, guide, controller),
              icon: Icon(
                controller.hasRequested(guide)
                    ? Icons.check
                    : Icons.chat_bubble_outline,
              ),
              label: Text(
                controller.hasRequested(guide)
                    ? 'Request sent'
                    : 'Request this guide',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GuideInfo extends StatelessWidget {
  const _GuideInfo({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.forest),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(value, style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showGuideRequest(
  BuildContext context,
  TourGuide guide,
  GuidesController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.cream,
    builder: (_) => _GuideRequestForm(guide: guide, controller: controller),
  );
}

class _GuideRequestForm extends StatefulWidget {
  const _GuideRequestForm({required this.guide, required this.controller});

  final TourGuide guide;
  final GuidesController controller;

  @override
  State<_GuideRequestForm> createState() => _GuideRequestFormState();
}

class _GuideRequestFormState extends State<_GuideRequestForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  int _partySize = 1;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.controller.requestGuide(
        guide: widget.guide,
        travelerName: _nameController.text,
        partySize: _partySize,
        tripDetails: _detailsController.text,
      );
      if (mounted) Navigator.pop(context);
    } on ArgumentError catch (error) {
      setState(() => _error = error.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        18,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Request ${widget.guide.name}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Share enough detail for the guide to confirm availability and a final price.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Your name'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _partySize,
              decoration: const InputDecoration(labelText: 'Travelers'),
              items: List.generate(
                10,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1}'),
                ),
              ),
              onChanged: (value) => setState(() => _partySize = value ?? 1),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _detailsController,
              minLines: 3,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Trip details',
                hintText: 'Dates, places and activities you have in mind',
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
                onPressed: _submit,
                child: const Text('Send request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
