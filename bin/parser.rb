
require_relative "../libs/SyntaxAnalyzer.rb"

include RubyScript2CAPL

$rubyScript2CAPL_running = true
sourceFile = "bin/test.rcpl"

#$lexycalAnalyzer = RubyScript2CAPL::LexicalAnalyzer.new()
#$lexycalAnalyzer.lexycalChecker(file2Convert)

$syntax = RubyScript2CAPL::SyntaxAnalyzer.new(sourceFile)
$syntax.setDebugLevel(0)
$syntax.checker()
#convertor.writeCAPLFile

