enum BrandId {
  aurora('Aurora'),
  basalto('Basalto'),
  coral('Coral');

  const BrandId(this.label);

  final String label;

  static BrandId fromCode(String? code, {BrandId fallback = BrandId.aurora}) {
    if (code == null) return fallback;
    for (final brand in values) {
      if (brand.name == code.trim().toLowerCase()) return brand;
    }
    return fallback;
  }
}
