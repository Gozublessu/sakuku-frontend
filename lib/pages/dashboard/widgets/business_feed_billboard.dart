import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/models/business_feed_factory.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/models/business_feed_item.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/models/business_feed_type.dart';
import 'package:sakuku_desktop/providers/low_stock_provider.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

class BusinessFeedBillboard extends StatefulWidget {
  const BusinessFeedBillboard({super.key});

  @override
  State<BusinessFeedBillboard> createState() => _BusinessFeedBillboardState();
}

class _BusinessFeedBillboardState extends State<BusinessFeedBillboard> {
  final PageController _controller = PageController();

  int currentPage = 0;
  int currentScene = 0;
  bool showIntro = true;
  int currentReveal = 0;
  bool isParking = false;
  bool parkingComplete = false;

  Timer? autoSlide;
  int slideCount = 1;
  List<BusinessFeedItem> slides = [];

  @override
  void initState() {
    super.initState();

    // autoSlide = Timer.periodic(
    //   const Duration(seconds: 4),
    //   (_) {
    //     if (!_controller.hasClients) return;

    //     currentPage++;
    //     // print("AUTO PAGE = $currentPage");
    //     print("AUTO PAGE = $currentPage | SLIDES = ${slides.length}");

    //     if (currentPage >= slides.length) {
    //       currentPage = 0;
    //     }

    //     _controller.animateToPage(
    //       currentPage,
    //       duration: const Duration(milliseconds: 600),
    //       curve: Curves.easeInOut,
    //     );
    //   },
    // );

    autoSlide = Timer.periodic(
      const Duration(seconds: 2),
      (_) {
        if (!mounted || slides.isEmpty) return;

        final currentSlide = slides[currentPage];

        final totalScene = currentSlide.scenes?.length ?? 1;

        setState(() {
          if (showIntro) {
            print("INTRO OFF");
            showIntro = false;
            return;
          }
          final currentSceneData = currentSlide.scenes?.elementAtOrNull(currentScene);

          final revealCount = currentSceneData?.reveals?.length ?? 0;

          if (revealCount > 0) {
            if (!isParking) {
              print("FOCUS -> PARKING");
              isParking = true;
              // print(
              //   "PARKING ON -> REVEAL $currentReveal",
              // );
              return;
            }
            if (!parkingComplete) {
              print("PARKING HOLD");
              parkingComplete = true;
              return;
            }
            print("ADVANCE");
          }
          parkingComplete = false;
          isParking = false;
          // print(
          //   "PARKING OFF -> NEXT REVEAL",
          // );

          if (currentReveal < revealCount - 1) {
            currentReveal++;
            return;
          }
          isParking = false;
          currentReveal = 0;
          currentScene++;

          if (currentScene >= totalScene) {
            currentScene = 0;

            currentPage++;

            if (currentPage >= slides.length) {
              currentPage = 0;
            }
            showIntro = true;

            _controller.animateToPage(
              currentPage,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );
          }
        });
      },
    );
  }

  @override
  void dispose() {
    autoSlide?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();

    slides = BusinessFeedFactory.buildFromDashboard(
      dashboard,
    );
    print("SLIDES COUNT = ${slides.length}");

    // if (slides.isEmpty) {
    //   slides.addAll(
    //     BusinessFeedFactory.buildDummy(),
    //   );
    // }
    return SizedBox(
      height: 525,
      child: Card(
        color: const Color(0xFFF8FAFC),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.campaign_rounded),
                  const SizedBox(width: 8),
                  Text(
                    "Business Feed",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    final scene = showIntro ? null : slide.scenes?[currentScene];

                    // print("${slide.title} -> ${slide.scenes?.length}");
                    // print("SCENE = ${scene?.headline}");
                    // print("SHOW INTRO = $showIntro");
                    // print("PAGE = ${slide.title}");
                    // print("SCENE = ${scene?.headline}");
                    // print(
                    //   "REVEAL = ${scene?.reveals?.elementAtOrNull(currentReveal)?.headline}",
                    // );
                    // print("CURRENT REVEAL = $currentReveal");
                    // print(
                    //   "REVEAL = $currentReveal | PARKING = $isParking",
                    // );

                    return _FeedSlide(
                      title: slide.title,
                      feedHeadline: slide.headline,
                      feedSubtitle: slide.subtitle,

                      scene: scene,
                      sceneType: scene?.type ?? SceneType.normal,
                      reveal: scene?.reveals?.elementAtOrNull(currentReveal),
                      reveals: scene?.reveals,
                      currentReveal: currentReveal,
                      isParking: isParking,

                      description: scene?.description ?? slide.description ?? '',
                      icon: slide.icon,
                      color: slide.color,
                      // description: slide.description,
                      originalPrice: slide.originalPrice,
                      promoPrice: slide.promoPrice,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                  (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentPage == index ? Colors.blue : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedSlide extends StatelessWidget {
  final String title;
  final String? feedHeadline;
  final String? feedSubtitle;
  final String description;
  final IconData icon;
  final Color color;
  final num? originalPrice;
  final num? promoPrice;
  final SceneType sceneType;
  final BusinessFeedReveal? reveal;
  final BusinessFeedScene? scene;
  final List<BusinessFeedReveal>? reveals;
  final int currentReveal;
  final bool isParking;

  const _FeedSlide({
    required this.title,
    this.feedHeadline,
    this.feedSubtitle,
    required this.icon,
    required this.color,
    required this.description,
    this.originalPrice,
    this.promoPrice,
    required this.sceneType,
    this.reveal,
    this.scene,
    this.reveals,
    required this.currentReveal,
    required this.isParking,
  });

  @override
  Widget build(BuildContext context) {
    final focusReveal = reveal;
    final parkedCount = isParking ? currentReveal + 1 : currentReveal;

    final parkedReveals = reveals?.take(parkedCount).toList() ?? [];

    // print("FOCUS=${focusReveal?.headline}");

    // print("CURRENT=$currentReveal");

    // print("PARKED COUNT=$parkedCount");

    // print("PARKED=${parkedReveals.map((e) => e.headline).toList()}");
    print("FOCUS BUILD = ${focusReveal?.headline}");
    if (scene == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              feedHeadline ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              feedSubtitle ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey(
        "${scene?.headline}_${scene?.subtitle}",
      ),
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            if (sceneType == SceneType.showcase) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// LEFT SIDE (PARKED)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: parkedReveals.asMap().entries.map((entry) {
                                    final isNewest = entry.key == parkedReveals.length - 1;

                                    final item = entry.value;

                                    return AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 600),
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      child: Padding(
                                        key: ValueKey(item.headline),
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: AnimatedOpacity(
                                          duration: const Duration(milliseconds: 400),
                                          opacity: isNewest ? 1.0 : 0.4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.headline,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(item.subtitle ?? ''),
                                              Text(
                                                item.description ?? '',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(width: 40),

                              /// RIGHT SIDE (FOCUS)
                              Expanded(
                                flex: 2,
                                child: focusReveal != null
                                    ? AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 800),
                                        transitionBuilder: (child, animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: AnimatedOpacity(
                                          key: ValueKey(focusReveal.headline),
                                          duration: const Duration(milliseconds: 600),
                                          opacity: isParking ? 0 : 1,
                                          child: TweenAnimationBuilder<double>(
                                            duration: const Duration(milliseconds: 800),
                                            tween: Tween(
                                              begin: 0,
                                              end: 1,
                                            ),
                                            builder: (context, value, child) {
                                              return Opacity(
                                                opacity: value,
                                                child: Transform.scale(
                                                  scale: .95 + (value * .05),
                                                  child: child,
                                                ),
                                              );
                                            },
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    focusReveal.headline,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 28,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    focusReveal.subtitle ?? '',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    focusReveal.description ?? '',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ),
            ] else ...[
              const SizedBox(height: 16),
              Text(
                scene?.headline ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                scene?.subtitle ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              if (originalPrice != null && promoPrice != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      rupiah(originalPrice!),
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      rupiah(promoPrice!),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                )
              ],
              const SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),
              Divider(
                height: 20,
                color: Colors.grey.shade200,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "View Details",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
