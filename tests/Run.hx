package;

class Run { 

  static function main() {
    //trace('hello world');
    Sys.command('node', ['bin/vhosts.js']);
    Sys.getChar(true);
  }
  
}