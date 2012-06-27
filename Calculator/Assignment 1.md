1. ~~Walk-through~~

2. ~~Floating Point Numbers i.e. decimal point~~
    * decimal pressed
    * has decimal?
        * YES - do nothing
        * NO - append decimal
        
3. Add four operations
    * ~~sin~~
    * ~~cos~~
    * ~~pi~~
    * ~~sqrt~~

4. Add list of arguments sent to the brain

5. Clear button
    * ~~clear display in View~~
    * ~~empty stack in Model~~
    * ~~reset state in Controller~~
6. ~~Protect against invalid operation~~

7. ~~Avoid problems in Evaluation section~~

---
~~*BUG*: X Y Z + + --> X i.e.  
       4 3 2 + + _should_ be 2+3 = 5 + 4 = 9, but is 4  
       *No, enter is pushed after first +*~~  
       ~~_Add enter pressed after diplay changes_~~  
       pushOperand of result in performOperation