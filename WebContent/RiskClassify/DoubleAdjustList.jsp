<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//String sCustomerID =  CurComp.getParameter("CustomerID");
	//String sCustomerType = CurPage.getParameter("CustomerType");
	//String sListType = CurPage.getParameter("ListType");
     String SerialNo = CurPage.getParameter("SerialNo");
     if(SerialNo == null || "" == SerialNo || "".equals(SerialNo)){
    	 SerialNo = "''";
     }
     
	ASObjectModel doTemp = new ASObjectModel("DUEBILL_DOUBLE_APPLY");
	doTemp.setJboWhere(doTemp.getJboWhere() + " and O.SerialNo in  ("+SerialNo+") ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
    dwTemp.genHTMLObjectWindow(SerialNo);
    
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			//{"false","All","Button","附件上传","附件上传","","","","","btn_icon_add",""},
		};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
