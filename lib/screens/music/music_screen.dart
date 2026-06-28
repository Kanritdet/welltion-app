import 'dart:math' show min;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/playlist_model.dart';
import '../../models/track_model.dart';
import '../../providers/player_provider.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key, required this.deviceName});
  final String deviceName;

  void _playPlaylist(BuildContext context, PlaylistModel playlist) {
    context.read<PlayerProvider>().loadPlaylist(playlist);
    context.push('/player');
  }

  void _playTrack(BuildContext context, TrackModel track) {
    final playlist = MockData.playlists.firstWhere(
      (p) => p.trackIds.contains(track.id),
      orElse: () => MockData.playlists.first,
    );
    final idx = playlist.trackIds.indexOf(track.id);
    context.read<PlayerProvider>().loadPlaylist(playlist, startIndex: idx < 0 ? 0 : idx);
    context.push('/player');
  }

  @override
  Widget build(BuildContext context) {
    final specialPlaylists = MockData.playlists.where((p) => p.type == PlaylistType.special).toList();
    final healerPlaylists  = MockData.playlists.where((p) => p.type == PlaylistType.healer).toList();
    final quickTracks      = MockData.tracks.take(3).toList();
    final modes = [
      _ModeItem(id: 'm1', label: 'ผ่อนคลาย',  icon: Icons.air_rounded,              trackCount: 14),
      _ModeItem(id: 'm2', label: 'ทำสมาธิ',   icon: Icons.self_improvement_rounded, trackCount: 9),
      _ModeItem(id: 'm3', label: 'ก่อนนอน',   icon: Icons.bedtime_rounded,          trackCount: 11),
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.arrow_back_rounded, size: 21, color: AppColors.primaryDark),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('กำลังเล่นบน', style: GoogleFonts.ibmPlexSansThai(fontSize: 11, color: AppColors.textSecondary)),
                        Text(deviceName, style: GoogleFonts.ibmPlexSansThai(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── เล่นด่วน ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('เล่นด่วน', style: GoogleFonts.ibmPlexSansThai(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 136,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: quickTracks.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, i) => _QuickTrackCard(
                    track: quickTracks[i],
                    onTap: () => _playTrack(context, quickTracks[i]),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ── โหมด ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('โหมด', style: GoogleFonts.ibmPlexSansThai(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: modes.map((m) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: m != modes.last ? 10 : 0),
                      child: _ModeCard(
                        item: m,
                        onTap: () {
                          final pl = MockData.playlists.firstWhere(
                            (p) => p.type == PlaylistType.special,
                            orElse: () => MockData.playlists.first,
                          );
                          _playPlaylist(context, pl);
                        },
                      ),
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 18),

              // ── เพลย์ลิสต์พิเศษ ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('เพลย์ลิสต์พิเศษ', style: GoogleFonts.ibmPlexSansThai(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    GestureDetector(
                      onTap: () {},
                      child: Text('เล่นทั้งหมด', style: GoogleFonts.ibmPlexSansThai(fontSize: 12, color: AppColors.primaryDark)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _PlaylistHScroll(
                playlists: specialPlaylists,
                isHealer: false,
                onTap: (pl) => _playPlaylist(context, pl),
              ),
              const SizedBox(height: 18),

              // ── เพลย์ลิสต์จาก Healer ─────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('เพลย์ลิสต์จาก Healer', style: GoogleFonts.ibmPlexSansThai(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    GestureDetector(
                      onTap: () {},
                      child: Text('เล่นทั้งหมด', style: GoogleFonts.ibmPlexSansThai(fontSize: 12, color: AppColors.primaryDark)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _PlaylistHScroll(
                playlists: healerPlaylists,
                isHealer: true,
                onTap: (pl) => _playPlaylist(context, pl),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────

class _ModeItem {
  const _ModeItem({required this.id, required this.label, required this.icon, required this.trackCount});
  final String id;
  final String label;
  final IconData icon;
  final int trackCount;
}

class _QuickTrackCard extends StatelessWidget {
  const _QuickTrackCard({required this.track, required this.onTap});
  final TrackModel track;
  final VoidCallback onTap;

  String get _duration {
    final m = track.durationSeconds ~/ 60;
    return '$m นาที';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 90,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC0E4F5),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.image_outlined, size: 24, color: Color(0x660E3D6E)),
                ),
                Positioned(
                  right: 7, bottom: 7,
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, size: 17, color: AppColors.amber),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ibmPlexSansThai(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            Text(_duration,
                style: GoogleFonts.ibmPlexSansThai(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.item, required this.onTap});
  final _ModeItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.accentGold, borderRadius: BorderRadius.circular(12)),
              child: Icon(item.icon, size: 21, color: AppColors.amber),
            ),
            const SizedBox(height: 8),
            Text(item.label, style: GoogleFonts.ibmPlexSansThai(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text('${item.trackCount} แทร็ก', style: GoogleFonts.ibmPlexSansThai(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _PlaylistHScroll extends StatelessWidget {
  const _PlaylistHScroll({required this.playlists, required this.isHealer, required this.onTap});
  final List<PlaylistModel> playlists;
  final bool isHealer;
  final ValueChanged<PlaylistModel> onTap;

  @override
  Widget build(BuildContext context) {
    // แบ่ง playlists เป็น groups ละ 4 items สำหรับ horizontal page
    final groups = <List<PlaylistModel>>[];
    for (var i = 0; i < playlists.length; i += 4) {
      groups.add(playlists.sublist(i, min(i + 4, playlists.length)));
    }

    const rowHeight = 64.0;
    final groupH = groups.isEmpty ? rowHeight : (groups.map((g) => g.length).reduce((a, b) => a > b ? a : b)) * rowHeight;

    return SizedBox(
      height: groupH,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: groups.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, gi) {
          final group = groups[gi];
          return SizedBox(
            width: 300,
            child: Column(
              children: List.generate(group.length, (i) => _PlaylistRow(
                playlist: group[i],
                isHealer: isHealer,
                isLast: i == group.length - 1,
                onTap: () => onTap(group[i]),
              )),
            ),
          );
        },
      ),
    );
  }
}

class _PlaylistRow extends StatelessWidget {
  const _PlaylistRow({required this.playlist, required this.isHealer, required this.isLast, required this.onTap});
  final PlaylistModel playlist;
  final bool isHealer;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE3EFF4))),
        ),
        child: Row(
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFC0E4F5),
                borderRadius: BorderRadius.circular(isHealer ? 999 : 9),
              ),
              child: Icon(
                isHealer ? Icons.person_rounded : Icons.image_outlined,
                size: isHealer ? 22 : 18,
                color: isHealer ? AppColors.primaryDark : const Color(0x660E3D6E),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(playlist.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ibmPlexSansThai(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                  Text('${playlist.trackIds.length} แทร็ก',
                      style: GoogleFonts.ibmPlexSansThai(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.amber),
          ],
        ),
      ),
    );
  }
}
