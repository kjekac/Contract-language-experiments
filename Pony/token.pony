use "collections"
use "promises"


trait tag User
  be grant(access: Contract tag)
  be address(p: Promise[U64])


trait Contract



actor Account is Contract
  var _balance: U64 = 0
  let _bank: Bank

  new create(balance: U64, bank: Bank) =>
    _balance = balance
    _bank = bank

  be transfer(n: U64, to: String) => // to
    if n >= _balance then
      _balance = _balance - n
      _bank.send(n, to)
    end



actor Bank is Contract
  let _accounts: Map[String, Account] = _accounts.create()

  new create(owner: User, n: U64) =>
    let ownerAccount = Account(n, this)
    let addressPromise = Promise[String]

    addressPromise.next({(address: String) => _accounts.insert(address, ownerAccount)})
    owner.address(addressPromise)

    owner.grant(ownerAccount)

  be send(n: U64, to: String) =>
    None
/*
trait Account
  be grant(access: Contract tag)



trait Contract



actor TokenReceiver
  let _sender: TokenSender ref

  new create(sender: TokenSender iso) =>
    _sender = consume sender

  be receive(amount: U64) =>
    _sender._credit(amount)


class ref TokenSender is Contract
  var _balance: U64
  let receiver: TokenReceiver = TokenReceiver(this)

  new create(balance: U64) =>
    _balance = balance

  fun ref transfer(amount: U64, to: TokenReceiver) =>
    if amount <= _balance then
      _balance = _balance - amount
      to.receive(amount)
    end

  fun ref _credit(amount: U64) =>
    _balance = _balance + amount


actor TokenBank
  //let _tokenOwners: collections.List[TokenOwner] = _tokenOwners.create()

  new create(owner: Account tag, n: U64) =>
    let ts = TokenSender(n)
    
    owner.grant(ts)



actor RegularAccount is Account
  var _myTokens: collections.List[TokenSender tag] = _myTokens.create()
  let name: String

  new create(name': String) =>
    name = name' 

  be grant(access: Contract tag) =>
    _grant(access)

  be myTokenBalance(f: {(U64)} val) =>
    None

  fun ref _grant(access: Contract tag) =>
    match access
    | let ts: TokenSender tag => _myTokens.push(ts)
    end


actor Main
  new create(env: Env) =>
    let astrid = RegularAccount("Astrid")
    let bosse = RegularAccount("Bosse")
    let tokenBank = TokenBank(astrid, 10)

*/
/*

class ref TokenOwner is Account
  var _balance: U64

  new create(owner: Account ref, balance': U64 = 0) =>
    _balance = balance'
    owner.grant(this)

  fun ref grant(access: Account tag) =>
    None

/* This could potentially be nice, but let's keep it simple for now.
  fun ref grant(access: Account tag) =>
    match access
    | let to: TokenOwner => to.add(this)
    end
*/
  
  fun box balance(): U64 val =>
    _balance

  fun ref _receive(n: U64) =>
    _balance = _balance + n

  fun ref transfer(to: TokenOwner tag, n: U64) =>
    if _balance >= n then
      _balance = _balance - n
      to._receive(n)
    end


actor TokenBank is Account
  let _tokenOwners: collections.List[TokenOwner] = _tokenOwners.create()

  new create(owner: Account tag, n: U64) =>
    let tokenOwner: TokenOwner ref = TokenOwner(n)

//    _tokenOwners.push(tokenOwner)
    owner.grant(tokenOwner)

  fun ref grant(access: Account tag) =>
    None




actor RegularAccount is Account
  var _myTokens: collections.List[TokenOwner] = _myTokens.create()
  let name: String

  new create(name': String) =>
    name = name' 

  fun ref grant(access: Account tag) =>
    match access
    | let to: TokenOwner => _myTokens.push(to)
    end

  be myTokenBalance(f: {(U64)} val) =>
    None




actor Main
  new create(env: Env) =>
    let astrid = RegularAccount("Astrid")
    let bosse = RegularAccount("Bosse")
    let tokenBank = TokenBank(astrid, 10)

/*
actor Token is Account
  let _balances: collections.Map[Address, U64] = _balances.create()

  new create(owner: Address, amount: U64) =>
    _balances(owner) = amount
    owner.grant(transfer_now(owner))

  fun balance(account: Address): U64 =>
    try _balances(account)? else 0 end

  be transfer(n: U64, from: Address, to: Address) =>
    transfer_now(n, from, to)

  fun ref transfer_now(from: Address, to: Address, n: U64) =>
    if balance(from) >= n then
      _balances(from) = balance(from) - n
      _balances(to) = balance(to) + n
    end
*/
*/