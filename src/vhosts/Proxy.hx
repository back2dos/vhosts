package vhosts;

using tink.CoreApi;

import tink.http.Application;
import tink.http.Client;
import tink.http.Request;
import tink.http.Response;

class Proxy { 
  
  public var done(default, null):Future<Noise>;
  var rule:Rule;
  var client:Client;
  var handleError:Error->Void;
  
  public function new(rule, handleError, ?done) {
    this.rule = rule;
    this.handleError = handleError;
    this.done = switch done {
      case null: Future.trigger();
      case v: v;
    }
    this.client = 
      #if nodejs
        new NodeClient();
      #elseif tink_tcp
        new TcpClient();
      #else
        new StdClient();
      #end
  }
  
  public function serve(request:IncomingRequest):Future<OutgoingResponse> 
    return switch request.header.get('host') {
      case []:
        Future.sync((new Error(Forbidden, 'Forbidden') : OutgoingResponse));
      case [host]:
        Future.async(function (cb) 
          rule.apply( { host: host } ).handle(function (o) switch o {
            case Success(to): 
              client.request(
                new OutgoingRequest(
                  new OutgoingRequestHeader(
                    request.header.method,
                    to.host,
                    to.port,
                    request.header.uri,
                    null,
                    request.header.fields
                  ),
                  request.body.idealize(onError)
                )
              ).handle(function (res:IncomingResponse) {
                cb(new OutgoingResponse(res.header, res.body.idealize(onError)));
              });
            case Failure(e): cb(e);
          })
        );        
      case v:
        Future.sync((new Error(Forbidden, 'Forbidden') : OutgoingResponse));
    }
  
  public function onError(e:Error):Void {
    handleError(e);
  }
  
}