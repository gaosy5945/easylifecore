<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
		Author:   qzhang  2004/12/02
		Tester:
		Content: 合同信息列表
		Input Param:	 
		Output param:
		History Log: 
	*/

	//获取前端传入的参数
    String sTemplateNo = DataConvert.toString(CurPage.getParameter("TemplateNo"));//模板号
    String sStatus = DataConvert.toString(CurPage.getParameter("Status"));//模板号
    
	ASObjectModel doTemp = new ASObjectModel(sTemplateNo); 
    
    if(CurUser.hasRole("PLBS0001") || CurUser.hasRole("PLBS0002"))
    {
    	doTemp.appendJboWhere(" and O.OperateUserID=:UserID ");
    }
    
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID()+","+CurUser.getUserID());

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","合同制作","合同制作","create()","","","","",""},
			{"true","","Button","合同详情","合同详情","edit()","","","","",""},
			{"false","","Button","打印电子合同","打印电子合同","print()","","","","",""},
		};
	 if("010".equals(sStatus)){
		sButtons[0][0] = "true";
	}

%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function create(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");		
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsCredit.openFunction("DocContractTab", "SerialNo="+serialNo);
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsCredit.openFunction("ContractTab", "SerialNo="+serialNo+"&rightType=ReadOnly");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
