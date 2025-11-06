List<T> getUniqueListByProperty<T, K>(List<T> list, K Function(T) getProperty) {
  final seen = <K>{};
  return list.where((x) => seen.add(getProperty(x))).toList();
}
