<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String serialNo = CurPage.getParameter("SerialNo");	

	ASObjectModel doTemp = new ASObjectModel("ProjectProduct");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","","Button","���뷽����Ʒ","���뷽����Ʒ","add()","","","","btn_icon_add",""},
			{"true","","Button","ɾ�����뷽����Ʒ","ɾ�����뷽����Ʒ","deleteRecord()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	/*���뷽��*/
	function add(){
		if(getRowCount(0)!="0")
		{
			alert("ֻ������һ��������Ʒ��");
			return;
		}
		var returnValue = setObjectValue("SelectAllBusinessType","","",0,0,"");
		if(typeof(returnValue)=="undefined"||returnValue==""||returnValue=="_CLEAR_"){return;}
		returnValue = returnValue.split("@");
		var param = "objectNo=<%=serialNo%>,accessoryNo=" + returnValue[0] + ",accessoryName=" + returnValue[1] +",accessoryType=Product";
		var flag = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.ProjectRelativeAction","initRelative",param);
		if(flag == "true")
		{
			alert("����ɹ���");
			reloadSelf();
		}else
		{
			alert("����ʧ�ܡ�");
		}
	}
	/*ɾ����¼*/
	function deleteRecord(){
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
