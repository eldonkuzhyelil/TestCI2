public  class PdfExampleController {
    public List<Account> accList{get;set;}
    public PdfExampleController (){
    //first
    //second
    //3
    //4
    //5
    //6
    //7
    //89=
    //9
    //10
        accList = new List<Account>();
        accList = [select id,name,type,accountnumber,annualrevenue,Rating from account limit 10];
    
    }
}