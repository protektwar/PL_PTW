
require_relative "../libs/SyntaxAnalyzer.rb"

include RubyScript

$rubyScript_running = true
sourceFile = "bin/test.rcpl"

$syntax = RubyScriptL::SyntaxAnalyzer.new(sourceFile)
$syntax.setDebugLevel(0)
$syntax.checker()

