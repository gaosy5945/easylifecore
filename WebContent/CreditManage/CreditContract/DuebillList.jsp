<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String contractSerialNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
	ASObjectModel doTemp = new ASObjectModel("DuebillList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ContractSerialNo", contractSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		var duebillSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(duebillSerialNo)=="undefined" || duebillSerialNo.length==0) {
			return;
		}else{
			AsControl.OpenComp("/CreditManage/AfterBusiness/DuebillInfo.jsp","DuebillSerialNo="+duebillSerialNo,"rightdown","");
		}
	}
	mySelectRow(); 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
