<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
	String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
	String isQuery = DataConvert.toString(CurPage.getParameter("isQuery"));//�Ƿ��ǲ�ѯҳ��

	ASObjectModel doTemp = new ASObjectModel("AcctFeeLogList");
	doTemp.setDDDWJbo("FEESERIALNO","jbo.acct.ACCT_FEE,SERIALNO,FEENAME,ObjectType='"+objectType+"' and ObjectNo='"+objectNo+"'");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);
	
	String sButtons[][] = {
			{!"true".equals(isQuery)?"true":"false","","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{!"true".equals(isQuery)?"true":"false","","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
			{"true".equals(isQuery)?"true":"false","","Button","����","����","asExport()","","","","",""},
		};
%> 
<script type="text/javascript">
	function add(){
		var sObjectNo = '<%=objectNo%>';
		var sObjectType = '<%=objectType%>';
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
	 	var sUrl = "/AssetTransfer/AcctFeeLogInfo.jsp";
	 	OpenPage(sUrl+'?ObjectNo='+sObjectNo+'&ObjectType='+sObjectType+'&SerialNo='+serialNo,'_self','');
	}
	
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		
	 	var sUrl = "/AssetTransfer/AcctFeeLogInfo.jsp";
	 	OpenPage(sUrl+'?SerialNo='+serialNo,'_self','');
	}
	
	function del(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
	}
	
	function asExport(){
		
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
