require_relative 'version.rb'
require_relative 'syntaxPTW.rb'
require_relative 'LexicalAnalyzer.rb'

module RubyScript2CAPL

class SyntaxAnalyzer
  attr_accessor :keywords, :error, :errorList, :specialChar
  attr_accessor :includeFiles, :functionNames, :variableNames

  def initialize(sourceFile)
    puts "Script syntax checker version #{VERSIONSYNTAXCHECKER} Initialized"
    @syntax = SyntaxPTW.new()
    @lexical = LexicalAnalyzer.new(sourceFile)
    @debugLevel = 0
    @debugSyntax = false
    @includeFiles = Array.new
    @functionNames = Hash.new # {"functionName" => {0 => "param1", 1 => "param2"}
    @variableNames = Array.new # {"variableName1", "variableName2", etc.}
    @error = Hash.new #{ "Error Name" => {0 => "Linenumber",     1 => "whatkindoferror",       2 => "awaiting values are"               }
                      #    generated         codeGenerated      key@errorList=>0 or 1       generated based on relations
    @errorList = {0 => "not a relationship", 1 => "forbidenRelation" }
    @fileName = sourceFile 
  end

  def setDebugLevel(level)
    @debugLevel = level
    @lexical.setDebugLevel(level)
  end

  def printDebugInfo(file, line, level, messageInfo)
    if (@debugLevel >= level)
      puts("#{file}:#{line} #{messageInfo}")
    end
  end

  def activateSyntaxDebugger
    @debugSyntax = true
  end

  def findWordInRelationShip(word, relationShips_, atPosition)
    if relationShips_.values[atPosition].is_a?(Hash)
    #relationShips_.each do |relation_key, relations|
      relationShips_.values[atPosition].each_with_index do |(relation_key, relations), index|
        if (relations.is_a?(Hash))
          key = findWordInRelationShip(word, relations, index)
          relations.each do |r_key, rels|
            if key == r_key 
              return relation_key
            end
          end
        else
          if (relations == word)
            return relation_key
          end
        end
      end
    end
    return "R_NA"
  end

  def toggle(variable)
    if (variable)
      return false
    else
      return true
    end
  end

  def addKeyValue(hashVariableRef, hashVariableTarget, type, defaultValue)
    case type
    when "boolean"
      hashVariableRef.each do |key, value|
        hashVariableTarget.store(key, defaultValue)
      end
    end
  end

  def checkIfSyntaxPassed(hashVariable)
    hashVariable.each do |key, value|
      if value == false
        return false
      end 
    end
    return true 
  end

  def checkIfRelationCanBeMissing(hashVariable)
    hashVariable.each do |key, value| 
      if value == "MISSING"
        return true
      end
    end
    return false 
  end

  def insertNewRelationShip(relationShipHash, key, pair, proximity=:before)
    #relationShipHash.to_a.insert(relationShipHash.keys.index(key) + (proximity==:after ? 1 : 0), pair.first).to_h
    keys = relationShipHash.keys
    before_keys =
    case proximity
    when :before
      key==keys.first ? [[], keys] : keys.slice_before { |k| k == key }
    when :after
      keys.slice_after { |k| k == key }
    end.first
    relationShipHash.select { |k,_| before_keys.include? k }.
      update(pair).
      update(relationShipHash.reject { |k,_| before_keys.include? k })
  end  

  def solveConflicts(getRelationShips, newHasRelationShips)
    clone_getRelationShips = getRelationShips.clone
    getRelationShips.each_with_index do |(gRel, gRelValue), gIndex|
      mergedHases = newHasRelationShips.merge(clone_getRelationShips).sort.to_h
      rels = newHasRelationShips.keys.select {|k| k == gRel}
      new_gRel = gRel
      if !new_gRel.include?("THEN") and !new_gRel.include?("ELSE")
        while rels.length > 0
          if new_gRel.include?("RELATION")
            gRelNumber = new_gRel.gsub("RELATION","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "RELATION#{gRelNumber}"
          elsif new_gRel.include?("RELATIOnS")
            gRelNumber = new_gRel.gsub("RELATIOnS","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "RELATIOnS#{gRelNumber}"
          elsif new_gRel.include?("IF")
            gRelNumber = new_gRel.gsub("IF","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "IF#{gRelNumber}"
            new_gRelTHEN = "THEN#{gRelNumber}"
            new_gRelELSE = "ELSE#{gRelNumber}"
          elsif new_gRel.include?("OrLOOP")
            gRelNumber = new_gRel.gsub("OrLOOP","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "OrLOOP#{gRelNumber}"
          elsif new_gRel.include?("OR")
            gRelNumber = new_gRel.gsub("OR","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "OR#{gRelNumber}"
          elsif new_gRel.include?("BEGIN_INNER_BLOCK")
            gRelNumber = new_gRel.gsub("BEGIN_INNER_BLOCK","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "BEGIN_INNER_BLOCK#{gRelNumber}"
          elsif new_gRel.include?("END_INNER_BLOCK")
            gRelNumber = new_gRel.gsub("END_INNER_BLOCK","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "END_INNER_BLOCK#{gRelNumber}"
          elsif new_gRel.include?("BEGIN_FoR_ARGUMENT")
            gRelNumber = new_gRel.gsub("BEGIN_FoR_ARGUMENT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "BEGIN_FoR_ARGUMENT#{gRelNumber}"
          elsif new_gRel.include?("END_FoR_ARGUMENT")
            gRelNumber = new_gRel.gsub("END_FoR_ARGUMENT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "END_FoR_ARGUMENT#{gRelNumber}"
          elsif new_gRel.include?("END_DO_WHILE")
            gRelNumber = new_gRel.gsub("END_DO_WHILE","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "END_DO_WHILE#{gRelNumber}"
          elsif new_gRel.include?("BEGIN_ARGUMENT")
            gRelNumber = new_gRel.gsub("BEGIN_ARGUMENT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "BEGIN_ARGUMENT#{gRelNumber}"
          elsif new_gRel.include?("END_ARGUMENT")
            gRelNumber = new_gRel.gsub("END_ARGUMENT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "END_ARGUMENT#{gRelNumber}"
          elsif new_gRel.include?("BEGIN_CaLL_ARGUMENT")
            gRelNumber = new_gRel.gsub("BEGIN_CaLL_ARGUMENT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "BEGIN_CaLL_ARGUMENT#{gRelNumber}"
          elsif new_gRel.include?("END_CaLL_ARGUMENT")
            gRelNumber = new_gRel.gsub("END_CaLL_ARGUMENT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "END_CaLL_ARGUMENT#{gRelNumber}"
          elsif new_gRel.include?("BEGIN_SUBSCRIPT")
            gRelNumber = new_gRel.gsub("BEGIN_SUBSCRIPT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "BEGIN_SUBSCRIPT#{gRelNumber}"
          elsif new_gRel.include?("END_SUBSCRIPT")
            gRelNumber = new_gRel.gsub("END_SUBSCRIPT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "END_SUBSCRIPT#{gRelNumber}"
          elsif new_gRel.include?("BEGIN_FACTOr_EXPRESSION")
            gRelNumber = new_gRel.gsub("BEGIN_FACTOr_EXPRESSION","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "BEGIN_FACTOr_EXPRESSION#{gRelNumber}"
          elsif new_gRel.include?("END_FACTOr_EXPRESSION")
            gRelNumber = new_gRel.gsub("END_FACTOr_EXPRESSION","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "END_FACTOr_EXPRESSION#{gRelNumber}"
          elsif new_gRel.include?("BEGIN_If_ARGUMENT")
            gRelNumber = new_gRel.gsub("BEGIN_If_ARGUMENT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "BEGIN_If_ARGUMENT#{gRelNumber}"
          elsif new_gRel.include?("END_If_ARGUMENT")
            gRelNumber = new_gRel.gsub("END_If_ARGUMENT","").to_i
            gRelNumber = gRelNumber + 1
            new_gRel = "END_If_ARGUMENT#{gRelNumber}"
          else
            new_gRel = (new_gRel.to_i + 1).to_s
          end
          rels = mergedHases.keys.select {|k| k == new_gRel}
        end
      end
      if new_gRel != gRel
        if new_gRel.include?("IF")
          gRelNumberTHEN_ELSE = gRel.gsub("IF","").to_i
          gIndexTHEN = getRelationShips.find_index {|k,_| k == "THEN#{gRelNumberTHEN_ELSE}"}
          gRelValueTHEN = clone_getRelationShips.values[gIndexTHEN]
          gIndexELSE = getRelationShips.find_index {|k,_| k == "ELSE#{gRelNumberTHEN_ELSE}"}
          gRelValueELSE = clone_getRelationShips.values[gIndexELSE]
          clone_getRelationShips = insertNewRelationShip(clone_getRelationShips, clone_getRelationShips.keys[gIndex],     Hash["#{new_gRel}",    gRelValue], :after)
          clone_getRelationShips = insertNewRelationShip(clone_getRelationShips, clone_getRelationShips.keys[gIndexTHEN], Hash["#{new_gRelTHEN}",gRelValueTHEN], :after)
          clone_getRelationShips = insertNewRelationShip(clone_getRelationShips, clone_getRelationShips.keys[gIndexELSE], Hash["#{new_gRelELSE}",gRelValueELSE], :after)
          clone_getRelationShips.delete(gRel) #IF
          clone_getRelationShips.delete("THEN#{gRelNumberTHEN_ELSE}") #THEN
          clone_getRelationShips.delete("ELSE#{gRelNumberTHEN_ELSE}") #ELSE
        elsif new_gRel.include?("OrLOOP") or new_gRel.include?("OR") or new_gRel.include?("RELATION") or new_gRel.include?("RELATIOnS") or
              new_gRel.include?("BEGIN_INNER_BLOCK") or new_gRel.include?("END_INNER_BLOCK") or 
              new_gRel.include?("BEGIN_FoR_ARGUMENT") or new_gRel.include?("END_FoR_ARGUMENT") or
              new_gRel.include?("END_DO_WHILE") or 
              new_gRel.include?("BEGIN_ARGUMENT") or new_gRel.include?("END_ARGUMENT")
              new_gRel.include?("BEGIN_CaLL_ARGUMENT") or new_gRel.include?("END_CaLL_ARGUMENT")
              new_gRel.include?("BEGIN_SUBSCRIPT") or new_gRel.include?("END_SUBSCRIPT")
              new_gRel.include?("BEGIN_FACTOr_EXPRESSION") or new_gRel.include?("END_FACTOr_EXPRESSION")              
              new_gRel.include?("BEGIN_If_ARGUMENT") or new_gRel.include?("END_If_ARGUMENT")              
              
          clone_getRelationShips = insertNewRelationShip(clone_getRelationShips, clone_getRelationShips.keys[gIndex], Hash["#{new_gRel}",gRelValue], :after)
          clone_getRelationShips.delete(gRel)
        else  
          clone_getRelationShips = insertNewRelationShip(clone_getRelationShips, clone_getRelationShips.keys[gIndex], Hash["#{new_gRel}",gRelValue], :after)
          clone_getRelationShips.delete(gRel)
        end

      end
    end
    getRelationShips = clone_getRelationShips
end

  def refineRelationShips(hasRelationShips, positionToCheckWord, word, depth)
    if hasRelationShips.empty?
      return Hash["replace",Hash["#{depth}",hasRelationShips]]      
    end
    newHasRelationShips = hasRelationShips.clone 
    orsFound = newHasRelationShips.keys.select {|k| k.include? "OR"}
    relationFound = newHasRelationShips.keys.select {|k| k.include? "RELATION"}
    relationsFound = newHasRelationShips.keys.select {|k| k.include? "RELATIOnS"}
    ifFound = newHasRelationShips.keys.select {|k| k.include? "IF"}
    printDebugInfo(File.basename(__FILE__), __LINE__, 8, " newHasRelationShips #{newHasRelationShips}")
    printDebugInfo(File.basename(__FILE__), __LINE__, 8, " orsFound #{orsFound}")
    printDebugInfo(File.basename(__FILE__), __LINE__, 8, " relationFound #{relationFound}")
    printDebugInfo(File.basename(__FILE__), __LINE__, 8, " relations #{relationsFound}")
    printDebugInfo(File.basename(__FILE__), __LINE__, 8, " ifFound #{ifFound}")

    if newHasRelationShips.values[positionToCheckWord] == word
      #printDebugInfo(File.basename(__FILE__), __FILE__, @debugLevel, " #{word} word in values[positionToCheckWord]")
      if newHasRelationShips.keys[positionToCheckWord].include?("IF")
      elsif newHasRelationShips.keys[positionToCheckWord].include?("OR")
      end
    else
#      printDebugInfo(File.basename(__FILE__), __FILE__, @debugLevel, " #{word} word NOT in values[positionToCheckWord]")
#      printDebugInfo(File.basename(__FILE__), __FILE__, @debugLevel, " newHasRelationShips: #{newHasRelationShips}")
#      printDebugInfo(File.basename(__FILE__), __FILE__, @debugLevel, " positionToCheckWord: #{positionToCheckWord}")
      if newHasRelationShips.keys[positionToCheckWord].include?("IF")
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, " newHasRelationShips.keys[#{positionToCheckWord}].include?(\"IF\")")
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, " newHasRelationShips #{newHasRelationShips}")
        ifNumber = newHasRelationShips.keys[positionToCheckWord].gsub("IF","")
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, " ifNumber #{ifNumber}")
        findWordInIF = newHasRelationShips[newHasRelationShips.keys[positionToCheckWord]].values.find {|v| v.include? "#{word}"}
        findWordInELSE = newHasRelationShips["ELSE#{ifNumber}"].values.find {|v| v.include? "#{word}"}
        a = newHasRelationShips[newHasRelationShips.keys[positionToCheckWord]]
        if findWordInIF.nil? and findWordInELSE.nil?
          # search again
          if !newHasRelationShips[newHasRelationShips.keys[positionToCheckWord]].keys.find {|v| v.include? ("RELATIO" or "OR")}.nil?
            getRelationShips = refineRelationShips(newHasRelationShips[newHasRelationShips.keys[positionToCheckWord]], 0, word, depth + 1)
            shouldReplace = getRelationShips.keys.select { |k,v| k.include? "replace"}
            shouldAdd  = getRelationShips.keys.select { |k,v| k.include? "add"}
            if shouldReplace.length > 0
              if getRelationShips.is_a?(Hash)
                newHasRelationShips = insertNewRelationShip(newHasRelationShips, "IF#{ifNumber}", Hash["IF#{ifNumber}",getRelationShips["replace"].values[0]], :after)
              end
            end
            findWordInIF = newHasRelationShips[newHasRelationShips.keys[positionToCheckWord]].values.find { |v| v.include? "#{word}" }
          end
        end

        if !findWordInIF.nil?  # THEN+number

          getRelationShips = newHasRelationShips["IF#{ifNumber}"]

          if getRelationShips.is_a?(Hash)
            getRelationShips = solveConflicts(getRelationShips, newHasRelationShips)
          end
  
          newHasRelationShips = insertNewRelationShip(newHasRelationShips, "IF#{ifNumber}", getRelationShips, :after)
          findWord = hasRelationShips["THEN#{ifNumber}"].values.find {|k| k.include? "#{word}"}

          getRelationShips = hasRelationShips["THEN#{ifNumber}"]
          if getRelationShips.is_a?(Hash)
            getRelationShips = solveConflicts(getRelationShips, newHasRelationShips)
          end
  
          newHasRelationShips = insertNewRelationShip(newHasRelationShips, "THEN#{ifNumber}", getRelationShips, :after)
          newHasRelationShips.delete("IF#{ifNumber}")
          newHasRelationShips.delete("THEN#{ifNumber}")
          newHasRelationShips.delete("ELSE#{ifNumber}")
        else               # ELSE+number

          getRelationShips = hasRelationShips["ELSE#{ifNumber}"]
          if getRelationShips.is_a?(Hash) and !getRelationShips.empty?
            getRelationShips = solveConflicts(getRelationShips, newHasRelationShips)
          else
            currentIndex = hasRelationShips.find_index {|k,_| k == "ELSE#{ifNumber}"}
            getNextIndexKey = currentIndex + 1
            getNextKey = hasRelationShips.keys[getNextIndexKey]
          end
  
          newHasRelationShips = insertNewRelationShip(newHasRelationShips, "ELSE#{ifNumber}", getRelationShips, :after)
          findWord = hasRelationShips["ELSE#{ifNumber}"].values.find {|k| k.include? "#{word}"}
          newHasRelationShips.delete("IF#{ifNumber}")
          newHasRelationShips.delete("THEN#{ifNumber}")
          newHasRelationShips.delete("ELSE#{ifNumber}")
          if getRelationShips.empty?# and !getNextKey.include?("IF")
            getRelationShips = refineRelationShips(newHasRelationShips, positionToCheckWord, word, depth + 1)
            shouldReplace = getRelationShips.keys.select { |k,v| k.include? "replace"}
            shouldAdd  = getRelationShips.keys.select { |k,v| k.include? "add"}
            if shouldReplace.length > 0
              if getRelationShips.is_a?(Hash)
                newHasRelationShips = getRelationShips["replace"].values[0].clone
              end
            end
          elsif findWord.nil?
            getRelationShips = refineRelationShips(newHasRelationShips, positionToCheckWord, word, depth + 1)
            shouldReplace = getRelationShips.keys.select { |k,v| k.include? "replace"}
            shouldAdd  = getRelationShips.keys.select { |k,v| k.include? "add"}
            if shouldReplace.length > 0
              if getRelationShips.is_a?(Hash)
                newHasRelationShips = getRelationShips["replace"].values[0].clone
              end
            end
          end
        end
        return Hash["replace",Hash["#{depth}",newHasRelationShips]]
 
      elsif newHasRelationShips.keys[positionToCheckWord].include?("OR")
        #printDebugInfo(File.basename(__FILE__), __FILE__, @debugLevel, " newHasRelationShips: #{newHasRelationShips}")
        keyToDelete = newHasRelationShips.keys[positionToCheckWord]
        newHasRelationShips.values[positionToCheckWord].values.find { |v| v.include? "#{word}"}
        wordInOR = newHasRelationShips.values[positionToCheckWord].select { |k,v| v.include? "#{word}"}
        if !wordInOR.empty?
          wordInOR = solveConflicts(wordInOR, newHasRelationShips)
          newHasRelationShips = insertNewRelationShip(newHasRelationShips, newHasRelationShips.keys[positionToCheckWord], wordInOR, :after)
          newHasRelationShips.delete(newHasRelationShips.keys[positionToCheckWord])
          return Hash["replace",Hash["#{depth}",newHasRelationShips]]

        else
#          newHasRelationShips_ = newHasRelationShips.clone
#          relationShip = newHasRelationShips_.values[positionToCheckWord] 
          newHasRelationShips_ = newHasRelationShips.values[positionToCheckWord].clone
          relationShip = newHasRelationShips_.clone
          relShip = Hash.new
          rels = relationShip.keys.select { |k,v| k.include? "RELATIO"}
          rels.each_with_index do |rel, index|
            relationShip_ = refineRelationShips(Hash[rel,relationShip[rel]], 0, word, depth + 1)
            shouldReplace = relationShip_.keys.select { |k,v| k.include? "replace"}
            shouldAdd  = relationShip_.keys.select { |k,v| k.include? "add"}
            wordInRelation = relationShip_["replace"].values[0].values[0]
            if word == relationShip_["replace"].values[0].values[0]
              if shouldReplace.length > 0
                #printDebugInfo(File.basename(__FILE__), __FILE__, @debugLevel, " #{relationShip_}")
                if relationShip_.is_a?(Hash)
                  relationShip_ = solveConflicts(relationShip_["replace"].values[0], relationShip)
                end
                newHasRelationShips_ = insertNewRelationShip(newHasRelationShips_, relationShip.keys[index], relationShip_, :after)
                newHasRelationShips_.delete(relationShip.keys[index])
              end

            else
              newHasRelationShips_.delete(relationShip.keys[index])
            end
          end
          newHasRelationShips_ = solveConflicts(newHasRelationShips_, newHasRelationShips)
          newHasRelationShips = insertNewRelationShip(newHasRelationShips, keyToDelete, newHasRelationShips_, :after)
          newHasRelationShips.delete(newHasRelationShips.keys[positionToCheckWord])
          return Hash["replace",Hash["#{depth}",newHasRelationShips]]

        end                                                                        

      elsif newHasRelationShips.keys[positionToCheckWord].include?("OrLOOP")
        #printDebugInfo(File.basename(__FILE__), __FILE__, @debugLevel, " newHasRelationShips: #{newHasRelationShips}")
        keyToDelete = newHasRelationShips.keys[positionToCheckWord]
        newHasRelationShips.values[positionToCheckWord].values.find { |v| v.include? "#{word}"}
        wordInOR = newHasRelationShips.values[positionToCheckWord].select { |k,v| v.include? "#{word}"}
        if !wordInOR.empty?
          if wordInOR.is_a?(Hash)
            wordInOR = solveConflicts(wordInOR, newHasRelationShips)
          end
          newHasRelationShips = insertNewRelationShip(newHasRelationShips, newHasRelationShips.keys[positionToCheckWord], wordInOR, :after)
          newHasRelationShips.delete(newHasRelationShips.keys[positionToCheckWord])
          return Hash["replace",Hash["#{depth}",newHasRelationShips]]
        else
          newHasRelationShips_ = newHasRelationShips.values[positionToCheckWord].clone
          relationShip = newHasRelationShips_.clone
          relShip = Hash.new
#          rels = relationShip.keys.select { |k,v| k.include? "RELATIO"}
          rels = relationShip.keys.select { |k,v| k}
          rels.each_with_index do |rel, index|
            relationShip_ = refineRelationShips(Hash[rel,relationShip[rel]], 0, word, depth + 1)
            shouldReplace = relationShip_.keys.select { |k,v| k.include? "replace"}
            shouldAdd  = relationShip_.keys.select { |k,v| k.include? "add"}
            wordInRelation = relationShip_["replace"].values[0].values[0]
            if word == relationShip_["replace"].values[0].values[0]
              if shouldReplace.length > 0
#                printDebugInfo(File.basename(__FILE__), __FILE__, @debugLevel, " #{relationShip_}")
                if relationShip_.is_a?(Hash)
                  relationShip_ = solveConflicts(relationShip_["replace"].values[0], relationShip)
                end
                newHasRelationShips_ = insertNewRelationShip(newHasRelationShips_, relationShip.keys[index], relationShip_, :after)
                newHasRelationShips_.delete(relationShip.keys[index])
              end

            else
              newHasRelationShips_.delete(relationShip.keys[index])
            end
          end
          newHasRelationShips_ = solveConflicts(newHasRelationShips_, newHasRelationShips)
          newHasRelationShips = insertNewRelationShip(newHasRelationShips, keyToDelete, newHasRelationShips_, :before)
#          newHasRelationShips.delete(newHasRelationShips.keys[positionToCheckWord])
          return Hash["replace",Hash["#{depth}",newHasRelationShips]]

        end                                                                        

      elsif newHasRelationShips.keys[positionToCheckWord].include?("RELATION")
        relationShip = newHasRelationShips.values[positionToCheckWord]
        getRelationShips = @syntax.getRelationships(relationShip)
        getRelationShips_ = {}
        n = 0 
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "word #{word} | wordInOR #{wordInOR} | getRelationShips #{getRelationShips}")
        wordInOR = getRelationShips.select { |k,v| v.include? "#{word}"}
        while wordInOR.empty? and n < 1000 and getRelationShips_ != getRelationShips
          getRelationShips_ = getRelationShips
          getRelationShips = refineRelationShips(getRelationShips, 0, word, depth + 1)
          shouldReplace = getRelationShips.keys.select { |k,v| k.include? "replace"}
          shouldAdd  = getRelationShips.keys.select { |k,v| k.include? "add"}
          if shouldReplace.length > 0
            if getRelationShips.is_a?(Hash)
              getRelationShips = getRelationShips["replace"].values[0].clone
            end
          end
          wordInOR = getRelationShips.select { |k,v| v.include? "#{word}"}
          n = n + 1
        end
        if !wordInOR.empty?
          # get all keys from newHasRelationShip and if found in gerRelationShips increment them
          if getRelationShips.is_a?(Hash)
            getRelationShips = solveConflicts(getRelationShips, newHasRelationShips)
          end
          newHasRelationShips = insertNewRelationShip(newHasRelationShips, newHasRelationShips.keys[positionToCheckWord], getRelationShips, :after)
          newHasRelationShips.delete(newHasRelationShips.keys[positionToCheckWord])
          return Hash["replace",Hash["#{depth}",newHasRelationShips]]
        else
#            clone_getRelationShips = getRelationShips.clone
#            relationShip_ = refineRelationShips(getRelationShips, 0, word, depth + 1)
#            shouldReplace = relationShip_.keys.select { |k,v| k.include? "replace"}
#            shouldAdd  = relationShip_.keys.select { |k,v| k.include? "add"}
#            if shouldReplace.length > 0
#              clone_getRelationShips = insertNewRelationShip(clone_getRelationShips, clone_getRelationShips.keys[0], relationShip_["replace"].values[0], :after)
#              if getRelationShips != clone_getRelationShips
#                clone_getRelationShips.delete(clone_getRelationShips.keys[0])
#              end
#            end
#            getRelationShips = clone_getRelationShips
            if getRelationShips.is_a?(Hash)
              getRelationShips = solveConflicts(getRelationShips, newHasRelationShips)
            end
            newHasRelationShips = insertNewRelationShip(newHasRelationShips, newHasRelationShips.keys[positionToCheckWord], getRelationShips, :after)
            newHasRelationShips.delete(newHasRelationShips.keys[positionToCheckWord])
            return Hash["replace",Hash["#{depth}",newHasRelationShips]]
        end
      
      elsif newHasRelationShips.keys[positionToCheckWord].include?("RELATIOnS")
        relationShips = newHasRelationShips.values[positionToCheckWord]
        newHasRelationShips_ = Hash.new
        n = 0
        relationShips.split(" ").each_with_index do |relationShip, index|
          getRelationShips = @syntax.getRelationships(relationShip)
          
          if getRelationShips != "R_NA"
            wordInOR = getRelationShips.select { |k,v| v.include? "#{word}"}
            if !wordInOR.empty?
              if getRelationShips.is_a?(Hash)
                getRelationShips = solveConflicts(getRelationShips, newHasRelationShips_)
              end
            else #dig more inside
#              clone_getRelationShips = getRelationShips.clone
#              relationShip_ = refineRelationShips(getRelationShips, 0, word, depth + 1)
#              shouldReplace = relationShip_.keys.select { |k,v| k.include? "replace"}
#              if shouldReplace.length > 0
#                clone_getRelationShips = insertNewRelationShip(clone_getRelationShips, clone_getRelationShips.keys[0], relationShip_["replace"].values[0], :after)
#                clone_getRelationShips.delete(clone_getRelationShips.keys[0])
#              end
#              getRelationShips = clone_getRelationShips
              if getRelationShips.is_a?(Hash)
                getRelationShips = solveConflicts(getRelationShips, newHasRelationShips_)
              end
            end
          else
            getRelationShips = {}
            getRelationShips.merge(Hash["#{n}","#{relationShip}"])
            if getRelationShips.is_a?(Hash)
              getRelationShips = solveConflicts(getRelationShips, newHasRelationShips_)
            end
          end
          newHasRelationShips_.merge!(getRelationShips)
          n = n + 1
        end
        newHasRelationShips = insertNewRelationShip(newHasRelationShips, newHasRelationShips.keys[positionToCheckWord], newHasRelationShips_, :after)
        newHasRelationShips.delete(newHasRelationShips.keys[positionToCheckWord])
        return Hash["replace",Hash["#{depth}",newHasRelationShips]]            

      end
    end
    return Hash["replace",Hash["#{depth}",hasRelationShips]]

  end

  def displayError(syntaxError)
    case syntaxError[:errorType]
    when "SYNTAX_ERROR"
      fileContent = File.readlines(@fileName)
      line = fileContent[syntaxError[:lineNumber]]
      puts "Syntax error at line #{syntaxError[:lineNumber]}"
      puts(line)
      charPosition = syntaxError[:charPosition]
      (0..(charPosition.to_i-1)).each do 
          putc "-"
      end
      puts "^"
      #puts "syntaxError[:wordNumber]-1: #{syntaxError[:wordNumber]-1}"
      #puts "line.split(" "): #{line.split(" ")}"
      #puts "line.split(" ")[syntaxError[:wordNumber]-1]: ->#{line.split(" ")[syntaxError[:wordNumber]-1]}<-"
    end
  end

  def checker()
    syntaxError = checkSyntax()
    if !syntaxError.nil?
      displayError(syntaxError)
      puts "Script syntax checker Done"
    end
  end

  def checkSyntax()
    puts "Script syntax checker Started"
    typeOfKeyword = "K_NA"  #Keyword notAvailable  
    typeOfOperand = "O_NA"  #Operand notAvailable  
    typeOfRelation = "R_NA" #Relationship notAvailable  

    nextIdentifier = false 
    nextString = false
    nextCompound2BeFound = false
    nextWord = ""
    includeFiles = Hash.new
    includeFilesIndex = -1
    functionDefinitions = Hash.new
    functionDefinitionsIndex = -1
    variables = Hash.new
    variableIndex = -1
    syntaxLevelFlow = Hash.new 
    syntaxLevelFlowIndex = -1
    syntaxRelations = Hash.new
    syntaxRelationsIndex = 0
    syntaxRelationsIndexStack = Array.new
    syntaxRelationsTAGsStack = Array.new
    checkingSyntaxRelations = false
    syntaxforbidenRelations = Hash.new
    syntaxRelationsOR = Hash.new
    forbidenRelations = Hash.new
    syntaxOK = true
    isError = "true"
    isActivated = {                          
                    "T_INCLUDE" => false,
                    "T_VAR"     => false,
                    "T_DEF"     => false,
                    "T_FOR"     => false,
                    "T_FOREACH" => false,
                    "T_IF"      => false,
                    "T_ELSE"    => false,
                    "T_ELSEIF"  => false,
                    "T_DO"      => false,
                    "T_PUTS"    => false,
                    "T_RETURN"  => false
                  }                            

    #puts tempFileContent
#    fileContent = File.open(@fileName).read        #open file tempFileContent for each which is a translation of the source
#    fileContent.gsub!(/\r\n?/,"\n")                      #replace all \r\n with \n only 
    word = ""
    aux_word = ""
    lastWord = ""
    syntaxWordIndex = 0
    hasRelationsShips = "R_NA"
    #fileContent.each_line.with_index do |line, lineNumber|  #for each line do the block below
    while not (lexicalInfo = @lexical.parseAndTranslateToSyntax())["retValue"].empty? do
      syntax2Check = lexicalInfo["retValue"]      
      printDebugInfo(File.basename(__FILE__), __LINE__, 8, "|-- syntax2Check: #{syntax2Check}")
      printDebugInfo(File.basename(__FILE__), __LINE__, 8, "| while not (syntax2Check = @lexical.parseAndTranslateToSyntax()).empty? do")
      wordsFromLine = syntax2Check.split(" ")                       #split line in chars
      if wordsFromLine[0] == "S_VALUE"
        stringValue = syntax2Check.clone
        stringValue.slice! "S_VALUE" 
        wordsFromLine = [wordsFromLine[0], stringValue]
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "|-- stringValue: #{stringValue}")
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "|-- wordsFromLine: #{wordsFromLine}")
      end
      printDebugInfo(File.basename(__FILE__), __LINE__, 8, "|-- syntax2Check: #{syntax2Check}")
#      printDebugInfo(File.basename(__FILE__), __LINE__, 8, "|-- lexicalInfo: #{lexicalInfo}")
      printDebugInfo(File.basename(__FILE__), __LINE__, 8, "|-- lineNumber: #{lexicalInfo["lineNumber"]} charCount: #{lexicalInfo["charCount"]}")
      word = ""
      aux_word = ""
      word_idx = 0
      isCompound = false
      isActivated = {
                      "T_INCLUDE" => false,
                      "T_DEF"     => false,
                      "T_FOR"     => false,
                      "T_FOREACH" => false,
                      "T_IF"      => false,
                      "T_ELSE"    => false,
                      "T_ELSEIF"  => false,
                      "T_DO"      => false,
                      "T_PUTS"    => false,
                      "T_RETURN"  => false
                    }
      
      compoundString = ""
      isTypeOfConst = {
                        "type" => "",
                        "value" => false
                      }
      hasRelationShips = nil


      while ( word_idx != wordsFromLine.length ) do          #parce each char until end of line
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "  | while ( word_idx < wordsFromLine.length ) do #{wordsFromLine.length} #{wordsFromLine}")        
        if aux_word == "S_VALUE"
          word = stringValue
        else
          word = wordsFromLine[word_idx]
        end
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "  |-- word_idx: #{word_idx} syntax2Check: #{syntax2Check}")        
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "  |-- word: #{word} syntaxWordIndex: #{syntaxWordIndex}")
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "  |-- syntaxLevelFlow: #{syntaxLevelFlow}")
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "  |-- syntaxLevelFlowIndex: #{syntaxLevelFlowIndex}")
#        word = word.split(":")[0]

        hasRelationShips = @syntax.getRelationships(word)
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "  |-- hasRelationShips: #{hasRelationShips}")
        if !aux_word.empty?
          printDebugInfo(File.basename(__FILE__), __LINE__, 8, "    | if !aux_word.empty? #{aux_word}")
          aux_word = ""
          printDebugInfo(File.basename(__FILE__), __LINE__, 8, "    | aux_word: #{aux_word}")
        else 
          printDebugInfo(File.basename(__FILE__), __LINE__, 8, "    | esle if !aux_word.empty? #{aux_word}")
          if (hasRelationShips != "R_NA")                     #syntaxLevelFlow store and increment index
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      | if (hasRelationShips != \"R_NA\") #{hasRelationShips}")
            #should be indexed and stored in the apropriate structures... TBC
            case word
            when "T_VAR"
              variableIndex = variableIndex + 1

            when "T_INCLUDE"
              includeFilesIndex = includeFilesIndex + 1

            when "T_DEF"
              functionDefinitionsIndex = functionDefinitionsIndex + 1

            end
            if (syntaxLevelFlowIndex > -1)
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        | if (syntaxLevelFlowIndex > -1) #{syntaxLevelFlowIndex}")
              syntaxRelationsIndexStack.insert(syntaxLevelFlowIndex, syntaxWordIndex)
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        |-- syntaxRelationsIndexStack: #{syntaxRelationsIndexStack}")
              syntaxWordIndex = 0
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        |-- syntaxWordIndex: #{syntaxWordIndex}")
            end 

            syntaxLevelFlowIndex = syntaxLevelFlowIndex + 1
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxLevelFlowIndex: #{syntaxLevelFlowIndex}") 
            syntaxLevelFlow.store(syntaxLevelFlowIndex, hasRelationShips)
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxLevelFlow: #{syntaxLevelFlow.inspect}") 

          else #(hasRelationsShips != "R_NA")                #use syntaxLevelFlow relations
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      | else if (hasRelationShips != \"R_NA\")")

            # refine relationship based on the if structure or relation
            syntaxLevelFlowBack = syntaxLevelFlow[syntaxLevelFlowIndex].clone
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxLevelFlow: #{syntaxLevelFlow}") 
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxLevelFlowBack: #{syntaxLevelFlowBack}") 

            # refine begin
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- word: #{word} ")
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxWordIndex: #{syntaxWordIndex}")              
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxLevelFlow[#{syntaxLevelFlowIndex}].keys[#{syntaxWordIndex}]: #{syntaxLevelFlow[syntaxLevelFlowIndex].keys[syntaxWordIndex]} ")
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxLevelFlow[#{syntaxLevelFlowIndex}].values[#{syntaxWordIndex}]: #{syntaxLevelFlow[syntaxLevelFlowIndex].values[syntaxWordIndex]}")
            newSyntaxLevelFlowRefined = refineRelationShips(syntaxLevelFlow[syntaxLevelFlowIndex], syntaxWordIndex, word, 0)
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- newSyntaxLevelFlowRefined #{newSyntaxLevelFlowRefined} ")
            shouldReplace = newSyntaxLevelFlowRefined.keys.select { |k,v| k.include? "replace"}
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- shouldReplace #{shouldReplace} ")
            shouldAdd  = newSyntaxLevelFlowRefined.keys.select { |k,v| k.include? "add"}
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- shouldAdd #{shouldAdd} ")
            if shouldReplace.length > 0
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        | if shouldReplace.length > 0 #{shouldReplace.length}")
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        |-- shouldReplace: #{shouldReplace}")
              syntaxLevelFlow.delete(syntaxLevelFlowIndex)
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        |-- syntaxLevelFlow: #{syntaxLevelFlow}")
              syntaxLevelFlow.store(syntaxLevelFlowIndex, newSyntaxLevelFlowRefined["replace"].values[0]) #refineRelationShips(syntaxLevelFlow[syntaxLevelFlowIndex], word) 
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        |-- syntaxLevelFlow.store(#{syntaxLevelFlowIndex}, #{newSyntaxLevelFlowRefined["replace"].values[0]}): #{syntaxLevelFlow}")
            end

            if shouldAdd.length > 0
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        | if shouldAdd.length > 0 #{shouldAdd.lenght}")
              if (syntaxLevelFlowIndex > -1)
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        | if syntaxLevelFlowIndex > -1 #{syntaxLevelFlowIndex}")
                syntaxRelationsIndexStack.insert(syntaxLevelFlowIndex, syntaxWordIndex)
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        |-- syntaxRelationsIndexStack: #{syntaxRelationsIndexStack}")
                syntaxWordIndex = 0
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        |-- syntaxWordIndex: #{syntaxWordIndex}")
              end 
              syntaxLevelFlowIndex = syntaxLevelFlowIndex + 1
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxLevelFlowIndex: #{syntaxLevelFlowIndex}")
              syntaxLevelFlow.store(syntaxLevelFlowIndex, hasRelationShips)
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxLevelFlow: #{syntaxLevelFlow}")
              syntaxWordIndex = 0
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- syntaxWordIndex: #{syntaxWordIndex}")
            end
            # refine ended
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- refined syntaxLevelFlow: #{syntaxLevelFlow.inspect}")
           
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- findWordInRelationShip: #{findWordInRelationShip(word, syntaxLevelFlow[syntaxLevelFlowIndex],syntaxWordIndex)}")
            subRelationShip = syntaxLevelFlow[syntaxLevelFlowIndex].keys[syntaxWordIndex]
            printDebugInfo(File.basename(__FILE__), __LINE__, 8, "      |-- subRelationShip: #{subRelationShip}")
            #subRelationShip = findWordInRelationShip(word, syntaxLevelFlow[syntaxLevelFlowIndex],"|---")

            if subRelationShip != "R_NA"
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        | if subRelationShip != \"R_NA\") #{subRelationShip}")
              if !syntaxLevelFlow[syntaxLevelFlowIndex].values[syntaxWordIndex].is_a?(Hash)
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "            | if !syntaxLevelFlow[syntaxLevelFlowIndex].values[syntaxWordIndex].is_a?(Hash) #{subRelationShip}")
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "            |-- syntaxLevelFlow[#{syntaxLevelFlowIndex}].values[#{syntaxWordIndex}] #{syntaxLevelFlow[syntaxLevelFlowIndex].values[syntaxWordIndex]}")
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "            |-- syntaxLevelFlow[#{syntaxLevelFlowIndex}].keys[#{syntaxWordIndex}] #{syntaxLevelFlow[syntaxLevelFlowIndex].keys[syntaxWordIndex]}")
                if syntaxLevelFlow[syntaxLevelFlowIndex].values[syntaxWordIndex] != word
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "              | if syntaxLevelFlow[syntaxLevelFlowIndex].values[syntaxWordIndex] != word")
                  printDebugInfo(File.basename(__FILE__),__LINE__, @debugLevel,  "              |-- word index: #{word_idx} word: #{word} syntaxWordIndex: #{syntaxWordIndex}")
                  #return {:errorType => "SYNTAX_ERROR", :lineNumber => lineNumber+1, :wordNumber => word_idx, :line => line}
                  return {:errorType => "SYNTAX_ERROR", :lineNumber => lexicalInfo["lineNumber"], :charPosition => lexicalInfo["charCount"]-1}
                  #return {:errorType => "SYNTAX_ERROR", :wordNumber => syntaxWordIndex}
                end
              else
                #in this case will be parsed according to subRelationShip
              end

              case subRelationShip 
              when "END_STATEMENT", "END_BLOCK"
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "            |-- case subRelationShip when \"END_STATEMENT\", \"END_BLOCK\"")
                isTypeOfConst["type"] = ""
                isTypeOfConst["value"] = false
                case word 
                when "O_END_OF_STATEMENT"  
                when "O_BLOCK_CLOSE"
                end
                
                syntaxLevelFlow.delete(syntaxLevelFlow.keys[syntaxLevelFlowIndex])
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "            |-- AFTER DELETE: syntaxLevelFlow: #{syntaxLevelFlow}")
                syntaxLevelFlowIndex = syntaxLevelFlowIndex - 1
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "            |-- syntaxLevelFlowIndex: #{syntaxLevelFlowIndex}")
                if syntaxLevelFlowIndex > -1 
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "              | if syntaxLevelFlowIndex > -1")
                  syntaxWordIndex = syntaxRelationsIndexStack.pop
                  syntaxWordIndex = syntaxWordIndex - 1
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "              |-- syntaxWordIndex: #{syntaxWordIndex}")
                else 
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "              | else of if syntaxLevelFlowIndex > -1")
                  syntaxWordIndex = -1 
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "              |-- syntaxWordIndex: #{syntaxWordIndex}")
                end

              when /OR/,/Or/ 
                case word
                when "N_VALUE"
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- aux_word = N_VALUE")                  
                  aux_word = word
                when "A_VALUE"
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- aux_word = A_VALUE")                  
                  aux_word = word
                when "S_VALUE"
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- aux_word = S_VALUE")                  
                  aux_word = word
                when "O_OPEN_CLOSE_COMPOUND"
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- O_OPEN_CLOSE_COMPOUND")
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- isCompound = #{isCompound}")
                  isCompound = toggle(isCompound)
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- toggle(isCompound) = #{isCompound}")
                  if (!isCompound)
                    if (isTypeOfConst["value"])
                    end
                  end
                end

#                aux_word = word

              when "0".."9", "10".."99", "100".."999"
                case word
                when "N_VALUE"
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- aux_word = N_VALUE")                  
                  aux_word = word
                when "A_VALUE"
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- aux_word = A_VALUE")                  
                  aux_word = word
                when "S_VALUE"
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- aux_word = S_VALUE")                  
                  aux_word = word
                when "O_OPEN_CLOSE_COMPOUND"
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- O_OPEN_CLOSE_COMPOUND")
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- isCompound = #{isCompound}")
                  isCompound = toggle(isCompound)
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "             |-- toggle(isCompound) = #{isCompound}")
                  if (!isCompound)
                    printDebugInfo(File.basename(__FILE__), __LINE__, 8, "               | if (!isCompound)")
                    if (isTypeOfConst["value"])
                      printDebugInfo(File.basename(__FILE__), __LINE__, 8, "                 | if (isTypeOfConst[\"value\"]) #{isTypeOfConst["value"]}")
                    end
                  end
                end
              end
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        |-- word: #{word}")
              syntaxWordIndex = syntaxWordIndex + 1
              printDebugInfo(File.basename(__FILE__), __LINE__, 8, "        |-- syntaxWordIndex = #{syntaxWordIndex}")
            else 
              #identifiers and strings should be stored in the apropriate structures TBC
              if (isTypeOfConst["value"] and !isCompound)
              end
              if (isTypeOfConst["value"] and isCompound)
                printDebugInfo(File.basename(__FILE__), __LINE__, 8, "               | if (isTypeOfConst[\"value\"] and isCompound) #{isTypeOfConst["value"]} #{isCompound}")
                if (!@syntax.isTypeOfConst?(word))
                  printDebugInfo(File.basename(__FILE__), __LINE__, 8, "                 | if (!@syntax.isTypeOfConst?(word)) #{@syntax.isTypeOfConst?(word)}")
                  if (compoundString == "")
                    printDebugInfo(File.basename(__FILE__), __LINE__, 8, "                   | if (compoundString == "") #{compoundString}")
                    compoundString = word
                    printDebugInfo(File.basename(__FILE__), __LINE__, 8, "                   |-- compoundString = #{compoundString}")
                  else
                    printDebugInfo(File.basename(__FILE__), __LINE__, 8, "                   | esle if (compoundString == "") #{compoundString}")
                    compoundString = compoundString + " " + word
                    printDebugInfo(File.basename(__FILE__), __LINE__, 8, "                   |-- compoundString = #{compoundString}")
                  end
                end
              end  
            end

          end #(hasRelationsShips != "R_NA")
        end
        word_idx = word_idx + 1
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "  |-- word_idx: #{word_idx}")
        printDebugInfo(File.basename(__FILE__), __LINE__, 8, "  |-- syntaxLevelFlow: #{syntaxLevelFlow}")
      end
#      syntax2Check = @lexical.parseAndTranslateToSyntax()
#      printDebugInfo(File.basename(__FILE__), __LINE__, 8, " syntax2Check: #{syntax2Check}")
    end
    puts "Script syntax checker Done"    
  end
end #class SyntaxChecker

end #module RubyScript2CAPLConverter
