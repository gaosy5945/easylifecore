<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String orgList = "";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select OrgList from FLOW_ORGMAP where FlowOrgMapType = '01' and OrgID = :OrgID").setParameter("OrgID", CurUser.getOrgID()));
	if(rs.next()){
		orgList = rs.getString(1);
	}
	rs.close();
	
	ASObjectModel doTemp = new ASObjectModel("OldLoanOperateList");
	doTemp.appendJboWhere(" and O.OperateOrgID in ('"+orgList.replaceAll(",","','")+"','"+CurUser.getOrgID()+"')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ȷ��","ȷ��","enSure()","","","",""},
			{"true","All","Button","ȡ��","ȡ��","self.close()","","","",""},
		};
%>
<HEAD>
<title>�ϸ���Ǩ��δ���˴���ſ��б�</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*��¼��ѡ��ʱ�����¼�*/%>
	function enSure(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		top.returnValue ="true@"+SerialNo;
		top.close();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
