<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
    String PG_TITLE = "接受集团外客户担保信息"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
    //获得组件参数    ：客户类型    
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID == null) sGroupID = "";

	//取得模板号
    String sTempletNo = "GroupMemberOuterGuarantyList";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//增加过滤器 
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //产生DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(25); //设置在datawindows中显示的行数
    dwTemp.Style="1"; //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));    

    String sButtons[][] = {
		{"true","","Button","详情","详情","viewClue()","","","","btn_icon_detail"},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	function viewClue(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--担保信息编号
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
	   		var sGuarantyType= getItemValue(0,getRow(),"GuarantyType");//担保类型
			var sContractType = getItemValue(0,getRow(),"ContractType");//担保合同类型	010：一般担保；020：最高额担保
			if(sContractType="020"){//如果是最高额担保
				//PopPage("/CreditManage/CreditAssure/ApplyAssureInfo2.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","","dialogWidth=800px;dialogHeight=800px;");
				//AsControl.PopComp("/CreditManage/CreditAssure/CreditHAssureContract/HAContractInfo.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&RightType=ReadOnly","dialogWidth=800px;dialogHeight=800px;resizable=yes;maximize:yes;help:no;status:no;scrollbar:no;");
				AsControl.PopComp("/CreditManage/CreditAssure/ApplyAssureInfo2.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","dialogWidth=800px;dialogHeight=650px;");			
			}else{
				//PopPage("/CreditManage/CreditAssure/ApplyAssureInfo1.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","","dialogWidth=800px;dialogHeight=800px;");
				//AsControl.PopComp("/CreditManage/CreditAssure/CreditHAssureContract/GAContractInfo.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&RightType=ReadOnly","dialogWidth=800px;dialogHeight=800px;resizable=yes;maximize:yes;help:no;status:no;scrollbar:no;");
				AsControl.PopComp("/CreditManage/CreditAssure/ApplyAssureInfo1.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","dialogWidth=800px;dialogHeight=650px;");			
			}
		}
	}

    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//自动选中第一条记录
    my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>