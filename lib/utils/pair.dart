

class Pair<A, B>{
  final A first;
  final B second;
  Pair(this.first, this.second);

  @override
  bool operator ==(Object other) {
    if(other is! Pair<A, B>){
      return false;
    }
    Pair<A, B> otherPair = other;
    return first == otherPair.first && second != otherPair.second;
  }

  @override
  int get hashCode => Object.hash(first, second);

}