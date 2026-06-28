import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/track_model.dart';
import '../../providers/player_provider.dart';

const _kGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 0.42, 1.0],
  colors: [Color(0xFFDDEFF8), Color(0xFFEAF5FB), Color(0xFFF8FBFD)],
);

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double _position = 0.38;
  final _sheetController = DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _openQueue() => _sheetController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOut,
      );

  void _closeQueue() => _sheetController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );

  String _fmt(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, _) {
        final track = player.currentTrack;
        return Scaffold(
          backgroundColor: const Color(0xFFF8FBFD),
          body: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: _kGradient),
                ),
              ),
              SafeArea(
                bottom: false,
                child: track == null
                    ? _buildEmpty()
                    : _buildPlayerView(context, player, track),
              ),
              if (track != null)
                DraggableScrollableSheet(
                  controller: _sheetController,
                  initialChildSize: 0.0,
                  minChildSize: 0.0,
                  maxChildSize: 1.0,
                  snap: true,
                  snapSizes: const [0.0, 1.0],
                  builder: (ctx, sc) =>
                      _buildQueueSheet(ctx, player, track, sc),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty() => Center(
        child: Text(
          'ยังไม่มีเพลงที่กำลังเล่น',
          style: GoogleFonts.ibmPlexSansThai(
              fontSize: 14, color: AppColors.textSecondary),
        ),
      );

  // ── Screen 13: Player View ──────────────────────────────────────
  Widget _buildPlayerView(
      BuildContext context, PlayerProvider player, TrackModel track) {
    final healer =
        track.healerId != null ? MockData.healerById(track.healerId!) : null;
    final positionSec = (track.durationSeconds * _position).round();
    final playlistName = player.currentPlaylist?.title ?? 'ผ่อนคลาย';
    final nextTrack =
        player.hasNext ? player.queue[player.currentIndex + 1] : null;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    size: 30, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('กำลังเล่นจากโหมด',
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 11, color: AppColors.textSecondary)),
                  Text(playlistName,
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                ],
              ),
            ],
          ),
        ),
        // ── Center content (art + info + controls) expands to fill ──
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Album art — expands to fill remaining space
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFC0E4F5),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x2E0E3D6E),
                                blurRadius: 40,
                                offset: Offset(0, 16))
                          ],
                        ),
                        child: const Icon(Icons.image_outlined,
                            size: 54, color: Color(0x660E3D6E)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                // Track title + healer
                Text(track.title,
                    style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                if (healer != null) ...[
                  const SizedBox(height: 7),
                  _HealerChip(
                      name: healer.name,
                      onTap: () => context.push('/healer/${track.healerId}')),
                ],
                const SizedBox(height: 20),
                // Progress bar
                _ProgressBar(
                    position: _position,
                    onChanged: (v) => setState(() => _position = v)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_fmt(positionSec),
                        style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 11, color: AppColors.textSecondary)),
                    Text(_fmt(track.durationSeconds),
                        style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 20),
                // Transport controls
                _TransportBar(player: player),
              ],
            ),
          ),
        ),
        // ── Next track card pinned at bottom ──
        if (nextTrack != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
            child: _NextTrackCard(track: nextTrack, onTap: _openQueue),
          ),
        SizedBox(height: bottomPad + 16),
      ],
    );
  }

  // ── Screen 13b: Queue Sheet (slides up) ─────────────────────────
  Widget _buildQueueSheet(BuildContext context, PlayerProvider player,
      TrackModel track, ScrollController scrollController) {
    final healer =
        track.healerId != null ? MockData.healerById(track.healerId!) : null;
    final positionSec = (track.durationSeconds * _position).round();
    final playlistName =
        player.currentPlaylist?.title ?? 'เพลงผ่อนคลาย weLLtion';
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: _kGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, topPad + 10, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _closeQueue,
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 30, color: AppColors.primaryDark),
                  ),
                  const SizedBox(height: 12),
                  // Album art
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC0E4F5),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x2E0E3D6E),
                            blurRadius: 34,
                            offset: Offset(0, 5))
                      ],
                    ),
                    child: const Center(
                        child: Icon(Icons.image_outlined,
                            size: 52, color: Color(0x660E3D6E))),
                  ),
                  // Drag handle under album art
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(999)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Track info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      if (healer != null)
                        Text(healer.name,
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _ProgressBar(
                      position: _position,
                      onChanged: (v) => setState(() => _position = v)),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_fmt(positionSec),
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 11, color: AppColors.textSecondary)),
                      Text(_fmt(track.durationSeconds),
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _TransportBar(player: player),
                  const SizedBox(height: 14),
                  // Playing from
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('กำลังเล่นจาก',
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 11, color: AppColors.textSecondary)),
                      Text(playlistName,
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          // Queue list — drag ≡ handle เพื่อจัดลำดับ
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverReorderableList(
              itemCount: player.queue.length,
              onReorder: player.reorderQueue,
              itemBuilder: (context, i) => Column(
                key: ValueKey(player.queue[i].id),
                children: [
                  _QueueItem(
                    track: player.queue[i],
                    isPlaying: i == player.currentIndex,
                    onTap: () => player.jumpTo(i),
                    index: i,
                  ),
                  if (i < player.queue.length - 1)
                    const Divider(height: 1, color: Color(0xFFE3EFF4)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────

class _HealerChip extends StatelessWidget {
  const _HealerChip({required this.name, required this.onTap});
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 4, 11, 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.55),
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                  color: Color(0xFFC0E4F5), shape: BoxShape.circle),
              child:
                  const Icon(Icons.person, size: 15, color: Color(0x800E3D6E)),
            ),
            const SizedBox(width: 6),
            Text(name,
                style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryDark)),
            const SizedBox(width: 2),
            const Icon(Icons.chevron_right,
                size: 16, color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.position, required this.onChanged});
  final double position;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 5,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.5),
        overlayShape: SliderComponentShape.noOverlay,
        activeTrackColor: AppColors.amber,
        inactiveTrackColor: const Color(0xFFE8DFA8),
        thumbColor: AppColors.amber,
      ),
      child: Slider(value: position, onChanged: onChanged),
    );
  }
}

class _TransportBar extends StatelessWidget {
  const _TransportBar({required this.player});
  final PlayerProvider player;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Shuffle: dark = off, amber = on
        GestureDetector(
          onTap: player.toggleShuffle,
          child: Icon(Icons.shuffle_rounded,
              size: 24,
              color:
                  player.isShuffle ? AppColors.amber : AppColors.primaryDark),
        ),
        GestureDetector(
          onTap: player.previous,
          child: const Icon(Icons.skip_previous_rounded,
              size: 34, color: AppColors.amber),
        ),
        GestureDetector(
          onTap: player.isPlaying ? player.pause : player.resume,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentBorder, width: 2),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x470E3D6E),
                    blurRadius: 20,
                    offset: Offset(0, 8))
              ],
            ),
            child: Icon(
              player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 34,
              color: AppColors.accentText,
            ),
          ),
        ),
        GestureDetector(
          onTap: player.next,
          child: const Icon(Icons.skip_next_rounded,
              size: 34, color: AppColors.amber),
        ),
        // Repeat: none=dark, all=amber, one=amber + repeat_one icon
        GestureDetector(
          onTap: player.toggleRepeat,
          child: Icon(
            player.repeatMode == TrackRepeatMode.one
                ? Icons.repeat_one_rounded
                : Icons.repeat_rounded,
            size: 24,
            color: player.repeatMode == TrackRepeatMode.none
                ? AppColors.primaryDark
                : AppColors.amber,
          ),
        ),
      ],
    );
  }
}

class _NextTrackCard extends StatelessWidget {
  const _NextTrackCard({required this.track, required this.onTap});
  final TrackModel track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.queue_music_rounded,
                size: 19, color: AppColors.primaryDark),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ถัดไป',
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 11, color: AppColors.textSecondary)),
                  Text(track.title,
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _QueueItem extends StatelessWidget {
  const _QueueItem(
      {required this.track, required this.isPlaying, required this.onTap, required this.index});
  final TrackModel track;
  final bool isPlaying;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isPlaying
                    ? const Color(0xFFC0E4F5)
                    : const Color(0xFFDDEFF8),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.image_outlined,
                  size: 18, color: Color(0x660E3D6E)),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                track.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color:
                      isPlaying ? AppColors.primaryDark : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle_rounded,
                  size: 22, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
