<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//资金项目相关查询列表
	//接收参数
	String sAssetProjectType = DataConvert.toString(CurPage.getParameter("AssetProjectType"));//项目类型
	

	ASObjectModel doTemp = new ASObjectModel("AssetTransferList");
	doTemp.setJboWhere("projectType='"+sAssetProjectType+"' and status in('010','030','040')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
	{"true","All","Button","详情","详情","view()","","","","btn_icon_detail",""},
	{"true","All","Button","资产还款与风险情况","资产还款与风险情况","repaymentAndRisk()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectType_010.equals(sAssetProjectType)?"true":"false","All","Button","收益与费用清单","收益与费用清单","costList()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectType_010.equals(sAssetProjectType)?"true":"false","All","Button","项目回购清单","项目回购清单","buyBackList()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectType_020.equals(sAssetProjectType)?"true":"false","All","Button","支付与费用清单","支付与费用清单","costList()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectType_020.equals(sAssetProjectType)?"true":"false","All","Button","项目返售清单","项目返售清单","buyBackList()","","","","",""},
		};
%> 
<script type="text/javascript">
	
	//详情,只读
	function view(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		var sAssetProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
    	if(typeof(serialNo) == "undefined" || serialNo.length == 0){
   			alert("请先选择一条记录");
   			return ;
        }
        
    	var viewID = "002";
        paramString = "ObjectNo=" + serialNo + "&ObjectType=AssetProject&AssetProjectType="+sAssetProjectType+"&ViewID="+viewID; 
   	 
    	AsControl.OpenObjectTab(paramString);
    	reloadSelf();
    	return ;
	}
	
	//资产还款与风险情况
	function repaymentAndRisk(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		AsControl.OpenView("/AssetTransfer/AssetRepaymentRiskDetail.jsp","ObjectNo="+serialNo,"_blank");
	}
	
	//收益与费用清单 or 支付与费用清单
	function costList(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		AsControl.OpenView("/AssetTransfer/AcctFeeLogList.jsp","isQuery=true&ObjectNo="+serialNo,"_blank");
	}
	
	//项目回购清单 or 项目返售清单
	function buyBackList(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		AsControl.OpenView("/AssetTransfer/BuyBackList.jsp","ObjectNo="+serialNo,"_blank");
	}
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
