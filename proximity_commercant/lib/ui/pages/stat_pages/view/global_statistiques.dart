import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/config/colors.dart';
import 'package:proximity/config/values.dart';
import 'package:proximity/widgets/forms/border_type.dart';
import 'package:proximity/widgets/forms/drop_down_selector.dart';
import 'package:proximity/widgets/forms/section_divider.dart';
import 'package:proximity/widgets/top_bar.dart';
import 'package:proximity_commercant/domain/order_repository/src/order_service.dart';
import 'package:proximity_commercant/domain/statistic_repository/models/region_view.dart';

import 'package:proximity_commercant/domain/statistic_repository/src/Statistic_service.dart';
import 'package:proximity_commercant/ui/pages/stat_pages/widget/coloredCard.dart';
import 'package:proximity_commercant/ui/pages/stat_pages/widget/convertion_rate.dart';
import 'package:proximity_commercant/ui/pages/stat_pages/widget/product_sale.dart';
import 'package:proximity_commercant/ui/pages/stat_pages/widget/product_view.dart';
import 'package:proximity_commercant/ui/pages/stat_pages/widget/region_sale.dart';
import 'package:proximity_commercant/ui/pages/stat_pages/widget/store_sale.dart';
import 'package:proximity_commercant/ui/pages/stat_pages/widget/store_view.dart';

import '../widget/region_view.dart';

class GlobalStatisticsScreen extends StatefulWidget {
  const GlobalStatisticsScreen({Key? key}) : super(key: key);

  @override
  _GlobalStatisticsScreenState createState() => _GlobalStatisticsScreenState();
}

class _GlobalStatisticsScreenState extends State<GlobalStatisticsScreen> {
  // Replace this map with your actual data for stores and revenue

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticService>(
        builder: (context, statiscService, child) {
      return Scaffold(
        body: SafeArea(
          child: getWidgets(statiscService, context),
        ),
      );
    });
  }

  ListView getWidgets(StatisticService statiscService, BuildContext context) {
    return ListView(
      children: [
        const TopBar(title: 'Global Statistics'),
        Row(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
              child: Container(
                width: 150,
                child: DropDownSelector<String>(
                  // labelText: 'Product Category.',
                  hintText: 'Max Days to Pick Up.',
                  onChanged: statiscService.changeStatisticPeriod,
                  borderType: BorderType.middle,
                  savedValue: statiscService.period.toString(),
                  items: ['week', 'day', 'month']
                      .map((item) => DropdownItem<String>(
                          value: item,
                          child: Text(item,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w600))))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            ColoredCard(
              title: statiscService.totalViews.toString(),
              subTitle: 'product was viewed',
              cardColor: blueSwatch.shade100,
            ),
            ColoredCard(
              title: statiscService.totalSales.toString(),
              subTitle: 'product was sold  ',
              cardColor: blueSwatch.shade300,
            ),
          ],
        ),
        const StoreViewWidget(),
        const ProductsIncome(),
        RegionChart(
          totalViews: statiscService.totalViews,
          regionViews: statiscService.regionsViews!,
        ),
        const StoreSaleWidget(),
        const ProductSalesWidget(),
        RegionSalesWidget(
          totalSales: statiscService.totalSales,
          regionSales: statiscService.regionsSales!,
        ),

        /*   ConversionRateWidget(
                conversionRate:
                    statiscService.calculateProducyConversionRates()),*/
      ],
    );
  }
}
