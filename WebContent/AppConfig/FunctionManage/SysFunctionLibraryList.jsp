 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String functionId = CurPage.getParameter("FunctionID");
	if(functionId == null) functionId = "";
	ASObjectModel doTemp = new ASObjectModel("SysFunctionLibraryList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "0";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(functionId);
	
	String sButtons[][] = {
			{"true","","Button","����","����","add()","","","","",""},
			{"true","","Button","����","����","saveRecord()","","","","",""},
			{"true","","Button","����","����","viewDetail()","","","","",""},
			{"true","","Button","����","����","copy()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'')","","","","",""},
		};
%> 
<script type="text/javascript">
	function add(){
		 editStyle=parent.window.getItemValue(0,getRow(),"EditStyle");
		 AsControl.PopComp("/AppConfig/FunctionManage/SysFunctionLibraryInfo.jsp","FunctionID=<%=functionId%>&EditStyle="+editStyle,"");
		 reloadSelf();
	}

	function saveRecord(){
		as_save("0","");
	}
	function setValue(){
		setItemValue(0,getRow(),"ItemNo","10");
	}

	function copy(){
		var functionItemSerialNo = getItemValue(0,getRow(),"SERIALNO");		
		if (typeof(functionItemSerialNo)=="undefined" || functionItemSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.businessobject.web.BusinessObjectWebMethod", "simpleCopyBusinessObject"
				, "ObjectType=jbo.sys.SYS_FUNCTION_LIBRARY,ObjectNo="+functionItemSerialNo);
		if(result == "false"){
			alert("�Ѵ��ڸ�����Ϣ��");
		} else {
			reloadSelf();
		}
	};

	function viewDetail(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var editStyle=parent.window.getItemValue(0,getRow(),"EditStyle");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		 AsControl.PopComp("/AppConfig/FunctionManage/SysFunctionLibraryInfo.jsp","FunctionID=<%=functionId%>&SerialNo="+serialNo+"&EditStyle="+editStyle,"");
		 reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
 