keywords=Array.new
$dynamic_class_name_counter=0

def GetDynamicClassName
	$dynamic_class_name_counter+=1
	return "DYNAMIC"+$dynamic_class_name_counter.to_s
end



class Keyword
	
	
	attr_accessor :Setter,:AnnonymousSet
	
	
	def initialize
		@Keyword="XXX"	
		@Setter=Hash.new
		#@Setter["in"]=Function.new true
		#@Setter["Anonymous"]="Anno"
		@AnnonymousSet=false;
		
	end
	
	def GetAllChildMethods
		return public_methods-Object.methods
		#! hier noch die methoden von this weg... nur von den kindern wollen wir!
	end
	def HasMethod(name)
	
		
		classmethods=GetAllChildMethods().map(&:to_s)
		
		@Setter.each{|k,v|
			if not classmethods.include? k
				puts @Keyword+" -> WARNING: "+k
			else 
				#puts "COOL: "+method(:foo).parameters.map(&:last).map(&:to_s)
				#puts "COOL: "+method(:foo).parameters.map(&:last).map(&:to_s)
			end
		}
		#! use public_methods - Object.methods
	
		return true if classmethods.include?(name)#@Setter.has_key?(name)
		return false
	
	end
	def HasParameter(methodname)
		#! hier müssen noch die methods von this object raus!!!!
		#ausserdem lieber die anzahl zurückgeben...
		puts "Parameter: "+method(GetMethod(methodname)).parameters.map(&:last).map(&:to_s).to_s
		return true if method(GetMethod(methodname)).parameters.map(&:last).map(&:to_s).count>0
		return false 
	
	end
	
	def Raw(methodname,nr)
		puts "---------------------------------------"
		para=method(GetMethod(methodname)).parameters.map(&:last).map(&:to_s)[nr]
		return para.include?("raw_")
		#return if method(GetMethod(methodname)).parameters.map(&:last).map(&:to_s)[nr]==/raw_.*/ 
	end 
	
	def GetMethod(name)
		(public_methods-Object.methods).each{|m|
			return m if m.to_s==name
		}
		return nil
	end
	
	def SetAnnonymous(p)
		#if has the annonymous function
		@annonymous_set=true
	end
	
	def to_s()
		return "I am a : "+Keyword
	end
	def Keyword
		return @Keyword
	end
	def Execute(level,keywords)
		puts "Execute ("+@Keyword+")"
		return ["Keyword #{@Keyword}","e2"]
	end
end

def GenerateVal(keywords,name,val)
	
	#! Wenn des die schon gibt, muss sie im array überschrieben werden!!!
	#! also nicht mit <<
	eval("class SSC_KW_#{name}<Keyword
	def initialize
		super()
	end
	def Execute (level,keywords)
		return [#{val}]
	end
	end
	
	keywords<<SSC_KW_#{name}
	")

end


text="for each file in directory \".\" do \"cat it\""
#text="for range from 1 to 5 do \"echo it\""

#text="for each file in directory \".\" do \"cat it\""
#text="for each word in string \"bla hallo\" do \"echo it\""
#text="cat "
#text="for each number in range from 1 to 5 do cat it"

##text="for range from 1 to 5 do \"echo it\""
#text="for range from 1 to 5 which equals 3 do \"echo it\""
#text="for range from 1 to 5 which_is > 3 do \"echo it\""
#text="for file in directory \".\" with owner \"peter\" do \"cat it\""

#text="power 2 of 2"
#text="dictionary "

#text="if file \"/home/mrhase/.bashrc" exists do code \"echo it\""
#text="if file named peter \"/home/mrhase/.bashrc" exists do code \"echo peter\"" #named muss in der hauptklasse Keyword sein






class SSC_KW_file<Keyword
	#@Keyword="file"
	def initialize(fn="")
		super()
		@Keyword="file"
		@fname=fn
	end
	
	def to_s()
		return @fname
	end
	def Annonymous(p)
		puts "file annonymous set to: "+p
		
	end
		
	def Execute(level,keywords)
		return [self]
	end

end

class SSC_KW_directory<Keyword
	#@Keyword="file"
	def initialize
		super()
		@Keyword="directory"
	end
	
	def Annonymous(p)
		puts "Directory annonymous: "+p.to_s
	end
	
	def Content()
		return ["file1","file2"]
	end
	
	def Execute(level,keywords)
		return [self]
	end
end


class SSC_KW_parameter<Keyword
	attr_accessor :Parameter
	def initialize
		super()
		@Keyword="parameter"
		@Parameter=[]
		
	end
	
	def to_s
	
	end
	
	def Annonymous(p)
		#puts "ANNONYMOUS"
		@Parameter<< p
	end
end

class SSC_KW_number<Keyword
	#attr_accessor :Parameter
	def initialize (nr)
		super()
		@number=nr
		@Parameter=[]
		@Keyword="number"
	end
	
	def to_s
		return @number.to_s
	end
	def in (p)
	
	end
	
	def Annonymous(p)
		#puts "ANNONYMOUS"
		@Parameter<< p
	end
	def Execute(level,keywords)
	
		return [@number]
	end
end


class SSC_KW_range<Keyword
	#attr_accessor :Parameter
	def initialize
		super()
		@Parameter=[]
		@Keyword="range"
		@from=0
		@to=0
	end
	
	def to_s
		return "XXXXX RANGE"
	end
	
	def from (p_single)
		#check if number:
		@from=1 
		
	end
	
	def to (p_single)
		@to=5
	end
	
	def Annonymous(p)
		
		@Parameter<< p
	end
	
	def Finish ()
		i=@from
		ret=Array.new
		while (i<@to)
			ret<< SSC_KW_number.new(i)
			i+=1
		end
		return ret
	end
	def Execute(level,keywords)
		return Finish()
	end
end

class SSC_KW_1<Keyword
	#attr_accessor :Parameter
	def initialize
		super()
		@Keyword="1"
	end
	def to_s
		return "1"
	end
	def Execute(level,keywords)
		return ["1"]
	end	
	
end
class SSC_KW_5<Keyword
	#attr_accessor :Parameter
	def initialize
		super()
		@Keyword="5"
	end
	def to_s
		return "5"
	end
	def Execute(level,keywords)
		return ["5"]
	end
end

class SSC_KW_echo<Keyword
	#attr_accessor :Parameter
	
	def initialize
		super()
		@Keyword="echo"
		@data
	end
	
	def Execute (level,keywords)
		puts @data
	end
	def Annonymous (p_single)
		@data=p_single[0]
	end
end


class SSC_KW_cat<Keyword
	#@Keyword="file"
	def initialize
		super()
		@Keyword="cat"
	end
	
	
	def Execute (level,keywords)
		puts "Cat: "+@data.to_s
	end
	
	def Annonymous(p)
		@data=p[0]
	end
end

class SSC_KW_code<Keyword
	#attr_accessor :Parameter
	
	def initialize
		super()
		@Keyword="code"
		@code
	end
	def to_s
		return @Keyword
	end
	def Execute(level,keywords)
		p#uts "Executing: "+@code
		return [@code]
	end
	def Annonymous (p_single)
		@code=p_single[0]
	end
end
class SSC_KW_string<Keyword
	#attr_accessor :Parameter
	
	def initialize(init="")
		super()
		@Keyword="string"
		@str=init
	end
	def to_s
		return @Keyword
	end
	def Execute(level,keywords)
		return [@str]
	end
	def Annonymous (p_single)
		@str=p_single[0]
	end
end
class SSC_KW_for<Keyword
	#@Keyword="for"
	def initialize
		super()
		@Keyword="for"
		@code=""
		@in=[]
	end
	
	
	def do(p)
		#harter breack runter vom stack? optional
		@code=p[0]
		
		
	end
	def Annonymous (p)
		@in=p
	end
	def Execute (level,keywords)
		result=["1","2","3"]
		puts "Execute for: #{@code}"
		variables=Hash.new #! muss beim code setzen gefüllt werden
		@in.each{|o|
			variables["it"]=o
			Parse(level+1,keywords,variables,@code)
		}
		return result
	end
end

class SSC_KW_each<Keyword
	
	def initialize
		super()
		@Keyword="each"
		@in=nil
	end
	def Annonymous (raw_type)
	
		puts "EACH ---->"+raw_type
	end
	def in (p)
		puts "for IN "+ p.to_s
		@in=p
	end
	
	def Execute (level,keywords)
		result=[]
		@in[0].Content().each{|f|
			#result<<f
			result<<SSC_KW_file.new(f)
			puts "kw each...FILE: "+f
		}
		
		return result
	end

end


#Keyword.new.send(Keyword.new.GetMethod("Execute"))
#puts SSC_KW_for.new.HasParameter("do")







keywords<< SSC_KW_file
keywords<< SSC_KW_for
keywords<< SSC_KW_directory
keywords<< SSC_KW_cat
keywords<< SSC_KW_parameter
keywords<< SSC_KW_number
keywords<< SSC_KW_range

keywords<< SSC_KW_1
keywords<< SSC_KW_5
keywords<< SSC_KW_echo
keywords<< SSC_KW_code
keywords<< SSC_KW_string
keywords<< SSC_KW_each





#k=Keyword.new 
#k.Keyword="it"
#$keywords<< k

#k=Keyword.new 
#k.Keyword="directory"
#$keywords<< k


#k=Keyword.new
#k.Keyword="cat"
#k.Setter["Annonymous"]=Function.new true
#$keywords<<k


def IsKeyword(keywords,word)
	keywords.each{|kw|
		#puts "KW: "+kw.to_s.sub("SSC_KW_","")
		return true if kw.to_s.sub("SSC_KW_","")==word
		#return true if kw.new.Keyword==word
	}
	#puts "NO KEYWORD: "+word
	return false
	
end

def GetKeyword(keywords,word)
	keywords.each{|kw|
		
		return kw.new if kw.to_s.sub("SSC_KW_","")==word
	}
	
	return nil
	
end

def IsVariable(variables,word)
	return variables.key?(word)
end

def GetVariable(variables,word)
	return variables[word]
end

def IsVarOrKey(keywords,variables,word)
	return true if IsVariable(variables,word)
	return true if IsKeyword(keywords,word)
	return false
end

def GetVarOrKey(keywords,variables,word)
	return GetVariable(variables,word) if IsVariable(variables,word)
	return GetKeyword(keywords,word) if IsKeyword(keywords,word)
	return nil
end



def StackLog(level,kw,msg)

	
	
	print "[#{level}] " 
	level.times{print "  "}
	print kw+" -> "
	puts msg
end


#def Parse(level,kw,text)

	#if kw=="parameter" then
		#o,j=Parse2(level,text) #ohne map!
		#return o.Execute,j
	#else
		#o,j=Parse2(level,"parameter "+text)
		#return o.Execute,j-1
	#end
#end

def ParseRawParameter(level,keywords,variables,text)


end

def Parse(level,keywords,variables,text)


	o,j=Parse2(level,keywords,variables,text) #ohne map!
	return o.Execute(level,keywords),j
	#return o,j
	
	
end

def Parse2(level,keywords,variables,text)
	wordarray=text.split(' ')
	
	
	a=GetVarOrKey(keywords,variables,wordarray[0]) 
	
	i=1
	kw=a.Keyword
	
	
	
	while(i<wordarray.size) 
		word=wordarray[i]
		i+=1
		StackLog(level,kw,"word: "+word)
		if a.HasMethod word then
			#if a.Setter[word].Parameter==true then
			if a.HasParameter(word) then
				#puts "putting parameter"
				if a.Raw(word,0) then
					#puts "RAAAAAAAAAAWWW"+ wordarray[i]
					a.send(a.GetMethod(word),wordarray[i])
					i+=1
				else 
					
					if IsVarOrKey(keywords,variables,wordarray[i]) then
						newtext=wordarray[i..wordarray.size-1]*" "
						StackLog(level,kw,"Keyword "+wordarray[i]+" PARSING: "+newtext)
						o,j=Parse(level+1,keywords,variables,newtext)
						
						#StackLog(level,kw,"RESULT: Used Words: #{j} Setting parameter for  '#{word}' to "+o.to_s)
						
						#a.Setter[word].SetParameter(o)
						a.send(a.GetMethod(word),o)
						i+=(j) #die benutzten wörter addieren...
						
					else
						StackLog(level,kw,"Unexspected instruction (is not a Keyword for '#{word}'): "+wordarray[i])
						#return []
					end
					#a.Setter[word].SetParameter(wordarray[i])
				end	
			else
				#no parameter
				puts "WAS IST HIER? word: "+word
			end
		
		else
			StackLog(level, kw,"#{a.Keyword} dont have method: "+word)
			#if a.allows_anonym_parameter:
			#	if word is keyword
			#		ausführen
			#	else
			#		return a,a-1
			#else
			#	return a,a-1
			if IsVarOrKey(keywords,variables,word) then
				if a.HasMethod("Annonymous") then
					if not a.AnnonymousSet then 
						if a.Raw("Annonymous",0) then
							puts "RAAAAAAAAAAWWW "+ word
							a.send("Annonymous",word)
							#i+=1
						else
							newtext=wordarray[i-1..wordarray.size-1]*" "
							#puts "FUFU"
							StackLog(level,kw,"Keyword "+wordarray[i-1]+" PARSING: "+newtext)
							#exit(1)
							o,j=Parse(level+1,keywords,variables,newtext)
							StackLog(level,kw,"RESULT: Used Words: #{j} Setting parameter for  '#{word}' to "+o.to_s)
							StackLog(level, kw,"Setting Annonymous to "+o.to_s)
							
							a.send(:Annonymous,o)
							a.AnnonymousSet=true#kann auch in der funktion gesetzt werden
							i+=(j-1)
						end
					else
						StackLog(level,kw,"Annonymous already set")
						return a,i-1
					end
					#return a,i-1
				else
					StackLog(level,kw,"Has no Annonymous method")
					return a,i-1
				end
			else
				StackLog(level,kw,"has no function  '#{word}' and '#{word}' is also not a keyword")
				return a,i-1 #wie viele wörter haben wir benutzt?
			end
		end
	
	end
	
	
	return a,i
end



variables=Hash.new


#cname=GetDynamicClassName()

#eval("class SSC_KW_#{cname}<Keyword
#def initialize
	#super()
#end
#def Execute (level,keywords)
	#return [\"echo it\"]
#end
#end
#keywords<<SSC_KW_#{cname}
#")


#text.sub!(/".*"/,cname)
#variables[cname]=SSC_KW_string.new("echo it")

text.gsub!(/"[^"]*"/){ |match|
	puts "replacing: "+match.gsub("\"","")
	cname=GetDynamicClassName()
	variables[cname]=SSC_KW_string.new(match.gsub("\"",""))
	#variables[cname]=SSC_KW_string.new("echo it")
	cname
	#exit(1)

}



puts "AFTER REPLACING: "+text




Parse(0,keywords,variables,text)
