<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		ҳ��˵��: ������Ϣ����
	 */
	String PG_TITLE = "������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//���ҳ�����	
	String sOrgID =  CurPage.getParameter("CurOrgID");
	if(sOrgID == null) sOrgID = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ORG_INFO";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	if(sOrgID.equals("")) doTemp.setReadOnly("OrgID,OrgLevel", false);
    //�����ϼ�����ѡ��ʽ
    doTemp.setUnit("BelongOrgName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getOrgName();\"> ");
	doTemp.setHTMLStyle("BelongOrgName","  style={cursor:pointer;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getOrgName()\" ");
	doTemp.appendHTMLStyle("OrgID,SortNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
			
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow(sOrgID);
	//��������¼�
	//dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//����HTMLDataWindow

	String sButtons[][] = {
		//{(CurUser.hasRole("099")?"true":"false"),"","Button","����","�����޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����޸�","saveRecord()","","","",""},
		{"true","","Button","����","���ص��б����","doReturn()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false;
	function saveRecord(){
		if(bIsInsert && checkPrimaryKey("ORG_INFO","OrgID")){
			alert("�û������Ѵ��ڣ��������룡");
			return;
		}
		
// 	    var sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
// 	    if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0){
//         	alert(getBusinessMessage("901"));//��ѡ�񼶱�
//         	return;
//         }else{
//         	if(sOrgLevel != '0'){
//         		var sBelongOrgName = getItemValue(0,getRow(),"BelongOrgName");
// 			    if (typeof(sBelongOrgName) == 'undefined' || sBelongOrgName.length == 0){
// 		        	alert("��ѡ���ϼ�������");
// 		        	return;
// 		        }
//         	}
//         }
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
       as_save("myiframe0","");
	}
    
	function doReturn(){
		OpenPage("/AppConfig/OrgUserManage/OrgList.jsp","_self","");
	}

	<%/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;]~*/%>
	function getOrgName(){
		var sOrgID = getItemValue(0,getRow(),"OrgID");
// 		var sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0){
        	alert(getBusinessMessage("900"));//�����������ţ�
        	return;
        }
// 		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0){
//         	alert(getBusinessMessage("901"));//��ѡ�񼶱�
//         	return;
//         }
		
		
		
		//sParaString = "OrgID"+sOrgID;
		//	
		if(sOrgID.indexOf("10") == 0){ //��10��ͷ�ı��
			sParaString = "OrgID,"+"<%=CurOrg.getOrgID()%>";	
			setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");	;//�������ְ�ܲ���			
	    }else{
	    	sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;
	    	//setObjectValue("SelectOrg",sParaString,"@BelongOrgID@0@BelongOrgName@1",0,0,"");//���һ����� 	
	    	setObjectValue("SelectUpperOrgInfo",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");//���һ�����
	    	//setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");	    	
	    	//setObjectValue("SelectUpperOrgInfo",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");
		}
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	initRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>