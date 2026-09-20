import 'package:flutter/material.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/tourism_event.dart';
import 'package:nyetam/presentation/events_controller.dart';

class UpcomingEventsRail extends StatelessWidget {
  const UpcomingEventsRail({super.key, required this.controller});

  final EventsController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Upcoming in Cameroon',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  '${controller.events.length} events',
                  style: const TextStyle(
                    color: AppColors.forest,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (controller.isLoading)
            const SizedBox(
              height: 248,
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SizedBox(
              height: 248,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: controller.events.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _EventCard(
                  event: controller.events[index],
                  controller: controller,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class EventItinerarySection extends StatelessWidget {
  const EventItinerarySection({super.key, required this.controller});

  final EventsController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.itineraryEvents.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text('Saved events', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...controller.itineraryEvents.map(
              (event) => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Container(
                  width: 48,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4D6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    event.dateLabel.replaceFirst(' ', '\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.clay,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
                title: Text(
                  event.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('${event.startTime} · ${event.venue}'),
                trailing: IconButton(
                  tooltip: 'Remove event',
                  onPressed: () => controller.toggleItinerary(event),
                  icon: const Icon(Icons.close),
                ),
                onTap: () => _openEvent(context, event, controller),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.controller});

  final TourismEvent event;
  final EventsController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openEvent(context, event, controller),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: 'event-${event.id}',
                    child: Image.network(
                      event.imageUrl,
                      width: double.infinity,
                      height: 138,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 138,
                        color: AppColors.moss,
                        child: const Icon(
                          Icons.celebration_outlined,
                          size: 42,
                          color: AppColors.forest,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event.dateLabel,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${event.city} · ${event.startTime} · ${event.category}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
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

void _openEvent(
  BuildContext context,
  TourismEvent event,
  EventsController controller,
) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => EventDetailPage(event: event, controller: controller),
    ),
  );
}

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({
    super.key,
    required this.event,
    required this.controller,
  });

  final TourismEvent event;
  final EventsController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              pinned: true,
              expandedHeight: 290,
              leading: IconButton.filled(
                tooltip: 'Back',
                style: IconButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'event-${event.id}',
                  child: Image.network(event.imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.category.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.clay,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _EventFact(
                            icon: Icons.calendar_today_outlined,
                            title: event.dateLabel,
                            value: event.startTime,
                          ),
                        ),
                        Expanded(
                          child: _EventFact(
                            icon: Icons.location_on_outlined,
                            title: event.city,
                            value: event.venue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'About the event',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.description,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _EventInfoRow(
                      icon: Icons.groups_outlined,
                      label: 'Organizer',
                      value: event.organizer,
                    ),
                    _EventInfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Tickets',
                      value: event.ticketLabel,
                    ),
                    _EventInfoRow(
                      icon: Icons.map_outlined,
                      label: 'Map location',
                      value:
                          '${event.coordinates.latitude}, ${event.coordinates.longitude}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: FilledButton.icon(
              onPressed: () => controller.toggleItinerary(event),
              icon: Icon(
                controller.isInItinerary(event) ? Icons.check : Icons.add,
              ),
              label: Text(
                controller.isInItinerary(event)
                    ? 'Added to my trip'
                    : 'Add event to my trip',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EventFact extends StatelessWidget {
  const _EventFact({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.forest),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventInfoRow extends StatelessWidget {
  const _EventInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.forest),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
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
