import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../liquid_glass.dart';

class IPLNavbar extends StatelessWidget {
  const IPLNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 700;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kBg.withOpacity(0.98), kBg.withOpacity(0)],
        ),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 48 : 20, vertical: 14),
      child: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: () => context.go('/'),
            child: LiquidGlass(
              width: 42, height: 42,
              tint: kGold.withOpacity(0.12),
              child: Center(
                child: Text('IPL',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                      color: kGold,
                      letterSpacing: 0.5,
                    )),
              ),
            ),
          ),
          const Spacer(),

          // CTA
          GestureDetector(
            onTap: () => context.go('/create'),
            child: LiquidGlass(
              tint: kGold.withOpacity(0.10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: kGold, size: 15),
                  const SizedBox(width: 6),
                  Text(isWide ? 'Build Your Portfolio' : 'Build',
                      style: labelStyle(size: 12, color: kGold)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          LiquidGlass(
            width: 42, height: 42,
            child: const Center(
              child: Icon(Icons.emoji_events_outlined,
                  color: kGold, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
