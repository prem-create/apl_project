import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../blur_text.dart';
import '../liquid_glass.dart';
import '../widgets/fade_in.dart';
import '../models/fan_profile.dart';
import '../services/firestore_service.dart';

class PortfolioPage extends StatefulWidget {
  final String profileId;
  const PortfolioPage({super.key, required this.profileId});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  FanProfile? _profile;
  bool _loading = true;
  bool _linkCopied = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await FirestoreService.getProfile(widget.profileId);
    if (mounted) setState(() { _profile = p; _loading = false; });
  }

  void _copyLink(BuildContext context) {
    final uri = Uri.base.toString().split('#').first;
    final link = '${uri}#/portfolio/${widget.profileId}';
    Clipboard.setData(ClipboardData(text: link));
    setState(() => _linkCopied = true);
    Future.delayed(const Duration(seconds: 2),
        () { if (mounted) setState(() => _linkCopied = false); });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 700;

    if (_loading) return const _LoadingScreen();
    if (_profile == null) return const _NotFoundScreen();

    final p = _profile!;
    final teamEntry = _teamData[p.favouriteTeam];
    final teamColor = teamEntry ?? kGold;

    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // bg
          Positioned(top: -80, right: -60,
              child: _Orb(color: teamColor.withOpacity(0.12), size: 400)),
          Positioned(bottom: 0, left: -80,
              child: _Orb(color: kBlue.withOpacity(0.08), size: 320)),

          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                _ProfileHero(profile: p, teamColor: teamColor, isWide: isWide),
                const SizedBox(height: 48),
                _InfoSection(profile: p, teamColor: teamColor, isWide: isWide),
                const SizedBox(height: 48),
                _ShareSection(
                  profileId: widget.profileId,
                  linkCopied: _linkCopied,
                  onCopy: () => _copyLink(context),
                  isWide: isWide,
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),

          // Navbar
          Positioned(
            top: 0, left: 0, right: 0,
            child: _PortfolioNav(onBack: () => context.go('/')),
          ),
        ],
      ),
    );
  }
}

// ── Team colour map ───────────────────────────────────────────────────────────
const _teamData = {
  'MI':   Color(0xFF004BA0),
  'CSK':  Color(0xFFFFCC00),
  'RCB':  Color(0xFFD4001A),
  'KKR':  Color(0xFF3A225D),
  'SRH':  Color(0xFFFF6B00),
  'DC':   Color(0xFF0078BC),
  'GT':   Color(0xFF1C4B9C),
  'LSG':  Color(0xFF00B4D8),
  'PBKS': Color(0xFFED1B24),
  'RR':   Color(0xFFFF69B4),
};

// ── Hero ──────────────────────────────────────────────────────────────────────
class _ProfileHero extends StatelessWidget {
  final FanProfile profile;
  final Color teamColor;
  final bool isWide;
  const _ProfileHero(
      {required this.profile, required this.teamColor, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 24),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvatarCard(profile: profile, teamColor: teamColor),
                const SizedBox(width: 48),
                Expanded(child: _HeroText(profile: profile, teamColor: teamColor)),
              ],
            )
          : Column(
              children: [
                _AvatarCard(profile: profile, teamColor: teamColor),
                const SizedBox(height: 28),
                _HeroText(profile: profile, teamColor: teamColor),
              ],
            ),
    );
  }
}

class _AvatarCard extends StatelessWidget {
  final FanProfile profile;
  final Color teamColor;
  const _AvatarCard({required this.profile, required this.teamColor});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: LiquidGlass(
        borderRadius: BorderRadius.circular(24),
        tint: teamColor.withOpacity(0.06),
        padding: const EdgeInsets.all(20),
        width: 220,
        child: Column(
          children: [
            // Photo placeholder
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    teamColor.withOpacity(0.3),
                    teamColor.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                    color: teamColor.withOpacity(0.4), width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: teamColor.withOpacity(0.6), size: 52),
                  const SizedBox(height: 6),
                  Text('Photo',
                      style: bodyStyle(
                          size: 11, color: kWhite.withOpacity(0.3))),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Team badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: teamColor.withOpacity(0.18),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: teamColor.withOpacity(0.4)),
              ),
              child: Text(profile.favouriteTeam,
                  style: labelStyle(size: 13, color: teamColor)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final FanProfile profile;
  final Color teamColor;
  const _HeroText({required this.profile, required this.teamColor});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeIn(
          delay: const Duration(milliseconds: 100),
          child: Text('@${profile.handle}',
              style: bodyStyle(size: 14, color: teamColor.withOpacity(0.8))),
        ),
        const SizedBox(height: 8),
        BlurText(
          text: profile.name,
          alignment: WrapAlignment.start,
          style: headingStyle(size: isWide ? 56 : 38),
          initialDelay: const Duration(milliseconds: 200),
        ),
        const SizedBox(height: 6),
        FadeIn(
          delay: const Duration(milliseconds: 400),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined,
                  color: kWhite.withOpacity(0.4), size: 14),
              const SizedBox(width: 4),
              Text(profile.city,
                  style: bodyStyle(
                      size: 13, color: kWhite.withOpacity(0.5))),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FadeIn(
          delay: const Duration(milliseconds: 500),
          child: LiquidGlass(
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(16),
            child: Text(
              '"${profile.bio}"',
              style: bodyStyle(
                  size: 14, color: kWhite.withOpacity(0.8)),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Info section ──────────────────────────────────────────────────────────────
class _InfoSection extends StatelessWidget {
  final FanProfile profile;
  final Color teamColor;
  final bool isWide;
  const _InfoSection(
      {required this.profile, required this.teamColor, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: BlurText(
              text: 'Fan Details',
              alignment: WrapAlignment.start,
              style: headingStyle(size: isWide ? 36 : 28),
              initialDelay: const Duration(milliseconds: 300),
            ),
          ),
          const SizedBox(height: 20),
          FadeIn(
            delay: const Duration(milliseconds: 400),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _InfoCard(
                  icon: Icons.sports_cricket,
                  label: 'Favourite Player',
                  value: profile.favouritePlayer,
                  color: teamColor,
                ),
                _InfoCard(
                  icon: Icons.shield_outlined,
                  label: 'Favourite Team',
                  value: profile.favouriteTeam,
                  color: teamColor,
                ),
                _InfoCard(
                  icon: Icons.location_city_outlined,
                  label: 'City',
                  value: profile.city,
                  color: kBlue,
                ),
                _InfoCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'Fan Since',
                  value: 'IPL ${profile.createdAt.year}',
                  color: kGold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      borderRadius: BorderRadius.circular(18),
      tint: color.withOpacity(0.06),
      padding: const EdgeInsets.all(18),
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value, style: headingStyle(size: 20, color: kWhite)),
          const SizedBox(height: 4),
          Text(label,
              style: bodyStyle(size: 11, color: kWhite.withOpacity(0.45))),
        ],
      ),
    );
  }
}

// ── Share section ─────────────────────────────────────────────────────────────
class _ShareSection extends StatelessWidget {
  final String profileId;
  final bool linkCopied;
  final VoidCallback onCopy;
  final bool isWide;
  const _ShareSection(
      {required this.profileId,
      required this.linkCopied,
      required this.onCopy,
      required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 24),
      child: FadeIn(
        delay: const Duration(milliseconds: 600),
        child: LiquidGlass(
          borderRadius: BorderRadius.circular(20),
          tint: kGold.withOpacity(0.05),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.link, color: kGold, size: 18),
                  const SizedBox(width: 8),
                  Text('Your Shareable Link',
                      style: labelStyle(size: 13, color: kGold)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ipl-fans.app/portfolio/$profileId',
                        style: bodyStyle(
                            size: 13, color: kWhite.withOpacity(0.6)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: onCopy,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: linkCopied
                            ? const Icon(Icons.check_circle,
                                color: Color(0xFF00C896), size: 20,
                                key: ValueKey('check'))
                            : Icon(Icons.copy_outlined,
                                color: kGold.withOpacity(0.8), size: 20,
                                key: const ValueKey('copy')),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Share this link with friends and fellow fans!',
                style: bodyStyle(
                    size: 12, color: kWhite.withOpacity(0.4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Navbar ────────────────────────────────────────────────────────────────────
class _PortfolioNav extends StatelessWidget {
  final VoidCallback onBack;
  const _PortfolioNav({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kBg, kBg.withOpacity(0)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: LiquidGlass(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_ios_new,
                      color: kGold, size: 13),
                  const SizedBox(width: 6),
                  Text('All Fans',
                      style: bodyStyle(size: 13, color: kGold)),
                ],
              ),
            ),
          ),
          const Spacer(),
          LiquidGlass(
            width: 40, height: 40,
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

// ── Loading / Not found ───────────────────────────────────────────────────────
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();
  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: kBg,
        body: Center(
          child: CircularProgressIndicator(color: kGold),
        ),
      );
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: kBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_cricket,
                  color: kGold.withOpacity(0.3), size: 56),
              const SizedBox(height: 16),
              Text('Portfolio not found',
                  style: headingStyle(size: 28)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.go('/'),
                child: Text('← Back to all fans',
                    style: bodyStyle(size: 14, color: kGold)),
              ),
            ],
          ),
        ),
      );
}

class _Orb extends StatelessWidget {
  final Color color;
  final double size;
  const _Orb({required this.color, required this.size});
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(
              color: color, blurRadius: size * 0.9, spreadRadius: size * 0.3)],
        ),
      );
}
