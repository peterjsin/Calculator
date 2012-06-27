1. ~~Floating Point Numbers i.e. decimal point~~
    * decimal pressed
    * has decimal?
        * YES - do nothing
        * NO - append decimal
        
2. Add four operations
    * ~~sin~~
    * ~~cos~~
    * ~~pi~~
    * ~~sqrt~~

3. Add list of arguments sent to the brain

4. Clear button
    * ~~clear display in View~~
    * ~~empty stack in Model~~
    * ~~reset state in Controller~~
5. 

---
~~*BUG*: X Y Z + + --> X i.e.  
       4 3 2 + + _should_ be 2+3 = 5 + 4 = 9, but is 4  
       *No, enter is pushed after first +*~~  
       ~~_Add enter pressed after diplay changes_~~  
       pushOperand of result in performOperation