<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>

<%	
	ASObjectModel doTemp = new ASObjectModel("DuebillQueryResultList");
    doTemp.setLockCount(1);
	doTemp.setJboWhereWhenNoFilter("1=2");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.MultiSelect = true;//�����ѡ
	dwTemp.ReadOnly = "1";//�༭ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","ȷ��","ȷ��","confirm()","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
 <script>
 function confirm(){
	 
	var recordArray = getCheckedRows(0);
	 if(recordArray.length < 1){
		 alert("��ѡ�������Ϣ��");
		 
	 }else if(recordArray.length == 1){
			 var sUrl = "/RiskClassify/SingleAdjust.jsp";
			 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self',''); 
			 
		 }else{
		 		var relaSerialNos = '';
				if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {	
						for(var i = 1;i <= recordArray.length;i++){
							var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
							relaSerialNos += "@'"+serialNo+"'";
					}
						}
			
		var sReturn = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.riskclassify.RiskTypeSame","execute","serialNo="+relaSerialNos );
	    if(sReturn=='1'){
	    	 var sUrl = "/RiskClassify/DoubleAdjust.jsp";
			 OpenPage(sUrl+'?SerialNo=' + relaSerialNos,'_self','');
	    }else{
	    	alert('��ǰ���෽ʽ��ͬ��������������');
	    }
		 }
	 }
			
 </script>
 <%@include file="/Frame/resources/include/include_end.jspf"%>
