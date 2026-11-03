import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:mobil_arici/features/weather/domain/weather_icons.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_attribution.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_labels.dart';

/// Arılığın havası (docs/design "Arılık havası · 7 gün"): şimdiki durum,
/// bugünün kovan açma bandı, saat şeridi, gelen gün sayısı kadar günlük
/// liste ve yağışlı/rüzgarlı günler için "Planla" önerisi. Telefonda
/// saklanan paketten okunur; çevrimdışıyken son paket "Güncelleme" saatiyle
/// görünür, hiç paket yoksa boş durum ve "Yenile".
class ApiaryWeatherScreen extends ConsumerStatefulWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  ConsumerState<ApiaryWeatherScreen> createState() =>
      _ApiaryWeatherScreenState();
}

class _ApiaryWeatherScreenState extends ConsumerState<ApiaryWeatherScreen> {
  Timer? _hourTimer;

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(weatherRefresherProvider).refreshIfStale());
    _scheduleHourTick();
  }

  /// Ekran açıkken saat dönünce "Şimdi" ve bugünün satırı yeni saate
  /// geçsin; paket değişmese de yeniden çizilir.
  void _scheduleHourTick() {
    final now = clock.now().toLocal();
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    _hourTimer = Timer(nextHour.difference(now), () {
      if (!mounted) return;
      setState(() {});
      _scheduleHourTick();
    });
  }

  @override
  void dispose() {
    _hourTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    final l10n = AppLocalizations.of(context);
    final ok = await ref.read(weatherRefresherProvider).refreshNow();
    if (!ok && mounted) showMessageSnackBar(context, l10n.weatherRefreshFailed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(apiaryWeatherDetailProvider(widget.apiaryId));

    return switch (detail) {
      AsyncData(value: final detail?) => switch (detail.forecast) {
        // Tasarımdaki gibi üst çubuk yok: geri, ad ve alt yazı, "Güncelleme"
        // hapı sayfanın başında.
        final forecast? => Scaffold(
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: _ForecastView(detail: detail, forecast: forecast),
            ),
          ),
        ),
        null => Scaffold(
          appBar: AppBar(title: Text(detail.apiary.name)),
          body: _NoForecast(
            hasLocation: detail.apiary.latitude != null,
            onRefresh: _refresh,
          ),
        ),
      },
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.weatherApiaryNotFound)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

/// Hiç paket yok (ya da pakette bu arılık yok): açıklama, yenile ve atıf.
class _NoForecast extends StatelessWidget {
  const new({required this.hasLocation, required this.onRefresh});

  final bool hasLocation;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        EmptyState(
          icon: Icons.cloud_off_outlined,
          title: l10n.weatherEmptyTitle,
          message: hasLocation
              ? l10n.weatherEmptyMessage
              : l10n.weatherNoLocationMessage,
          actionLabel: hasLocation ? l10n.weatherRefresh : null,
          onAction: hasLocation ? onRefresh : null,
        ),
        SizedBox(height: spacing.lg),
        const WeatherAttribution(),
      ],
    );
  }
}

class _ForecastView extends ConsumerWidget {
  const new({required this.detail, required this.forecast});

  final ApiaryWeatherDetail detail;
  final Forecast forecast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final units = WeatherFormat(
      l10n,
      format,
      ref.watch(regionConfigProvider).defaultUnits,
    );
    final thresholds = detail.thresholds;
    final now = clock.now();
    final days = forecastDays(forecast, now);
    final today = forecastLocalTime(
      forecast,
      now.millisecondsSinceEpoch ~/ 1000,
    );
    final todayWeather = days.firstOrNull?.day.day == today.day
        ? days.first
        : null;
    final plan = inspectionPlan(days, thresholds);
    final place = [?forecast.place, ?forecast.region].join(', ');
    final secondary = context.typography.bodySmall.copyWith(
      color: colors.textSecondary,
    );

    return ListView(
      // Alt kenar telefonun gezinme çubuğunun üstünde kalsın.
      padding: EdgeInsets.fromLTRB(
        spacing.sm,
        spacing.sm,
        spacing.lg,
        spacing.lg + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(),
            SizedBox(width: spacing.xs),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: spacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.apiary.name, style: context.typography.title),
                    // Tek satır; sığmazsa küçülür.
                    _OneLine(
                      Text(
                        place.isEmpty
                            ? l10n.weatherScreenSubtitleNoPlace(
                                '${days.length}',
                              )
                            : l10n.weatherScreenSubtitle(
                                place,
                                '${days.length}',
                              ),
                        style: secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (detail.generatedAt case final generatedAt?) ...[
              SizedBox(width: spacing.sm),
              // Büyük yazıda adın yerini almasın; en çok yarısı, küçülür.
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(top: spacing.sm),
                  child: _OneLine(
                    _UpdatedPill(generatedAt.toLocal(), now: now),
                  ),
                ),
              ),
            ],
          ],
        ),
        // Sayfanın geri kalanı başlığın sağ ve sol boşluğuyla hizalı.
        Padding(
          padding: EdgeInsetsDirectional.only(start: spacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: spacing.lg),
              _CurrentCard(
                forecast: forecast,
                now: now,
                today: todayWeather,
                thresholds: thresholds,
                units: units,
              ),
              SizedBox(height: spacing.lg),
              _HourlyStrip(
                hours: hourlyStrip(forecast, now),
                forecast: forecast,
                thresholds: thresholds,
                units: units,
              ),
              if (days.isNotEmpty) ...[
                SizedBox(height: spacing.lg),
                _DailyList(
                  days: days,
                  today: todayWeather,
                  thresholds: thresholds,
                  units: units,
                ),
              ],
              if (plan != null) ...[
                SizedBox(height: spacing.lg),
                _PlanBand(plan: plan, apiary: detail.apiary),
              ],
              SizedBox(height: spacing.md),
              WeatherAttribution(
                leading: l10n.weatherThresholdsHint(
                  units.temperature(thresholds.minTemperatureC),
                  units.speed(thresholds.maxWindKmh),
                  units.percent(thresholds.maxPrecipitationProbability),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Güncelleme 06:40"; paket bugünden değilse günüyle.
class _UpdatedPill extends StatelessWidget {
  const new(this.generatedAt, {required this.now});

  final DateTime generatedAt;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final format = AppFormat.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final local = now.toLocal();
    final sameDay =
        generatedAt.year == local.year &&
        generatedAt.month == local.month &&
        generatedAt.day == local.day;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.tile,
        borderRadius: BorderRadius.circular(context.radii.pill),
        border: Border.all(
          color: colors.divider,
          width: context.strokes.border,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Text(
          AppLocalizations.of(context).weatherUpdatedAt(
            sameDay ? format.time(generatedAt) : format.dateTime(generatedAt),
          ),
          style: context.typography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Şimdiki durum: simge, sıcaklık, durum ve hissedilen; rüzgar, nem ve
/// yağış olasılığı; altında bugünün kovan açma bandı.
class _CurrentCard extends StatelessWidget {
  const new({
    required this.forecast,
    required this.now,
    required this.today,
    required this.thresholds,
    required this.units,
  });

  final Forecast forecast;
  final DateTime now;
  final DailyWeather? today;
  final HiveOpeningThresholds thresholds;
  final WeatherFormat units;

  @override
  Widget build(BuildContext context) {
    final l10n = units.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;
    final current = forecast.current;
    final hour = forecastHourAt(forecast, now);
    final temperature = current.temperatureC ?? hour?.temperatureC;
    final wind = current.windKmh ?? hour?.windKmh;
    final precipitation = hour?.precipitationProbability;
    final icon = weatherIconFor(current.conditionCode ?? hour?.conditionCode);
    final condition = weatherConditionLabel(
      l10n,
      current.conditionCode ?? hour?.conditionCode,
    );
    final opening = today == null ? null : dayOpening(today!, thresholds);

    // "Rüzgar 8 km/s": ad soluk, değer kalın; sağa yaslı.
    Widget measure(String label, String value) => Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(color: colors.textSecondary),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      style: typography.body,
      textAlign: TextAlign.end,
    );

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Solda simge, sıcaklık ve durum; sağda üstte ölçüler (tasarım).
            // Büyük yazıda sıcaklık küçülür, ölçüler alt satıra düşmez.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          weatherGlyph(
                            context,
                            l10n,
                            icon,
                            size: context.sizes.illustrationIcon,
                          ),
                          SizedBox(width: spacing.md),
                          // Büyük yazıda dar ekrana sığmazsa küçülür.
                          if (temperature != null)
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  units.temperature(temperature),
                                  style: typography.display,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        switch (current.feelsLikeC) {
                          final feels? => l10n.weatherFeelsLike(
                            condition,
                            units.temperature(feels),
                          ),
                          null => condition,
                        },
                        style: typography.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing.md),
                // Çok dar ekranda en çok yarısı; satırlar sağa yaslı kırılır.
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (wind != null)
                        measure(l10n.weatherWindLabel, units.speed(wind)),
                      if (current.humidity case final humidity?)
                        measure(
                          l10n.weatherHumidityLabel,
                          units.percent(humidity),
                        ),
                      if (precipitation != null)
                        measure(
                          l10n.weatherPrecipitationLabel,
                          units.percent(precipitation),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (opening != null) ...[
              SizedBox(height: spacing.lg),
              _StatusBand(
                status: hiveOpeningStatus(opening),
                icon: hiveOpeningIcon(opening),
                label: switch (opening) {
                  HiveOpening.suitable => l10n.weatherTodaySuitable,
                  HiveOpening.rain => l10n.weatherTodayRain,
                  HiveOpening.wind => l10n.weatherTodayWind,
                  HiveOpening.cold => l10n.weatherTodayCold,
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Durumun zemininde tam genişlikte bant: ikon ve kelime.
class _StatusBand extends StatelessWidget {
  const new({required this.status, required this.label, this.icon});

  final AppStatus status;
  final String label;

  /// Durumun varsayılan ikonunun yerine (rozetle aynı: yağmurda "×").
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final foreground = status.colorIn(colors);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.containerIn(colors),
        borderRadius: BorderRadius.circular(context.radii.button),
        border: colors.surfaceContainer == colors.surface
            ? Border.all(color: foreground, width: context.strokes.border)
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Row(
          children: [
            Icon(
              icon ?? status.icon,
              size: context.sizes.icon,
              color: foreground,
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Text(
                label,
                style: context.typography.subtitle.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bugünün saat şeridi: "Şimdi" ve sonraki üç saatlik dilimler.
class _HourlyStrip extends StatelessWidget {
  const new({
    required this.hours,
    required this.forecast,
    required this.thresholds,
    required this.units,
  });

  final List<HourlyWeather> hours;
  final Forecast forecast;
  final HiveOpeningThresholds thresholds;
  final WeatherFormat units;

  @override
  Widget build(BuildContext context) {
    if (hours.isEmpty) return const SizedBox.shrink();
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (i, hour) in hours.indexed)
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: i == 0 ? colors.surfaceContainer : null,
                    borderRadius: BorderRadius.circular(context.radii.button),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing.sm),
                    // Büyük yazıda sütun sığmazsa küçülür; beş sütun kalır.
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        children: [
                          Text(
                            i == 0
                                ? units.l10n.weatherNow
                                : units.format.time(
                                    forecastLocalTime(forecast, hour.time),
                                  ),
                            style: typography.label,
                          ),
                          SizedBox(height: spacing.xs),
                          weatherGlyph(
                            context,
                            units.l10n,
                            weatherIconFor(hour.conditionCode),
                            size: context.sizes.icon,
                          ),
                          SizedBox(height: spacing.xs),
                          Text(switch (hour.temperatureC) {
                            final celsius? => units.temperature(celsius),
                            null => '–',
                          }, style: typography.subtitle),
                          if (hour.precipitationProbability case final p?)
                            Text(
                              units.percent(p),
                              style: typography.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Günlük liste, gelen gün sayısı kadar. Geniş ekranda tablo (başlıklı
/// tek satır), dar ekranda ya da büyük yazıda her gün iki satır.
class _DailyList extends StatelessWidget {
  const new({
    required this.days,
    required this.today,
    required this.thresholds,
    required this.units,
  });

  final List<DailyWeather> days;
  final DailyWeather? today;
  final HiveOpeningThresholds thresholds;
  final WeatherFormat units;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final typography = context.typography;
    final colors = context.colors;
    final l10n = units.l10n;
    final header = typography.caption.copyWith(
      color: colors.textSecondary,
      fontWeight: FontWeight.w600,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Saha modlarında (güneş, eldiven) yazı büyük; eşik de büyür.
        final fieldScale =
            typography.body.fontSize! / AppTypography.standard.body.fontSize!;
        final wide =
            constraints.maxWidth >=
            MediaQuery.textScalerOf(context)
                .scale(context.sizes.weatherTable * fieldScale);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (wide)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.sm,
                ),
                child: _TableRow(
                  day: Text(
                    units.format.upperCase(l10n.weatherColumnDay),
                    style: header,
                  ),
                  temperature: Text(
                    units.format.upperCase(l10n.weatherColumnTemperature),
                    style: header,
                  ),
                  precipitation: Text(
                    units.format.upperCase(l10n.weatherColumnPrecipitation),
                    style: header,
                  ),
                  wind: Text(
                    units.format.upperCase(units.speedUnit),
                    style: header,
                  ),
                  hive: Text(
                    units.format.upperCase(l10n.weatherColumnHive),
                    style: header,
                  ),
                ),
              ),
            AppCard(
              child: Column(
                children: [
                  for (final (i, day) in days.indexed) ...[
                    if (i > 0) Divider(height: context.strokes.border),
                    _DayRow(
                      day: day,
                      isToday: identical(day, today),
                      wide: wide,
                      thresholds: thresholds,
                      units: units,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Tablonun sütun oranları; başlık ve satır aynı.
class _TableRow extends StatelessWidget {
  const new({
    required this.day,
    required this.temperature,
    required this.precipitation,
    required this.wind,
    required this.hive,
  });

  final Widget day;
  final Widget temperature;
  final Widget precipitation;
  final Widget wind;
  final Widget hive;

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(width: context.spacing.xs);
    return Row(
      children: [
        // Tasarımdaki sütun enleri (390dp'de ~80 / 70 / 40 / 40 / 90); YAĞIŞ
        // başlığı küçülmeden sığsın diye yağış biraz geniş, kovan biraz dar.
        // Başlık ve değerler sütunda ortalanır; yalnız gün sola yaslıdır.
        Expanded(flex: 8, child: day),
        gap,
        Expanded(flex: 7, child: _OneLine(temperature)),
        gap,
        Expanded(flex: 5, child: _OneLine(precipitation)),
        gap,
        Expanded(flex: 4, child: _OneLine(wind)),
        gap,
        Expanded(flex: 8, child: _OneLine(hive)),
      ],
    );
  }
}

/// Sütuna sığmayan başlık ya da değer alt satıra geçmez, küçülür.
class _OneLine extends StatelessWidget {
  const new(this.child, {this.alignment = Alignment.center});

  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) =>
      FittedBox(fit: BoxFit.scaleDown, alignment: alignment, child: child);
}

class _DayRow extends StatelessWidget {
  const new({
    required this.day,
    required this.isToday,
    required this.wide,
    required this.thresholds,
    required this.units,
  });

  final DailyWeather day;
  final bool isToday;
  final bool wide;
  final HiveOpeningThresholds thresholds;
  final WeatherFormat units;

  @override
  Widget build(BuildContext context) {
    final l10n = units.l10n;
    final format = units.format;
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;
    final opening = dayOpening(day, thresholds);
    // Tasarımdaki gibi simge gökyüzünden; rüzgar rozette ve km/s'de.
    final icon = weatherIconFor(day.conditionCode);
    final rainy = opening == HiveOpening.rain;
    final windy = opening == HiveOpening.wind;
    final secondary = typography.caption.copyWith(color: colors.textSecondary);

    // Gün adı ve tarih bölünmez ("Bugü / n" olmasın); sığmazsa küçülür.
    final dayLabel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _OneLine(
          alignment: AlignmentDirectional.centerStart,
          Text(
            isToday ? l10n.weatherToday : format.weekdayShort(day.day),
            style: typography.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        _OneLine(
          Text(format.dayMonth(day.day), style: secondary),
          alignment: AlignmentDirectional.centerStart,
        ),
      ],
    );
    final temperature = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: day.temperatureMaxC == null
                ? '–'
                : units.temperature(day.temperatureMaxC!),
            style: typography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text:
                ' / ${switch (day.temperatureMinC) {
                  final min? => units.temperature(min),
                  null => '–',
                }}',
            style: secondary,
          ),
        ],
      ),
    );
    final precipitation = Text(
      switch (day.precipitationProbability) {
        final p? => units.percent(p),
        null => '–',
      },
      style: (wide ? typography.bodySmall : secondary).copyWith(
        color: rainy ? colors.statusInfo : (wide ? null : colors.textPrimary),
        fontWeight: rainy ? FontWeight.w700 : (wide ? null : FontWeight.w600),
      ),
    );
    final wind = Text(
      switch (day.windMaxKmh) {
        final kmh? => units.speedValue(kmh),
        null => '–',
      },
      style: (wide ? typography.bodySmall : secondary).copyWith(
        color: windy
            ? colors.statusWarning
            : (wide ? null : colors.textPrimary),
        fontWeight: windy ? FontWeight.w700 : (wide ? null : FontWeight.w600),
      ),
    );
    final badge = opening == null
        ? const SizedBox.shrink()
        : Align(
            child: StatusBadge(
              status: hiveOpeningStatus(opening),
              icon: hiveOpeningIcon(opening),
              dense: true,
              label: hiveOpeningLabel(
                l10n,
                opening,
                suitable: l10n.hiveOpeningDaySuitable,
              ),
            ),
          );
    final iconWidget = weatherGlyph(
      context,
      l10n,
      icon,
      size: context.sizes.icon,
    );

    final Widget content;
    if (wide) {
      content = _TableRow(
        day: Row(
          children: [
            Expanded(child: dayLabel),
            iconWidget,
          ],
        ),
        temperature: temperature,
        precipitation: precipitation,
        wind: wind,
        hive: badge,
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: dayLabel),
              iconWidget,
              SizedBox(width: spacing.md),
              temperature,
            ],
          ),
          SizedBox(height: spacing.sm),
          // Solda yağış ve rüzgar, sağda (sıcaklığın altında) kovan rozeti.
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: spacing.md,
                  runSpacing: spacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Ad ve değer aynı satırda, aynı taban çizgisinde.
                    Text.rich(
                      TextSpan(
                        text: '${l10n.weatherPrecipitationLabel} ',
                        children: [
                          TextSpan(
                            text: precipitation.data,
                            style: precipitation.style,
                          ),
                        ],
                      ),
                      style: secondary,
                    ),
                    Text.rich(
                      TextSpan(
                        text: '${l10n.weatherWindLabel} ',
                        children: [
                          TextSpan(
                            text: '${wind.data} ${units.speedUnit}',
                            style: wind.style,
                          ),
                        ],
                      ),
                      style: secondary,
                    ),
                  ],
                ),
              ),
              if (opening != null) ...[
                SizedBox(width: spacing.sm),
                StatusBadge(
                  status: hiveOpeningStatus(opening),
                  icon: hiveOpeningIcon(opening),
                  dense: true,
                  label: hiveOpeningLabel(
                    l10n,
                    opening,
                    suitable: l10n.hiveOpeningDaySuitable,
                  ),
                ),
              ],
            ],
          ),
        ],
      );
    }

    return MergeSemantics(
      child: ColoredBox(
        color: isToday ? colors.surfaceContainer : Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.sm,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// `weatherPlanMove`'un gün anahtarları; `DateTime.weekday` 1 (pazartesi)
/// ile başlar.
const _weekdays = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

/// "Salı–Çarşamba yağmur. Muayeneleri Pazartesi'ye al." ve "Planla":
/// görev formu önerilen günle açılır; görev kullanıcı kaydedince yazılır.
class _PlanBand extends StatelessWidget {
  const new({required this.plan, required this.apiary});

  final InspectionPlan plan;
  final Apiary apiary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final days = plan.from == plan.to
        ? format.weekday(plan.from)
        : l10n.weatherDayRange(
            format.weekday(plan.from),
            format.weekday(plan.to),
          );
    final problem = plan.concern == HiveOpening.wind
        ? l10n.weatherPlanWind(days)
        : l10n.weatherPlanRain(days);
    final move = l10n.weatherPlanMove(_weekdays[plan.day.weekday - 1]);
    final foreground = AppStatus.info.colorIn(colors);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppStatus.info.containerIn(colors),
        borderRadius: BorderRadius.circular(context.radii.card),
        border: colors.surfaceContainer == colors.surface
            ? Border.all(color: foreground, width: context.strokes.border)
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: context.sizes.icon,
              color: foreground,
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: problem,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ' $move'),
                  ],
                ),
                style: context.typography.body,
              ),
            ),
            SizedBox(width: spacing.sm),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: foreground,
                minimumSize: Size(
                  context.touchTargets.field,
                  context.touchTargets.field,
                ),
                textStyle: context.typography.button,
              ),
              onPressed: () => context.push(
                AppRoutes.taskNewSuggested(
                  day: plan.day,
                  apiaryId: apiary.id,
                  title: l10n.weatherPlanTaskTitle(apiary.name),
                ),
              ),
              child: Text(l10n.weatherPlanAction),
            ),
          ],
        ),
      ),
    );
  }
}
