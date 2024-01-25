require_relative 'version.rb'
require_relative 'syntaxPTW.rb'

module RubyScript

class LexicalAnalyzer
  attr_accessor :keywords, :error, :errorList, :specialChar
  attr_accessor :includeFiles, :functionNames, :variableNames

  def initialize(sourceFile)
    puts "Script lexical converter version #{VERSIONLEXICALCONVERTER} Initialized"
    @typeOfToken = "K_NA" #Keyword notAvailable  
    @typeOfOperand = "O_NA" #Operand notAvailable  
    @typeOfRelation = "R_NA" #Relationship notAvailable  

    @openCloseCompound = 0;
    @openCloseBraket = 0;
    @openCloseParant = 0;
    @openCloseBraces = 0;
    @compoundVariable = Array.new
    @line = ""
    @lineNumber = 0
    @charCount = 0
    @word = ""
    @wordLast = ""
    @wordIndex = 0
    @word2Special = false
    @special2Word = false
    @specialWord = ""
    @specialWordLast = ""
    @haveWord = false
    @haveWordOldState = @haveWord
    @gotoNextLine = false
    @currentToken = "T_NA"
    @isCompound = false
    @isParanthesis = false
    @isBraket = false
    @isBraces = false
    @operandWord = "" 
    @sourceFile = sourceFile
    @fileCursorPosition = 0
    @wordIndex = 0
    @fileContent = File.open(sourceFile)
    @debugLexical = false
    @debugLevel = 0         # 0 Disable | 1 Info | 2 Warning | 4 Detailed | 8 Full
    @keywords = SyntaxPTW.new()
    @includeFiles = Array.new
    @functionNames = Hash.new # {"functionName" => {0 => "param1", 1 => "param2"}
    @variableNames = Array.new
    @error = Hash.new #{ "Error Name" => {0 => "Linenumber",     1 => "whatkindoferror",       2 => "awaiting values are"               }
                      #    generated         codeGenerated      key@errorList=>0 or 1       generated based on relations
    @errorList = {0 => "not a relationship", 1 => "forbidenRelation" }
    @specialChar = [
                      "(", 
                      ")", 
                      "[", 
                      "]", 
                      "{", 
                      "}", 
                      ";", 
                      ":", 
                      ",", 
                      ".", 
                      "\"",
                      "'", 
                      "_", 
                      "-",
                      "+",
                      "=",
                      "?",
                      " ",
                      "#",
                      "|",
                      "<",
                      ">",
                      "\/",
                      "\\",
                      "~",
                      "!",
                      "@",
                      "$",
                      "%",
                      "^",
                      "&",
                      "*",
                      "\n",
                      "\t",
                      "\r",
                      "?"
                   ]
  end

  def setDebugLevel(level)
    @debugLevel = level
  end

  def activateLexicalDebugger
    @debugLexical = true
  end

  def getTranslatedFileName()
    return @file2Convert_name
  end

  def setFileHeadPosition(position)
    @fileHeadPosition = poistion
  end

  def getFileHeadPosition
    return @fileHeadPosition
  end

  def checker(file2Convert)
    puts "Script lexical converter Started" if @debugLevel >= 0x1 
    parseAndTranslateToSyntax()
    puts "Script lexical converter Done" if @debugLevel >= 0x1
  end

  def toggle(variable)
    if (variable)
      return false
    else
      return true
    end
  end

  def pringDebugMsg(file, line, debugLevel, messageStr)
    if @debugLevel >= debugLevel
      puts "#{file}:#{line} #{messageStr}" 
    end
  end

  def parseAndTranslateToSyntax()

    @fileContent.seek(@fileCursorPosition, IO::SEEK_SET)
    pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, "@fileCursorPostion: #{@fileCursorPosition}")

    @fileContent.each_char do |chr|
      @charCount = @charCount + 1
      pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, "@fileContent.each_char do |#{chr}|")
      pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, "@fileCursorPostion: #{@fileContent.pos}")
      pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, "@charCount: #{@charCount}")
      pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, "@word: #{@word}")
      pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " char.ord:->#{chr.ord}<- char: ->#{chr}<-")
      pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " operandWord:->#{@operandWord}<-")
      @line = @line + chr
      if (chr.ord == 10)
        @lineNumber = @lineNumber + 1
        pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " char new line @lineNumber: #{@lineNumber}")
        @line = ""
        @charCount = 0
      end

      @line.gsub!(/\r\n?/,"\n")
      pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " \nLINE:#{@line}")
      if !@specialChar.include?(chr)
        pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if !specialChar.include?(#{chr}) ")
        pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " operandWord:->#{@operandWord}<-")
        if !@operandWord.empty?
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if !operandWord.empty? #{@operandWord} ")
          @operandFound = @keywords.isOperand?(@operandWord)
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " #{@operandFound} #{@word}")
          if @operandFound != "O_NA" and (@word.empty?)
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if operandFound != \"O_NA\" and (word.empty?) #{@operandFound}) #{@word}")
            @fileCursorPosition = @fileContent.pos
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return #{@operandFound}")
            @operandWord = ""
            @word = @word + chr
            return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@operandFound}"}
            @wordIndex = @wordIndex + 1
          end
        end
        @word = @word + chr
      elsif @specialChar.include?(chr)
        pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " elsif specialChar.include?(#{chr}) ")
        case chr
        when " ", "\n", "\t", "\r" #new word?
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " when ' ', '\\n', '\\t', '\\r' ")
          if !@word.empty? and @openCloseCompound == 0
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " !@word.empty? and @openCloseCompound == 0 #{@word} #{@openCloseCompound} ")
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " chr.ord:#{chr.ord} chr:#{chr} ")
            if (chr.ord == 10)
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if ((chr == '\n') or (chr == '\r'))")
              @charCount = 0
              #@lineNumber = @lineNumber + 1
              @wordIndex = 0
            end
            @typeOfToken = @keywords.isToken?(@word)
            if (@typeOfToken != "T_NA")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if (typeOfToken != \"T_NA\" #{@typeOfToken} ")
              @fileCursorPosition = @fileContent.pos
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, "  return typeOfToken: #{@typeOfToken}")
              @wordLast = @word
              @word = ""
              return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@typeOfToken} "}
              @wordIndex = @wordIndex + 1
            else
              if @isCompound
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if isCompound #{@isCompound} ")
                @fileCursorPosition = @fileContent.pos
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return S_VALUE #{@word}")
                @wordLast = @word
                @word = ""
                @isCompound = false
                return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "S_VALUE #{@word}"}
                @wordIndex = @wordIndex + 1
              else
                if @keywords.isNumeric?(@word)
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if @keywords.isNumeric?(word) #{@word}")
                  @fileCursorPosition = @fileContent.pos
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return N_VALUE #{@word}")
                  @wordLast = @word
                  @word = ""
                  return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "N_VALUE #{@word} "}
                  @wordIndex = @wordIndex + 1
                elsif @keywords.isAlphaNumeric?(@word)
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " elsif @keywords.isAlphaNumeric?(word) #{@word}")
                  @fileCursorPosition = @fileContent.pos
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return A_VALUE #{@word}")
                  @wordLast = @word
                  @word = ""
                  return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "A_VALUE #{@word} "}
                  @wordIndex = @wordIndex + 1
                end
              end
            end
          elsif @openCloseCompound > 0
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " elsif openCloseCompound > 0 #{@openCloseCompound}")
            @word = @word + chr
          end
          @operandFound = @keywords.isOperand?(@operandWord)
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " operandFound #{@operandFound}")
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " operandWord #{@operandWord}")
          if @operandFound != "O_NA"# and (@word.empty?)
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if operandFound != \"O_NA\" and (word.empty?) #{@operandFound} #{@word}")
            @fileCursorPosition = @fileContent.pos
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return #{@operandFound}")
            @operandWord = ""
            return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@operandFound} "}
            @wordIndex = @wordIndex + 1
          end
        when "\""
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " when '\"'")
          if ["?", "~", "^", "!", "+", "-", "%", "/", "*", ">", "<", "=", "&", "|", "(", ",", "[", "]", ")", "{", "}", ";"].include? @operandWord
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if ['?', '~', '^', '!', '+', '-', '%', '/', '*','>','<','=','&','|','(', ',', '[', ']', ')', '{', '}',';'].include? operandWord #{@operandWord}")
            @openCloseCompound = @openCloseCompound + 1
            @operandFound = @keywords.isOperand?(@operandWord)
            if @operandFound != "O_NA" and (@word.empty?)
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if operandFound != \"O_NA\" and (word.empty?) #{@operandFound} #{@word}")
              @fileCursorPosition = @fileContent.pos
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return #{@operandFound}")
              @operandWord = chr 
              return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@operandFound} "}
              @wordIndex = @wordIndex + 1
            end
          end
          @operandWord = @operandWord + chr
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " @operandWord:->#{@operandWord}<-")
          @openCloseCompound = @openCloseCompound + 1
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " @openCloseCompound:->#{@openCloseCompound}<-")
          if ( (@openCloseCompound % 2) == 0 )
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if ( (openCloseCompound % 2) == 0 ) #{@openCloseCompound}")
            @isCompound = false
            @openCloseCompound = 0
            @operandFound = @keywords.isOperand?(@operandWord)
            @fileCursorPosition = @fileContent.pos
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return S_VALUE #{@word}")
            #@operandWord = ""
            @wordLast = @word
            @word = ""
            return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "S_VALUE #{@wordLast}"}
#            return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@operandFound} "
          end
        when "#"
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " when '#'")
          if !@word.empty? and @openCloseCompound == 0
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if !word.empty? and openCloseCompound == 0 #{@word} #{@operandCompound}")
            @typeOfToken = @keywords.isToken?(@word)
            if (@typeOfToken != "T_NA")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if (typeOfToken != \"T_NA\") #{@typeOfToken}")
              @fileCursorPosition = @fileContent.pos
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return #{@typeOfToken}")
              @wordLast = @word
              @word = ""
              return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@typeOfToken} "}
              @wordIndex = @wordIndex + 1
            else
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " else of if (typeOfToken != \"T_NA\") #{@typeOfToken}")
              if @isCompound
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if isCompound #{@isCompound}")
                @fileCursorPosition = @fileContent.pos
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return S_VALUE #{@word}")
                @wordLast = @word
                @word = ""
                @isCompound = false
                return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "S_VALUE #{@wordLast} "}
              else
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " else of if isCompound #{@isCompound}")
                if @keywords.isNumeric?(@word)
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if @keywords.isNumeric?(word) #{@word}")
                  @fileCursorPosition = @fileContent.pos
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return N_VALUE #{@word}")
                  @wordLast = @word
                  @word = ""
                  return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "N_VALUE #{@wordLast} "}
                elsif @keywords.isAlphaNumeric?(@word)
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " elsif @keywords.isAlphaNumeric?(word) #{@word}")
                  @fileCursorPosition = @fileContent.pos
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return I_VALUE #{@word}")
                  @wordLast = @word
                  @word = ""
                  return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "I_VALUE #{@wordLast} "}
                end
              end
            end
          elsif @openCloseCompound > 0
            @word = @word + chr
          end
          if @openCloseCompound == 0
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " break #{@openCloseCompound}")
            @line = ""
            @lineNumber = @lineNumber + 1
            @word = ""
            @wordLast = ""
            @wordIndex = 0
            @word2Special = false
            @special2Word = false
            @specialWord = ""
            @specialWordLast = ""
            @haveWord = false
            @haveWordOldState = @haveWord
            @gotoNextLine = false
            @currentToken = "T_NA"
            @isCompound = false
            @isParanthesis = false
            @isBraket = false
            @isBraces = false
            @operandWord = ""
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " read whole line #{@fileContent.gets} ")
          end
        when "?", "(", ")", "[", "]", "{", "}", ",", ";"
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " when '?', '(', ',', '[', ']', ')', '{', '}',';' ")
          if !@operandWord.empty?
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if !operandWord.empty? #{@operandWord}")
            @operandFound = @keywords.isOperand?(@operandWord)
            if @operandFound != "O_NA" and (@word.empty?)
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if operandFound != \"O_NA\" and (word.empty?) #{@operandFound} #{@word}")
              @fileCursorPosition = @fileContent.pos-1
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return #{@operandFound}")
              @operandWord = ""
              return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@operandFound} "}
            end
          end
          @operandWord = @operandWord + chr
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, "operandWord: #{@operandWord}")
          if !@word.empty? and @openCloseCompound == 0
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if !word.empty? and openCloseCompound == 0 #{@word} #{@openCloseCompound}")
            @typeOfToken = @keywords.isToken?(@word)
            if (@typeOfToken != "T_NA")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if (typeOfToken != \"T_NA\") #{@typeOfToken}")
              @fileCursorPosition = @fileContent.pos
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return #{@typeOfToken}")
              @wordLast = @word
              @word = ""
              return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@typeOfToken} "}
            else
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " else of if (typeOfToken != \"T_NA\") #{@typeOfToken}")
              if @isCompound
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if isCompound #{@isCompound}")
                @fileCursorPosition = @fileContent.pos
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return S_VALUE #{@word}")
                @wordLast = @word
                @word = ""
                @isCompound = false
                return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "S_VALUE #{@wordLast} "}
              else
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " else of if isCompound #{@isCompound}")
                if @keywords.isNumeric?(@word)
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if @keywords.isNumeric?(word) #{@word}")
                  @fileCursorPosition = @fileContent.pos
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return N_VALUE #{@word}")
                  @wordLast = @word
                  @word = ""
                  return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "N_VALUE #{@wordLast} "}
                elsif @keywords.isAlphaNumeric?(@word)
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " elsif @keywords.isAlphaNumeric?(word) #{@word}")
                  @fileCursorPosition = @fileContent.pos
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return A_VALUE #{@word}")
                  @wordLast = @word
                  @word = ""
                  return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "A_VALUE #{@wordLast} "}
                end
              end
            end
          elsif @openCloseCompound > 0
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " elsif @openCloseCompound > 0 #{@word}")
            @word = @word + chr
          end
        when "?", "~", ":", "^", "!", "+", "-", "%", "/", "*", ">", "<", "=", "&", "|"
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " when '?', '~', ':', '^', '!', '+', '-', '%', '/', '*','>','<','=','&','|'")
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " char: #{chr}")
          if !@operandWord.empty? and (@operandWord.include? ")" or @operandWord.include? "\"")
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if !operandWord.empty? and operandWord.include? \")\" #{@operandWord}")
            @operandFound = @keywords.isOperand?(@operandWord)
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " operandFound:#{@operandFound} word:#{@word}")
            if @operandFound != "O_NA" and (@word.empty?)
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if operandFound != \"O_NA\" and (word.empty?) #{@operandFound} #{@word}")
              @fileCursorPosition = @fileContent.pos
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return #{@operandFound}")
              @operandWord = chr
              return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@operandFound} "}
              @wordIndex = @wordIndex + 1
              @operandWord = ""
            end
          end
          @operandWord = @operandWord + chr
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " operandWord:#{@operandWord} word:#{@word}")
          if !@word.empty? and @openCloseCompound == 0
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if !word.empty? and openCloseCompound == 0 #{@word} #{@openCloseCompound}")
            @typeOfToken = @keywords.isToken?(@word)
            if (@typeOfToken != "T_NA")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if (typeOfToken != \"T_NA\") #{@typeOfToken}")
              @fileCursorPosition = @fileContent.pos
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return #{@typeOfToken}")
              @wordLast = @word
              @word = ""
              return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "#{@typeOfToken} "}
              @wordIndex = @wordIndex + 1
            else
              pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " else of if (typeOfToken != \"T_NA\") #{@typeOfToken}")
              if @isCompound
                 pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if isCompound #{@isCompound}")
                 @fileCursorPosition = @fileContent.pos
                 pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                 pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return S_VALUE #{@word}")
                 @wordLast = @word
                 @word = ""
                 @isCompound = false
                 return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "S_VALUE #{@wordLast} "}
              else
                pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " else of if isCompound #{@isCompound}")
                if @keywords.isNumeric?(@word)
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if @keywords.isNumeric?(word) #{@word}")
                  @fileCursorPosition = @fileContent.pos
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return N_VALUE #{@word}")
                  @wordLast = @word
                  @word = ""
                  return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "N_VALUE #{@wordLast} "}
                elsif @keywords.isAlphaNumeric?(@word)
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if @keywords.isAlphaNumeric?(word) #{@word}")
                  @fileCursorPosition = @fileContent.pos
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " @fileCursorPosition #{@fileCursorPosition} char: #{chr}")
                  pringDebugMsg(File.basename(__FILE__), __LINE__, 0x4, " return A_VALUE #{@word}")
                  @wordLast = @word
                  @word = ""
                  return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => "A_VALUE #{@wordLast} "}
                end
              end
            end
          elsif @openCloseCompound > 0
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " elsif !@word.empty? and @openCloseCompound == 0 #{@word} #{@openCloseCompound}")
            @word = @word + chr
          end
        when "."
          pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " when '.'")
          if @keywords.isTypeOfToken(@typeOfToken)
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " if @keywords.isTypeOfToken(typeOfToken) #{@typeOfToken}")
            @word = @word + chr
          else
            pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " else of if @keywords.isTypeOfToken(typeOfToken) #{@typeOfToken}")
            @operandWord = @operandWord + chr
          end
        end
      end
    end
    pringDebugMsg(File.basename(__FILE__), __LINE__, 0x8, " file pos:#{@fileContent.pos} end of def") 
    return {"lineNumber" => @lineNumber, "charCount" => @charCount, "retValue" => ""}
  end
end #class LexicalAnalyzer

end #module RubyScript2CAPLConverter


