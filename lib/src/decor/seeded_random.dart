class SeededRandom {
  SeededRandom(int seed) : _state = seed <= 0 ? 1 : seed & _mask;

  static const int _mask = 0x7fffffff;
  int _state;

  int _next() {
    _state = (_state * 1103515245 + 12345) & _mask;
    return _state;
  }

  double nextDouble() => _next() / _mask;

  int nextInt(int max) {
    assert(max > 0, 'max deve ser positivo');
    return _next() % max;
  }

  bool nextBool() => _next().isEven;
}
