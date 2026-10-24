import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart'
    show QueenMarkColor;

/// Galerideki bileşenler. Golden testler de bu örnekleri çizer; galeride
/// görünen ile test edilen aynı kalır.
enum GalleryComponent {
  bigButton(_BigButtonSamples()),
  choiceChipGroup(_ChoiceChipGroupSamples()),
  bigStepper(_BigStepperSamples()),
  statusBadge(_StatusBadgeSamples()),
  hiveTile(_HiveTileSamples()),
  strengthDots(_StrengthDotsSamples()),
  emptyState(_EmptyStateSamples()),
  sectionCard(_SectionCardSamples()),
  timelineTile(_TimelineTileSamples());

  new(this.samples);

  final Widget samples;

  String title(AppLocalizations l10n) => switch (this) {
    GalleryComponent.bigButton => l10n.galleryBigButton,
    GalleryComponent.choiceChipGroup => l10n.galleryChoiceChipGroup,
    GalleryComponent.bigStepper => l10n.galleryBigStepper,
    GalleryComponent.statusBadge => l10n.galleryStatusBadge,
    GalleryComponent.hiveTile => l10n.galleryHiveTile,
    GalleryComponent.strengthDots => l10n.galleryStrengthDots,
    GalleryComponent.emptyState => l10n.galleryEmptyState,
    GalleryComponent.sectionCard => l10n.gallerySectionCard,
    GalleryComponent.timelineTile => l10n.galleryTimelineTile,
  };
}

void _noop() {}

class _BigButtonSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.touchTargets.gap,
      children: [
        BigButton(
          label: l10n.gallerySampleStartInspection,
          icon: Icons.play_arrow_rounded,
          onPressed: _noop,
        ),
        BigButton(
          label: l10n.gallerySampleAddPhoto,
          icon: Icons.photo_camera_rounded,
          variant: BigButtonVariant.secondary,
          onPressed: _noop,
        ),
        BigButton(label: l10n.gallerySampleSave, onPressed: null),
        BigButton(
          label: l10n.gallerySampleSave,
          variant: BigButtonVariant.secondary,
          onPressed: null,
        ),
      ],
    );
  }
}

enum _QueenSighting { seen, eggs, none }

enum _HiveAction { superAdded, frameAdded, fed }

class _ChoiceChipGroupSamples extends StatefulWidget {
  const new();

  @override
  State<_ChoiceChipGroupSamples> createState() =>
      _ChoiceChipGroupSamplesState();
}

class _ChoiceChipGroupSamplesState extends State<_ChoiceChipGroupSamples> {
  Set<_QueenSighting> _queen = {_QueenSighting.seen};
  Set<_HiveAction> _actions = {_HiveAction.superAdded, _HiveAction.fed};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.gallerySampleQueen, style: context.typography.body),
        SizedBox(height: spacing.sm),
        ChoiceChipGroup(
          options: [
            ChoiceChipOption(
              value: _QueenSighting.seen,
              label: l10n.gallerySampleQueenSeen,
            ),
            ChoiceChipOption(
              value: _QueenSighting.eggs,
              label: l10n.gallerySampleEggs,
            ),
            ChoiceChipOption(
              value: _QueenSighting.none,
              label: l10n.gallerySampleNone,
            ),
          ],
          selected: _queen,
          onChanged: (value) => setState(() => _queen = value),
        ),
        SizedBox(height: spacing.lg),
        Text(l10n.gallerySampleActions, style: context.typography.body),
        SizedBox(height: spacing.sm),
        ChoiceChipGroup(
          multiSelect: true,
          options: [
            ChoiceChipOption(
              value: _HiveAction.superAdded,
              label: l10n.gallerySampleSuperAdded,
            ),
            ChoiceChipOption(
              value: _HiveAction.frameAdded,
              label: l10n.gallerySampleFrameAdded,
            ),
            ChoiceChipOption(
              value: _HiveAction.fed,
              label: l10n.gallerySampleFed,
            ),
          ],
          selected: _actions,
          onChanged: (value) => setState(() => _actions = value),
        ),
      ],
    );
  }
}

class _BigStepperSamples extends StatefulWidget {
  const new();

  @override
  State<_BigStepperSamples> createState() => _BigStepperSamplesState();
}

class _BigStepperSamplesState extends State<_BigStepperSamples> {
  var _beeFrames = 7;
  var _broodFrames = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      spacing: context.touchTargets.gap,
      children: [
        BigStepper(
          label: l10n.gallerySampleBeeFrames,
          value: _beeFrames,
          max: 10,
          onChanged: (value) => setState(() => _beeFrames = value),
        ),
        BigStepper(
          label: l10n.gallerySampleBroodFrames,
          value: _broodFrames,
          max: 10,
          onChanged: (value) => setState(() => _broodFrames = value),
        ),
      ],
    );
  }
}

class _StatusBadgeSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: context.spacing.sm,
      runSpacing: context.spacing.sm,
      children: [
        StatusBadge(status: AppStatus.good, label: l10n.gallerySampleStrong),
        StatusBadge(status: AppStatus.warning, label: l10n.gallerySampleWeak),
        StatusBadge(
          status: AppStatus.critical,
          label: l10n.gallerySampleQueenless,
        ),
        StatusBadge(status: AppStatus.info, label: l10n.gallerySampleTask),
      ],
    );
  }
}

class _HiveTileSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gap = context.touchTargets.gap;
    final tiles = [
      const HiveTile(
        number: '101',
        strength: 5,
        queenColor: QueenMarkColor.yellow,
        onTap: _noop,
      ),
      HiveTile(
        number: '102',
        strength: 2,
        queenColor: QueenMarkColor.white,
        alertStatus: AppStatus.warning,
        alertLabel: l10n.gallerySampleWeak,
        onTap: _noop,
      ),
      HiveTile(
        number: '103',
        alertStatus: AppStatus.critical,
        alertLabel: l10n.gallerySampleQueenless,
        onTap: _noop,
      ),
      const HiveTile(
        number: '1024',
        strength: 3,
        queenColor: QueenMarkColor.blue,
        onTap: _noop,
      ),
    ];
    return Column(
      spacing: gap,
      children: [
        for (var i = 0; i < tiles.length; i += 2)
          Row(
            spacing: gap,
            children: [
              Expanded(child: tiles[i]),
              Expanded(child: tiles[i + 1]),
            ],
          ),
      ],
    );
  }
}

/// Puansızdan 5'e her değer, kovan kartındaki gibi kelimesiyle.
class _StrengthDotsSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing.sm,
      children: [
        for (final strength in <int?>[null, 1, 2, 3, 4, 5])
          Row(
            children: [
              StrengthDots(strength: strength),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text(
                  strength == null
                      ? l10n.hiveStrengthNone
                      : l10n.hiveTileStrength(strength),
                  style: context.typography.body,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _EmptyStateSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.hive_rounded,
      title: l10n.gallerySampleNoApiaries,
      message: l10n.gallerySampleNoApiariesMessage,
      actionLabel: l10n.gallerySampleAddApiary,
      onAction: _noop,
    );
  }
}

class _SectionCardSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing.md,
      children: [
        SectionCard(
          title: l10n.gallerySampleLastInspection,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing.sm,
            children: [
              Text(l10n.gallerySampleLastInspectionBody),
              StatusBadge(
                status: AppStatus.good,
                label: l10n.gallerySampleStrong,
              ),
            ],
          ),
        ),
        SectionCard(child: Text(l10n.gallerySampleUntitledCard)),
      ],
    );
  }
}

/// Kovan kartındaki gibi üç olay: muayene, taşıma ve ilk arılık (son
/// satır, altında çizgi yok). Zamanlar sabit; golden saate bağlı kalmasın.
class _TimelineTileSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final hill = l10n.gallerySampleApiaryHill;
    final plain = l10n.gallerySampleApiaryPlain;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TimelineTile(
          icon: Icons.fact_check_rounded,
          title: l10n.timelineInspection,
          time: format.dateTime(DateTime(2026, 10, 21, 14, 5)),
          details: [
            l10n.timelineField(l10n.inspectionQueen, l10n.queenStateSeen),
            l10n.timelineField(
              l10n.inspectionFrames,
              [
                l10n.timelineBeeFrames(7),
                l10n.timelineBroodFrames(4),
              ].join(l10n.listSeparator),
            ),
          ],
        ),
        TimelineTile(
          icon: Icons.local_shipping_rounded,
          title: l10n.timelineMoved,
          time: format.dateTime(DateTime(2026, 10, 12, 9, 30)),
          details: [l10n.timelineMoveRoute(hill, plain)],
        ),
        TimelineTile(
          icon: Icons.add_location_alt_rounded,
          title: l10n.timelineAdded,
          time: format.dateTime(DateTime(2026, 9, 3, 8, 15)),
          details: [hill],
          isLast: true,
        ),
      ],
    );
  }
}
