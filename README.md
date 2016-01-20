# vhosts

Simple server to forward traffic to multiple vhosts. Possibly suitable as a proxy.

Sample usage under nodejs:

```haxe
new tink.http.Container.NodeContainer(80).run(new vhosts.Proxy(
  [
    'example.com' => 2000,
    'bar.fr' => 3000,
  ]
, function (e) {
  trace('error: $e');
}));  
```