<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Content: 
		Input Param:
			ObjectType���弶�������("Classify")
			ClassifyType: �޸ı�־(010:���ý���ģ�ͷ�����㣬020��ֻ�������ģ�ͷ�����)
			ResultType: ��������(����ͬ��BUSINESS_CONTRACT������ݣ�BUSINESS_DUEBILL)
	 */
	//�������������������͡�ģ�ͺš����͡��弶�����ݻ��ͬ
	String sObjectType = CurPage.getParameter("ObjectType");
	String sClassifyType = CurPage.getParameter("ClassifyType");
	String sResultType = CurPage.getParameter("ResultType"); 
	//����ֵת��Ϊ���ַ���	
	if(sObjectType == null) sObjectType = "";
	if(sClassifyType == null) sClassifyType = "";
	if(sResultType == null) sResultType = "";

	String[][] sHeaders1 = {
					{"AccountMonth","���շ����·�"},							
					{"ObjectNo","��ͬ��"}							
			      };
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASObjectModel doTemp = new ASObjectModel("ClassifyDialogInfo");	
	if(sResultType.equals("BusinessContract"))
		doTemp.setHeader(sHeaders1);
	//����Ĭ��ֵ
	doTemp.setDefaultValue("AccountMonth",StringFunction.getToday().substring(0,7));
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {	
		{"true","","Button","ȷ��","�����ʲ����շ���","doSubmit()","","","",""},
		{"true","","Button","ȡ��","ȡ���ʲ����շ���","doCancel()","","","",""}		
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("�����ʲ����շ���");
	<%/*~[Describe=�����ʲ����շ���;]~*/%>	
	function doSubmit(){
		var sObjectType = "<%=sObjectType%>";
		var sResultType = "<%=sResultType%>";
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//����·�		
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0){
			alert(getMessageText('ALS70671'));//��ѡ����շ����·ݣ�
			return;
		}
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//������	
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0){
			if(sResultType == "BusinessContract")
				alert(getMessageText('ALS70672'));//��ѡ�����ʲ����շ���ĺ�ͬ��ˮ�ţ�
			if(sResultType == "BusinessDueBill")
				alert(getMessageText('ALS70673'));//��ѡ�����ʲ����շ���Ľ����ˮ�ţ�
			return;
		}
		//�����ʲ����շ�����Ϣ
	    sReturn = AsControl.RunJsp("/CreditManage/CreditCheck/ConsoleClassifyActionX.jsp","AccountMonth="+sAccountMonth+"&ResultType="+sResultType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelNo=Classify1");
	    if(typeof(sReturn) == "undefined" || sReturn.length == 0){
	    	alert(getMessageText('ALS70674'));//�����ʲ����շ�������ʧ�ܣ�
	    	return;
	    }else if(sReturn == "IsExist"){
	    	alert(getMessageText("ALS70665"));//�����ʲ����շ����Ѿ����ڣ�
	    	return;
		}else{
			alert(getMessageText('ALS70675'));//�����ʲ����շ��������ɹ���
			top.returnValue = sReturn;
	        sParamString = "ComponentName=���շ���ο�ģ��"+
					       "&OpenType=Tab"+ //jschen@20100412 �������ִ򿪷���ģ�ͽ���ķ�ʽ
	            		   "&Action=_DISPLAY_"+
	            		   "&ClassifyType="+"<%=sClassifyType%>"+
	            		   "&ObjectType="+sObjectType+
	            		   "&ObjectNo="+sReturn+
	            		   "&SerialNo="+sObjectNo+
	            		   "&AccountMonth="+sAccountMonth+
	            		   "&ModelNo=Classify1"+
	            		   "&ResultType="+sResultType;
			AsControl.OpenObjectTab(sParamString);
			top.close();
		}
    }
    
	<%/*~[Describe=ȡ�������ʲ����շ���;OutPutParam=ȡ����־;]~*/%>
	function doCancel(){
		top.returnValue = "_CANCEL_";
		top.close();
	}

	<%/*~[Describe=ѡ�����·�;]~*/%>
    function getMonth(){
		var sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp","","dialogWidth=250px;dialogHeight=180px;resizable=yes;center:yes;status:no;statusbar:no");
		if (typeof(sMonth) != "undefined" && sMonth.length > 0)
			setItemValue(0,0,"AccountMonth",sMonth);
	}
    
    <%/*~[Describe=����������ѡ���;]~*/%>
	function getObjectNo(){
		var sReturnValue = "";
		var sObjectNo = "";
		var sResultType = "<%=sResultType%>";
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//--����·�		
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0){
			alert(getMessageText('ALS70671'));//��ѡ����շ����·ݣ�
			return;
		}
		
		if(sResultType == "BusinessContract"){ //������պ�ͬ�����ʲ����շ��࣬��ôѡ���ͬ��ˮ��
			sParaString = "ObjectType,"+sResultType+",AccountMonth"+","+sAccountMonth+",UserID,"+"<%=CurUser.getUserID()%>";
			sReturnValue = setObjectValue("SelectClassifyContractnew",sParaString,"",0,0,"");			
		} else { //������ս�ݽ����ʲ����շ��࣬��ôѡ������ˮ��
			sParaString = "ObjectType,"+sResultType+",AccountMonth"+","+sAccountMonth+",UserID,"+"<%=CurUser.getUserID()%>";
			sReturnValue = setObjectValue("SelectClassifyDueBillnew",sParaString,"",0,0,"");
		}
		if(sReturnValue != "_CLEAR_" && typeof(sReturnValue) != "undefined"){
			sReturnValue = sReturnValue.split('@');
			for(var i = 0;i < sReturnValue.length;i++){
				sObjectNo += sReturnValue[i];
			}
			setItemValue(0,getRow(),"ObjectNo",sObjectNo);
		}
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>