import cpp

class NetworkByteSwap extends Expr{
    NetworkByteSwap (){
    exists(MacroInvocation m |
        m.getExpr() = this and
        m.getMacroName() in ["ntohs", "ntohl", "ntohll"]
      ) 
    }
}

from NetworkByteSwap n
select n, "Network byte swap"