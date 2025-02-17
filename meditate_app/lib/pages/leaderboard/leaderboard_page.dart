import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/util.dart';

import 'leaderboard_widget.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FollowController followController = Get.find();
    final UserController userController = Get.find();
    NetworkStatusController network = Get.find();

    return Obx(() => network.offline.value
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(height: 240, child: Image.asset("assets/offline.png")),
                const Text(
                  "The leaderboard is unavailable right now",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "You seem to be offline. Check your connection or try again later!",
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[900]!,
              title: const Text('Leaderboard'),
            ),
            body: Obx(() {
              // Get all users including current user and sort
              final allUsers = [...followController.allUsers]..sort((a, b) {
                  final levelComparison =
                      (b.levelPoints + calculateUserTotalXPFromCollections(b))
                          .compareTo((a.levelPoints +
                              calculateUserTotalXPFromCollections(a)));
                  if (levelComparison == 0) {
                    return b.totalMinutes.compareTo(a.totalMinutes);
                  }
                  return levelComparison;
                });

              // Find current user's rank
              final currentUserRank = allUsers.indexWhere(
                    (user) => user.id == userController.user.value.id,
                  ) +
                  1;

              if (followController.loadingFollowers.value) {
                return const SpinKitCircle(
                  color: Colors.white,
                  size: 50,
                );
              }
              return Stack(
                children: [
                  // Main scrollable list
                  CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final user = allUsers[index];
                            final color = index % 2 == 0
                                ? Colors.grey[900]!
                                : Colors.grey[900]!;

                            return Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Center(
                                    child: Text(
                                      index == 0
                                          ? '🥇'
                                          : index == 1
                                              ? '🥈'
                                              : index == 2
                                                  ? '🥉'
                                                  : '#${index + 1}',
                                      style: TextStyle(
                                        fontSize: index <= 2 ? 26 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: LeaderboardWidget(
                                    user: user,
                                    color: color,
                                  ),
                                ),
                              ],
                            );
                          },
                          childCount: allUsers.length,
                        ),
                      ),
                      // Add bottom padding to prevent the last item from being hidden
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 72),
                      ),
                    ],
                  ),
                  // Current user fixed at bottom
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Center(
                              child: Text(
                                '#$currentUserRank',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: LeaderboardWidget(
                              user: userController.user.value,
                              color: Colors.grey[800]!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ));
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent =>
      72.0; // Adjust this value based on your FollowerWidget height

  @override
  double get minExtent => 72.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
