import 'package:test/test.dart';

void main() {
  test('String split', () {
    var string = 'foo,bar,baz';
    expect(string.split(','), equals(['foo', 'bar', 'baz']));
  });
}