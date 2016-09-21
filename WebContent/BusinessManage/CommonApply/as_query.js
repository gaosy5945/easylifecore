/**
 *�Ŵ���ѯ����js 
 */
function setErrorTips(colName,tips){
	setItemUnit(0,getRow(),colName,"<font color=red>"+tips+"</font>");
}
/**
 * ����ͻ���Ϣʱ�ж��Ƿ���ں��Ƿ�����ӦȨ��
 * <li>����ͻ�����ֶΣ��ͻ������ֶΣ�Ĭ��Ϊ CustomerID��Customerame
 * <li>�ڵ���ʱ�����ֶ�δȨ���˱�ź������ֶ�ΪOwnerid��OwnerName 
 */
function queryCustomer(colId,colName){
		if(typeof(colId)=="undefined") colId="CustomerID";
		if(typeof(colName)=="undefined") colName="CustomerName";
		var certType = getItemValue(0,0,"CertType");
		var certID = getItemValue(0,0,"CertID");
		setErrorTips("CertID",""); 
		if(certID=="") return false;
		if(certType=="") return false;
		//�ж���֯��������Ϸ���
		if(certType =='Ent01' ){
			 if(!CheckORG(certID) ){
				setErrorTips("certId",getBusinessMessage('102')); 
				return false;
			}
		} 
		if(certType == 'Ind01' || certType =='Ind08'){
		 	if (!CheckLicense(certID)){
				setErrorTips("CertID",getBusinessMessage('156'));  
				return false;
			}
		}
		
		if(certType != "" && certID != ""){
			var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CustomerOperateAction","customerVerify","certType="+certType+",certID="+certID+",userID="+AsCredit.userId);
			var returnstr = returnValue.split("@");
			if(returnstr[0]==1 || returnstr[0]==2){
				setItemUnit(0,getRow(),'CertID',"<font color=red>"+returnstr[1]+"</font>");
				if(existsFiled(colId))  	setItemValue(0,getRow(),colId,'');//����ֶ��Ƿ���ڣ������ٸ�ֵ
				if(existsFiled(colName))  setItemValue(0,getRow(),colName,'');
				return false;
			}else if(returnstr[0]==3){
				setItemUnit(0,getRow(),'CertID','');
				if(existsFiled(colId))  setItemValue(0,0,colId,returnstr[1]);
				if(existsFiled(colName))  setItemValue(0,0,colName,returnstr[2]);
			}
		}
		return true;
}
/**
 * ����ֶ��Ƿ����
 */
function existsFiled(colName){
	obj=getColIndex(0,colName);
	if(obj>0){
		return true;
	}
	return false;
}
/**
 * ��ѯ�ͻ���Ϣ
 * @returns
 */
function getCustomerName(){
	return queryCustomer();
}