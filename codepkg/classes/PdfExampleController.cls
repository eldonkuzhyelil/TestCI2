public  class PdfExampleController {
    public List<Account> accList{get;set;}
    public PdfExampleController (){
    //first
    //second
    //3
    //4sd
    //5
    //6
    //7
    //89=
    //9d
    //10
    //11
    //123
    //13
    //14
	//15
	//16
	//17g
        accList = new List<Account>();
        accList = [select id,name,type,accountnumber,annualrevenue,Rating from account limit 10];
    
    }
}