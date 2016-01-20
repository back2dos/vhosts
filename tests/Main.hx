package;

class Main {
	
	static function main() {
    new tink.http.Container.NodeContainer(80).run(new vhosts.Proxy(
      [
        'example.com' => 2000,
        'bar.fr' => 3000,
      ]
    , function (e) {
      trace('error: $e');
    }));
	}
	
}