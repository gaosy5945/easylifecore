
var cltype_info={
		
};
cltype_info.initRow=function(){
	try{
		if(getRowCount(0)>0) return ;
		setItemValue(0,0,"CODENO","CreditLineType"); 
		setItemValue(0,0,"INPUTUSER",AsCredit.userId);
		setItemValue(0,0,"INPUTUSERNAME",AsCredit.userName);
		setItemValue(0,0,"INPUTORG",AsCredit.orgId);
		setItemValue(0,0,"INPUTTIME",AsCredit.today);
		setItemValue(0,0,"INPUTORGNAME",AsCredit.orgName); 
	}catch(e){
		
	}
};


/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
cltype_info.saveRecord=function (sPostEvents){
	as_save("0","");
};
 

/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
cltype_info.goBack=function(){
	top.close();
};

$(function(){
	setTimeout(cltype_info.initRow,500);
});