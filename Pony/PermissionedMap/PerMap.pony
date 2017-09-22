use "collections"
use "promises"

class trn Cell[A: Any val]
  var _value: A

  new create(value: A) =>
    _value = value

  fun box get(): A =>
    _value

  fun trn set(value: A) =>
    _value = value



actor PerMap[K: (Hashable val & Equatable[K] val), V: Any val]
  let _mapping: Map[K, Cell[V]] = _mapping.create()

  be register(key: K, value: Cell[V]) =>
    let newCell = Cell[V](value)
    
    _mapping.insert(key, newCell)
    owner.grant(newCell)


actor User
  let _myCell: Cell[Int]

  new create(permap: PerMap[Int, Int], key: Int, value: Int) =>
    _myCell = Cell[Int](value)
    permap.register(key, _myCell)
