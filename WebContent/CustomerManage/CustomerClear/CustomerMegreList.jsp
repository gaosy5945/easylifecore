 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    ASObjectModel doTemp = new ASObjectModel("CustomerMergListNew");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","�����ϲ�","�����ϲ�","add()","","","","btn_icon_add",""}, 
		};
%> 
<script type="text/javascript">
	function add(){ 
		sReturnValue = AsControl.PopComp("/CustomerManage/CustomerClear/CustomerMegreInfo.jsp","","resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
	    if(sReturnValue=="true")   reloadSelf();
	}
 
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
 