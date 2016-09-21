<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%-- 页面说明: 查封资产台账 上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	//AsControl.OpenView("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsList.jsp","","rightup","");
	AsControl.OpenView("/RecoveryManage/LawCaseManage/LawCaseDailyManage/CloseDownAssetList.jsp","","rightup","");
	//AsControl.OpenView("/RecoveryManage/NPAManage/NPARMGoodsMag/NPALawAssetsList.jsp","","rightdown","");
	AsControl.OpenView("/RecoveryManage/LawCaseManage/LawCaseDailyManage/OutCloseDownAssetList.jsp","","rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
