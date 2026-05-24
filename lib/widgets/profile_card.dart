import 'package:flutter/material.dart';
import '../theme.dart';
import '../liquid_glass.dart';
import '../models/fan_profile.dart';

const _teamColors = {
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

class ProfileCard extends StatefulWidget {
  final FanProfile profile;
  final VoidCallback onTap;

  const ProfileCard({super.key, required this.profile, required this.onTap});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _hovered = false;

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
    final teamColor =
        _teamColors[widget.profile.favouriteTeam] ?? kGold;

    return MouseRegion(
      onEnter: (_) { setState(() => _hovered = true); _ctrl.forward(); },
      onExit: (_) { setState(() => _hovered = false); _ctrl.reverse(); },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Transform.scale(
            scale: 1.0 + 0.03 * _ctrl.value,
            child: child,
          ),
          child: LiquidGlass(
            borderRadius: BorderRadius.circular(22),
            tint: teamColor.withOpacity(0.05 + 0.05 * (_hovered ? 1 : 0)),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: avatar placeholder + team badge
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [
                            teamColor.withOpacity(0.35),
                            teamColor.withOpacity(0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                            color: teamColor.withOpacity(0.3), width: 1),
                      ),
                      child: Icon(Icons.person,
                          color: teamColor.withOpacity(0.7), size: 26),
                    ),
                    const Spacer(),
                    // Team pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: teamColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(
                            color: teamColor.withOpacity(0.35)),
                      ),
                      child: Text(widget.profile.favouriteTeam,
                          style: labelStyle(size: 11, color: teamColor)),
                    ),
                  ],
                ),
                const Spacer(),

                // Name
                Text(
                  widget.profile.name,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    color: kWhite,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text('@${widget.profile.handle}',
                    style: bodyStyle(
                        size: 12, color: teamColor.withOpacity(0.8))),
                const SizedBox(height: 8),

                // Bio preview
                Text(
                  widget.profile.bio,
                  style: bodyStyle(
                      size: 12, color: kWhite.withOpacity(0.5)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Footer row
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        color: kWhite.withOpacity(0.3), size: 12),
                    const SizedBox(width: 3),
                    Text(widget.profile.city,
                        style: bodyStyle(
                            size: 11, color: kWhite.withOpacity(0.35))),
                    const Spacer(),
                    Icon(Icons.arrow_outward,
                        color: teamColor.withOpacity(0.6), size: 14),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
