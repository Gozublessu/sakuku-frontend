import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/capital_model.dart';
import 'package:sakuku_desktop/models/highlight_update_model.dart';
import 'package:sakuku_desktop/models/low_stock.dart';
import 'package:sakuku_desktop/models/new_produk_model.dart';
import 'package:sakuku_desktop/models/promo_model.dart';
import 'package:sakuku_desktop/models/tierl_list_model.dart';
import 'package:sakuku_desktop/providers/low_stock_provider.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';
import 'business_feed_item.dart';
import 'business_feed_type.dart';

class BusinessFeedFactory {
  static BusinessFeedItem? buildLowStock(
    LowStockResp? lowStock,
  ) {
    if (lowStock == null) return null;

    if (lowStock.count == 0) return null;

    final first = lowStock.data.first;

    return BusinessFeedItem(
      type: FeedType.lowStock,
      title: "LOW STOCK ALERT",
      headline: "${lowStock.count} Products",
      subtitle: lowStock.count > 1 ? "${first.name} + ${lowStock.count - 1} others" : first.name,
      description: "Beberapa produk memiliki stok rendah dan mungkin memerlukan restock dalam waktu dekat.",
      icon: Icons.inventory_2_outlined,
      color: const Color(0xFFDC2626),
      actionLabel: "View Products",
      actionType: FeedActionType.lowStock,
      scenes: null,
    );
  }

  static BusinessFeedItem? buildNewProduct(
    List<NewProdukModel> products,
  ) {
    if (products.isEmpty) return null;

    final latest = products.first;

    return BusinessFeedItem(
      type: FeedType.newProduct,
      title: "NEW PRODUCT",
      headline: latest.namaProduk,
      subtitle: "${latest.qty} pcs added",
      description: "Produk baru telah ditambahkan ke inventory dan mulai dipantau performanya.",
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFF2563EB),
      actionLabel: "View Product",
      scenes: [
        BusinessFeedScene(
          headline: "${products.length}",
          subtitle: "New Product",
          description: "Added recently",
        ),
        BusinessFeedScene(
          headline: latest.namaProduk,
          subtitle: latest.jenis,
        ),
        BusinessFeedScene(
          headline: "${latest.qty}",
          subtitle: "Initial Stock",
        ),
        BusinessFeedScene(
          headline: rupiah(latest.cost),
          subtitle: "Initial Capital",
        ),
      ],
    );
  }

  static BusinessFeedItem? buildTopMover(
    tierListItem? topMover,
  ) {
    if (topMover == null) return null;

    return BusinessFeedItem(
      type: FeedType.topMoverWeekly,
      title: "TOP MOVER WEEKLY",
      headline: topMover.namaProduk,
      subtitle: "${topMover.totalQty} pcs sold this week",
      description: "Produk dengan performa penjualan tertinggi di minggu ini.",
      icon: Icons.trending_up_rounded,
      color: const Color(0xFF10B981),
      actionLabel: "View Product",
      scenes: null,
    );
  }

  static BusinessFeedItem? buildPromo(
    PromoModel? promo,
  ) {
    if (promo == null) return null;

    if (promo.promos.isEmpty) return null;

    final isScheduled = promo.status == "SCHEDULED";

    return BusinessFeedItem(
      type: isScheduled ? FeedType.promoScheduled : FeedType.promoActive,
      title: isScheduled ? "PROMO SCHEDULED" : "PROMO ACTIVE",
      headline: isScheduled ? "${promo.schedule} Scheduled" : "${promo.activeCount} Active",
      subtitle: isScheduled ? "Campaign Starting Soon" : "Campaign Running",
      icon: Icons.local_offer_rounded,
      color: isScheduled ? Colors.pinkAccent : Colors.orangeAccent,
      actionLabel: "View Promo",
      actionType: FeedActionType.promo,
      scenes: [
        // BusinessFeedScene(
        //   headline: "${promo.activeCount} Active Campaign",
        //   subtitle: "Promotion currently running",
        //   description: "${promo.schedule} scheduled campaign",
        // ),
        BusinessFeedScene(
          type: SceneType.showcase,
          headline: isScheduled ? "${promo.schedule} Scheduled" : "${promo.activeCount} Active",
          subtitle: isScheduled ? "Campaign Starting Soon" : "Campaign Running",
          reveals: promo.promos.map(
            (item) {
              final saving = item.originalPrice - item.promoPrice;

              return BusinessFeedReveal(
                headline: item.promoLabel,
                subtitle: item.namaProduk,
                description: isScheduled ? "Start Tomorrow • Save ${rupiah(saving)}" : "${item.daysRemaining} Days Left • Save ${rupiah(saving)}",
                notes: item.notes,
              );
            },
          ).toList(),
        ),
        BusinessFeedScene(
          headline: isScheduled ? "${promo.schedule} Scheduled" : "${promo.activeCount} Active",
          subtitle: isScheduled ? "Campaign Starting Soon" : "Campaign Running",
          description: isScheduled ? "Start Tomorrow" : "Days Left",
        ),
      ],
    );
  }

  static BusinessFeedItem? buildRestock(
    List<HighlightUpdateModel> updates,
  ) {
    final item = updates.where((e) => e.type == false).firstOrNull;
    final restocks = updates.where((e) => e.type == false).toList();
    return BusinessFeedItem(
      type: FeedType.restockActivity,
      title: "RESTOCK",
      headline: "${restocks.length} Products",
      subtitle: "Recently Restocked",
      description: "Latest: ${item?.name} (+${item?.qty} pcs)",
      icon: Icons.inventory_2_outlined,
      color: Colors.blue,
      scenes: null,
    );
  }

  static BusinessFeedItem? buildCapital(
    CapitalModel? capital,
  ) {
    if (capital == null) return null;

    if (capital.totalProduct == 0) return null;

    final top1 = capital.products.elementAtOrNull(0);
    final top2 = capital.products.elementAtOrNull(1);
    final top3 = capital.products.elementAtOrNull(2);

    return BusinessFeedItem(
      type: FeedType.capitalExposure,
      title: "IDLE CAPITAL",
      headline: rupiah(capital.totalIdleCapital),
      subtitle: "${capital.totalProduct} Products • ${capital.top3Contribution}% Top 3",
      icon: Icons.account_balance_wallet_outlined,
      color: Colors.deepOrange,
      scenes: [
        BusinessFeedScene(
          type: SceneType.showcase,
          headline: rupiah(capital.totalIdleCapital),
          subtitle: "Idle Capital Exposure",
          description: "${capital.totalProduct} Products • ${capital.top3Contribution}% Top 3",
          reveals: [
            if (top1 != null)
              BusinessFeedReveal(
                headline: top1.nameProduct,
                subtitle: rupiah(top1.idleCapital),
                description: "${top1.coverageDay} Days Coverage",
              ),
            if (top2 != null)
              BusinessFeedReveal(
                headline: top2.nameProduct,
                subtitle: rupiah(top2.idleCapital),
                description: "${top2.coverageDay} Days Coverage",
              ),
            if (top3 != null)
              BusinessFeedReveal(
                headline: top3.nameProduct,
                subtitle: rupiah(top3.idleCapital),
                description: "${top3.coverageDay} Days Coverage",
              ),
          ],
        ),
        BusinessFeedScene(
          type: SceneType.normal,
          headline: "${capital.top3Contribution}%",
          subtitle: "Top 3 Contribution",
          description: "Capital concentrated in top products",
        ),
      ],
    );
  }

  static List<BusinessFeedItem> buildFromDashboard(
    DashboardProvider dashboard,
  ) {
    final feeds = <BusinessFeedItem>[];

    final lowStockFeed = BusinessFeedFactory.buildLowStock(
      dashboard.lowStock,
    );

    if (lowStockFeed != null) {
      feeds.add(lowStockFeed);
    }
    final newProductFeed = buildNewProduct(
      dashboard.updatesNP,
    );

    if (newProductFeed != null) {
      feeds.add(newProductFeed);
    }
    final topMoverWeekly = buildTopMover(
      dashboard.topMoverWeekly,
    );

    if (topMoverWeekly != null) {
      feeds.add(topMoverWeekly);
    }

    final productPromo = buildPromo(
      dashboard.promoProduct,
    );

    if (productPromo != null) {
      feeds.add(productPromo);
    }

    final restockFeed = buildRestock(
      dashboard.updates,
    );

    if (restockFeed != null) {
      feeds.add(restockFeed);
    }

    final capitalAlert = buildCapital(
      dashboard.capitalAlert,
    );

    if (capitalAlert != null) {
      feeds.add(capitalAlert);
    }

    // print("TOP MOVER = ${dashboard.topMoverWeekly?.namaProduk}");
    // print("LOW STOCK = ${dashboard.lowStock?.count}");
    // print("NEW PRODUCT = ${dashboard.updatesNP.length}");
    // print("FEEDS = ${feeds.length}");
    // print("CAPITAL SCENES = ${dashboard.capitalAlert?.products.length}");

    return feeds;
  }
}
