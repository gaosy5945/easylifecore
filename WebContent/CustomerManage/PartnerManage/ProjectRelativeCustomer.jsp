<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectRelativeCustomer");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "0";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","All","Button","����","����ͻ�","add()","","","","btn_icon_add",""},
			{"true","All","Button","����","����","save()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		var returnValue = setObjectValue("SelectOrgCustomer","","");
		if(typeof(returnValue) == "undefined" || returnValue == "_CLEAR_"){
			return;
		}
		returnValue = returnValue.split("@");
		var param = "objectNo=<%=serialNo%>,accessoryNo="+returnValue[0]+",accessoryType=Customer,accessoryName="+returnValue[1];
		var flag = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.ProjectRelativeAction","initRelative",param);
		if(flag == "true"){
			alert("����ɹ�");
			reloadSelf();
		}else{
			alert("����ʧ��");
		}
		
	}
	function save(){
		as_save(0);
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
