


Lexar and Syntax Checker made in Ruby.  
Below is an example code that will be parsed without errors...  

```
#rcpl syntax check...

   #testing Comments
#include;  #haha
include <testFile1.inc>
include "testFile3.inc"
include <testFile2.inc>

def TestCase1()
{
  var var2:int=0;
  var2 = (2+log(2)+1);
  var3 = var1*5 +9 + var3 + (100 * 3) - var2/2 + (40*var1/2+3*var3)+log(3);

  step 1 {
    for (var kk=0; kk<=30; kk++){ 
      if ( kk > 3 ){
                #puts " test " ;
      }
    }
    for (kk=0; kk<=30; kk++)
    {
      if ( kk > 3 )
      {
        #puts " test " ;
      }
    }
  }

  return 0;
}

def function1()
{
  var3 = var1*5 +9 + var3 + (100 * 3) - var2/2 + (40*var1/2+3*var3);

}

def function2(param1, param2)
{
}

def function3(param1, param2, param3) #test comment
{
var string1:string, string2:string, string3:string;
}

def function4()
{
var string1:string, string2:string, string3:string, bool:boolean, var1:int, var2:int;
   string1 = "ab"+ "ac" ;
   string2 = string1+ "ad";
   string3 = string2 +"ae";

   var1 = 0;
   while bool == TRUE
   {
    var1 += 1;
    var2 = 2;
   }
    
   while (var1 == 0)
   {
    var1 -= 1; 
    var2 = !5;
   }

   do{
     var1 += 1;
     var2 ~= 10;

   }while bool == TRUE;

   do{
     var1 += 1;
     var2 = ~15; 

   }while(bool == TRUE);

   return string1;
}

def function5(param1)
{
var var1:int,var2:uint,var3:ulong,var4:ullong;

  if (var1 == 0)
  {
    puts "   true     bla     bla   bla ", var1;
    #puts "   true     bla     bla   bla ", var1;
    var1 += 1;
    var1 -= 1;
    var1*=2;
    var1 /= 2;
    var1 %= 2;
    var1 >>= 1;
    var1 >>=  1 ;
    var1>>=  1 ;
    var1 >>=1 ;
    var1>>=1 ;
    var1 <<= 1 ;
    var1 &= 2 ;
    var1 ^= 2 ;
    var1 |= 2 ;

    var1 = 1 ;
    var2 = var1 + 3 ;
    var3 = var1 + var2 ;
    var3 = var1 + var3 ;
    var3 = var1 + var3 + 1;
    var3 = var1 + var3 + (100 * 3) - var2;

    var3 = var1*5 +9 + var3 + (100 * 3) - var2/2 + (40*var1/2+3*var3)+log(3);

    var1 = 4 ;
    var2 = var1 - 3 ;
    var3 = var1 - var2 ;
    var3 = var1 - var3 ; 

    var1 = 1 ;
    var2 = var1 * 3 ;
    var3 = var1 * var2 ;
    var3 = var1 * var3 ;

    var1 = 9 ;
    var2 = var1 / 3 ;
    var3 = var1 / var2 ;
    var3 = var1 / var3 ;

    var1 = 10 ;
    var2 = var1 % 3 ;
    var3 = var1 % var2 ;
    var3 = var1 % var3 ;

    var1 = 9 ;
    var2 = var1 >> 3 ;
    var3 = var1 >> var2 ;
    var3 = var1 >> var3 ;

    var1 = 9 ;
    var2 = var1 << 3 ;
    var3 = var1 << var2 ;
    var3 = var1 << var3 ;

    var1 = 9 ;
    var2 = var1 & 3 ;
    var3 = var1 & var2 ;
    var3 = var1 & var3 ;

    var1 = 9 ;
    var2 = var1 ^ 3 ;
    var3 = var1 ^ var2 ;
    var3 = var1 ^ var3 ;

    var1 = 9 ;
    var2 = var1 | 3 ;
    var3 = var1 | var2 ;
    var3 = var1 | var3 ;

    var1 = 19 ;
    var2 = var1 ~ 3 ;
    var3 = var1 ~ var2 ;
    var3 = var1 ~ var3 ;

    var1 = 155 ;
    var2 = var1 != 3 ;
    var3 = var1 != var2 ;
    var3 = var1 != var3 ;
  }
  else
  {
    #puts "   false       ", var999;

    for (var kk=0; kk<=30; kk++)
    {
      if ( kk > 3 )
      {
        #puts " test " ;
      }
    }
  }
}

def canMessage(canId, canValue)
{
  receive canId, canValue; 
  expect canId.signalName1 == canValue;
}

def main(args)
{
  var i:int,j:uchar,k:long,l:string;

  call function1(i,j);
  call function2();
  call function3(k);
  call function3(l);
  expect canId.signalName1 == canValue;
  receive canId, canValue; 
  return 0;
}

```

