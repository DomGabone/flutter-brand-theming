import 'package:brand_theming/brand_theming.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  final _controller = BrandThemeController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrandThemeScope(
      controller: _controller,
      builder: (context, theme) => MaterialApp(
        title: 'Brand Theming',
        theme: theme,
        home: HomePage(controller: _controller),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final BrandThemeController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.brandTokens;
    return Scaffold(
      appBar: AppBar(title: Text('Conta ${tokens.brand.label}')),
      body: Stack(
        children: [
          Positioned.fill(
            child: CircuitTracesBackground(color: tokens.accent, seed: 5),
          ),
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SegmentedButton<BrandId>(
                segments: [
                  for (final brand in BrandId.values)
                    ButtonSegment(value: brand, label: Text(brand.label)),
                ],
                selected: {tokens.brand},
                onSelectionChanged: (selection) =>
                    controller.select(selection.first),
              ),
              const SizedBox(height: 24),
              Text(
                'Saldo disponivel',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'R\$ 12.480,00',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: () {}, child: const Text('Transferir')),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: tokens.accent,
                  foregroundColor: tokens.onAccent,
                ),
                child: const Text('Abrir conta premium'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  SoftPageRoute.of<void>(
                    context,
                    builder: (_) => const DetailPage(),
                  ),
                ),
                child: const Text('Ver extrato'),
              ),
              const SizedBox(height: 24),
              const SkeletonShimmer(child: SkeletonCard()),
              const SizedBox(height: 12),
              const SkeletonShimmer(child: SkeletonCard(showAvatar: false)),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extrato')),
      body: const Center(
        child: Text('Transicao suave, ou nenhuma se o sistema pedir.'),
      ),
    );
  }
}
