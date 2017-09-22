use "promises"

class Token
  var _n: U64 = 0

  fun ref _set(n: U64) =>
    _n = n

  fun ref split(n: U64): (Token iso^ | None) =>
    if n <= _n then
      _n = _n - n
      Token.>_set(n)
    end

  fun balance(): U64 val =>
    _n


actor User
  var _myToken: Token iso = Token

  be myBalance(p: Promise[U64]) =>
    p(_myToken.balance())

  be give(token: Token iso) =>
    _myToken = consume token

  be transfer(n: U64, to: User) =>
    match _myToken.split(n)
    | let yourToken: Token iso => to.give(consume yourToken)
    end

class TokenFactory
  fun newToken(owner: User, supply: U64) =>
    owner.give(recover Token.>_set(supply) end)

actor Main
  new create(env: Env) =>
    let tokenFactory = TokenFactory

    let bosse = User
    let astrid = User

    tokenFactory.newToken(astrid, 10)

    astrid.transfer(1, bosse)

    let promise1a = Promise[U64]
      .>next[None]( {(b: U64) => env.out.print("astrid" + b.string())} )
    let promise2a = Promise[U64]
      .>next[None]( {(b: U64) => env.out.print("astrid" + b.string())} )
    let promise1b = Promise[U64]
      .>next[None]( {(b: U64) => env.out.print("bosse" + b.string())} )
    let promise2b = Promise[U64]
      .>next[None]( {(b: U64) => env.out.print("bosse" + b.string())} )

    astrid.myBalance(promise1a)
    bosse.myBalance(promise1b)

    astrid.transfer(4, bosse)

    astrid.myBalance(promise2a)
    bosse.myBalance(promise2b)    

