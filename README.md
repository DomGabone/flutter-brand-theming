# brand_theming

Sistema de temas multi-marca para Flutter. Um único `ThemeData` base, várias marcas, e a regra de que **só a cor de destaque muda entre marcas**. Texto, superfícies, bordas e o botão neutro são idênticos em todas, para que a cor da marca fique reservada a chamadas de ação e indicadores, sem saturar a tela.

O pacote foi generalizado a partir de trabalho privado e aparece aqui sobre um cenário fictício de banco digital com três marcas: Aurora, Basalto e Coral.

## O que tem dentro

| Peça | Para que serve |
|---|---|
| `BrandTokens` | `ThemeExtension` tipada com cores, raios e opacidades. Tem `copyWith`, `lerp` e um `fallback` para widgets fora do tema. |
| `BrandThemeFactory` | Constrói o `ThemeData` Material 3 completo a partir da marca. Botões, inputs, chips, navegação, diálogos e snackbars já saem coerentes. |
| `BrandThemeController` | `ChangeNotifier` que reconstrói o tema **apenas quando a marca muda**, e conta as reconstruções para você provar isso em teste. |
| `MotionPolicy` e `SoftPageRoute` | Transição suave de página que vira nenhuma transição quando o sistema pede redução de movimento. |
| `SkeletonShimmer`, `SkeletonBox`, `SkeletonLines`, `SkeletonCard` | Estados de carregamento sem dependência externa. O brilho para quando o usuário pede menos movimento. |
| `CircuitTracesPainter` | Textura decorativa determinística. Mesma semente, mesmo traçado, sem recalcular a cada rebuild. |
| `SeededRandom` | Gerador congruencial linear minúsculo que sustenta a textura. |

## Uso

```dart
final controller = BrandThemeController(initial: BrandId.basalto);

BrandThemeScope(
  controller: controller,
  builder: (context, theme) => MaterialApp(theme: theme, home: const HomePage()),
);

// em qualquer widget
final tokens = context.brandTokens;
FilledButton(
  style: FilledButton.styleFrom(
    backgroundColor: tokens.accent,
    foregroundColor: tokens.onAccent,
  ),
  onPressed: ...,
  child: const Text('Chamada principal'),
);
```

Para navegar respeitando acessibilidade:

```dart
Navigator.of(context).push(
  SoftPageRoute.of<void>(context, builder: (_) => const DetailPage()),
);
```

## Decisões de projeto

- **Uma cor por marca.** Cada accent passa em WCAG AA como texto branco sobre a cor. Há um teste que falha se alguém adicionar uma marca com contraste insuficiente.
- **Botão neutro é o padrão global.** O accent só aparece quando a tela pede explicitamente. Isso impede que a cor de destaque se banalize.
- **Reconstrução mínima.** O controlador ignora seleções repetidas. Em apps reais, eventos de sessão disparam com frequência e não podem reconstruir a árvore inteira.
- **Movimento é opcional.** Toda animação do pacote consulta `MotionPolicy.shouldReduce` e desliga quando o sistema sinaliza.
- **Sem dependências além do Flutter.** Skeleton e textura são implementados no próprio pacote.

## Rodando

```bash
flutter pub get
flutter analyze
flutter test
cd example && flutter run
```

## Licença

MIT.
