import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../localization/locale_provider.dart';

class LanguageSwitcher extends ConsumerWidget {
  final bool onDarkBackground;

  const LanguageSwitcher({super.key, this.onDarkBackground = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);
    final isAmharic = locale.languageCode == 'am';
    final fg = onDarkBackground ? Colors.white : const Color(0xFF6B4CE6);
    final bg = onDarkBackground
        ? Colors.white.withValues(alpha: 0.2)
        : const Color(0xFF6B4CE6).withValues(alpha: 0.08);
    final border = onDarkBackground
        ? Colors.white.withValues(alpha: 0.4)
        : const Color(0xFF6B4CE6).withValues(alpha: 0.3);

    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: fg, size: 18),
            const SizedBox(width: 4),
            Text(
              isAmharic ? 'አማ' : 'EN',
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      onSelected: (code) {
        ref.read(localeProvider.notifier).setLocale(Locale(code));
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'am',
          child: Row(
            children: [
              if (isAmharic) const Icon(Icons.check, size: 18, color: Color(0xFF6B4CE6)),
              if (isAmharic) const SizedBox(width: 8),
              Text(l10n.amharic),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              if (!isAmharic) const Icon(Icons.check, size: 18, color: Color(0xFF6B4CE6)),
              if (!isAmharic) const SizedBox(width: 8),
              Text(l10n.english),
            ],
          ),
        ),
      ],
    );
  }
}
