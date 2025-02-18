import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import "package:meditate_app/api/index.dart" as api;
import 'package:meditate_app/pages/get_subscription/get_subscription_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/util/util.dart';

class SendVibeWidget extends StatefulWidget {
  final String targetUserId;
  const SendVibeWidget({super.key, required this.targetUserId});

  @override
  State<SendVibeWidget> createState() => _SendVibeWidgetState();
}

class _SendVibeWidgetState extends State<SendVibeWidget> {
  UserController userController = Get.find<UserController>();
  String? nextAvailableTime;
  DateTime? lastSentAt;
  String? selectedVibe;

  @override
  void initState() {
    super.initState();
    setState(() {
      lastSentAt = userController.user.value.emojisSentAt[widget.targetUserId];
      selectedVibe = userController.user.value.sentEmojis[widget.targetUserId];
      logSuccess(widget.targetUserId +
          "!!!" +
          userController.user.value.sentEmojis.toString());
    });

    _calculateNextAvailableTime();
  }

  void _calculateNextAvailableTime() {
    final DateTime nowUtc = DateTime.now().toUtc();

    if (lastSentAt != null) {
      final DateTime lastSentAtUtc = lastSentAt!.toUtc();
      final Duration difference = nowUtc.difference(lastSentAtUtc);

      logWarning("Current Time (UTC): $nowUtc");
      logWarning("Last Sent Time (UTC): $lastSentAtUtc");
      logWarning("Time Difference: $difference");

      if (difference < const Duration(hours: 24)) {
        Duration timeLeft = const Duration(hours: 24) - difference;
        setState(() {
          nextAvailableTime =
              "${timeLeft.inHours} more hours to send another emoji";
        });
        logWarning(
            "timeLeft: ${timeLeft.inHours} hours, ${timeLeft.inMinutes % 60} minutes");
      } else {
        setState(() {
          nextAvailableTime = null;
        });
      }
    }
  }

  void selectVibe(String vibe) {
    HapticFeedback.heavyImpact();
    SaveController save = Get.find();
    UserController user = Get.find();
    if ((vibe == "🙏" || vibe == "👍" || vibe == "✨") &&
        !save.isSubscribedToPremium.value &&
        !user.user.value.isPremiumOverride == true &&
        !userController.user.value.createdAt.isBefore(PREMIUM_BEFORE_DATE)) {
      Get.to(const GetSubscriptionPage());
      return;
    }

    PostHogService posthog = Get.find();
    posthog.logEvent("VIBE_SENT", {});
    setState(() {
      selectedVibe = vibe;
    });
    final DateTime now = DateTime.now().toUtc();

    if (lastSentAt == null ||
        now.difference(lastSentAt!) >= const Duration(hours: 24)) {
      userController.updateProperty(UserProperty.emojisSentAt, {
        ...userController.user.value.emojisSentAt,
        widget.targetUserId: now,
      });
      userController.updateProperty(UserProperty.sentEmojis,
          {...userController.user.value.sentEmojis, widget.targetUserId: vibe});
      setState(() {
        lastSentAt = now;
      });
      _calculateNextAvailableTime();

      // Logic to send the emoji
      // Send push notification to the target user
      if (selectedVibe != null) {
        api.follow.sendEmoji(widget.targetUserId, selectedVibe!);
      }
    }

    setState(() {
      logInfo("Next available time: $nextAvailableTime");
    }); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              nextAvailableTime ?? "Send them an emoji",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color:
                      (nextAvailableTime != null ? Colors.grey : Colors.white)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Vibe(
                vibe: '🔥',
                onSelect: selectVibe,
                isDisabled: nextAvailableTime != null,
                selectedVibe: selectedVibe ?? "",
              ),
              Vibe(
                vibe: '💜',
                onSelect: selectVibe,
                isDisabled: nextAvailableTime != null,
                selectedVibe: selectedVibe ?? "",
              ),
              Vibe(
                vibe: '❤️',
                onSelect: selectVibe,
                isDisabled: nextAvailableTime != null,
                selectedVibe: selectedVibe ?? "",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Vibe(
                vibe: '👉',
                onSelect: selectVibe,
                isDisabled: nextAvailableTime != null,
                selectedVibe: selectedVibe ?? "",
              ),
              Vibe(
                vibe: '👋',
                onSelect: selectVibe,
                isDisabled: nextAvailableTime != null,
                selectedVibe: selectedVibe ?? "",
              ),
              Vibe(
                vibe: '🙌',
                onSelect: selectVibe,
                isDisabled: nextAvailableTime != null,
                selectedVibe: selectedVibe ?? "",
              ),
            ],
          ),
          const Text("Premium emojis", style: TextStyle(color: Colors.white70)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Vibe(
                vibe: '🙏',
                onSelect: selectVibe,
                isDisabled: nextAvailableTime != null,
                selectedVibe: selectedVibe ?? "",
                premium: true,
              ),
              Vibe(
                vibe: '👍',
                onSelect: selectVibe,
                isDisabled: nextAvailableTime != null,
                selectedVibe: selectedVibe ?? "",
                premium: true,
              ),
              Vibe(
                vibe: '✨',
                onSelect: selectVibe,
                isDisabled: nextAvailableTime != null,
                selectedVibe: selectedVibe ?? "",
                premium: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Vibe extends StatefulWidget {
  final String vibe;
  final Function(String) onSelect;
  final bool isDisabled;
  final String selectedVibe;
  final bool premium;

  const Vibe(
      {Key? key,
      required this.vibe,
      required this.onSelect,
      required this.selectedVibe,
      this.isDisabled = false,
      this.premium = false})
      : super(key: key);

  @override
  _VibeState createState() => _VibeState();
}

class _VibeState extends State<Vibe> {
  @override
  Widget build(BuildContext context) {
    SaveController save = Get.find();
    UserController user = Get.find();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.isDisabled ? null : () => widget.onSelect(widget.vibe),
        child: Opacity(
          opacity:
              widget.isDisabled && widget.selectedVibe != widget.vibe ? 0.5 : 1,
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              color: widget.selectedVibe == widget.vibe && widget.isDisabled
                  ? Colors.white24
                  : widget.isDisabled
                      ? Colors.transparent
                      : const Color.fromARGB(255, 46, 48, 59),
              border: Border.all(
                color: widget.isDisabled
                    ? Colors.grey
                    : const Color.fromARGB(255, 81, 80, 107),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.vibe,
                    style: const TextStyle(fontSize: 30),
                  ),
                  widget.premium &&
                          !save.isSubscribedToPremium.value &&
                          !user.user.value.isPremiumOverride == true &&
                          !user.user.value.createdAt
                              .isBefore(PREMIUM_BEFORE_DATE)
                      ? const Icon(Icons.lock, size: 15)
                      : Text(
                          widget.isDisabled
                              ? widget.selectedVibe == widget.vibe
                                  ? "Sent"
                                  : "Wait"
                              : "Send",
                          style: TextStyle(
                              color: widget.isDisabled &&
                                      widget.selectedVibe != widget.vibe
                                  ? Colors.grey
                                  : Colors.white),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
