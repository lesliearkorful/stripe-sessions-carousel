import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stripe_sessions/utils/app_asset.dart';

class Speakers extends StatefulWidget {
  const Speakers({super.key});

  @override
  State<Speakers> createState() => _SpeakersState();
}

class _SpeakersState extends State<Speakers> {
  final controller = ScrollController();
  late double panelWidth = 0;
  final curve = Curves.linearToEaseOut;
  final duration = const Duration(milliseconds: 700);
  int activeIndex = 0;
  int? hoveredIndex;
  bool animating = false;
  final glow = Image.asset(
    "assets/images/glow-texture.png",
    width: 1080,
    height: 1080,
  );

  List<String> get images => [
        AppAssets.images.speakerSamJpg,
        AppAssets.images.speakerClaireJpg,
        AppAssets.images.speakerHeadshotsEileenOMaraJpg,
        AppAssets.images.speakerVivekJpg,
        AppAssets.images.speakerTanyaJpg,
        AppAssets.images.speakerHeadshotsChristaDaviesJpg,
        AppAssets.images.speakerHeadshotsYinWuJpg,
        AppAssets.images.speakerHeadshotsDevakiRajJpg,
        AppAssets.images.speakerHeadshotsAmitSagivJpg,
        AppAssets.images.speakerHeadshotsAngelaStrangeJpg,
        AppAssets.images.speakerHeadshotsSimonTayloJpg,
        AppAssets.images.speakerHeadshotsTedPowerJpg,
        AppAssets.images.speakerHeadshotsJeffSherlockJpg,
        AppAssets.images.speakerHeadshotsJasonFanJpg,
        AppAssets.images.speakerHeadshotsRachelLeaFishmanJpg,
        AppAssets.images.speakerHeadshotsTakaoChitoseJpg,
        AppAssets.images.speakerHeadshotsPeterFitzpatrickJpg,
        AppAssets.images.speakerPatrickJpg,
        AppAssets.images.speakerJohnJpg,
      ];

  void prev() async {
    if (animating) return;
    final newIndex = max(0, activeIndex - 1);
    final oldIndex = activeIndex;
    animating = true;
    setState(() => activeIndex = newIndex);
    await controller.animateTo(
      max(
        controller.offset -
            (newIndex < 2
                ? panelWidth
                : (panelWidth * min(oldIndex - newIndex, 2))),
        0,
      ),
      duration: duration,
      curve: curve,
    );
    setState(() => animating = false);
  }

  void next() async {
    if (animating) return;
    final newIndex = min(activeIndex + 1, images.length);
    final oldIndex = activeIndex;
    animating = true;
    setState(() => activeIndex = newIndex);
    await controller.animateTo(
      max(
        controller.offset +
            (newIndex > 2 ? (panelWidth * min(newIndex - oldIndex, 2)) : 0),
        controller.offset,
      ),
      duration: duration,
      curve: curve,
    );
    setState(() => animating = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 64, 12, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meet our speakers",
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 42),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Our speaker lineup comprises leaders from Stripe and beyond,\n"
                      "who'll share knowledge and advice on the most pressing topics\n"
                      "facing companies today. Stay tuned for more announcements.",
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () => prev(),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  IconButton(
                    onPressed: () => next(),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              LayoutBuilder(builder: (context, constraints) {
                const cardMargin = 12;
                final cardWidth = (constraints.maxWidth / 10);
                final activeWidth = (constraints.maxWidth / 2);
                panelWidth = cardWidth;
                return SizedBox(
                  height: 640,
                  width: double.infinity,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final active = index == activeIndex;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (activeIndex == index) return;
                          setState(() {
                            if (index > activeIndex) {
                              controller.animateTo(
                                max(
                                  controller.offset +
                                      (index > 2
                                          ? (cardWidth *
                                              min(index - activeIndex, 2))
                                          : 0),
                                  controller.offset,
                                ),
                                duration: duration,
                                curve: curve,
                              );
                            } else {
                              controller.animateTo(
                                max(
                                  controller.offset -
                                      (index < 2
                                          ? cardWidth
                                          : (cardWidth *
                                              min(activeIndex - index, 2))),
                                  0,
                                ),
                                duration: duration,
                                curve: curve,
                              );
                            }
                            activeIndex = index;
                          });
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onHover: (event) {
                            if (index == 0) return;
                            setState(() => hoveredIndex = index);
                          },
                          onExit: (event) {
                            setState(() => hoveredIndex = null);
                          },
                          child: AnimatedContainer(
                            curve: curve,
                            duration: duration,
                            height: 640,
                            width: active
                                ? hoveredIndex != null
                                    ? (activeWidth - 32)
                                    : activeWidth
                                : hoveredIndex == index
                                    ? (cardWidth + 32)
                                    : cardWidth,
                            padding: const EdgeInsets.symmetric(
                              horizontal: cardMargin / 2,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: AnimatedContainer(
                                curve: curve,
                                duration: duration,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(images.toList()[index]),
                                  ),
                                ),
                                child: AnimatedOpacity(
                                  duration: duration,
                                  curve: curve,
                                  opacity: active ? 1 : 0,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: -400,
                                        left: 40,
                                        child: glow,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 40,
                                        child: glow,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
