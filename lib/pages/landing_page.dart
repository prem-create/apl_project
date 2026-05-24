import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../blur_text.dart';
import '../liquid_glass.dart';
import '../widgets/fade_in.dart';
import '../services/firestore_service.dart';
import '../models/fan_profile.dart';
import '../widgets/profile_card.dart';
import '../widgets/ipl_navbar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // ── animated background ──────────────────────────────────────────
          const _AnimatedBg(),

          // ── scrollable content ───────────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                _HeroHeader(),
                const SizedBox(height: 72),
                _ProfilesGrid(),
                const SizedBox(height: 80),
                const _Footer(),
              ],
            ),
          ),

          // ── fixed navbar ─────────────────────────────────────────────────
          const Positioned(
            top: 0, left: 0, right: 0,
            child: IPLNavbar(),
          ),
        ],
      ),
    );
  }
}

// ── Animated background orbs ─────────────────────────────────────────────────
class _AnimatedBg extends StatefulWidget {
  const _AnimatedBg();
  @override
  State<_AnimatedBg> createState() => _AnimatedBgState();
}

class _AnimatedBgState extends State<_AnimatedBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        return SizedBox.expand(
          child: Stack(children: [
            Positioned(
              top: -100 + 40 * t,
              right: -80 + 30 * t,
              child: _Orb(color: kGold.withOpacity(0.12 + 0.06 * t), size: 420),
            ),
            Positioned(
              bottom: 60 - 30 * t,
              left: -100 + 20 * t,
              child: _Orb(color: kBlue.withOpacity(0.10 + 0.05 * t), size: 360),
            ),
            Positioned(
              top: 300 + 60 * t,
              left: 200 + 40 * t,
              child: _Orb(color: kRed.withOpacity(0.06 + 0.03 * t), size: 280),
            ),
          ]),
        );
      },
    );
  }
}

class _Orb extends StatelessWidget {
  final Color color;
  final double size;
  const _Orb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: size * 0.9, spreadRadius: size * 0.3)
          ],
        ),
      );
}

// ── Hero header ───────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 700;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 24),
      child: Column(
        children: [
          // Badge
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: LiquidGlass(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kGold,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text('IPL 2026',
                        style: labelStyle(size: 11, color: kBg)),
                  ),
                  const SizedBox(width: 8),
                  Text('Season 19 · The Greatest Show on Turf',
                      style: bodyStyle(size: 13, color: kWhite.withOpacity(0.85))),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Headline
          BlurText(
            text: 'Where Every Fan Has a Story',
            style: headingStyle(size: isWide ? 64 : 40),
            initialDelay: const Duration(milliseconds: 400),
          ),
          const SizedBox(height: 16),

          // Sub
          FadeIn(
            delay: const Duration(milliseconds: 900),
            child: Text(
              'Build your IPL fan portfolio. Share your passion.\nJoin thousands of cricket lovers across India.',
              style: bodyStyle(size: isWide ? 16 : 14, color: kWhite.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // CTA
          FadeIn(
            delay: const Duration(milliseconds: 1100),
            child: _BuildPortfolioButton(),
          ),
        ],
      ),
    );
  }
}

class _BuildPortfolioButton extends StatefulWidget {
  @override
  State<_BuildPortfolioButton> createState() => _BuildPortfolioButtonState();
}

class _BuildPortfolioButtonState extends State<_BuildPortfolioButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: GestureDetector(
        onTap: () => context.go('/create'),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Transform.scale(
            scale: 1.0 + 0.03 * _ctrl.value,
            child: child,
          ),
          child: LiquidGlassStrong(
            tint: kGold.withOpacity(0.15),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_circle_outline, color: kGold, size: 18),
                const SizedBox(width: 10),
                Text('Build Your Portfolio',
                    style: bodyStyle(size: 15, weight: FontWeight.w600, color: kGold)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_outward, color: kGold, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Profiles grid ─────────────────────────────────────────────────────────────
class _ProfilesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 700;
    final crossCount = w > 1100 ? 4 : (w > 700 ? 3 : 2);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeIn(
            child: Row(
              children: [
                Text('// Fan Portfolios',
                    style: bodyStyle(size: 13, color: kWhite.withOpacity(0.45))),
                const Spacer(),
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                    color: kGold, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text('Live', style: labelStyle(size: 11, color: kGold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          FadeIn(
            delay: const Duration(milliseconds: 100),
            child: BlurText(
              text: 'Meet the Fans',
              alignment: WrapAlignment.start,
              style: headingStyle(size: isWide ? 42 : 30),
            ),
          ),
          const SizedBox(height: 32),

          StreamBuilder<List<FanProfile>>(
            stream: FirestoreService.profilesStream(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const _LoadingGrid();
              }
              if (snap.hasError) {
                return Center(
                  child: Text('Could not load profiles',
                      style: bodyStyle(color: kWhite.withOpacity(0.4))),
                );
              }
              final profiles = snap.data ?? [];
              if (profiles.isEmpty) {
                return _EmptyState();
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.82,
                ),
                itemCount: profiles.length,
                itemBuilder: (_, i) => FadeIn(
                  delay: Duration(milliseconds: 100 * (i % crossCount)),
                  child: ProfileCard(
                    profile: profiles[i],
                    onTap: () => context.go('/portfolio/${profiles[i].id}'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 16,
        mainAxisSpacing: 16, childAspectRatio: 0.82,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => LiquidGlass(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.02 + 0.02 * _ctrl.value),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.sports_cricket,
                color: kGold.withOpacity(0.3), size: 56),
            const SizedBox(height: 16),
            Text('No portfolios yet — be the first!',
                style: bodyStyle(size: 15, color: kWhite.withOpacity(0.4))),
          ],
        ),
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: kGold.withOpacity(0.15), width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_cricket,
                  color: kGold.withOpacity(0.5), size: 14),
              const SizedBox(width: 8),
              Text('IPL Fan Portfolio · 2026',
                  style: bodyStyle(size: 12, color: kWhite.withOpacity(0.3))),
            ],
          ),
        ],
      ),
    );
  }
}
