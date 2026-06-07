import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/models/business_feed_factory.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/models/business_feed_item.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/models/business_feed_type.dart';
import 'package:sakuku_desktop/providers/low_stock_provider.dart';
import 'package:sakuku_desktop/providers/product_provider.dart';
import 'package:sakuku_desktop/sidebar.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

class BusinessFeedBillboard extends StatefulWidget {
  const BusinessFeedBillboard({super.key});

  @override
  State<BusinessFeedBillboard> createState() => _BusinessFeedBillboardState();
}

class _BusinessFeedBillboardState extends State<BusinessFeedBillboard> with TickerProviderStateMixin {
  final PageController _controller = PageController();

  int currentPage = 0;
  int currentScene = 0;
  bool showIntro = true;
  int currentReveal = 0;
  bool isParking = false;
  bool parkingComplete = false;
  int introTick = 0;

  Timer? autoSlide;
  int slideCount = 1;
  List<BusinessFeedItem> slides = [];
  late AnimationController progressController;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
    );

    autoSlide = Timer.periodic(
      const Duration(milliseconds: 1500),
      (_) {
        if (!mounted || slides.isEmpty) return;

        final currentSlide = slides[currentPage];

        final totalScene = currentSlide.scenes?.length ?? 1;

        setState(() {
          if (showIntro) {
            introTick++;
            if (introTick < 2) {
              return;
            }
            introTick = 0;
            showIntro = false;
            return;
          }
          final currentSceneData = currentSlide.scenes?.elementAtOrNull(currentScene);

          final revealCount = currentSceneData?.reveals?.length ?? 0;

          if (revealCount > 0) {
            if (!isParking) {
              isParking = true;

              return;
            }
            if (!parkingComplete) {
              parkingComplete = true;
              return;
            }
          }
          parkingComplete = false;
          isParking = false;

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
            WidgetsBinding.instance.addPostFrameCallback((_) {
              startFeedProgress();
            });
          }
        });
      },
    );
  }

  int getFeedTicks(
    BusinessFeedItem feed,
  ) {
    if (feed.scenes == null || feed.scenes!.isEmpty) {
      return 3; // intro only
    }

    int ticks = 2; // intro

    for (final scene in feed.scenes!) {
      final revealCount = scene.reveals?.length ?? 0;

      if (revealCount > 0) {
        ticks += revealCount * 3;
      } else {
        ticks += 1;
      }
    }

    return ticks;
  }

  void startFeedProgress() {
    if (slides.isEmpty) return;

    final feed = slides[currentPage];

    final ticks = getFeedTicks(feed);

    progressController.duration = Duration(
      milliseconds: ticks * 1500,
    );

    progressController.forward(
      from: 0,
    );
  }

  void handleFeedAction(
    FeedActionType type,
  ) {
    switch (type) {
      case FeedActionType.lowStock:
        final provider = context.read<ProductProvider>();

        provider.applyFilter(
          lowStock: true,
        );

        Get.find<SidebarController>().activeIndex.value = 2;

        Get.toNamed(
          '/produk',
          id: 1,
        );

        break;

      case FeedActionType.promo:
        final provider = context.read<ProductProvider>();

        provider.applyFilter(
          isPromo: true,
        );

        Get.find<SidebarController>().activeIndex.value = 2;

        Get.toNamed(
          '/produk',
          id: 1,
        );

        break;

      case FeedActionType.none:
        break;
    }
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
    if (!progressController.isAnimating && slides.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startFeedProgress();
      });
    }
    final activeSlide = slides[currentPage];

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
              const SizedBox(height: 10),
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
                      actionLabel: slide.actionLabel,

                      onActionTap: () {
                        handleFeedAction(
                          slide.actionType,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: progressController,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progressController.value,
                      minHeight: 5,
                      color: activeSlide.color,
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
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
  final String? actionLabel;
  final String? notes;
  final Function()? onActionTap;

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
    this.actionLabel,
    this.notes,
    this.onActionTap,
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
    // print("FOCUS BUILD = ${focusReveal?.headline}");
    // print(
    //   "STORY $currentSteps / $totalSteps",
    // );
    if (scene == null) {
      return Container(
        padding: const EdgeInsets.all(10),
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
            const SizedBox(height: 10),
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
                    InkWell(
                      onTap: onActionTap,
                      child: Text(
                        actionLabel ?? "View Details",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
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
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
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
                                              // Text(
                                              //   item.notes ?? '',
                                              //   maxLines: 1,
                                              //   overflow: TextOverflow.ellipsis,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              // const SizedBox(width: 40),

                              /// RIGHT SIDE (FOCUS)
                              Expanded(
                                flex: 2,
                                child: focusReveal != null
                                    ? AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 500),
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
                                            duration: const Duration(milliseconds: 500),
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
                                                      fontSize: 35,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    focusReveal.subtitle ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    focusReveal.description ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                  ),
                                                  Text(
                                                    focusReveal.notes ?? '',
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
            ],
          ],
        ),
      ),
    );
  }
}
