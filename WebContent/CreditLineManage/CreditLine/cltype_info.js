
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


/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
cltype_info.saveRecord=function (sPostEvents){
	as_save("0","");
};
 

/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
cltype_info.goBack=function(){
	top.close();
};

$(function(){
	setTimeout(cltype_info.initRow,500);
});