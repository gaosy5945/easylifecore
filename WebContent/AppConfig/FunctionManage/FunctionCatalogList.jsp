 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String menuId=CurPage.getParameter("MenuID");
	if(menuId==null) menuId="";
	ASObjectModel doTemp = new ASObjectModel("SysFunctionCatalogList");
	doTemp.appendJboWhere(" MenuID like '"+menuId+"%'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
			{"true","","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","copy()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'')","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		 AsControl.PopComp("/AppConfig/FunctionManage/FunctionCatalogInfo.jsp","FunctionID=&MenuID=<%=menuId%>","");
		 reloadSelf();
	}
	
	function copy(){
		var functionID = getItemValue(0,getRow(),"FunctionID");		
		if (typeof(functionID)=="undefined" || functionID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var result = RunJavaMethodTrans("com.amarsoft.app.als.sys.function.action.SysFunctionService", "copyFunctionConfig", "FunctionID="+functionID);
		if(result == "false"){
			alert("�Ѵ��ڸ�����Ϣ��");
		} else {
			alert("���Ƴɹ���FunctionIDΪCopyOf"+functionID);
		}
		reloadSelf();
	}
	
	function edit(){
		var functionID = getItemValue(0,getRow(),"FunctionID");		
		if (typeof(functionID)=="undefined" || functionID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		AsControl.PopComp("/AppConfig/FunctionManage/FunctionCatalogInfo.jsp","FunctionID="+functionID,'','');
		reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
 