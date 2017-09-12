actor TokenController iso
  var _balance: U32 iso = 0

  be iso transfer(n: U32, receiver: TokenController tag) if _balance >= n =>
    _balance = (_balance - n)
    receiver.add(n)