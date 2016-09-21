<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
	Author:   qzhang  2004/12/04
	Tester:
	Content: 合同面签信息列表
	Input Param:	 
	Output param:
	History Log: 
	*/

	//获取前端传入的参数
	String sObjectNo =  DataConvert.toString(CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toString(CurPage.getParameter("ObjectType"));
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	ASObjectModel doTemp = new ASObjectModel("ContractFileCheckList");
	doTemp.setDDDWJbo("STATUS","jbo.sys.CODE_LIBRARY,itemNo,ItemName,Codeno='BPMCheckItemStatus'  and ItemNo like '1%' and IsInuse='1' ");	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(3);
	dwTemp.genHTMLObjectWindow(sObjectNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","保存","保存","save()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function save(){
		as_save("myiframe0","");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
