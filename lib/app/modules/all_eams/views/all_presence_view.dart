import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:eams/app/style/app_color.dart';
import 'package:eams/app/widgets/presence_tile.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/all_presence_controller.dart';

class AllPresenceView extends GetView<AllPresenceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final top = constraints.biggest.height;
                final expandedHeight = MediaQuery.of(context).padding.top + 120;
                final shrinkOffset = 1 - ((top - kToolbarHeight) / (expandedHeight - kToolbarHeight)).clamp(0.0, 1.0);

                return FlexibleSpaceBar(
                  title: Text(
                    'All Presence',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  titlePadding: EdgeInsetsDirectional.only(
                    start: 16 + 56 * shrinkOffset, // Keep the original positioning logic
                    bottom: 16,
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                    ),
                  ),
                );
              },
            ),
            leading: IconButton(
              icon: SvgPicture.asset('assets/icons/arrow-left.svg', color: Colors.white),
              onPressed: () => Get.back(),
            ),
            backgroundColor: AppColor.primary,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 44,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.dialog(
                          Dialog(
                            child: Container(
                              height: 372,
                              child: SfDateRangePicker(
                                headerHeight: 50,
                                headerStyle: DateRangePickerHeaderStyle(
                                  textAlign: TextAlign.center,
                                  textStyle: TextStyle(color: AppColor.primary),
                                ),
                                yearCellStyle: DateRangePickerYearCellStyle(
                                  todayTextStyle: TextStyle(color: AppColor.primary),
                                  leadingDatesTextStyle: TextStyle(color: AppColor.primary.withOpacity(0.5)),
                                  disabledDatesTextStyle: TextStyle(color: Colors.grey),
                                ),
                                monthCellStyle: DateRangePickerMonthCellStyle(
                                  todayTextStyle: TextStyle(color: AppColor.primary),
                                  leadingDatesTextStyle: TextStyle(color: AppColor.primary.withOpacity(0.5)),
                                  disabledDatesTextStyle: TextStyle(color: Colors.grey),
                                ),
                                monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                                selectionMode: DateRangePickerSelectionMode.range,
                                selectionColor: AppColor.primary,
                                rangeSelectionColor: AppColor.primary.withOpacity(0.2),
                                startRangeSelectionColor: AppColor.primary,
                                endRangeSelectionColor: AppColor.primary,
                                todayHighlightColor: AppColor.primary,
                                selectionTextStyle: TextStyle(color: AppColor.secondary),
                                rangeTextStyle: TextStyle(color: AppColor.secondary),
                                viewSpacing: 10,
                                showActionButtons: true,
                                onCancel: () => Get.back(),
                                onSubmit: (data) {
                                  if (data != null) {
                                    PickerDateRange range = data as PickerDateRange;
                                    if (range.endDate != null) {
                                      controller.pickDate(range.startDate!, range.endDate!);
                                    }
                                  }
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      child: SvgPicture.asset('assets/icons/filter.svg'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        primary: AppColor.primary, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GetBuilder<AllPresenceController>(
                    builder: (con) {
                      return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: controller.getAllPresence(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            case ConnectionState.active:
                            case ConnectionState.done:
                              var data = snapshot.data!.docs;
                              return ListView.separated(
                                itemCount: data.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 30),
                                separatorBuilder: (context, index) => SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  var presenceData = data[index].data();
                                  return PresenceTile(
                                    presenceData: presenceData,
                                  );
                                },
                              );
                            default:
                              return SizedBox();
                          }
                        },
                      );
                    },
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