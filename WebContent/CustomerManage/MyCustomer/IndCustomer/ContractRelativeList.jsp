<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("ContractRelativeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var ContractSerialNo = getItemValue(0,getRow(0),'ContractSerialNo');
		 if(typeof(ContractSerialNo)=="undefined" || ContractSerialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 AsCredit.openFunction("ContractInfo","ObjectNo="+ContractSerialNo+"&ObjectType="+"jbo.app.BUSINESS_CONTRACT"+"&RightType="+"ReadOnly");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
