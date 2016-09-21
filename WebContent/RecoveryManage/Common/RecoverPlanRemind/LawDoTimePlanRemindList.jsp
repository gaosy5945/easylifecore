<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("LawDoTimePlanRemindList");
	String sWhereSql = "";
	sWhereSql = " AND LB.BookType =(select  max(LB1.booktype) from jbo.preservation.LAWCASE_BOOK LB1 where LB1.lawcaseserialno=LB.lawcaseserialno and LB1.booktype in('040','050','060') group by LB1.lawcaseserialno ) " +
	           " AND  not exists (select 1 from  jbo.preservation.LAWCASE_BOOK LB2 WHERE O.SERIALNO = LB2.LAWCASESERIALNO AND LB2.BookType = '070') " +
	           " and v.to_char(v.sysdate,'yyyy/mm/dd') between v.to_char(v.add_months(v.to_date(lb.IntoEffectDate, 'yyyy/mm/dd'),23),'yyyy/mm/dd') and v.to_char(v.add_months(v.to_date(lb.IntoEffectDate, 'yyyy/mm/dd'),24),'yyyy/mm/dd') " ; 	           
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	
	String role [] = {"PLBS0052"};
	if(CurUser.hasRole(role)){
		doTemp.appendJboWhere(" and exists (select 1 from jbo.sys.ORG_BELONG OB where OB.orgid='"+CurUser.getOrgID()+"' and OB.BelongOrgID=O.InputOrgID)");
	}else{
		doTemp.appendJboWhere(" and O.InputUserID='"+CurUser.getUserID()+"' ");
	}
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			//{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","案件详情","案件详情","viewAndEdit()","","","","btn_icon_detail",""},
			//{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			var sFunctionID="";
			if(sLawCaseType == "01" ){
				sFunctionID = "CaseInfoList1";
			}else{
				sFunctionID = "CaseInfoList2";
			}
			
			AsCredit.openFunction(sFunctionID,"SerialNo="+sObjectNo+"&LawCaseType="+sLawCaseType+"&RightType=ReadOnly");	
			reloadSelf();	
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
