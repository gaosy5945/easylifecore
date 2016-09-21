<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo==null||objectNo.length()==0)objectNo="";
	
	String contractNoList="";
	BizObjectManager bm = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_CONTRACT_CHANGE" );
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", objectNo).getSingleResult(false);
	if(bo!=null){
		contractNoList=bo.getAttribute("BATCHCHANGECONTRACTNOLIST").getString();
	}
	if(contractNoList==null)contractNoList="";
	
	contractNoList = "('"+contractNoList.replace(",", "','")+"')";
	
	ASObjectModel doTemp = new ASObjectModel("ChangeManager_ViewContractList");
	doTemp.appendJboWhere("  and  O.SerialNo in "+contractNoList);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>

