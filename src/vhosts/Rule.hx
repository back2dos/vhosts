package vhosts;

using tink.CoreApi;

typedef RuleFunc = { host: String }->Surprise<{ port: Int, host:String }, Error>;

abstract Rule(RuleFunc) from RuleFunc {
  
  public inline function apply(ctx)
    return (this)(ctx);
    
  @:from static function ofMap(map:Map<String, Int>):Rule
    return (function (ctx) return Future.sync(switch map[ctx.host] {
      case null: Failure(new Error(404, 'No entry for host ${ctx.host})'));
      case v: Success({ port: v, host: 'localhost' });
    }):RuleFunc);
}