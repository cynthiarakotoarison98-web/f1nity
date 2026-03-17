import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ------------------------------------------------------------
/// PAGE: Race Intelligence + Momentum Engine
/// - LIVE: dernière session live OpenF1
/// - REPLAY: dernière course terminée OpenF1 + replay animé
/// - Tracé fallback : Melbourne / Albert Park
/// ------------------------------------------------------------
class RaceIntelligenceMelbournePage extends StatefulWidget {
  const RaceIntelligenceMelbournePage({super.key});

  @override
  State<RaceIntelligenceMelbournePage> createState() =>
      _RaceIntelligenceMelbournePageState();
}

class _RaceIntelligenceMelbournePageState
    extends State<RaceIntelligenceMelbournePage> {
  final _api = OpenF1Service();

  bool _loading = true;
  String? _error;

  int? _meetingKey;
  int? _sessionKey;

  Map<int, DriverInfo> _drivers = {};
  List<DriverLive> _leaderboard = [];
  final Map<int, List<GapPoint>> _gapHistory = {};
  int? _selectedDriverNumber;

  bool _isReplay = false;
  Timer? _timerLive;

  bool _replayDataLoading = false;
  bool _isReplayPlaying = false;

  Timer? _replayTimer;
  List<IntervalRow> _replayTimeline = [];
  int _replayIdx = 0;
  int? _replaySessionKey;
  String? _replayRaceLabel;

  final Map<int, IntervalLatest> _replayLatestByDriver = {};

  List<LocationRow> _replayLocations = [];
  int _replayLocationIdx = 0;
  final Map<int, LocationRow> _latestLocationByDriver = {};
  DateTime? _currentReplayTime;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void dispose() {
    _timerLive?.cancel();
    _replayTimer?.cancel();
    super.dispose();
  }

  Future<void> _boot() async {
    _timerLive?.cancel();
    _replayTimer?.cancel();

    setState(() {
      _loading = true;
      _error = null;
      _isReplay = false;
      _isReplayPlaying = false;

      _meetingKey = null;
      _sessionKey = null;

      _leaderboard = [];
      _gapHistory.clear();

      _replayTimeline = [];
      _replayIdx = 0;
      _replaySessionKey = null;
      _replayRaceLabel = null;
      _replayLatestByDriver.clear();

      _replayLocations = [];
      _replayLocationIdx = 0;
      _latestLocationByDriver.clear();
      _currentReplayTime = null;
    });

    try {
      final latest = await _api.getLatestLiveSession();
      if (latest == null) {
        throw Exception("Aucune session live trouvée.");
      }

      final drivers = await _api.getDrivers(sessionKey: latest.sessionKey);
      if (drivers.isEmpty) {
        throw Exception("Drivers introuvables pour la session live.");
      }

      if (!mounted) return;
      setState(() {
        _meetingKey = latest.meetingKey;
        _sessionKey = latest.sessionKey;
        _drivers = drivers;
        _selectedDriverNumber ??=
            drivers.keys.isNotEmpty ? drivers.keys.first : null;
        _error = "${latest.meetingName} — ${latest.sessionName}";
      });

      await _refreshLive();

      if (_leaderboard.isEmpty) {
        throw Exception("Aucune donnée live exploitable.");
      }

      _timerLive = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!_isReplay) {
          _refreshLive();
        }
      });

      if (!mounted) return;
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      _setReplayMode(true, message: "Live indisponible — mode Replay.");
    }
  }

  Future<void> _refreshLive() async {
    final sessionKey = _sessionKey;
    if (sessionKey == null || _isReplay) return;

    try {
      final latest = await _api.getLatestIntervalsByDriver(sessionKey: sessionKey);
      if (latest.isEmpty) {
        _setReplayMode(true, message: "Live indisponible — mode Replay.");
        return;
      }

      final live = <DriverLive>[];

      latest.forEach((driverNumber, row) {
        final info = _drivers[driverNumber];
        final acronym = (info?.acronym.isNotEmpty == true)
            ? info!.acronym
            : "#$driverNumber";

        final gapSec = (row.gapToLeader is num)
            ? (row.gapToLeader as num).toDouble()
            : (row.gapToLeader == null ? 0.0 : double.nan);

        final intervalSec =
            (row.interval is num) ? (row.interval as num).toDouble() : null;

        live.add(
          DriverLive(
            driverNumber: driverNumber,
            acronym: acronym,
            teamColor: hexToColor(info?.teamColorHex ?? "FFFFFF"),
            gapToLeaderSec: row.gapToLeader == null ? 0.0 : gapSec,
            intervalSec: intervalSec,
            rawGap: row.gapToLeader,
            rawInterval: row.interval,
            dateIso: row.dateIso,
          ),
        );
      });

      live.sort((a, b) {
        final ag = a.gapToLeaderSec.isNaN ? double.infinity : a.gapToLeaderSec;
        final bg = b.gapToLeaderSec.isNaN ? double.infinity : b.gapToLeaderSec;
        return ag.compareTo(bg);
      });

      for (int i = 0; i < live.length; i++) {
        live[i] = live[i].copyWith(position: i + 1);
      }

      final now = DateTime.now();
      for (final d in live) {
        if (!d.gapToLeaderSec.isNaN) {
          final list = _gapHistory.putIfAbsent(d.driverNumber, () => []);
          list.add(GapPoint(t: now, gapSec: d.gapToLeaderSec));
          if (list.length > 40) {
            list.removeRange(0, list.length - 40);
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _leaderboard = live;

        if (_selectedDriverNumber != null &&
            !_leaderboard.any((e) => e.driverNumber == _selectedDriverNumber)) {
          _selectedDriverNumber =
              _leaderboard.isNotEmpty ? _leaderboard.first.driverNumber : null;
        }
      });
    } catch (_) {
      _setReplayMode(true, message: "Live indisponible — mode Replay.");
    }
  }

  void _setReplayMode(bool value, {String? message}) {
    if (!mounted) return;

    setState(() {
      _isReplay = value;
      _error = message ?? _error;
    });

    if (value) {
      _timerLive?.cancel();
      _loadReplayFromOpenF1();
    } else {
      _replayTimer?.cancel();
    }
  }

  Future<void> _loadReplayFromOpenF1() async {
    if (_replayDataLoading) return;

    setState(() {
      _replayDataLoading = true;
      _isReplayPlaying = false;
      _error = "Replay: chargement des données OpenF1…";
      _leaderboard = [];
      _gapHistory.clear();

      _replayTimeline = [];
      _replayIdx = 0;
      _replayLatestByDriver.clear();

      _replayLocations = [];
      _replayLocationIdx = 0;
      _latestLocationByDriver.clear();
      _currentReplayTime = null;
    });

    try {
      final picked = await _api.pickMostRecentFinishedRaceSession();
      if (picked == null) {
        throw Exception("Aucune course terminée trouvée (OpenF1).");
      }

      _replaySessionKey = picked.sessionKey;
      _replayRaceLabel = "${picked.meetingName} — ${picked.sessionName}";

      final drivers = await _api.getDrivers(sessionKey: picked.sessionKey);
      if (drivers.isEmpty) {
        throw Exception("Replay: drivers vides (OpenF1).");
      }

      final timeline = await _api.getAllIntervals(sessionKey: picked.sessionKey);
      if (timeline.isEmpty) {
        throw Exception("Replay: intervals vides (OpenF1).");
      }

      final locations = await _api.getAllLocations(sessionKey: picked.sessionKey);

      timeline.sort((a, b) => a.t.compareTo(b.t));
      locations.sort((a, b) => a.t.compareTo(b.t));

      if (!mounted) return;
      setState(() {
        _drivers = drivers;
        _replayTimeline = timeline;
        _replayLocations = locations;
        _replayIdx = 0;
        _replayLocationIdx = 0;
        _error = null;
      });

      _startReplayPlayback();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = "Replay: impossible de charger.\n${e.runtimeType}: $e";
      });
    } finally {
      if (!mounted) return;
      setState(() => _replayDataLoading = false);
    }
  }

  void _toggleReplayPlayback() {
    if (!_isReplay) return;
    if (_replayTimeline.isEmpty) return;

    if (_replayIdx >= _replayTimeline.length) {
      _restartReplayPlayback();
      return;
    }

    if (_isReplayPlaying) {
      _replayTimer?.cancel();
      if (!mounted) return;
      setState(() => _isReplayPlaying = false);
    } else {
      _startReplayPlayback();
    }
  }

  void _restartReplayPlayback() {
    _replayTimer?.cancel();

    _gapHistory.clear();
    _leaderboard = [];
    _replayIdx = 0;
    _replayLocationIdx = 0;
    _replayLatestByDriver.clear();
    _latestLocationByDriver.clear();
    _currentReplayTime = null;

    if (!mounted) return;
    setState(() {
      _isReplayPlaying = false;
    });

    _startReplayPlayback();
  }

  void _startReplayPlayback() {
    _replayTimer?.cancel();

    if (_replayTimeline.isEmpty) {
      if (!mounted) return;
      setState(() => _isReplayPlaying = false);
      return;
    }

    if (_replayIdx >= _replayTimeline.length) {
      if (!mounted) return;
      setState(() => _isReplayPlaying = false);
      return;
    }

    if (!mounted) return;
    setState(() => _isReplayPlaying = true);

    const chunk = 60;

    _replayTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      if (!mounted) return;

      if (!_isReplay || !_isReplayPlaying) {
        _replayTimer?.cancel();
        return;
      }

      if (_replayTimeline.isEmpty) {
        _replayTimer?.cancel();
        setState(() => _isReplayPlaying = false);
        return;
      }

      final end = min(_replayIdx + chunk, _replayTimeline.length);

      for (int i = _replayIdx; i < end; i++) {
        final r = _replayTimeline[i];

        if (r.gapToLeader == null) continue;

        _replayLatestByDriver[r.driverNumber] = IntervalLatest(
          driverNumber: r.driverNumber,
          gapToLeader: r.gapToLeader,
          interval: r.interval,
          dateIso: r.dateIso,
        );

        final gapSec = (r.gapToLeader is num)
            ? (r.gapToLeader as num).toDouble()
            : double.nan;

        if (!gapSec.isNaN) {
          final list = _gapHistory.putIfAbsent(r.driverNumber, () => []);
          list.add(GapPoint(t: r.t, gapSec: gapSec));
          if (list.length > 160) {
            list.removeRange(0, list.length - 160);
          }
        }
      }

      _replayIdx = end;

      if (_replayIdx > 0) {
        _currentReplayTime = _replayTimeline[_replayIdx - 1].t;
      }

      if (_currentReplayTime != null) {
        while (_replayLocationIdx < _replayLocations.length &&
            !_replayLocations[_replayLocationIdx].t.isAfter(_currentReplayTime!)) {
          final loc = _replayLocations[_replayLocationIdx];
          _latestLocationByDriver[loc.driverNumber] = loc;
          _replayLocationIdx++;
        }
      }

      final live = <DriverLive>[];
      _replayLatestByDriver.forEach((driverNumber, row) {
        final info = _drivers[driverNumber];
        final acronym = (info?.acronym.isNotEmpty == true)
            ? info!.acronym
            : "#$driverNumber";

        final gapSec = (row.gapToLeader is num)
            ? (row.gapToLeader as num).toDouble()
            : (row.gapToLeader == null ? 0.0 : double.nan);

        final intervalSec =
            (row.interval is num) ? (row.interval as num).toDouble() : null;

        live.add(
          DriverLive(
            driverNumber: driverNumber,
            acronym: acronym,
            teamColor: hexToColor(info?.teamColorHex ?? "FFFFFF"),
            gapToLeaderSec: row.gapToLeader == null ? 0.0 : gapSec,
            intervalSec: intervalSec,
            rawGap: row.gapToLeader,
            rawInterval: row.interval,
            dateIso: row.dateIso,
          ),
        );
      });

      live.sort((a, b) {
        final ag = a.gapToLeaderSec.isNaN ? double.infinity : a.gapToLeaderSec;
        final bg = b.gapToLeaderSec.isNaN ? double.infinity : b.gapToLeaderSec;
        return ag.compareTo(bg);
      });

      for (int i = 0; i < live.length; i++) {
        live[i] = live[i].copyWith(position: i + 1);
      }

      setState(() {
        _leaderboard = live;

        if (_selectedDriverNumber == null && live.isNotEmpty) {
          _selectedDriverNumber = live.first.driverNumber;
        } else if (_selectedDriverNumber != null &&
            !_leaderboard.any((e) => e.driverNumber == _selectedDriverNumber)) {
          _selectedDriverNumber =
              _leaderboard.isNotEmpty ? _leaderboard.first.driverNumber : null;
        }
      });

      if (_replayIdx >= _replayTimeline.length) {
        _replayTimer?.cancel();
        if (!mounted) return;
        setState(() => _isReplayPlaying = false);
      }
    });
  }

  List<MomentumRow> _computeMomentumTable() {
    final rows = <MomentumRow>[];

    for (final d in _leaderboard.take(20)) {
      final hist = _gapHistory[d.driverNumber];
      if (hist == null || hist.length < 6) continue;

      final last = hist.last;
      final prev = hist[hist.length - 6];

      final dtSeconds = last.t.difference(prev.t).inMilliseconds / 1000.0;
      if (dtSeconds <= 0) continue;

      final dg = prev.gapSec - last.gapSec;
      final momentum = (dg / dtSeconds) * 60.0;

      rows.add(
        MomentumRow(
          driverNumber: d.driverNumber,
          acronym: d.acronym,
          teamColor: d.teamColor,
          momentumSecPerMin: momentum,
        ),
      );
    }

    rows.sort((a, b) => b.momentumSecPerMin.compareTo(a.momentumSecPerMin));
    return rows;
  }

  List<GapPoint> _selectedHistory() {
    final num = _selectedDriverNumber;
    if (num == null) return [];
    return _gapHistory[num] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F6F8);

    final momentumAll = _computeMomentumTable();
    final momentumUp =
        momentumAll.where((e) => e.momentumSecPerMin >= 0).toList();
    final momentumDown =
        momentumAll.where((e) => e.momentumSecPerMin < 0).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F8),
        elevation: 0,
        title: const Text(
          "Replay des meilleurs grands prix",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: _boot,
            icon: const Icon(Icons.refresh_rounded, color: Colors.black),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _boot(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 65),
                children: [
                  _HeroReplayTrackCardPremium(
                    isReplay: _isReplay,
                    isPlaying: _isReplayPlaying,
                    replayLabel: _isReplay ? _replayRaceLabel : _error,
                    replayIndex: _replayIdx,
                    totalItems: _replayTimeline.length,
                    leaderboard: _leaderboard,
                    currentLocations: _latestLocationByDriver,
                    onPlayPause: _toggleReplayPlayback,
                    onRestart: _restartReplayPlayback,
                  ),
                  const SizedBox(height: 14),
                  _TopStatusRow(
                    isReplay: _isReplay,
                    error: _error,
                    replayLabel: _isReplay ? _replayRaceLabel : null,
                  ),
                  if (_isReplay && _replayDataLoading) ...[
                    const SizedBox(height: 10),
                    const _EmptyBox(text: "Chargement des données replay…"),
                  ],
                  const SizedBox(height: 18),
                  const _SectionTitle(
                    title: "Qui accélère / qui décroche",
                    subtitle: "Les plus rapides / Les plus en difficulté",
                  ),
                  const SizedBox(height: 10),
                  _MomentumGainersLosers(
                    gainers: momentumUp.take(6).toList(),
                    losers: momentumDown.take(6).toList(),
                    selectedDriverNumber: _selectedDriverNumber,
                    onSelectDriver: (n) =>
                        setState(() => _selectedDriverNumber = n),
                    loadingText: _isReplay && _replayDataLoading
                        ? "Chargement des données replay…"
                        : "Collecte des données…",
                  ),
                  const SizedBox(height: 14),
                  const _SectionTitle(
                    title: "Tableau de momentum",
                    subtitle: "Vue globale",
                  ),
                  const SizedBox(height: 10),
                  _MomentumTablePremium(
                    rows: momentumAll,
                    selectedDriverNumber: _selectedDriverNumber,
                    onSelectDriver: (n) =>
                        setState(() => _selectedDriverNumber = n),
                    emptyText: _isReplay && _replayDataLoading
                        ? "Chargement des données replay…"
                        : "Collecte des données…",
                  ),
                  const SizedBox(height: 14),
                  const _SectionTitle(
                    title: "Graphique d’écart",
                    subtitle: "Gap au leader (pilote sélectionné)",
                  ),
                  const SizedBox(height: 10),
                  _GapChartCardPremium(
                    title: _selectedDriverNumber == null
                        ? "Sélectionne un pilote"
                        : (_drivers[_selectedDriverNumber!]?.acronym ??
                            "#$_selectedDriverNumber"),
                    teamColor: _selectedDriverNumber == null
                        ? Colors.black26
                        : hexToColor(
                            _drivers[_selectedDriverNumber!]?.teamColorHex ??
                                "FFFFFF",
                          ),
                    points: _selectedHistory(),
                    emptyText: _isReplay && _replayDataLoading
                        ? "Chargement du graphe…"
                        : "Pas assez de données pour tracer le graphe.",
                  ),
                  const SizedBox(height: 18),
                  _SectionTitle(
                    title: "Classement (Top 10)",
                    subtitle: _isReplay ? "Mode Replay (OpenF1)" : "Mode Live",
                  ),
                  const SizedBox(height: 10),
                  if (_leaderboard.isEmpty)
                    const _EmptyBox(text: "Aucune donnée pour le moment.")
                  else
                    ..._leaderboard.take(10).map((d) => _LeaderRowPremium(d: d)),
                ],
              ),
            ),
    );
  }
}

class _HeroReplayTrackCardPremium extends StatelessWidget {
  final bool isReplay;
  final bool isPlaying;
  final String? replayLabel;
  final int replayIndex;
  final int totalItems;
  final List<DriverLive> leaderboard;
  final Map<int, LocationRow> currentLocations;
  final VoidCallback onPlayPause;
  final VoidCallback onRestart;

  const _HeroReplayTrackCardPremium({
    required this.isReplay,
    required this.isPlaying,
    required this.replayLabel,
    required this.replayIndex,
    required this.totalItems,
    required this.leaderboard,
    required this.currentLocations,
    required this.onPlayPause,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        totalItems <= 0 ? 0.0 : (replayIndex / totalItems).clamp(0.0, 1.0);

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: CustomPaint(
                painter: ReplayTrackPainter(
                  cars: leaderboard,
                  locations: currentLocations,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            top: 12,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    isReplay ? "REPLAY OPENF1" : "LIVE OPENF1",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    replayLabel ?? "Chargement…",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: onPlayPause,
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        label: Text(
                          isPlaying
                              ? "Pause"
                              : (replayIndex >= totalItems && totalItems > 0
                                  ? "Rejouer"
                                  : "Lecture"),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: onRestart,
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text("Recommencer"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${(progress * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white12,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
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

class ReplayTrackPainter extends CustomPainter {
  final List<DriverLive> cars;
  final Map<int, LocationRow> locations;

  ReplayTrackPainter({
    required this.cars,
    required this.locations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgGrid = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), bgGrid);
    }

    final trackStroke = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final trackInner = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final path = _buildMelbourneTrack(size);
    canvas.drawPath(path, trackStroke);
    canvas.drawPath(path, trackInner);

    final locs = locations.values.toList();

    if (locs.length >= 2) {
      final minX = locs.map((e) => e.x).reduce(min);
      final maxX = locs.map((e) => e.x).reduce(max);
      final minY = locs.map((e) => e.y).reduce(min);
      final maxY = locs.map((e) => e.y).reduce(max);

      final rangeX = (maxX - minX).abs() < 0.0001 ? 1.0 : (maxX - minX);
      final rangeY = (maxY - minY).abs() < 0.0001 ? 1.0 : (maxY - minY);

      Offset normalize(double x, double y) {
        const pad = 30.0;
        final nx = (x - minX) / rangeX;
        final ny = (y - minY) / rangeY;
        final dx = pad + nx * (size.width - pad * 2);
        final dy = pad + ny * (size.height - pad * 2);
        return Offset(dx, dy);
      }

      final dots = Paint()..style = PaintingStyle.fill;

      for (final d in cars.take(20)) {
        final loc = locations[d.driverNumber];
        if (loc == null) continue;

        final p = normalize(loc.x, loc.y);

        dots.color = d.teamColor;
        canvas.drawCircle(p, 5.8, dots);

        final outline = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.3;
        canvas.drawCircle(p, 5.8, outline);

        final tp = TextPainter(
          text: TextSpan(
            text: d.position <= 9 ? "${d.position}" : "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        if (d.position <= 9) {
          tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
        }
      }
    } else {
      final carsOnFallback = cars.take(12).toList();
      for (int i = 0; i < carsOnFallback.length; i++) {
        final d = carsOnFallback[i];
        final t = ((i / max(1, carsOnFallback.length)) * 0.92 + 0.02) % 1.0;
        final p = _pointOnPath(path, size, t);

        final paint = Paint()..color = d.teamColor;
        canvas.drawCircle(p, 5.8, paint);

        final outline = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.3;
        canvas.drawCircle(p, 5.8, outline);
      }
    }
  }

  Path _buildMelbourneTrack(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();

    path.moveTo(w * 0.86, h * 0.73);

    path.cubicTo(
      w * 0.78, h * 0.73,
      w * 0.66, h * 0.73,
      w * 0.56, h * 0.73,
    );

    path.cubicTo(
      w * 0.46, h * 0.73,
      w * 0.32, h * 0.73,
      w * 0.22, h * 0.71,
    );

    path.cubicTo(
      w * 0.14, h * 0.69,
      w * 0.10, h * 0.60,
      w * 0.12, h * 0.50,
    );

    path.cubicTo(
      w * 0.14, h * 0.39,
      w * 0.17, h * 0.28,
      w * 0.20, h * 0.20,
    );

    path.cubicTo(
      w * 0.28, h * 0.09,
      w * 0.44, h * 0.07,
      w * 0.58, h * 0.10,
    );

    path.cubicTo(
      w * 0.69, h * 0.12,
      w * 0.78, h * 0.16,
      w * 0.84, h * 0.23,
    );

    path.cubicTo(
      w * 0.91, h * 0.31,
      w * 0.90, h * 0.41,
      w * 0.84, h * 0.47,
    );

    path.cubicTo(
      w * 0.78, h * 0.54,
      w * 0.67, h * 0.56,
      w * 0.56, h * 0.56,
    );

    path.cubicTo(
      w * 0.48, h * 0.56,
      w * 0.42, h * 0.57,
      w * 0.39, h * 0.61,
    );

    path.cubicTo(
      w * 0.36, h * 0.65,
      w * 0.38, h * 0.69,
      w * 0.44, h * 0.70,
    );

    path.cubicTo(
      w * 0.51, h * 0.71,
      w * 0.61, h * 0.69,
      w * 0.69, h * 0.67,
    );

    path.cubicTo(
      w * 0.77, h * 0.65,
      w * 0.84, h * 0.64,
      w * 0.88, h * 0.67,
    );

    path.cubicTo(
      w * 0.91, h * 0.69,
      w * 0.91, h * 0.72,
      w * 0.86, h * 0.73,
    );

    return path;
  }

  Offset _pointOnPath(Path path, Size size, double t) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return Offset(size.width / 2, size.height / 2);

    final metric = metrics.first;
    final tangent = metric.getTangentForOffset(metric.length * t);
    return tangent?.position ?? Offset(size.width / 2, size.height / 2);
  }

  @override
  bool shouldRepaint(covariant ReplayTrackPainter oldDelegate) {
    return oldDelegate.cars != cars || oldDelegate.locations != locations;
  }
}

class _TopStatusRow extends StatelessWidget {
  final bool isReplay;
  final String? error;
  final String? replayLabel;

  const _TopStatusRow({
    required this.isReplay,
    required this.error,
    required this.replayLabel,
  });

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFFFFFFFF);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isReplay
                        ? const Color(0xFF6D6D6D)
                        : const Color(0xFF1B5E20),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isReplay ? "REPLAY" : "LIVE",
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                if (replayLabel != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      replayLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.withOpacity(0.25)),
              ),
              child: Text(
                error!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
      const SizedBox(height: 3),
      Text(subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54)),
    ]);
  }
}

class _MomentumGainersLosers extends StatelessWidget {
  final List<MomentumRow> gainers;
  final List<MomentumRow> losers;
  final int? selectedDriverNumber;
  final void Function(int) onSelectDriver;
  final String loadingText;

  const _MomentumGainersLosers({
    required this.gainers,
    required this.losers,
    required this.selectedDriverNumber,
    required this.onSelectDriver,
    required this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    Widget placeholderList() {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
        ),
      );
    }

    Widget panel(String title, IconData icon, List<MomentumRow> rows) {
      return Expanded(
        child: SizedBox(
          height: 360,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                ]),
                const SizedBox(height: 10),
                Expanded(
                  child: rows.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loadingText,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(child: placeholderList()),
                          ],
                        )
                      : ListView(
                          padding: EdgeInsets.zero,
                          children: rows.map((r) {
                            final isSel = selectedDriverNumber == r.driverNumber;
                            final val = r.momentumSecPerMin;
                            final absVal = val.abs();
                            final bar = (absVal / 2.0).clamp(0.06, 1.0);

                            return InkWell(
                              onTap: () => onSelectDriver(r.driverNumber),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSel ? Colors.black : const Color(0xFFF7F7F8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: r.teamColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 48,
                                      child: Text(
                                        r.acronym,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: isSel ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(999),
                                        child: LinearProgressIndicator(
                                          value: bar.toDouble(),
                                          minHeight: 8,
                                          backgroundColor:
                                              isSel ? Colors.white12 : Colors.black12,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            isSel ? Colors.white : r.teamColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${val >= 0 ? "+" : "-"}${absVal.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: isSel
                                            ? Colors.white
                                            : (val >= 0
                                                ? const Color(0xFF1B5E20)
                                                : const Color(0xFFB71C1C)),
                                      ),
                                    ),
                                    const Text(
                                      " s",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        panel("Gainers", Icons.trending_up_rounded, gainers),
        const SizedBox(width: 10),
        panel("Losers", Icons.trending_down_rounded, losers),
      ],
    );
  }
}

class _MomentumTablePremium extends StatelessWidget {
  final List<MomentumRow> rows;
  final int? selectedDriverNumber;
  final void Function(int) onSelectDriver;
  final String emptyText;

  const _MomentumTablePremium({
    required this.rows,
    required this.selectedDriverNumber,
    required this.onSelectDriver,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Text(
          emptyText,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: rows.take(14).map((r) {
          final isSel = selectedDriverNumber == r.driverNumber;
          final pos = r.momentumSecPerMin >= 0;
          final v = r.momentumSecPerMin.abs();

          return InkWell(
            onTap: () => onSelectDriver(r.driverNumber),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: isSel ? Colors.black : const Color(0xFFF7F7F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: r.teamColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 52,
                    child: Text(
                      r.acronym,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: isSel ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    pos
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    color: isSel
                        ? Colors.white
                        : (pos
                            ? const Color(0xFF1B5E20)
                            : const Color(0xFFB71C1C)),
                    size: 28,
                  ),
                  Text(
                    "${pos ? "+" : "-"}${v.toStringAsFixed(2)} s/min",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: isSel
                          ? Colors.white
                          : (pos
                              ? const Color(0xFF1B5E20)
                              : const Color(0xFFB71C1C)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GapChartCardPremium extends StatelessWidget {
  final String title;
  final Color teamColor;
  final List<GapPoint> points;
  final String emptyText;

  const _GapChartCardPremium({
    required this.title,
    required this.teamColor,
    required this.points,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: teamColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: points.length < 3
              ? Center(
                  child: Text(
                    emptyText,
                    style: const TextStyle(color: Colors.black54),
                  ),
                )
              : CustomPaint(
                  painter: GapChartPainter(points: points, accent: teamColor),
                  child: const SizedBox.expand(),
                ),
        ),
      ]),
    );
  }
}

class GapChartPainter extends CustomPainter {
  final List<GapPoint> points;
  final Color accent;
  GapChartPainter({required this.points, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = accent
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke;

    final grid = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final gaps = points.map((e) => e.gapSec).toList();
    final minG = gaps.reduce(min);
    final maxG = gaps.reduce(max);
    final range = (maxG - minG).abs() < 0.0001 ? 1.0 : (maxG - minG);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final yNorm = (points[i].gapSec - minG) / range;
      final y = (yNorm * (size.height - 10)) + 5;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant GapChartPainter oldDelegate) =>
      oldDelegate.points.length != points.length || oldDelegate.accent != accent;
}

class _LeaderRowPremium extends StatelessWidget {
  final DriverLive d;
  const _LeaderRowPremium({required this.d});

  String _gapText() {
    if (d.rawGap == null) return "LEADER";
    if (d.rawGap is num) {
      final s = (d.rawGap as num).toDouble();
      return s < 10 ? "+${s.toStringAsFixed(3)}" : "+${s.toStringAsFixed(1)}";
    }
    return d.rawGap.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text("${d.position}",
                style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: d.teamColor,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 56,
            child: Text(d.acronym,
                style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
          const Spacer(),
          Text(_gapText(), style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String text;
  const _EmptyBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black54)),
    );
  }
}

class DriverInfo {
  final int number;
  final String acronym;
  final String teamColorHex;

  DriverInfo({
    required this.number,
    required this.acronym,
    required this.teamColorHex,
  });
}

class IntervalLatest {
  final int driverNumber;
  final dynamic gapToLeader;
  final dynamic interval;
  final String dateIso;

  IntervalLatest({
    required this.driverNumber,
    required this.gapToLeader,
    required this.interval,
    required this.dateIso,
  });
}

class DriverLive {
  final int driverNumber;
  final int position;
  final String acronym;
  final Color teamColor;
  final double gapToLeaderSec;
  final double? intervalSec;
  final dynamic rawGap;
  final dynamic rawInterval;
  final String dateIso;

  DriverLive({
    required this.driverNumber,
    required this.acronym,
    required this.teamColor,
    required this.gapToLeaderSec,
    required this.intervalSec,
    required this.rawGap,
    required this.rawInterval,
    required this.dateIso,
    this.position = 0,
  });

  DriverLive copyWith({int? position}) => DriverLive(
        driverNumber: driverNumber,
        acronym: acronym,
        teamColor: teamColor,
        gapToLeaderSec: gapToLeaderSec,
        intervalSec: intervalSec,
        rawGap: rawGap,
        rawInterval: rawInterval,
        dateIso: dateIso,
        position: position ?? this.position,
      );
}

class GapPoint {
  final DateTime t;
  final double gapSec;
  GapPoint({required this.t, required this.gapSec});
}

class MomentumRow {
  final int driverNumber;
  final String acronym;
  final Color teamColor;
  final double momentumSecPerMin;

  MomentumRow({
    required this.driverNumber,
    required this.acronym,
    required this.teamColor,
    required this.momentumSecPerMin,
  });
}

class IntervalRow {
  final int driverNumber;
  final dynamic gapToLeader;
  final dynamic interval;
  final String dateIso;
  final DateTime t;

  IntervalRow({
    required this.driverNumber,
    required this.gapToLeader,
    required this.interval,
    required this.dateIso,
    required this.t,
  });
}

class LocationRow {
  final int driverNumber;
  final double x;
  final double y;
  final double z;
  final String dateIso;
  final DateTime t;

  LocationRow({
    required this.driverNumber,
    required this.x,
    required this.y,
    required this.z,
    required this.dateIso,
    required this.t,
  });
}

class PickedRaceSession {
  final int sessionKey;
  final String meetingName;
  final String sessionName;
  final DateTime dateEnd;

  PickedRaceSession({
    required this.sessionKey,
    required this.meetingName,
    required this.sessionName,
    required this.dateEnd,
  });
}

class LatestLiveSession {
  final int sessionKey;
  final int? meetingKey;
  final String meetingName;
  final String sessionName;

  LatestLiveSession({
    required this.sessionKey,
    required this.meetingKey,
    required this.meetingName,
    required this.sessionName,
  });
}

class OpenF1Service {
  static const _base = 'https://api.openf1.org/v1';

  DateTime? _parseIso(dynamic v) {
    if (v == null) return null;
    final s = v.toString();
    try {
      return DateTime.parse(s).toUtc();
    } catch (_) {
      return null;
    }
  }

  Future<LatestLiveSession?> getLatestLiveSession() async {
    final uri = Uri.parse('$_base/sessions?session_key=latest');
    final res = await http.get(uri).timeout(const Duration(seconds: 12));

    if (res.statusCode != 200) return null;

    final body = jsonDecode(res.body);
    if (body is! List || body.isEmpty) return null;

    final s = Map<String, dynamic>.from(body.first as Map);

    final sessionKey = s['session_key'];
    if (sessionKey is! int) return null;

    return LatestLiveSession(
      sessionKey: sessionKey,
      meetingKey: s['meeting_key'] as int?,
      meetingName:
          (s['meeting_name'] ?? s['location'] ?? 'Unknown meeting').toString(),
      sessionName: (s['session_name'] ?? 'Unknown session').toString(),
    );
  }

  Future<Map<int, DriverInfo>> getDrivers({required int sessionKey}) async {
    final uri = Uri.parse('$_base/drivers?session_key=$sessionKey');
    final res = await http.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) return {};

    final body = jsonDecode(res.body);
    if (body is! List) return {};

    final map = <int, DriverInfo>{};

    for (final item in body) {
      if (item is! Map) continue;
      final d = Map<String, dynamic>.from(item);

      final num = d['driver_number'];
      if (num is! int) continue;

      map[num] = DriverInfo(
        number: num,
        acronym: (d['name_acronym'] ?? '').toString(),
        teamColorHex: (d['team_colour'] ?? 'FFFFFF').toString(),
      );
    }
    return map;
  }

  Future<Map<int, IntervalLatest>> getLatestIntervalsByDriver({
    required int sessionKey,
  }) async {
    final uri = Uri.parse('$_base/intervals?session_key=$sessionKey');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));

    if (res.statusCode != 200) return {};

    final body = jsonDecode(res.body);
    if (body is! List || body.isEmpty) return {};

    final latest = <int, Map<String, dynamic>>{};

    for (final item in body) {
      if (item is! Map) continue;
      final row = Map<String, dynamic>.from(item);

      final n = row['driver_number'];
      if (n is! int) continue;

      final currentDate = (row['date'] ?? '').toString();
      if (currentDate.isEmpty) continue;

      final prev = latest[n];
      if (prev == null) {
        latest[n] = row;
      } else {
        final prevDate = (prev['date'] ?? '').toString();
        if (currentDate.compareTo(prevDate) > 0) {
          latest[n] = row;
        }
      }
    }

    final out = <int, IntervalLatest>{};
    latest.forEach((n, r) {
      out[n] = IntervalLatest(
        driverNumber: n,
        gapToLeader: r['gap_to_leader'],
        interval: r['interval'],
        dateIso: (r['date'] ?? '').toString(),
      );
    });

    return out;
  }

  Future<PickedRaceSession?> pickMostRecentFinishedRaceSession() async {
    final now = DateTime.now().toUtc();
    final yearsToCheck = <int>[now.year, now.year - 1, now.year - 2];
    final candidates = <PickedRaceSession>[];

    for (final year in yearsToCheck) {
      final uri = Uri.parse('$_base/sessions?year=$year&session_name=Race');
      final res = await http.get(uri).timeout(const Duration(seconds: 15));

      if (res.statusCode != 200) continue;

      final body = jsonDecode(res.body);
      if (body is! List) continue;

      for (final item in body) {
        if (item is! Map) continue;
        final s = Map<String, dynamic>.from(item);

        final sessionKey = s['session_key'];
        final end = _parseIso(s['date_end']);

        if (sessionKey is! int || end == null) continue;

        if (end.isBefore(now)) {
          candidates.add(
            PickedRaceSession(
              sessionKey: sessionKey,
              meetingName:
                  (s['meeting_name'] ?? s['location'] ?? 'Race').toString(),
              sessionName: (s['session_name'] ?? 'Race').toString(),
              dateEnd: end,
            ),
          );
        }
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => b.dateEnd.compareTo(a.dateEnd));
    return candidates.first;
  }

  Future<List<IntervalRow>> getAllIntervals({required int sessionKey}) async {
    final uri = Uri.parse('$_base/intervals?session_key=$sessionKey');
    final res = await http.get(uri).timeout(const Duration(seconds: 25));
    if (res.statusCode != 200) return [];

    final body = jsonDecode(res.body);
    if (body is! List || body.isEmpty) return [];

    final out = <IntervalRow>[];

    for (final item in body) {
      if (item is! Map) continue;
      final r = Map<String, dynamic>.from(item);

      final driverNumber = r['driver_number'];
      if (driverNumber is! int) continue;

      final dateIso = (r['date'] ?? '').toString();
      final t = _parseIso(dateIso);
      if (t == null) continue;

      out.add(
        IntervalRow(
          driverNumber: driverNumber,
          gapToLeader: r['gap_to_leader'],
          interval: r['interval'],
          dateIso: dateIso,
          t: t,
        ),
      );
    }

    return out;
  }

  Future<List<LocationRow>> getAllLocations({required int sessionKey}) async {
    final uri = Uri.parse('$_base/location?session_key=$sessionKey');
    final res = await http.get(uri).timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) return [];

    final body = jsonDecode(res.body);
    if (body is! List || body.isEmpty) return [];

    final out = <LocationRow>[];

    for (final item in body) {
      if (item is! Map) continue;
      final r = Map<String, dynamic>.from(item);

      final driverNumber = r['driver_number'];
      final x = r['x'];
      final y = r['y'];
      final z = r['z'];

      if (driverNumber is! int) continue;
      if (x is! num || y is! num || z is! num) continue;

      final dateIso = (r['date'] ?? '').toString();
      final t = _parseIso(dateIso);
      if (t == null) continue;

      out.add(
        LocationRow(
          driverNumber: driverNumber,
          x: x.toDouble(),
          y: y.toDouble(),
          z: z.toDouble(),
          dateIso: dateIso,
          t: t,
        ),
      );
    }

    return out;
  }
}

Color hexToColor(String hex) {
  var h = hex.replaceAll('#', '').trim();
  if (h.isEmpty) h = 'FFFFFF';
  if (h.length == 6) h = 'FF$h';

  try {
    return Color(int.parse(h, radix: 16));
  } catch (_) {
    return const Color(0xFFFFFFFF);
  }
}