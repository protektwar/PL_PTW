
module RubyScript2CAPL
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
          @typeOfToken = {   0 => "T_INCLUDE",
                             1 => "T_CALL", # to be rechecked it should be used, as there could be there following syntax a = function + 2; or a = function + b;
                             2 => "T_FOR",
                             3 => "T_WHILE",
                             4 => "T_DO",
                             5 => "T_IF",
                             6 => "T_ELSE",
                             7 => "T_ELSEIF",
                             8 => "T_DEF",
                             9 => "T_VAR",
                            10 => "T_MAIN",
                            11 => "T_RETURN",
                            12 => "T_FOREACH",
                            13 => "T_PUTS",
                            14 => "T_RECEIVE",
                            15 => "T_EXPECT",
                            16 => "T_STEP",
                            17 => "TYPE_INT",
                            18 => "TYPE_LONG",
                            19 => "TYPE_LLONG",
                            20 => "TYPE_FLOAT",
                            21 => "TYPE_DOUBLE",
                            22 => "TYPE_UINT",
                            23 => "TYPE_ULONG",
                            24 => "TYPE_ULLONG",
                            25 => "TYPE_UCHAR",
                            26 => "TYPE_CHAR",
                            27 => "TYPE_STRING",
                            28 => "TYPE_BIT",
                            29 => "TYPE_STRUCT",
                            30 => "TYPE_BOOLEAN"
          }

          @typeOfCons = { 
                         0 => "S_EMPTY", #if nothing found between 
                         1 => "S_VALUE", # when string between "" is found
                         2 => "A_VALUE", # when Identifier is found
                         3 => "N_VALUE"  # when numeric value is found
          }


          @operandList = [
                          "::",   # O_SCOPE_LR
                          "(",    # O_UNARY_FUNCTIONAL_OPEN_LR
                          ")",    # O_UNARY_FUNCTIONAL_CLOSE_LR
                          "[",    # O_UNARY_SUBSCRIPT_OPEN_LR
                          "]",    # O_UNARY_SUBSCRIPT_CLOSE_LR
                          "++",   # O_UNARY_INCREMENT
                          "--",   # O_UNARY_DECREMENT
                          ".",    # O_UNARY_MEMBER_ACCESS_LR
                          "!",    # O_UNARY_LOGICAL_NOT_RL
                          "~",    # O_UNARY_BITWISE_NOT_RL
                          #sign
                          "+",    # O_UNARY_PREFIX_OR_ADDITION_RL_LR
                          "-",    # O_UNARY_PREFIX_OR_SUBTRACTION_RL_LR
                          #----
                          #mulop
                          "*",    # O_ARITHMETIC_MULTIPLY_LR
                          "%",    # O_ARITHMETIC_MODULO_LR
                          "/",    # O_ARITHMETIC_DIVIDE_LR
                          #-----
                          ">>",   # O_BITWISE_SHIFT_RIGHT_LR
                          "<<",   # O_BITWISE_SHIFT_LEFT_LR
                          #relop
                          "!=",   # O_EQUALITY_INEQUALITY_LR
                          "==",   # O_EQUALITY_EQUALITY_LR
                          ">",    # O_RELATIONAL_BIGGER_THAN_LR
                          ">=",   # O_RELATIONAL_BIGGER_OR_EQUAL_THAN_LR
                          "<",    # O_RELATIONAL_SMALLER_THAN_LR
                          "<=",   # O_RELATIONAL_SMALLER_OR_EQUAL_THAN_LR 
                          #-----
                          "&",    # O_BITWISE_AND_LR 
                          "^",    # O_BITWISE_XOR_LR 
                          "|",    # O_BITWISE_OR_LR 
                          "&&",   # O_LOGICAL_AND_LR 
                          "||",   # O_LOGICAL_OR_LR 
                          "=",    # O_ASSIGNMENT_RL 
                          "*=",   # O_COMPOUND_ASSIGNMENT_MULTIPLY_RL 
                          "/=",   # O_COMPOUND_ASSIGNMENT_DIVIDE_RL 
                          "%=",   # O_COMPOUND_ASSIGNMENT_MODULO_RL 
                          "+=",   # O_COMPOUND_ASSIGNMENT_ADDITION_RL 
                          "-=",   # O_COMPOUND_ASSIGNMENT_SUBSTRACTION_RL 
                          ">>=",  # O_COMPOUND_ASSIGNMENT_BITWISE_SHIFT_RIGHT_RL  
                          "<<=",  # O_COMPOUND_ASSIGNMENT_BITWISE_SHIFT_LEFT_RL 
                          "&=",   # O_COMPOUND_ASSIGNMENT_BITWISE_AND_RL 
                          "^=",   # O_COMPOUND_ASSIGNMENT_BITWISE_XOR_RL 
                          "|=",   # O_COMPOUND_ASSIGNMENT_BITWISE_OR_RL 
                          "~=",   # O_COMPOUND_ASSIGNMENT_BITWISE_NEG_RL 
                          ",",    # O_SEQUENCING_LR 
                          ";",    # O_END_OF_STATEMENT
                          "\"",   # O_OPEN_CLOSE_COMPOUND # "blabla"
                          "#",    # O_COMMENT_LINE_IGNORED
                          "{",    # O_BLOCK_OPEN
                          "}",    # O_BLOCK_CLOSE
                          ":",    # O_VAR_DEFINITION
                          "..",   # O_?????
                          "?"     # O_QUESTION_MARK 
          ]

          @typeOfOperand = { 
                             0 => "O_SCOPE_LR", 
                             1 => "O_UNARY_FUNCTIONAL_OPEN_LR",  
                             2 => "O_UNARY_FUNCTIONAL_CLOSE_LR",
                             3 => "O_UNARY_SUBSCRIPT_OPEN_LR",
                             4 => "O_UNARY_SUBSCRIPT_CLOSE_LR",
                             5 => "O_UNARY_INCREMENT", 
                             6 => "O_UNARY_DECREMENT", 
                             7 => "O_UNARY_MEMBER_ACCESS_LR", 
                             8 => "O_UNARY_LOGICAL_NOT_RL",
                             9 => "O_UNARY_BITWISE_NOT_RL",
                            10 => "O_UNARY_PREFIX_OR_ADDITION_RL_LR",
                            11 => "O_UNARY_PREFIX_OR_SUBTRACTION_RL_LR",
                            12 => "O_ARITHMETIC_MULTIPLY_LR",
                            13 => "O_ARITHMETIC_MODULO_LR",
                            14 => "O_ARITHMETIC_DIVIDE_LR",
                            15 => "O_BITWISE_SHIFT_RIGHT_LR",
                            16 => "O_BITWISE_SHIFT_LEFT_LR",
                            17 => "O_EQUALITY_INEQUALITY_LR",
                            18 => "O_EQUALITY_EQUALITY_LR",
                            19 => "O_RELATIONAL_BIGGER_THAN_LR",
                            20 => "O_RELATIONAL_BIGGER_OR_EQUAL_THAN_LR",
                            21 => "O_RELATIONAL_SMALLER_THAN_LR",
                            22 => "O_RELATIONAL_SMALLER_OR_EQUAL_THAN_LR",
                            23 => "O_BITWISE_AND_LR",
                            24 => "O_BITWISE_XOR_LR",
                            25 => "O_BITWISE_OR_LR",
                            26 => "O_LOGICAL_AND_LR",
                            27 => "O_LOGICAL_OR_LR",
                            28 => "O_ASSIGNMENT_RL",
                            29 => "O_COMPOUND_ASSIGNMENT_MULTIPLY_RL",
                            30 => "O_COMPOUND_ASSIGNMENT_DIVIDE_RL",
                            31 => "O_COMPOUND_ASSIGNMENT_MODULO_RL",
                            32 => "O_COMPOUND_ASSIGNMENT_ADDITION_RL",
                            33 => "O_COMPOUND_ASSIGNMENT_SUBSTRACTION_RL",
                            34 => "O_COMPOUND_ASSIGNMENT_BITWISE_SHIFT_RIGHT_RL",
                            35 => "O_COMPOUND_ASSIGNMENT_BITWISE_SHIFT_LEFT_RL",
                            36 => "O_COMPOUND_ASSIGNMENT_BITWISE_AND_RL",
                            37 => "O_COMPOUND_ASSIGNMENT_BITWISE_XOR_RL",
                            38 => "O_COMPOUND_ASSIGNMENT_BITWISE_OR_RL",
                            39 => "O_COMPOUND_ASSIGNMENT_BITWISE_NEG_RL",
                            40 => "O_SEQUENCING_LR",
                            41 => "O_END_OF_STATEMENT",
                            42 => "O_OPEN_CLOSE_COMPOUND",
                            43 => "O_COMMENT_LINE_IGNORED",
                            44 => "O_BLOCK_OPEN",
                            45 => "O_BLOCK_CLOSE",
                            46 => "O_VAR_DEFINITION",
                            47 => "W_What",
                            48 => "O_QUESTION_MARK",
                            49 => "O_EXCLAMATION_POINT"
          }
        end
	
        def getKeywordList()
          return @keywordList
        end

        def getTypeOfToken()
          return @typeOfToken
        end

        def getTypeOfCons()
          return @typeOfCons
        end

        def getOperandList()
          return @getOperandList
        end

        def getTypeOfOperand()
          return @typeOfOperand
        end

        def getOperandList()
          return @operandList
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
