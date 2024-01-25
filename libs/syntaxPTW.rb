require_relative "tokenKeywordPTW.rb"

module RubyScript
class SyntaxPTW
    
  attr_accessor :keywordList, :typeOfToken, :operandList, :typeOfOperand, :typeOfCons
  attr_accessor :syntanxRelationships, :syntanxRelationshipsExceptions
  
  def initialize()
    @tokenKeywordPTW = Keywords.new()
    @keywordList = @tokenKeywordPTW.getKeywordList()
    @typeOfToken = @tokenKeywordPTW.getTypeOfToken()      
    @typeOfCons = @tokenKeywordPTW.getTypeOfCons() 
    @operandList = @tokenKeywordPTW.getOperandList()
    @typeOfOperand = @tokenKeywordPTW.getTypeOfOperand()

    @syntanxRelationships = {
                             #POSSIBLE TO BE ADDED 
                             # some types and standard_types
                             "TYPE" => {
                                          "OR21" => {
                                                       "RELATION21" => "STANDARD_TYPE",
                                                       "RELATION22" => "ARRAY",
                                                       "RELATION23" => "CANMESSAGE"
                                                    }
                                       },
                             "ARRAY" => {
                                           "0" => "W_ARRAY", # ???
                                           "1" => "O_UNARY_SUBSCRIPT_OPEN_LR",
                                           "2" => "N_VALUE",
                                           "3" => "O_RANGE", #".." to be reviewed
                                           "4" => "N_VALUE",
                                           "5" => "O_UNARY_SUBSCRIPT_CLOSE_LR",
                                           "6" => "W_OF",    # ???
                                    "RELATION" => "STANDARD_TYPE"
                                        },
                             "CANMESSAGE" => {

                                             },
                             "STANDARD_TYPE" => {
                                                    "OR22" => {
                                                                 "0" => "TYPE_INT",
                                                                 "1" => "TYPE_LONG",
                                                                 "2" => "TYPE_LLONG",
                                                                 "3" => "TYPE_FLOAT",
                                                                 "4" => "TYPE_DOUBLE",
                                                                 "5" => "TYPE_UINT",
                                                                 "6" => "TYPE_ULONG",
                                                                 "7" => "TYPE_ULLONG",
                                                                 "8" => "TYPE_UCHAR",
                                                                 "9" => "TYPE_CHAR",
                                                                "10" => "TYPE_STRING",
                                                                "11" => "TYPE_BIT",
                                                                "12" => "TYPE_STRUCT",
                                                                "13" => "TYPE_BOOLEAN"
                                                              }

                                                },
                             "VAR"     => { 
                                              "88" => "T_VAR",
                                              "RELATION88" => "VAR_DECLARATION"
                                          },
                             "VAR_DECLARATION" => {
                                                        "7" => "A_VALUE",
                                                        "8" => "O_VAR_DEFINITION",
                                                "RELATION0" => "STANDARD_TYPE",
                                                    "IF478" => {
                                                                 "28" => "O_ASSIGNMENT_RL"
                                                               },
                                                  "THEN478" => {
                                                                 "RELATION1" => "FACTOR"
                                                               },
                                                  "ELSE478" => {},
                                                      "IF5" => {
                                                                 "5" => "O_SEQUENCING_LR"
                                                               },
                                                    "THEN5" => { 
                                                                 "RELATION" => "VAR_DECLARATION"
                                                               },
                                                    "ELSE5" => { 
                                                               }
                                                  },
                             "T_INCLUDE" => { 
                                                        "IF1" => {
                                                                   "0" => "O_OPEN_CLOSE_COMPOUND"
                                                                 },
                                                      "THEN1" => {
                                                                   "1" => "S_VALUE",
                                                                   "END_STATEMENT" => "O_OPEN_CLOSE_COMPOUND"
                                                                 },
                                                      "ELSE1" => {
                                                                               "0" => "O_RELATIONAL_SMALLER_THAN_LR",
                                                                               "1" => "A_VALUE",
                                                                   "END_STATEMENT" => "O_RELATIONAL_BIGGER_THAN_LR"
                                                                 }
#                                              "END_STATEMENT" => "O_END_OF_STATEMENT"
                                            },
                             "T_DEF" => { 
                                          "OR55" => {
                                                         "0" => "A_VALUE",
                                                         "1" => "T_MAIN"
                                                        },
                                          "RELATION0" => "ARGUMENTS",
                                          "RELATION1" => "COMPOUND_STATEMENT"
                                        },
                             "ARGUMENTS" => { 
                                              "BEGIN_ARGUMENT0" => "O_UNARY_FUNCTIONAL_OPEN_LR",
                                                         "OR20" => {
                                                                     "RELATION0" => "PARAMETER_LIST",
                                                                     "END_ARGUMENT0" => "O_UNARY_FUNCTIONAL_CLOSE_LR" 
                                                                   }
                                            },
                             "PARAMETER_LIST" => {   
                                                  "4" => "A_VALUE",
                                                "IF2" => { 
                                                                  "5" => "O_SEQUENCING_LR"
                                                         },
                                              "THEN2" => {
                                                          "RELATION4" => "PARAMETER_LIST"
                                                         },
                                              "ELSE2" => {
                                                         }
                                             },
                             "COMPOUND_STATEMENT" => {
                                             "BEGIN_BLOCK" => "O_BLOCK_OPEN",
                                             "RELATION0" => "OPTIONAL_STATEMENT",
                             },

                             "OPTIONAL_STATEMENT" => {
                                                        "OrLOOP20" => { #is OR a loop??? until END???
                                                                        "RELATION0" => "STATEMENT",
                                                                        "END_BLOCK" => "O_BLOCK_CLOSE"
                                                                       }
                                                     },
                             "INNER_COMPOUND_STATEMENT" => {
                                                              "BEGIN_INNER_BLOCK0" => "O_BLOCK_OPEN",
                                                              "RELATION0" => "INNER_OPTIONAL_STATEMENT",
                                                           },

                             "INNER_OPTIONAL_STATEMENT" => {
                                                        "OrLOOP21" => { #is OR a loop??? until END???
                                                                        "RELATION0_21" => "STATEMENT",
                                                                        "END_INNER_BLOCK0" => "O_BLOCK_CLOSE"
                                                                       }
                                                     },
                             "STATEMENT_LIST" => { #TBD
                                                           "RELATION0" => "STATEMENT",
                                                    "END_OF_STATEMENT" => "O_END_OF_STATEMENT"
                                                 },
                             "STATEMENT_END" => {
                                                    "END_OF_STATEMENT0" => "O_END_OF_STATEMENT"
                                                },
                             "VARIABLE_ASSIGNMENT_OR_INCREMENT" => {
                                              "IF455" => { 
                                                            "RELATION1_5" => "ASSIGNOP"
                                                         },
                                              "THEN455" => {
                                                             "RELATION2_5" => "EXPRESSION"
                                                           },
                                              "ELSE455" => {
                                                             "RELATION3_5" => "INCREMENT_DECREMENT"
                                                           }                                 
                             },
                             "STATEMENT" => { 
                                                 "OR10"  => { 
                                                                  "RELATION0_10"  => "IF",
                                                                  "RELATION1_10"  => "FOR",
                                                                  "RELATION2_10"  => "WHILE",
                                                                  "RELATION3_10"  => "DO",
                                                                  "RELATION4_10"  => "STEP",
                                                                  "RELATION5_10"  => "INNER_COMPOUND_STATEMENT",
                                                                  "RELATIOnS0_10"  => "VARIABLE VARIABLE_ASSIGNMENT_OR_INCREMENT STATEMENT_END",
                                                                  "RELATIOnS1_10" => "CALL STATEMENT_END",
                                                                  "RELATIOnS2_10" => "PUTS STATEMENT_END",
                                                                  "RELATIOnS3_10" => "VAR STATEMENT_END",
                                                                  "RELATIOnS4_10" => "RETURN STATEMENT_END",
                                                                  "RELATIOnS5_10" => "RECEIVE STATEMENT_END",
                                                                  "RELATIOnS6_10" => "EXPECT STATEMENT_END"
                                                            }
                                            },
                             "FOR" => { #TBC
                                                         "0" => "T_FOR",
                                        "BEGIN_FoR_ARGUMENT0" => "O_UNARY_FUNCTIONAL_OPEN_LR",
                                                       "OR1" => {
                                                                  "RELATION5" => "FOR_CONDITION",
                                                                  "END_FoR_ARGUMENT0" => "O_UNARY_FUNCTIONAL_CLOSE_LR"
                                                                },
                                                "RELATION5"  => "INNER_COMPOUND_STATEMENT",
                                      },
                             "IF"  => { 
                                                                      "0" => "T_IF",
                                                     "BEGIN_If_ARGUMENT0" => "O_UNARY_FUNCTIONAL_OPEN_LR",
                                                              "RELATION6" => "EXPRESSION",
                                                       "END_If_ARGUMENT0" => "O_UNARY_FUNCTIONAL_CLOSE_LR",
                                                              "RELATION7" => "INNER_COMPOUND_STATEMENT",
                                                                  "IF155" => {"0" => "T_ELSE"},
                                                                "THEN155" => {"RELATION0" => "ELSE"},               
                                                                "ELSE155" => {
                                                                                  "IF156" => { "0" => "T_ELSEIF" },
                                                                                "THEN156" => { "RELATION1" => "ELSEIF" },
                                                                                "ELSE156" => {}
                                                                              }
                                        },
                             "ELSE" => {
                                            "RELATION7" => "INNER_COMPOUND_STATEMENT",
                                       },
                             "ELSEIF" => {
                                            "BEGIN_If_ARGUMENT0" => "O_UNARY_FUNCTIONAL_OPEN_LR",
                                            "RELATION6" => "EXPRESSION",
                                            "END_If_ARGUMENT0" => "O_UNARY_FUNCTIONAL_CLOSE_LR",
                                            "RELATION7" => "INNER_COMPOUND_STATEMENT",
                                            "IF155" => {"0" => "T_ELSE"},
                                            "THEN155" => {"RELATION0" => "ELSE"},                                               
                                            "ELSE155" => {
                                                             "IF156" => { "0" => "T_ELSEIF" },
                                                           "THEN156" => { "RELATION1" => "ELSEIF" },
                                                           "ELSE156" => {}
                                                         }
                                      },
                             "DO" => { 
                                                  "0" => "T_DO",
                                         "RELATION12" => "INNER_COMPOUND_STATEMENT",
                                                  "1" => "T_WHILE",
                                         "RELATION14" => "EXPRESSION",
                                       "END_DO_WHILE0" => "O_END_OF_STATEMENT"
                                      },
                             "WHILE" => { 
                                                  "0" => "T_WHILE",
                                         "RELATION14" => "EXPRESSION",
                                         "RELATION15" => "INNER_COMPOUND_STATEMENT"
                                          },
                             "PUTS" => { #TBC
                                                  "0" => "T_PUTS",
                                         "RELATION16" => "PRINT_PARAMETERS"
                             #                   "END" => "O_END_OF_STATEMENT"
                                         },
                             "RETURN" => { # is this covered? return "blabla"
                                                  "0" => "T_RETURN",
                                          "RELATION0" => "EXPRESSION"
                                         },
                             "FOR_CONDITION" => {  # min 2 x O_END_OF_STATEMENT inside confition #TBD
                                                  "IF269" => {
                                                                "0" => "T_VAR"
                                                             },
                                                  "THEN269" => {
                                                                "1" => "A_VALUE",
                                                                "2" => "O_ASSIGNMENT_RL",
                                                                "3" => "N_VALUE",
                                                               },
                                                  "ELSE269" => {
                                                                "0" => "A_VALUE",
                                                                "1" => "O_ASSIGNMENT_RL",
                                                                "2" => "N_VALUE",
                                                               },
                                                  "4" => "O_END_OF_STATEMENT",
                                                  "RELATION0" => "EXPRESSION",
                                                  "5" => "O_END_OF_STATEMENT",
                                                  "RELATION1" => "VARIABLE",
                                                  "RELATION2" => "INCREMENT_DECREMENT"
                                                },
                             "PRINT_PARAMETERS" => { #TBD
                                                    "IF4" => { 
                                                               "0" => "O_OPEN_CLOSE_COMPOUND"
                                                             },
                                                  "THEN4" => {
                                                               "0" => "S_VALUE",
                                                               "1" => "O_OPEN_CLOSE_COMPOUND"
                                                             },
                                                  "ELSE4" => {
                                                               "OR" => { 
                                                                                 "0" => "A_VALUE",
                                                                         "RELATION0" => "expression"
                                                                       }
                                                             },
                                                    "IF5" => { 
                                                               "2" => "O_SEQUENCING_LR" #if not O_SEQUENCING_LR anymore then end of parameters list
                                                             },
                                                  "THEN5" => {
                                                               "RELATION0" => "PRINT_PARAMETERS"
                                                             },
                                                  "ELSE5" => {
                                                             }
                                                  },
                             "RECEIVE" => { 
                                                    "0" => "T_RECEIVE",
                                            "RELATION0" => "PARAMETER_LIST"

                                          },
                             "EXPECT" => { 
                                                  "0" => "T_EXPECT",
                                           "RELATION0" => "EXPRESSION"
                                         },
                             "STEP" => {
                                                  "0" => "T_STEP",
                                                  "1" => "N_VALUE",
                                          "RELATION0" => "INNER_COMPOUND_STATEMENT"
                                       },
                             "CALL" => { 
                                                  "0" => "T_CALL",
                                                  "1" => "A_VALUE",
                                              "IF105" => {
                                                           "BEGIN_CaLL_ARGUMENT0" => "O_UNARY_FUNCTIONAL_OPEN_LR"
                                                         },
                                              "THEN105" => {
#                                                              "OrLOOP" => {
                                                                     "RELATION0" => "EXPRESSION_LIST",
                                                            "END_CaLL_ARGUMENT0" => "O_UNARY_FUNCTIONAL_CLOSE_LR"
#                                                                          }
                                                           },
                                              "ELSE105" => {                                                           
                                                           }
                                         },
                             "EXPRESSION_LIST" => {
                                                    "RELATION0" => "EXPRESSION",
                                                        "IF100" => {
                                                                    "0" => "O_SEQUENCING_LR"
                                                                   },
                                                      "THEN100" => {
                                                                    "RELATION0" => "EXPRESSION_LIST"
                                                                   },
                                                      "ELSE100" => {}
                             },
                             "EXPRESSION" => {
                                            "RELATION0" => "SIMPLE_EXPRESSION",
                                                "IF101" => {
                                                           "RELATION1" => "RELOP"
                                                           },
                                              "THEN101" => {
                                                            "RELATION2" => "EXPRESSION"
                                                           },
                                              "ELSE101" => {}
                             },
                             "SIMPLE_EXPRESSION" => {
                                                      "IF102" => {
                                                                   "RELATION0_2" => "UNARY"
                                                                 },
                                                    "THEN102" => {
                                                                   "RELATION1_2" => "TERM",
                                                                       "IF103" => {
                                                                                     "RELATION3_3" => "ADDOP"
                                                                                  },
                                                                     "THEN103" => {
                                                                                    "RELATION4_3" => "SIMPLE_EXPRESSION"
                                                                                  },
                                                                     "ELSE103" => {}                                                                 
                                                    },
                                                    "ELSE102" => {
                                                                   "RELATION2_2" => "TERM",
                                                                       "IF103" => {
                                                                                     "RELATION3_3" => "ADDOP"
                                                                                  },
                                                                     "THEN103" => {
                                                                                     "RELATION4_3" => "SIMPLE_EXPRESSION"
                                                                                  },
                                                                     "ELSE103" => { }
                                                                  }
                             },
                             "VARIABLE" => {
                                              "0" => "A_VALUE",
                                                "IF106" => {
                                                            "BEGIN_SUBSCRIPT" => "O_UNARY_SUBSCRIPT_OPEN_LR"
                                                           },
                                              "THEN106" => {
                                                                "RELATION0_106" => "EXPRESSION",
                                                            "END_SUBSCRIPT" => "O_UNARY_SUBSCRIPT_CLOSE_LR"
                                                           },
                                              "ELSE106" => {
                                                           }
                                           },
                             "STRING" => { 
                                            "0" => "O_OPEN_CLOSE_COMPOUND",
                                            "1" => "S_VALUE",
                                            "2" => "O_OPEN_CLOSE_COMPOUND"
                                         },
                             "NUM" => { 
                                          "0" => "N_VALUE"
                                      },
                             "TERM" => {
                                          "RELATION0" => "FACTOR",
                                              "IF110" => {
                                                            "RELATION0" => "MULOP"
                                                         },
                                            "THEN110" => {
                                                            "RELATION1" => "TERM"        
                                                         }, 
                                            "ELSE110" => {}
                                       },
                             "VAR_OR_FUNCTION" => {
                                                         "0" => "A_VALUE",
                                                      "IF77" => {
                                                                  "BEGIN_ARGUMENT0" => "O_UNARY_FUNCTIONAL_OPEN_LR"
                                                                },
                                                    "THEN77" => {
                                                                   "RELATION0" => "EXPRESSION_LIST",
                                                                   "END_ARGUMENT0" => "O_UNARY_FUNCTIONAL_CLOSE_LR"
                                                                },
                                                    "ELSE77" => {
                                                                  "IF167" => {
                                                                                "BEGIN_SUBSCRIPT0" => "O_UNARY_SUBSCRIPT_OPEN_LR"
                                                                             },
                                                                "THEN167" => {
                                                                                    "RELATION0" => "EXPRESSION",
                                                                                "END_SUBSCRIPT0" => "O_UNARY_SUBSCRIPT_CLOSE_LR"
                                                                             },
                                                                "ELSE167" => {
                                                                             }
                                                                }
                                                  },
                             "FACTOR_EXPRESSION" => {
                                                      "BEGIN_FACTOr_EXPRESSION0" => "O_UNARY_FUNCTIONAL_OPEN_LR",
                                                                     "RELATION1" => "EXPRESSION",
                                                        "END_FACTOr_EXPRESSION0" => "O_UNARY_FUNCTIONAL_CLOSE_LR"                                                       
                                                    },
                             "FACTOR" => { 
                                           "OR12" => {
                                                        "RELATION0_12"  => "VAR_OR_FUNCTION",
                                                        "RELATION1_12"  => "STRING",
                                                        "RELATION2_12"  => "NUM", # to be replaced with NUM
                                                        "RELATION3_12"  => "FACTOR_EXPRESSION",
                                                        "RELATIOnS1_12" => "NOT FACTOR" # ??? what could this be???
                                                     }
                                         },
                             "NOT"  => { #TBD
                                          "0" => "O_UNARY_LOGICAL_NOT_RL"
                                       },                                        
                             "UNARY" => {
                                          "OR11" => {
                                                       "0" => "O_UNARY_PREFIX_OR_ADDITION_RL_LR",
                                                       "1" => "O_UNARY_PREFIX_OR_SUBTRACTION_RL_LR",
                                                       "2" => "O_UNARY_BITWISE_NOT_RL"
#                                                       "3" => "O_BITWISE_AND_LR"
#                                                       "4" => "O_BITWISE_XOR_LR"
                                                    }
                                       },
                             "RELOP" => {
                                          "OR18" => {
                                                      "0" => "O_EQUALITY_INEQUALITY_LR",              # !=
                                                      "1" => "O_EQUALITY_EQUALITY_LR",                # ==
                                                      "2" => "O_RELATIONAL_BIGGER_THAN_LR",           # >
                                                      "3" => "O_RELATIONAL_BIGGER_OR_EQUAL_THAN_LR",  # >=
                                                      "4" => "O_RELATIONAL_SMALLER_THAN_LR",          # <  
                                                      "5" => "O_RELATIONAL_SMALLER_OR_EQUAL_THAN_LR" # <=
                                         } 
                             },
                             "MULOP" => { 
                                          "OR33" => {
                                                       "0" => "O_ARITHMETIC_MULTIPLY_LR", #"*"
                                                       "1" => "O_ARITHMETIC_MODULO_LR",   #"%"
                                                       "2" => "O_ARITHMETIC_DIVIDE_LR"    #"/"
                                                    }
                                        },
                             "ADDOP" => {
                                          "OR19" => {
                                                      "0" => "O_UNARY_PREFIX_OR_ADDITION_RL_LR",      # +   
                                                      "11" => "O_UNARY_PREFIX_OR_SUBTRACTION_RL_LR",  # -
                                                      "15" => "O_BITWISE_SHIFT_RIGHT_LR",             # >>
                                                      "16" => "O_BITWISE_SHIFT_LEFT_LR",              # <<
                                                      "23" => "O_BITWISE_AND_LR",                     # &
                                                      "24" => "O_BITWISE_XOR_LR",                     # ^
                                                      "25" => "O_BITWISE_OR_LR",                       # |
                                                      "26" => "O_UNARY_BITWISE_NOT_RL"                # ~
                                                 }
                                        },
                             "INCREMENT_DECREMENT" => {
                                                       "OR88" => {
                                                                   "0" => "O_UNARY_INCREMENT",                           # ++ 
                                                                   "1" => "O_UNARY_DECREMENT",                           # --
                                                                 }
                                                      },
                             "ASSIGNOP" => {
                                             "OR300" => {
                                                          "28" => "O_ASSIGNMENT_RL",                              # = 
                                                          "29" => "O_COMPOUND_ASSIGNMENT_MULTIPLY_RL",            # *=
                                                          "30" => "O_COMPOUND_ASSIGNMENT_DIVIDE_RL",              # /=
                                                          "31" => "O_COMPOUND_ASSIGNMENT_MODULO_RL",              # %=
                                                          "32" => "O_COMPOUND_ASSIGNMENT_ADDITION_RL",            # +=
                                                          "33" => "O_COMPOUND_ASSIGNMENT_SUBSTRACTION_RL",        # -=
                                                          "34" => "O_COMPOUND_ASSIGNMENT_BITWISE_SHIFT_RIGHT_RL", # >>=
                                                          "35" => "O_COMPOUND_ASSIGNMENT_BITWISE_SHIFT_LEFT_RL",  # <<=
                                                          "36" => "O_COMPOUND_ASSIGNMENT_BITWISE_AND_RL",         # &=
                                                          "37" => "O_COMPOUND_ASSIGNMENT_BITWISE_XOR_RL",         # ^=
                                                          "38" => "O_COMPOUND_ASSIGNMENT_BITWISE_OR_RL",          # |=
                                                          "39" => "O_COMPOUND_ASSIGNMENT_BITWISE_NEG_RL"          # ~=
                                                        }
                                           },
                             "operand" => {
                                             "OR10" => {
                                                          "3" => "O_UNARY_SUBSCRIPT_OPEN_LR",                   # [
                                                          "4" => "O_UNARY_SUBSCRIPT_CLOSE_LR",                  # ] 
                                                          "5" => "O_UNARY_INCREMENT",                           # ++ 
                                                          "6" => "O_UNARY_DECREMENT",                           # --
                                                          "7" => "O_UNARY_MEMBER_ACCESS_LR",                    # .
                                                          "8" => "O_UNARY_LOGICAL_NOT_RL",                      # !
                                                          "9" => "O_UNARY_BITWISE_NOT_RL",                      # ~
                                                         "10" => "O_UNARY_PREFIX_OR_ADDITION_RL_LR",             # +
                                                         "11" => "O_UNARY_PREFIX_OR_SUBTRACTION_RL_LR",          # -
                                                         "12" => "O_ARITHMETIC_MULTIPLY_LR",                     # *
                                                         "13" => "O_ARITHMETIC_MODULO_LR",                       # %
                                                         "14" => "O_ARITHMETIC_DIVIDE_LR",                       # /
                                                         "15" => "O_BITWISE_SHIFT_RIGHT_LR",                     # >>
                                                         "16" => "O_BITWISE_SHIFT_LEFT_LR",                      # <<
                                                         "17" => "O_EQUALITY_INEQUALITY_LR",                     # !=
                                                         "18" => "O_EQUALITY_EQUALITY_LR",                       # == 
                                                         "19" => "O_RELATIONAL_BIGGER_THAN_LR",                  # >
                                                         "20" => "O_RELATIONAL_BIGGER_OR_EQUAL_THAN_LR",         # >=
                                                         "21" => "O_RELATIONAL_SMALLER_THAN_LR",                 # <
                                                         "22" => "O_RELATIONAL_SMALLER_OR_EQUAL_THAN_LR",        # <=
                                                         "23" => "O_BITWISE_AND_LR",                             # &
                                                         "24" => "O_BITWISE_XOR_LR",                             # ^
                                                         "25" => "O_BITWISE_OR_LR",                              # |
                                                         "26" => "O_LOGICAL_AND_LR",                             # &&
                                                         "27" => "O_LOGICAL_OR_LR",                              # ||
                                                         "28" => "O_ASSIGNMENT_RL",                              # =
                                                         "29" => "O_COMPOUND_ASSIGNMENT_MULTIPLY_RL",            # *=
                                                         "30" => "O_COMPOUND_ASSIGNMENT_DIVIDE_RL",              # /=
                                                         "31" => "O_COMPOUND_ASSIGNMENT_MODULO_RL",              # %=
                                                         "32" => "O_COMPOUND_ASSIGNMENT_ADDITION_RL",            # +=
                                                         "33" => "O_COMPOUND_ASSIGNMENT_SUBSTRACTION_RL",        # -=
                                                         "34" => "O_COMPOUND_ASSIGNMENT_BITWISE_SHIFT_RIGHT_RL", # >>=
                                                         "35" => "O_COMPOUND_ASSIGNMENT_BITWISE_SHIFT_LEFT_RL",  # <<=
                                                         "36" => "O_COMPOUND_ASSIGNMENT_BITWISE_AND_RL",         # &=
                                                         "37" => "O_COMPOUND_ASSIGNMENT_BITWISE_XOR_RL",         # ^=
                                                         "38" => "O_COMPOUND_ASSIGNMENT_BITWISE_OR_RL",          # |=
                                                         "39" => "O_COMPOUND_ASSIGNMENT_BITWISE_NEG_RL"          # ~=
                                                      }
                                          }
                    }
    @syntanxRelationshipsForbiden = { 
                                    }
  end
  
  def isToken?(word2Check)
    @keywordList.each_with_index.map do |keyword, index|
      if (keyword == word2Check)
        #print "typeOfKeyword ", @typeOfKeyword[index], "\nindex : ", index, " \n"
        return @typeOfToken[index]
      end
    end
   return "T_NA"
  end
  
  def isTypeOfToken(word2Check)
    found = @typeOfToken.values.select {|v| v == word2Check}
    if found.length > 0
      return true
    else
      return false
    end
  end

  def isInTypeOperand?(word2Check)
    @typeOfOperand.each do |operand_key, operand_value|
      if (operand_value == word2Check)
        return true
      end
    end
    return false
  end

  def isTypeOfConst?(word2Check)
    @typeOfCons.each do |type_key, type_value|
      if (type_value == word2Check)
        return true
      end
    end
    return false
  end

  def isOperand?(word2Check)
    @operandList.each_with_index.map do |operand, index|
      if (operand == word2Check)
        #print "typeOfOperand ", @typeOfOperand[index], "\nindex : ", index, " \n"
        return @typeOfOperand[index]
      end
    end
    return "O_NA"
  end
  
  def getRelationships(relation)
    @syntanxRelationships.each do |relation_key, relations|
#      puts "getRelationShips #{__LINE__} relation_key: #{relation_key} - relation #{relations}"
      if (relation_key == relation)
        return relations
      end
    end
   return "R_NA"
  end
  
  
  def getForbidenRelationships?(relation)
    @syntanxRelationshipsForbiden.each do |relation_key, relations|
      if (relation_key == relation)
        return relations
      end
    end
    return "R_NA"
  end

#   def getRelationships(relation)
#      @syntanxRelationships.each_with_index.map do |relationships, index|
#          if (relationship == relation)
#          return @syntanxRelationships[index]
#          end
#      end
#     return "R_NA"
#  end 

  def isAlpha?(str)
    valid_chars = [*?a..?z, *?A..?Z, *'0'..'9', *'.']
    str.chars.all? do |ch| 
      valid_chars.include?(ch)
    end
  end  

  def isAlphaNumeric?(str)
    valid_chars = [*?a..?z, *?A..?Z, *'0'..'9', *'.']
    str.chars.all? do |ch| 
      valid_chars.include?(ch)
    end
  end  

  def isNumeric?(str)
    valid_chars = [*'0'..'9']
    str.chars.all? do |ch| 
      valid_chars.include?(ch)
    end
  end  
 
end #class Syntax
end #module
