import 'package:flutter/material.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/culture_article.dart';
import 'package:nyetam/presentation/culture_controller.dart';

class CultureGuidePage extends StatelessWidget {
  const CultureGuidePage({super.key, required this.controller});

  final CultureController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Culture guide'),
          actions: [
            IconButton(
              tooltip: 'Saved articles',
              onPressed: () {},
              icon: const Icon(Icons.bookmark_outline),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _GuideIntroduction()),
            SliverToBoxAdapter(child: _TopicFilters(controller: controller)),
            SliverToBoxAdapter(child: _RegionFilter(controller: controller)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.topic?.label ?? 'Stories and traditions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      '${controller.visibleArticles.length} reads',
                      style: const TextStyle(
                        color: AppColors.forest,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.visibleArticles.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No guide articles match these filters.'),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                sliver: SliverList.separated(
                  itemCount: controller.visibleArticles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) =>
                      _CultureCard(article: controller.visibleArticles[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GuideIntroduction extends StatelessWidget {
  const _GuideIntroduction();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      height: 185,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1523805009345-7448845a9e53?auto=format&fit=crop&w=1400&q=85',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: AppColors.forest),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xD9173129)],
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travel with understanding',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Food, language, history and respectful ways to connect.',
                  style: TextStyle(color: Colors.white, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicFilters extends StatelessWidget {
  const _TopicFilters({required this.controller});

  final CultureController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              selected: controller.topic == null,
              label: const Text('All topics'),
              onSelected: (_) => controller.selectTopic(null),
            ),
          ),
          ...CultureTopic.values.map(
            (topic) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                selected: controller.topic == topic,
                avatar: Icon(topic.icon, size: 17),
                label: Text(topic.label),
                onSelected: (_) => controller.selectTopic(
                  controller.topic == topic ? null : topic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegionFilter extends StatelessWidget {
  const _RegionFilter({required this.controller});

  final CultureController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: DropdownButtonFormField<String?>(
        initialValue: controller.region,
        decoration: const InputDecoration(
          labelText: 'Region',
          prefixIcon: Icon(Icons.map_outlined),
        ),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('All Cameroon'),
          ),
          ...controller.regions.map(
            (region) =>
                DropdownMenuItem<String?>(value: region, child: Text(region)),
          ),
        ],
        onChanged: controller.selectRegion,
      ),
    );
  }
}

class _CultureCard extends StatelessWidget {
  const _CultureCard({required this.article});

  final CultureArticle article;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CultureArticlePage(article: article),
          ),
        ),
        child: Row(
          children: [
            Hero(
              tag: 'culture-${article.id}',
              child: Image.network(
                article.imageUrl,
                width: 112,
                height: 126,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 112,
                  height: 126,
                  color: AppColors.moss,
                  child: Icon(article.topic.icon, color: AppColors.forest),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${article.topic.label.toUpperCase()} · ${article.region.toUpperCase()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.clay,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${article.readMinutes} min read',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CultureArticlePage extends StatelessWidget {
  const CultureArticlePage({super.key, required this.article});

  final CultureArticle article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton.filled(
              tooltip: 'Back',
              style: IconButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'culture-${article.id}',
                child: Image.network(
                  article.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.moss,
                    alignment: Alignment.center,
                    child: Icon(
                      article.topic.icon,
                      size: 58,
                      color: AppColors.forest,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${article.topic.label.toUpperCase()} · ${article.region.toUpperCase()}',
                    style: const TextStyle(
                      color: AppColors.clay,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    article.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.subtitle,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    article.introduction,
                    style: const TextStyle(fontSize: 17, height: 1.6),
                  ),
                  const SizedBox(height: 26),
                  ...article.sections.map(
                    (section) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            section.content,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 16,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4D6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.handshake_outlined, color: AppColors.clay),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Local customs vary. Follow your host’s lead and ask respectfully when unsure.',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
