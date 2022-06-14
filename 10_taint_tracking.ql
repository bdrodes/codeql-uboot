
/**
 * @kind path-problem
 */

import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph



class NetworkByteSwap extends Expr{
    NetworkByteSwap (){
    exists(MacroInvocation m |
        m.getExpr() = this and
        m.getMacroName() in ["ntohs", "ntohl", "ntohll"]
      ) 
    }
}

class Config extends TaintTracking::Configuration {
    Config() { this = "NetworkToMemFuncLength" }
  
    override predicate isSource(DataFlow::Node source) {
      source.asExpr() instanceof NetworkByteSwap
    }
    override predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call |
        call.getTarget().getName() = "memcpy" and
        call.getArgument(2) = sink.asExpr())
    }
  }

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"

// from FunctionCall call
// where call.getTarget().getName() = "memcpy"
// select call, "memcpy calls"

// from NetworkByteSwap n
// select n, "Network byte swap"
