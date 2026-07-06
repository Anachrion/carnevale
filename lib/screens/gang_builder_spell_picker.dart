part of 'gang_builder_screen.dart';

/// The result of the spell picker: the committed Discipline and the chosen non-Cantrip spell ids.
class _SpellSelection {
  final String? discipline;
  final List<int> spellIds;
  const _SpellSelection(this.discipline, this.spellIds);
}

class _SpellPickerDialog extends StatefulWidget {
  const _SpellPickerDialog({required this.entry, required this.allSpells});

  final api.ListEntry entry;
  final List<api.Spell> allSpells;

  @override
  State<_SpellPickerDialog> createState() => _SpellPickerDialogState();
}

class _SpellPickerDialogState extends State<_SpellPickerDialog> {
  String? _discipline;
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    final disciplines = widget.entry.disciplines;
    // Default to the model's committed Discipline, or the only one it has access to.
    _discipline =
        widget.entry.spellDiscipline ??
        (disciplines.length == 1 ? disciplines.first : null);
    _selected = widget.entry.spells
        .where((s) => !s.cantrip)
        .map((s) => s.id)
        .toSet();
  }

  List<api.Spell> get _choosable =>
      widget.allSpells
          .where(
            (s) => disciplineSlug(s.discipline) == _discipline && !s.cantrip,
          )
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  api.Spell? get _cantrip {
    try {
      return widget.allSpells.firstWhere(
        (s) => disciplineSlug(s.discipline) == _discipline && s.cantrip,
      );
    } catch (_) {
      return null;
    }
  }

  int get _slots => widget.entry.spellSlots;

  void _selectDiscipline(String slug) {
    if (slug == _discipline) return;
    // Spells must all share one Discipline (rulebook p24), so switching clears the picks.
    setState(() {
      _discipline = slug;
      _selected = {};
    });
  }

  void _toggle(api.Spell spell) {
    setState(() {
      if (_selected.contains(spell.id)) {
        _selected.remove(spell.id);
      } else if (_selected.length < _slots) {
        _selected.add(spell.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final disciplines = widget.entry.disciplines;
    final accent = Theme.of(context).brightness == Brightness.dark
        ? AppPalette.gold
        : AppPalette.red;
    return ThemedDialogCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.entry.name,
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Spells known — ${_selected.length}/$_slots',
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 14),
          if (disciplines.length > 1) ...[
            Text(
              'Discipline',
              style: TextStyle(
                fontSize: 11,
                color: context.subtleTextColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: disciplines.map((slug) {
                final selected = slug == _discipline;
                return GestureDetector(
                  onTap: () => _selectDiscipline(slug),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? accent.withOpacity(0.85)
                          : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? accent
                            : context.subtleTextColor.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      disciplineLabel(slug),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected ? Colors.white : context.textColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
          ] else if (disciplines.length == 1) ...[
            Text(
              'Discipline: ${disciplineLabel(disciplines.first)}',
              style: TextStyle(
                fontSize: 12,
                color: context.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (_discipline == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Pick a Discipline to choose spells.',
                  style: TextStyle(
                    color: context.subtleTextColor,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_cantrip != null)
                      _SpellRow(
                        spell: _cantrip!,
                        checked: true,
                        enabled: false,
                        trailingLabel: 'always known',
                        onTap: null,
                      ),
                    ..._choosable.map((spell) {
                      final checked = _selected.contains(spell.id);
                      final enabled = checked || _selected.length < _slots;
                      return _SpellRow(
                        spell: spell,
                        checked: checked,
                        enabled: enabled,
                        onTap: enabled ? () => _toggle(spell) : null,
                      );
                    }),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: context.subtleTextColor),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(
                  context,
                ).pop(_SpellSelection(_discipline, _selected.toList())),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpellRow extends StatelessWidget {
  const _SpellRow({
    required this.spell,
    required this.checked,
    required this.enabled,
    this.trailingLabel,
    this.onTap,
  });

  final api.Spell spell;
  final bool checked;
  final bool enabled;
  final String? trailingLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).brightness == Brightness.dark
        ? AppPalette.gold
        : AppPalette.red;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              checked ? Icons.check_circle : Icons.circle_outlined,
              size: 20,
              color: checked
                  ? accent
                  : context.subtleTextColor.withOpacity(enabled ? 0.6 : 0.25),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spell.name,
                          style: GoogleFonts.cinzel(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: enabled
                                ? context.textColor
                                : context.subtleTextColor,
                          ),
                        ),
                      ),
                      if (trailingLabel != null)
                        Text(
                          trailingLabel!,
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: context.subtleTextColor,
                          ),
                        )
                      else
                        Text(
                          'WP ${spell.cost} · Diff ${spell.difficulty}',
                          style: TextStyle(
                            fontSize: 10,
                            color: context.subtleTextColor,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    spell.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.subtleTextColor,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
