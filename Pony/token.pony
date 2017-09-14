use collections = "collections"

trait box Account
  fun box give(access: Account tag) // Having this as tag will be problematic down the road, whenever we actually want to store the access token...



actor TokenOwner is Account
  var _balance: U64

  new create(balance': U64 = 0) =>
    _balance = balance'

  fun box give(access: Account tag) =>
    None

/* This could potentially be nice, but let's keep it simple for now.
  fun give(access: Account tag) =>
    match access
    | let to: TokenOwner => to.add(this)
    end
*/
  
  fun balance(): U64 val =>
    _balance




actor TokenBank is Account
  let _tokenOwners: collections.List[TokenOwner] = _tokenOwners.create()

  new create(owner: Account tag, n: U64) =>
    let tokenOwner = TokenOwner(n)

    _tokenOwners.push(tokenOwner)
    owner.give(tokenOwner)

  fun box give(access: Account tag) =>
    None




actor RegularAccount is Account
  var _myTokens: collections.List[TokenOwner] = _myTokens.create()
  let name: String

  new create(name': String) =>
    name = name' 

  fun box give(access: Account tag) =>
    match access
    | let to: TokenOwner => _myTokens.push(to)
    end




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
    owner.give(transfer_now(owner))

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