<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String sObjectNo = CurPage.getParameter("ObjectNo");//��Ŀ���
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//��Ŀ����

	String sTempletNo = "ProjectAssetAcctFeeList";//--ģ���--
	String sTempletFilter = "1=1"; 
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setReadOnly("*", true);
	doTemp.setJboWhere("O.ObjectNo=:sObjectNo and ObjectType=:sObjectType");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "0";	 //�༭ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	String sButtons[][] = {
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		initSerialNo();
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sUrl = "/AssetTransfer/AcctFeeInfo.jsp";
		AsControl.OpenPage(sUrl,"SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self");
	}
	
	function edit(){
	 	var sUrl = "/AssetTransfer/AcctFeeInfo.jsp";
	 	var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
	 	//alert(sSerialNo);
		if(typeof(sSerialNo) == 'undefined' || sSerialNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		AsControl.OpenPage(sUrl,"SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self");
	}
	
	function del(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
	}
	
	function initSerialNo() 
	{
		var sTableName = "ACCT_FEE";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺
		var sSerialNo = PopPageAjax("/Frame/page/sys/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>