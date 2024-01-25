
module RubyScript
  class Keywords
    
	attr_accessor :keywordList, :typeOfKeyword
	
	def initialize()
          @keywordList = [
                          "include",   # T_INCLUDE
                          "call",      # T_CALL
                          "for",       # T_FOR
                          "while",     # T_WHILE
                          "do",        # T_DO
                          "if",        # T_IF
                          "else",      # T_ELSE
                          "elseif",    # T_ELSEIF
                          "def",       # T_DEF
                          "var",       # T_VAR
                          "main",      # T_MAIN
                          "return",    # T_RETURN
                          "foreach",   # T_FOREACH
                          "puts",      # T_PUTS - print with EOL
                          "receive",   # T_RECEIVE
                          "expect",    # T_EXPECT
                          "step",      # T_STEP
                          "int",       # TYPE_INT
                          "long",      # TYPE_LONG
                          "llong",     # TYPE_LLONG
                          "float",     # TYPE_FLOAT
                          "double",    # TYPE_DOUBLE
                          "uint",      # TYPE_UINT
                          "ulong",     # TYPE_ULONG
                          "ullong",    # TYPE_ULLONG
                          "char",      # TYPE_CHAR
                          "uchar",     # TYPE_UCHAR
                          "string",    # TYPE_STRING
                          "bit",       # TYPE_BIT
                          "struct",    # TYPE_STRUCT
                          "boolean"    # TYPE_BOOLEAN
           ]      
           @typeOfKeyword = { 0 => "T_INCLUDE",
                              1 => "T_CALL",
                              2 => "T_FOR",
                              3 => "T_WHILE",
                              4 => "T_DO",
                              5 => "T_IF",
                              6 => "T_DEF",
                              7 => "T_VAR",
                              8 => "T_MAIN"
          }
	end
	
        def getKeywordList()
          return @keywordList
        end

	def isKeyword(word2Check)
	    @keywordList.each_with_index.map do |keyword, index|
    	    if (keyword == word2Check)
			    #print "typeOfKeyword ", @typeOfKeyword[index], "\nindex : ", index, " \n"
		        return @typeOfKeyword[index]
	        end
	   end
	   return "T_NA"
	end
	
  end
end
